import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import 'DownloadItems.dart';

class StudyMaterialPage extends StatefulWidget with WidgetsBindingObserver {
  const StudyMaterialPage({required this.platform});

  final TargetPlatform? platform;

  @override
  _StudyMaterialPageState createState() => _StudyMaterialPageState();
}

class _StudyMaterialPageState extends State<StudyMaterialPage> {
  List<TaskInfo>? _tasks;
  late List<ItemHolder> _items;
  bool _loading = false;
  bool _permissionReady = false;
  late String _localPath;
  final ReceivePort _port = ReceivePort();
  void initEveryThing() async {
    await DownloadItems().getDownloadItems().then((value) {
      _bindBackgroundIsolate();

      setState(() {
        _loading = true;
        _permissionReady = false;
      });

      _prepare();
    });
  }

  @override
  void initState() {
    super.initState();
    FlutterDownloader.registerCallback(downloadCallback, step: 1);
    initEveryThing();
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  void _bindBackgroundIsolate() {
    final isSuccess = IsolateNameServer.registerPortWithName(
      _port.sendPort,
      'downloader_send_port',
    );
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      final taskId = (data as List<dynamic>)[0] as String;
      final status = data[1] as DownloadTaskStatus;
      final progress = data[2] as int;

      print(
        'Callback on UI isolate: '
        'task ($taskId) is in status ($status) and process ($progress)',
      );

      if (_tasks != null && _tasks!.isNotEmpty) {
        final task = _tasks!.firstWhere((task) => task.taskId == taskId);
        setState(() {
          task
            ..status = status
            ..progress = progress;
        });
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
    String id,
    DownloadTaskStatus status,
    int progress,
  ) {
    print(
      'Callback on background isolate: '
      'task ($id) is in status ($status) and process ($progress)',
    );

    IsolateNameServer.lookupPortByName('downloader_send_port')
        ?.send([id, status, progress]);
  }

  Widget _buildDownloadList() => ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          for (final item in _items)
            item.task == null
                ? _buildListSectionHeading(item.name!)
                : DownloadListItem(
                    data: item,
                    onTap: (task) async {
                      final success = await _openDownloadedFile(task);
                      if (!success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Cannot open this file'),
                          ),
                        );
                      }
                    },
                    onActionTap: (task) {
                      if (task.status == DownloadTaskStatus.undefined) {
                        _requestDownload(task);
                      } else if (task.status == DownloadTaskStatus.running) {
                        _pauseDownload(task);
                      } else if (task.status == DownloadTaskStatus.paused) {
                        _resumeDownload(task);
                      } else if (task.status == DownloadTaskStatus.complete ||
                          task.status == DownloadTaskStatus.canceled) {
                        _delete(task);
                      } else if (task.status == DownloadTaskStatus.failed) {
                        _retryDownload(task);
                      }
                    },
                    onCancel: _delete,
                  ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.2,
          )
        ],
      );

  Widget _buildListSectionHeading(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.blue,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildNoPermissionWarning() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Grant storage permission to continue',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blueGrey, fontSize: 18),
            ),
          ),
          const SizedBox(height: 32),
          TextButton(
            onPressed: _retryRequestPermission,
            child: const Text(
              'Retry',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _retryRequestPermission() async {
    final hasGranted = await _checkPermission();

    if (hasGranted) {
      await _prepareSaveDir();
    }

    setState(() {
      _permissionReady = hasGranted;
    });
  }

  Future<void> _requestDownload(TaskInfo task) async {
    task.taskId = await FlutterDownloader.enqueue(
      url: task.link!,
      headers: {'auth': 'test_for_sql_encoding'},
      savedDir: _localPath,
      saveInPublicStorage: true,
    );
  }

  Future<void> _pauseDownload(TaskInfo task) async {
    await FlutterDownloader.pause(taskId: task.taskId!);
  }

  Future<void> _resumeDownload(TaskInfo task) async {
    final newTaskId = await FlutterDownloader.resume(taskId: task.taskId!);
    task.taskId = newTaskId;
  }

  Future<void> _retryDownload(TaskInfo task) async {
    final newTaskId = await FlutterDownloader.retry(taskId: task.taskId!);
    task.taskId = newTaskId;
  }

  Future<bool> _openDownloadedFile(TaskInfo? task) {
    if (task != null) {
      return FlutterDownloader.open(taskId: task.taskId!);
    } else {
      return Future.value(false);
    }
  }

  Future<void> _delete(TaskInfo task) async {
    await FlutterDownloader.remove(
      taskId: task.taskId!,
      shouldDeleteContent: true,
    );
    await _prepare();
    setState(() {});
  }

  Future<bool> _checkPermission() async {
    if (Platform.isIOS) {
      return true;
    }

    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    if (widget.platform == TargetPlatform.android &&
        androidInfo.version.sdkInt! <= 28) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<void> _prepare() async {
    final tasks = await FlutterDownloader.loadTasks();

    if (tasks == null) {
      print('No tasks were retrieved from the database.');
      return;
    }

    var count = 0;
    _tasks = [];
    _items = [];

    _tasks!.addAll(
      DownloadItems.documents.map(
        (document) => TaskInfo(
            name: document.name,
            link: document.url,
            description: document.description,
            date: document.updatedAt),
      ),
    );

    // _items.add(ItemHolder(name: 'Documents'));
    for (var i = count; i < _tasks!.length; i++) {
      _items.add(ItemHolder(
          name: _tasks![i].name,
          task: _tasks![i],
          description: _tasks![i].description));
      count++;
    }

    for (final task in tasks) {
      for (final info in _tasks!) {
        if (info.link == task.url) {
          info
            ..taskId = task.taskId
            ..status = task.status
            ..progress = task.progress;
        }
      }
    }

    _permissionReady = await _checkPermission();

    if (_permissionReady) {
      await _prepareSaveDir();
    }

    setState(() {
      _loading = false;
    });
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;
    final savedDir = Directory(_localPath);
    final hasExisted = savedDir.existsSync();
    if (!hasExisted) {
      await savedDir.create();
    }
  }

  Future<String?> _findLocalPath() async {
    String? externalStorageDirPath;
    if (Platform.isAndroid) {
      try {
        externalStorageDirPath = await AndroidPathProvider.downloadsPath;
      } catch (e) {
        final directory = await getExternalStorageDirectory();
        externalStorageDirPath = directory?.path;
      }
    } else if (Platform.isIOS) {
      externalStorageDirPath =
          (await getApplicationDocumentsDirectory()).absolute.path;
    }
    return externalStorageDirPath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Material'),
        actions: [
          if (Platform.isIOS)
            PopupMenuButton<Function>(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: () => exit(0),
                  child: const ListTile(
                    title: Text('Simulate App Backgrounded',
                        style: TextStyle(fontSize: 15)),
                  ),
                ),
              ],
            )
        ],
      ),
      body: Builder(
        builder: (context) {
          if (_loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return _permissionReady
              ? _buildDownloadList()
              : _buildNoPermissionWarning();
        },
      ),
    );
  }
}

class ItemHolder {
  ItemHolder({this.description, this.name, this.task});

  final String? name;
  final String? description;
  final TaskInfo? task;
}

class TaskInfo {
  TaskInfo({this.date, this.description, this.name, this.link});

  final String? name;
  final String? description;
  final String? link;
  final String? date;

  String? taskId;
  int? progress = 0;
  DownloadTaskStatus? status = DownloadTaskStatus.undefined;
}

class DownloadListItem extends StatelessWidget {
  const DownloadListItem({
    this.data,
    this.onTap,
    this.onActionTap,
    this.onCancel,
  });

  final ItemHolder? data;
  final Function(TaskInfo?)? onTap;
  final Function(TaskInfo)? onActionTap;
  final Function(TaskInfo)? onCancel;

  Widget? _buildTrailing(TaskInfo task) {
    if (task.status == DownloadTaskStatus.undefined) {
      return IconButton(
        onPressed: () => onActionTap?.call(task),
        constraints: const BoxConstraints(minHeight: 32, minWidth: 32),
        icon: const Icon(Icons.file_download),
      );
    } else if (task.status == DownloadTaskStatus.running) {
      return Row(
        children: [
          Text('${task.progress}%'),
          IconButton(
            onPressed: () => onActionTap?.call(task),
            constraints: const BoxConstraints(minHeight: 32, minWidth: 32),
            icon: const Icon(Icons.pause, color: Colors.red),
          ),
        ],
      );
    } else if (task.status == DownloadTaskStatus.paused) {
      return Row(
        children: [
          Text('${task.progress}%'),
          IconButton(
            onPressed: () => onActionTap?.call(task),
            constraints: const BoxConstraints(minHeight: 32, minWidth: 32),
            icon: const Icon(Icons.play_arrow, color: Colors.green),
          ),
          if (onCancel != null)
            IconButton(
              onPressed: () => onCancel?.call(task),
              constraints: const BoxConstraints(minHeight: 32, minWidth: 32),
              icon: const Icon(Icons.cancel),
            ),
        ],
      );
    } else if (task.status == DownloadTaskStatus.complete) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text('Ready', style: TextStyle(color: Colors.green)),
          IconButton(
            onPressed: () => onActionTap?.call(task),
            constraints: const BoxConstraints(minHeight: 32, minWidth: 32),
            icon: const Icon(Icons.delete),
          )
        ],
      );
    } else if (task.status == DownloadTaskStatus.canceled) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text('Canceled', style: TextStyle(color: Colors.red)),
          if (onActionTap != null)
            IconButton(
              onPressed: () => onActionTap?.call(task),
              constraints: const BoxConstraints(minHeight: 32, minWidth: 32),
              icon: const Icon(Icons.cancel),
            )
        ],
      );
    } else if (task.status == DownloadTaskStatus.failed) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text('Failed', style: TextStyle(color: Colors.red)),
          IconButton(
            onPressed: () => onActionTap?.call(task),
            constraints: const BoxConstraints(minHeight: 32, minWidth: 32),
            icon: const Icon(Icons.refresh, color: Colors.green),
          )
        ],
      );
    } else if (task.status == DownloadTaskStatus.enqueued) {
      return const Text('Pending', style: TextStyle(color: Colors.orange));
    } else {
      return null;
    }
  }

  String getExtension({required String url}) {
    String uri =
        "http://www.google.com/support/enterprise/static/gsa/docs/admin/70/gsa_doc_set/integrating_apps/images/google_logo.png";
    String extension = url.substring(url.lastIndexOf("."));
    return extension;
  }

  @override
  Widget build(BuildContext context) {
    String url = data!.task!.link!;
    String fileType = getExtension(url: url);
    String image =
        'assets/images/${fileType == '.png' || fileType == '.jpg' || fileType == '.jpeg' ? 'image' : fileType == '.mp3' || fileType == '.m4a' || fileType == '.wva' ? 'audio' : fileType == '.mp4' || fileType == '.avi' || fileType == '.M4P' ? 'video' : fileType == '.doc' || fileType == '.docx' || fileType == '.dotx' || fileType == '.pdf' || fileType == '.xml' ? 'pdf' : fileType == '.apk' ? 'apk' : 'dontKnow'}.png';
    Color color =
        fileType == '.png' || fileType == '.jpg' || fileType == '.jpeg'
            ? const Color(0x4CF19AF6)
            : fileType == '.mp3' || fileType == '.m4a' || fileType == '.wva'
                ? const Color(0x4F82EF76)
                : fileType == '.mp4' || fileType == '.avi' || fileType == '.M4P'
                    ? const Color(0x3482FCFC)
                    : fileType == '.apk'
                        ? Color(0x37FF0000)
                        : fileType == '.doc' ||
                                fileType == '.docx' ||
                                fileType == '.dotx' ||
                                fileType == '.pdf' ||
                                fileType == '.xml'
                            ? const Color(0x345790F8)
                            : const Color(0x348F8E8E);

    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: data!.task!.status == DownloadTaskStatus.complete
          ? () {
              onTap!(data!.task);
            }
          : null,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        child: InkWell(
          child: Stack(
            children: [
              Container(
                height: w * 0.25,
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  height: w * 0.2,
                  width: w - 24,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 2,
                      ),
                      Row(
                        children: [
                          Text(DateFormat('dd-MM-yyyy hh:mm')
                              .format(DateTime.parse(data!.task!.date!))),
                        ],
                        mainAxisAlignment: MainAxisAlignment.end,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    if (image == 'assets/images/dontKnow.png') {
                                      if (await canLaunch(url)) {
                                        launch(url);
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: 'Cann\'t open this link.');
                                      }
                                    }
                                  },
                                  child: Text(
                                    data!.name!.capitalize,
                                    style: TextStyle(
                                        color: image ==
                                                'assets/images/dontKnow.png'
                                            ? Colors.blue
                                            : Colors.black,
                                        decoration: image ==
                                                'assets/images/dontKnow.png'
                                            ? TextDecoration.underline
                                            : TextDecoration.none,
                                        fontSize: w * 0.035,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  data!.description!.capitalize,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: w * 0.03,
                                      fontWeight: FontWeight.normal),
                                  maxLines: 1,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: _buildTrailing(data!.task!),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (data!.task!.status == DownloadTaskStatus.running ||
                  data!.task!.status == DownloadTaskStatus.paused)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 10,
                  child: Container(
                    width: w - 24,
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: LinearProgressIndicator(
                      value: data!.task!.progress! / 100,
                    ),
                  ),
                ),
              Positioned(
                top: 0,
                child: Container(
                  height: h * 0.05,
                  width: w - 36,
                  padding: EdgeInsets.only(left: w * 0.01),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    // color: Colors.red[300],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () async {
                              // await saveFile();
                            },
                            child: Image.asset(
                              image,
                              width: h * 0.04,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

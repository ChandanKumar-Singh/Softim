import 'dart:io';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

class ItemHolder {
  ItemHolder({this.name, this.task});

  final String? name;
  final TaskInfo? task;
}

class TaskInfo {
  TaskInfo({this.name, this.link,this.taskId,this.status,this.progress});

  final String? name;
  final String? link;

  String? taskId;
  int? progress = 0;
  DownloadTaskStatus? status = DownloadTaskStatus.undefined;
}

Future<void> retryRequestPermission() async {
  // final hasGranted = await checkPermission();

  // if (hasGranted) {
  //   await prepareSaveDir();
  // }



  // setState(() {
  //   permissionReady = hasGranted;
  // });
}

Future<void> requestDownload(TaskInfo task,String localPath) async {
  task.taskId = await FlutterDownloader.enqueue(
    url: task.link!,
    headers: {'auth': 'test_for_sql_encoding'},
    savedDir: localPath,
    saveInPublicStorage: true,
  );
}

// Not used in the example.
// Future<void> _cancelDownload(TaskInfo task) async {
//   await FlutterDownloader.cancel(taskId: task.taskId!);
// }

Future<void> pauseDownload(TaskInfo task) async {
  await FlutterDownloader.pause(taskId: task.taskId!);
}

Future<void> resumeDownload(TaskInfo task) async {
  final newTaskId = await FlutterDownloader.resume(taskId: task.taskId!);
  task.taskId = newTaskId;
}

Future<void> retryDownload(TaskInfo task) async {
  final newTaskId = await FlutterDownloader.retry(taskId: task.taskId!);
  task.taskId = newTaskId;
}

Future<bool> openDownloadedFile(TaskInfo? task) {
  if (task != null) {
    return FlutterDownloader.open(taskId: task.taskId!);
  } else {
    return Future.value(false);
  }
}

Future<void> delete(TaskInfo task) async {
  await FlutterDownloader.remove(
    taskId: task.taskId!,
    shouldDeleteContent: true,
  );
  // await prepare();
  // setState(() {});
}



Future<void> prepareSaveDir() async {
  var localPath = (await findLocalPath())!;
  final savedDir = Directory(localPath);
  final hasExisted = savedDir.existsSync();
  if (!hasExisted) {
    await savedDir.create();
  }
}

Future<String?> findLocalPath() async {
  String? externalStorageDirPath;
  if (Platform.isAndroid) {
    try {
      final directory = await getExternalStorageDirectory();
      externalStorageDirPath = directory?.path;
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
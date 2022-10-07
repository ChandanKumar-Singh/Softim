import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:crm_application/ApiManager/Apis.dart';
import 'package:crm_application/NewCode/Model/UserLoginData.dart';
import 'package:crm_application/NewCode/Widget/faseInRoute.dart';
import 'package:crm_application/NewCode/Widget/profilePages/UpdateProfilePage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'FeeDetails.dart';
import 'PresenceDetails.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, this.currentIndex}) : super(key: key);
  final int? currentIndex;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

enum Options {
  camera,
  photos,
}

class _ProfilePageState extends State<ProfilePage> {
  String image = '';
  bool networkImage = false;
  bool uploading = false;
  bool running = false;
  var _popupMenuItemIndex = 0;
  IconData _changeColorAccordingToMenuItem = Icons.camera;
  var name = '';
  late SharedPreferences prefs;
  late UserLoginData user;

  Future<UserLoginData> checkState() async {
    prefs = await SharedPreferences.getInstance();
    var response = prefs.getString('loginData')!;
    user = UserLoginData.fromJson(jsonDecode(response)['results']);
    setState(() {
      image = prefs.getString('profile_image')!;
      networkImage = true;
    });
    return user;
  }


  @override
  void initState() {
    super.initState();

    checkState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: widget.currentIndex == null
            ? IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
              )
            : Container(),
        title: Text(name != '' ? name : 'Fetching ...'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5),
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                Navigator.of(context)
                    .push(ThisIsFadeRoute(route: UpdateProfilePage()));
              },
              child: Image.asset(
                'assets/images/addNote.png',
                width: 25,
                height: 25,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: checkState(),
            builder: (context, AsyncSnapshot<UserLoginData> snap) {
              if (snap.hasError) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snap.data != null) {
                  user = snap.data!;
                  name = user.data!.name!;
                  // print(user.contact);
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 18.0),
                              child: Card(
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 18.0, horizontal: 10),
                                  child: Row(
                                    children: [
                                      Stack(
                                        children: [
                                          if (uploading)
                                            SizedBox(
                                              width: s.width * 0.2,
                                              height: s.width * 0.2,
                                              child: CircularProgressIndicator(
                                                color: running
                                                    ? const Color(0x813B2A98)
                                                    : const Color(0xCF02FF06),
                                                // value: 0.5,
                                              ),
                                            ),

                                          InkWell(
                                            onTap: () {
                                              // _showPicker(context);
                                            },
                                            child: Badge(
                                              badgeColor: Colors.white,
                                              animationDuration:
                                                  const Duration(seconds: 1),
                                              animationType:
                                                  BadgeAnimationType.scale,
                                              position:
                                                  BadgePosition.bottomEnd(),
                                              badgeContent: InkWell(
                                                onTap: () async {
                                                  await showDialog(
                                                    context: context,
                                                    builder: (_) => AlertDialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      elevation: 0,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      insetPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  s.width / 4),
                                                      content: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: s.width *
                                                                    0.02,
                                                                bottom:
                                                                    s.width *
                                                                        0.05,
                                                                right: s.width *
                                                                    0.04),
                                                        decoration: BoxDecoration(
                                                            shape: BoxShape
                                                                .rectangle,
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            boxShadow: const [
                                                              BoxShadow(
                                                                  color: Colors
                                                                      .black,
                                                                  offset:
                                                                      Offset(0,
                                                                          10),
                                                                  blurRadius:
                                                                      10),
                                                            ]),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            IconButton(
                                                              onPressed:
                                                                  () async {
                                                                await pickImage(
                                                                        ImageSource
                                                                            .camera)
                                                                    .then((value) =>
                                                                        Navigator.pop(
                                                                            context))
                                                                    .then((value) async => await uploadProfileImage(File(
                                                                            image))
                                                                        .then((value) =>
                                                                            debugPrint('--------------------- uploaded ------------')));
                                                              },
                                                              icon: Icon(
                                                                Icons.camera,
                                                                color:
                                                                    Colors.pink,
                                                                size:
                                                                    s.width / 9,
                                                              ),
                                                            ),
                                                            IconButton(
                                                              onPressed:
                                                                  () async {
                                                                await pickImage(
                                                                        ImageSource
                                                                            .gallery)
                                                                    .then((value) =>
                                                                        Navigator.pop(
                                                                            context))
                                                                    .then((value) async => await uploadProfileImage(File(
                                                                            image))
                                                                        .then((value) =>
                                                                            debugPrint('--------------------- uploaded ------------')));
                                                              },
                                                              icon: Icon(
                                                                Icons
                                                                    .photo_size_select_actual,
                                                                color: Colors
                                                                    .green,
                                                                size:
                                                                    s.width / 9,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: const Icon(
                                                  Icons.camera_alt,
                                                  color: Color(0xAB84B0E3),
                                                ),
                                              ),
                                              child: CircleAvatar(
                                                radius: s.width * 0.10,
                                                backgroundColor:
                                                    Colors.transparent,
                                                backgroundImage: networkImage
                                                    ? NetworkImage(image)
                                                    : image == ''
                                                        ? const AssetImage(
                                                            'assets/images/profile.png')
                                                        : FileImage(File(image))
                                                            as ImageProvider,
                                              ),
                                            ),
                                          ),
                                          // Positioned(
                                          //   bottom: 0,
                                          //   right: 0,
                                          //   child: InkWell(
                                          //     onTap: () async {
                                          //       await showDialog(
                                          //         context: context,
                                          //         builder: (_) => AlertDialog(
                                          //           shape:
                                          //               RoundedRectangleBorder(
                                          //             borderRadius:
                                          //                 BorderRadius.circular(
                                          //                     20),
                                          //           ),
                                          //           elevation: 0,
                                          //           backgroundColor:
                                          //               Colors.transparent,
                                          //           insetPadding:
                                          //               EdgeInsets.symmetric(
                                          //                   horizontal:
                                          //                       s.width / 4),
                                          //           content: Container(
                                          //             padding: EdgeInsets.only(
                                          //                 top: s.width * 0.02,
                                          //                 bottom:
                                          //                     s.width * 0.05,
                                          //                 right:
                                          //                     s.width * 0.04),
                                          //             decoration: BoxDecoration(
                                          //                 shape: BoxShape
                                          //                     .rectangle,
                                          //                 color: Colors.white,
                                          //                 borderRadius:
                                          //                     BorderRadius
                                          //                         .circular(20),
                                          //                 boxShadow: const [
                                          //                   BoxShadow(
                                          //                       color: Colors
                                          //                           .black,
                                          //                       offset: Offset(
                                          //                           0, 10),
                                          //                       blurRadius: 10),
                                          //                 ]),
                                          //             child: Row(
                                          //               mainAxisAlignment:
                                          //                   MainAxisAlignment
                                          //                       .spaceAround,
                                          //               children: [
                                          //                 IconButton(
                                          //                   onPressed:
                                          //                       () async {
                                          //                     await pickImage(
                                          //                             ImageSource
                                          //                                 .camera)
                                          //                         .then((value) =>
                                          //                             Navigator.pop(
                                          //                                 context))
                                          //                         .then((value) async => await uploadProfileImage(
                                          //                                 File(
                                          //                                     image))
                                          //                             .then((value) =>
                                          //                                 debugPrint(
                                          //                                     '--------------------- uploaded ------------')));
                                          //                   },
                                          //                   icon: Icon(
                                          //                     Icons.camera,
                                          //                     color:
                                          //                         Colors.pink,
                                          //                     size: s.width / 9,
                                          //                   ),
                                          //                 ),
                                          //                 IconButton(
                                          //                   onPressed:
                                          //                       () async {
                                          //                     await pickImage(
                                          //                             ImageSource
                                          //                                 .gallery)
                                          //                         .then((value) =>
                                          //                             Navigator.pop(
                                          //                                 context))
                                          //                         .then((value) async => await uploadProfileImage(
                                          //                                 File(
                                          //                                     image))
                                          //                             .then((value) =>
                                          //                                 debugPrint(
                                          //                                     '--------------------- uploaded ------------')));
                                          //                   },
                                          //                   icon: Icon(
                                          //                     Icons
                                          //                         .photo_size_select_actual,
                                          //                     color:
                                          //                         Colors.green,
                                          //                     size: s.width / 9,
                                          //                   ),
                                          //                 ),
                                          //               ],
                                          //             ),
                                          //           ),
                                          //         ),
                                          //       );
                                          //     },
                                          //     child: Container(
                                          //       padding:
                                          //           const EdgeInsets.all(3.0),
                                          //       decoration: BoxDecoration(
                                          //         border: Border.all(
                                          //             color: const Color(0xAB84B0E3),
                                          //             width: 2),
                                          //         shape: BoxShape.circle,
                                          //         color: Colors.white,
                                          //       ),
                                          //       child: const Icon(
                                          //         Icons.camera_alt,
                                          //         color: Color(0xAB84B0E3),
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: s.width * 0.05,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text('📲    ${user.data!.contact}'),
                                          SizedBox(width: s.height * 0.05),
                                          Text('📧    ${user.data!.email}'),
                                          SizedBox(width: s.height * 0.05),
                                          Text(
                                              '📖    ${user.courseInfo!.course!}'),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.redAccent,
                                    gradient: const LinearGradient(colors: [
                                      Color(0x4FB2A7F1),
                                      Color(0x89c2eca9),
                                    ])),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18.0, vertical: 10),
                                  child: Text(
                                    'Profile'.toUpperCase(),
                                    style: TextStyle(
                                        fontSize: s.width * 0.04,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xEA077296)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: s.height * 0.01),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Activities',
                                      style: TextStyle(
                                          fontSize: s.width / 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      height: 3,
                                      width: s.width / 9,
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(2)),
                                    )
                                  ],
                                ),
                                SizedBox(height: s.height * 0.03),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('🔵 Attendance'),
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            ThisIsFadeRoute(
                                                route: PresenceDetails()));
                                      },
                                      child: Text(
                                        'View',
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: s.height * 0.02),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('🔵 Fee History'),
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            ThisIsFadeRoute(
                                                route: FeeDetails()));
                                      },
                                      child: const Text(
                                        'View',
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: s.height * 0.01),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Basic Info',
                                      style: TextStyle(
                                          fontSize: s.width / 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 5),
                                    Container(
                                      height: 3,
                                      width: s.width / 9,
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(2)),
                                    )
                                  ],
                                ),
                                SizedBox(height: s.height * 0.03),
                                BasicInfoRow(
                                    s,
                                    'User Id',
                                    user.data!.id!.toString(),
                                    'Roll no.',
                                    user.data!.rollno.toString()),
                                SizedBox(height: s.height * 0.02),
                                BasicInfoRow(
                                    s,
                                    'Father Name',
                                    user.data!.father!,
                                    'Gender',
                                    user.data!.gender ?? ''),
                                SizedBox(height: s.height * 0.02),
                                BasicInfoRow(s, 'Address', user.data!.address!,
                                    '', '---'),
                                SizedBox(height: s.height * 0.02),
                                BasicInfoRow(
                                    s,
                                    'Course Duration',
                                    user.courseInfo!.duration.toString() ==
                                            'null'
                                        ? '---'
                                        : user.courseInfo!.duration.toString(),
                                    'Batch No.',
                                    user.batchInfo!.first.batchName.toString()),
                                SizedBox(height: s.height * 0.02),
                                BasicInfoRow(
                                  s,
                                  'Batch-Period',
                                  user.batchInfo!.first.startFrom.toString() +
                                      ' - ' +
                                      user.batchInfo!.first.endAt.toString(),
                                  'Branch Name',
                                  user.branchInfo!.name.toString(),
                                ),
                                SizedBox(height: s.height * 0.02),
                                BasicInfoRow(
                                    s,
                                    'Branch Email',
                                    user.branchInfo!.email!,
                                    'Expires at',
                                    '2023-08-24 06:38:57'),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                            height: widget.currentIndex == null
                                ? s.height * 0.02
                                : s.height * 0.1),

                        // InkWell(
                        //   onTap: () {
                        //     Navigator.of(context).push(ThisIsFadeRoute(
                        //         route: const ChangePassword(
                        //       route: ProfilePage(),
                        //     )));
                        //   },
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(30),
                        //         // color: Colors.redAccent,
                        //         gradient: const LinearGradient(colors: [
                        //           Color(0x4FB2A7F1),
                        //           Color(0x89c2eca9),
                        //         ])),
                        //     child: Padding(
                        //       padding: const EdgeInsets.symmetric(
                        //           horizontal: 18.0, vertical: 8),
                        //       child: Text('Update Password',
                        //           style: Theme.of(context)
                        //               .textTheme
                        //               .headline5!
                        //               .copyWith(
                        //                   fontWeight: FontWeight.bold,
                        //                   fontFamily: 'Bafura',
                        //                   color: Color(0xDF048391))),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  );
                }
                return Column(
                  children: const [
                    SizedBox(
                      child: LinearProgressIndicator(),
                      height: 5,
                    ),
                  ],
                );
              }
            }),
      ),
    );
  }

  Row BasicInfoRow(
      Size s, String first, String second, String third, String fourth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(first,
                  style: TextStyle(
                      fontSize: s.width / 22,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey)),
              SizedBox(
                height: 5,
              ),
              Text(second,
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: s.width / 25,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(0.6))),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(third,
                  style: TextStyle(
                      fontSize: s.width / 22,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey)),
              SizedBox(
                height: 5,
              ),
              Text(fourth,
                  style: TextStyle(
                      fontSize: s.width / 25,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(0.6))),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> pickImage(ImageSource source) async {
    // XFile? pickedFile = await ImagePicker().pickImage(source: source);
    XFile? pickedFile = await ImagePicker().pickImage(
        source: source, maxWidth: 200, maxHeight: 200, imageQuality: 100);
    final bytes = File(pickedFile!.path).readAsBytesSync().lengthInBytes;
    final kb = bytes / 1024;
    final mb = kb / 1024;

    print('MB ------------------------ $mb');

    if (pickedFile != null) {
      setState(() {
        image = pickedFile.path;
        networkImage = false;
      });
    } else {
      Fluttertoast.showToast(
          msg: 'Image could not picked.', backgroundColor: Colors.red);
    }
  }

  Future<void> uploadProfileImage(File file) async {
    var url = ApiManager.BASE_URL + ApiManager.updateProfileImage;

    // var fileContent = file.readAsBytesSync();
    // var fileContentBase64 = base64.encode(fileContent);
    setState(() {
      uploading = true;
    });
    try {
      Map<String, String> header = {
        'Authorization': ApiManager.authKey,
      };
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.files
          .add(await http.MultipartFile.fromPath('profile_image', file.path));
      // request.fields['profile_image'] = file.path;
      request.headers.addAll(header);
      var res = await request.send();
      var prefs = await SharedPreferences.getInstance();
      var responseData = await res.stream.toBytes();
      var result = String.fromCharCodes(responseData);
      if (kDebugMode) {
        print('ImageResponse : ${result.toString()}');
      }
      var imageResponse = json.decode(result.toString());
      var success = imageResponse['status'];
      if (success == 200) {
        Fluttertoast.showToast(msg: imageResponse['message']);

        //get Account details
        var url = ApiManager.BASE_URL + ApiManager.getAccount;
        final headers = {
          'Authorization': ApiManager.authKey,
        };
        final response = await http.get(Uri.parse(url), headers: headers);
        var responseData = await json.decode(response.body);
        var image = responseData['data']['image'];
        prefs.setString('profile_image', image);
        if (kDebugMode) {
          print(image);
        }
        setState(() {
          uploading = false;
        });
      } else {
        setState(() {
          uploading = false;
        });
      }
    } catch (e) {
      setState(() {
        uploading = false;
      });
      rethrow;
    }
  }

  PopupMenuItem<int> _buildPopupMenuItem(IconData iconData, int position) {
    return PopupMenuItem<int>(
      value: position,
      child: Row(
        children: [
          Icon(
            iconData,
            color: Colors.pink,
          ),
        ],
      ),
    );
  }

  _onMenuItemSelected(int value) {
    setState(() {
      _popupMenuItemIndex = value;
    });
    debugPrint(_popupMenuItemIndex.toString());
    if (value == Options.camera.index) {
      _changeColorAccordingToMenuItem = Icons.camera;
    } else if (value == Options.photos.index) {
      _changeColorAccordingToMenuItem = Icons.photo_size_select_actual;
    }
  }
}

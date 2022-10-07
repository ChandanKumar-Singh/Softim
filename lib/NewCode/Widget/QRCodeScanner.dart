import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:crm_application/ApiManager/Apis.dart';
import 'package:crm_application/NewCode/HomePage.dart';
import 'package:crm_application/NewCode/Model/UserLoginData.dart';
import 'package:crm_application/NewCode/Provider/AuthProvider.dart';
import 'package:duration_button/duration_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart ' as http;
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QRCodeScanner extends StatefulWidget {
  const QRCodeScanner({Key? key}) : super(key: key);

  @override
  State<QRCodeScanner> createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  Position? currentPosition;
  bool locationTurnedOn = false;
  bool isLoading = false;

  late BranchInfo branchInfo;

  void getUserData() async {
    var prefs = await SharedPreferences.getInstance();
    var response = prefs.getString('loginData');
    print(response);
    branchInfo =
        BranchInfo.fromJson(jsonDecode(response!)['results']['branch_info']);
    print(
        '---------------------------------------------------------------------------------------------------------------------------------------------------------- \n ${branchInfo.longitude}  ------------');
    initCurrentPosition();
    showAdjustErrorToast();
    initScanner();
  }

  Future<void> makeAttendance() async {
    String curDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    print('current date : $curDate');
    var url = ApiManager.BASE_URL + ApiManager.attendance;
    final headers = {
      'Authorization': ApiManager.authKey,
    };
    Map<String, dynamic> body = {"attendance": "1", "date": curDate};
    setState(() {
      isLoading = true;
    });
    try {
      var responce =
          await http.post(Uri.parse(url), headers: headers, body: body);
      print(responce.body);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  void initScanner() async {
    await controller?.resumeCamera();
  }

  void showAdjustErrorToast() async {
    debugPrint('showAdjustErrorToast----------------');
    Timer(const Duration(seconds: 6), () {
      if (result == null) {
        Fluttertoast.showToast(
          msg: 'Please adjust your camera screen\nto scan properly.',
          backgroundColor: Colors.red,
        );
      }
    });
  }

  void initCurrentPosition() async {
    currentPosition = await _determinePosition();
    debugPrint(currentPosition.toString());
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    double _w = MediaQuery.of(context).size.width;
    double _h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                    overlay: QrScannerOverlayShape(
                      borderColor: Colors.red,
                      borderRadius: 10,
                      borderLength: 30,
                      borderWidth: 10,
                      cutOutSize: scanArea,
                    ),
                    onPermissionSet: (ctrl, p) =>
                        _onPermissionSet(context, ctrl, p)),
                Opacity(
                  opacity: 0,
                  child: DurationButton(
                    duration: const Duration(microseconds: 50),
                    onPressed: () {},
                    backgroundColor: Colors.transparent,
                    splashFactory: NoSplash.splashFactory,
                    onComplete: () async {
                      await controller
                          ?.resumeCamera()
                          .then((value) => print('resumed'));
                    },
                    child: const Text(""),
                  ),
                ),
                Positioned(
                  bottom: _h * 0.1,
                  left: _w / 2.3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () async {
                          HapticFeedback.lightImpact();
                          await controller!.toggleFlash();
                        },
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(99)),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaY: 40, sigmaX: 40),
                            child: Container(
                              height: _h * 0.06,
                              width: _h * 0.06,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.4),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.flashlight_on_rounded,
                                  size: _w / 17,
                                  color: Colors.black.withOpacity(.6),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: _h * 0.1,
                  left: _w / 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(99)),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaY: 40, sigmaX: 40),
                          child: Container(
                            height: _h * 0.05,
                            width: _w / 3,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Center(
                                child: AnimatedTextKit(
                              repeatForever: true,
                              animatedTexts: [
                                TypewriterAnimatedText('Scanning...',
                                    speed: const Duration(milliseconds: 100),
                                    cursor: ''),
                              ],
                            )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
      });
      print(
          '********************************************************************** ${result!.format  } ***********************${result!.code  } **************************');
      var prefs = await SharedPreferences.getInstance();
      var response = prefs.getString('loginData');
      // print(response);
     UserLoginData userData = UserLoginData.fromJson(jsonDecode(response!)['results']);

      await makeAttendance().then((value) async => await Fluttertoast.showToast(
              msg:
                  //             'Hello ${result!.code!.split(':').getRange(0, 2).join(' ')} Good Morning ✋.'
                  'Hello ${userData.data!.name!.toUpperCase()}. Good Morning ✋.')
          // )
          .then((value) async =>
              await Fluttertoast.showToast(msg: 'Your Attendance Has Done.'))
          .then((value) => Navigator.maybePop(context)));
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void disposeToast() async {
    await Fluttertoast.cancel();
  }

  ///location
  Future<Position?> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    Position? position;
    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await controller?.stopCamera();
        await Geolocator.openLocationSettings().then((value) async {});
        await controller?.flipCamera();
        await controller?.flipCamera();
        bool location = await Geolocator.isLocationServiceEnabled();
        setState(() {
          locationTurnedOn = location;
        });
        if (!locationTurnedOn) {}
      }
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      /// userPosition
      position = await Geolocator.getCurrentPosition();
      print('user position:---> ' + position.toString());

      /// educationCenterPosition
      Position educationCenterPosition = Position(
          // longitude: 80.94527593923328,
          // latitude: 26.930455310322547,
          longitude: double.parse(branchInfo.longitude!),
          latitude: double.parse(branchInfo.latitude!),
          timestamp: DateTime.now(),
          accuracy: 90,
          altitude: 20,
          heading: 20,
          speed: 30,
          speedAccuracy: 50);
      print('educationCenterPosition position:---> ' +
          educationCenterPosition.toString());

      ///measure distance
      var _distanceInMeters = await Geolocator.distanceBetween(
        26.93126010956731,
        80.94693147449263,
        educationCenterPosition.latitude,
        educationCenterPosition.longitude,
      );
      print(
          'Distaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaance --- ${_distanceInMeters.floorToDouble().toStringAsFixed(3)} meters');

      ///distance error
      if (_distanceInMeters >= double.parse(branchInfo.radius!)) {
        await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              if (Platform.isAndroid) {
                return WillPopScope(
                    onWillPop: () async {
                      return Navigator.maybePop(context, false);
                    },
                    child: AlertDialog(
                      content:
                          const Text('You are not at your education center.'),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                  onPressed: () =>
                                      Navigator.pushNamedAndRemoveUntil(context,
                                          HomePage.routeName, (route) => false),
                                  child: const Text('Go Back')),
                            ),
                          ],
                        )
                      ],
                    ));
              }
              if (Platform.isIOS) {
                return WillPopScope(
                  onWillPop: () async {
                    return Navigator.maybePop(context, false);
                  },
                  child: CupertinoAlertDialog(
                    content:
                        const Text('You are not at your education center.'),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                                onPressed: () => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HomePage())),
                                child: const Text('Go Back')),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              }
              return Container();
            });
      }
    } catch (e) {
      print('GeoLocator error --- $e');
    }
    return position;
  }

  Future<bool> goBack() async {
    return false;
  }
}

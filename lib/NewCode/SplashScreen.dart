import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:animator/animator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import '../FCM/local_notification_service.dart';
import '../Utils/Constant.dart';
import 'Auth/LoginPage.dart';

class WelcomeSplashScreen extends StatefulWidget {
  static const routeName = '/splashScreen';

  const WelcomeSplashScreen({Key? key}) : super(key: key);
  @override
  _WelcomeSplashScreenState createState() => _WelcomeSplashScreenState();
}

class _WelcomeSplashScreenState extends State<WelcomeSplashScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String _deviceToken = '';
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();

    Timer(Duration(milliseconds: 400), () {
      setState(() {
        _a = true;
      });
    });
    Timer(Duration(milliseconds: 600), () {
      setState(() {
        _b = true;
      });
    });
    Timer(Duration(milliseconds: 1800), () {
      setState(() {
        _c = true;
      });
    });
    Timer(Duration(milliseconds: 2500), () {
      setState(() {
        _e = true;
      });
    });
    Timer(const Duration(milliseconds: 4000), () {
      setState(() {
        _b = false;
        _d = true;
      });
    });
    Timer(const Duration(milliseconds: 5000), () {
      checkLogin(context);
    });
    _saveDeviceToken();

    // workaround for onLaunch: When the app is completely closed (not in the background) and opened directly from the push notification
    _firebaseMessaging.getInitialMessage().then(
      (RemoteMessage? message) {
        debugPrint('getInitialMessage data: ${message?.data}');
      },
    );

    // onMessage: When the app is open and it receives a push notification
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        debugPrint("onMessage data: ${message.data}");
        LocalNotificationService.createanddisplaynotification(message);
      },
    );

    // replacement for onResume: When the app is in the background and opened directly from the push notification.
    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        debugPrint('onMessageOpenedApp data: ${message.data}');
        //Navigator.pushNamed(context, '/home');
      },
    );
  }

  Future<String?> _saveDeviceToken() async {
    prefs = await SharedPreferences.getInstance();
    if (Platform.isAndroid) {
      var token = await FirebaseMessaging.instance.getToken();
      setState(() {
        _deviceToken = token!;
      });
    } else if (Platform.isIOS) {
      var token = await FirebaseMessaging.instance.getAPNSToken();
      setState(() {
        _deviceToken = token!;
      });
    }
    if (_deviceToken != null) {
      debugPrint('--------Device Token---------- ${_deviceToken}');
      await prefs.setString(Const.FCM_TOKEN, _deviceToken);
    }
    return _deviceToken;
  }

  bool _a = false;
  bool _b = false;
  bool _c = false;
  bool _d = false;
  bool _e = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _h = MediaQuery.of(context).size.height;
    double _w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xBE7FF55A),
      body: Center(
        child: Stack(
          children: [
            Center(
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: _d ? 900 : 5000),
                    curve:
                        _d ? Curves.fastLinearToSlowEaseIn : Curves.elasticOut,
                    height: _d
                        ? 0
                        : _a
                            ? _h / 2
                            : 20,
                    width: 20,
                  ),
                  AnimatedContainer(
                    duration: Duration(
                        seconds: _d
                            ? 1
                            : _c
                                ? 2
                                : 0),
                    curve: Curves.fastLinearToSlowEaseIn,
                    height: _d
                        ? _h
                        : _c
                            ? 80
                            : 20,
                    width: _d
                        ? _w
                        : _c
                            ? _w * 0.6
                            : 20,
                    decoration: BoxDecoration(
                        color: _b
                            ? Colors.white
                            : _d
                                ? const Color(0xFF008CC7)
                                : Colors.transparent,
                        borderRadius: _d
                            ? const BorderRadius.only()
                            : BorderRadius.circular(30)),
                    child: Center(
                      child: _e
                          ? AnimatedTextKit(
                              totalRepeatCount: 1,
                              animatedTexts: [
                                WavyAnimatedText('softim'.toUpperCase(),
                                    textStyle: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                15,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black),
                                    speed: const Duration(milliseconds: 200)),
                              ],
                            )
                          : const SizedBox(),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Center(
                child: Column(
                  children: [
                    Animator<double>(
                        duration: const Duration(seconds: 1),
                        cycles: 0,
                        curve: Curves.easeInOut,
                        tween: Tween(begin: 0, end: 10),
                        builder: (context, animatorState, child) => Column(
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                ),
                                SizedBox(
                                  height: animatorState.value * 3,
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.asset(
                                    'assets/images/app-logo.png',
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                  ),
                                ),
                              ],
                            )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void checkLogin(BuildContext context) async {
    String TAG = 'SplashScreen';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    // debugPrint('$TAG ------------- ' + userId.toString());
    // debugPrint("$TAG UserId : $userId");
    Future.delayed(
      const Duration(seconds: 0),
      () {
        if (userId == null) {
          Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
        } else {
          Navigator.of(context).pushReplacementNamed('/homePage');
        }
      },
    );
  }
}

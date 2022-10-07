import 'dart:async';

import 'package:crm_application/NewCode/Auth/LoginPage.dart';
import 'package:crm_application/NewCode/Auth/changePassword.dart';
import 'package:crm_application/NewCode/HomePage.dart';
import 'package:crm_application/NewCode/Widget/faseInRoute.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key, required this.route}) : super(key: key);
  final Widget route;

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool otpSent = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: SizedBox(
            height: size.height,
            child: Stack(
              children: [
                SizedBox(
                  height: size.height,
                  child: Image.asset(
                    'assets/images/verify.png',
                    // #Image Url: https://unsplash.com/photos/bOBM8CB4ZC4
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      const Expanded(
                        child: SizedBox(),
                      ),
                      Expanded(
                        flex: 7,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaY: 35, sigmaX: 35),
                            child: SizedBox(
                              width: size.width * .9,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(height: 20,),
                                  CircleAvatar(
                                    // decoration: BoxDecoration(
                                    //   shape: BoxShape.circle,
                                    //   color: Colors.white,
                                    // ),
                                    backgroundColor: Colors.white,
                                    radius:
                                    MediaQuery.of(context).size.width / 6,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        'assets/images/app-logo.png',
                                        width:
                                        MediaQuery.of(context).size.width /
                                            4,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: size.width * .04,
                                      bottom: size.width * .1,
                                    ),
                                    child: Text(
                                      'Verify Your Identity',
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white.withOpacity(1),
                                      ),
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: EdgeInsets.only(
                                  //     top: size.width * .15,
                                  //     bottom: size.width * .1,
                                  //   ),
                                  //   child: Text(
                                  //     'Verify Your Identity',
                                  //     style: TextStyle(
                                  //       fontSize: 25,
                                  //       fontWeight: FontWeight.w600,
                                  //       color: Colors.white.withOpacity(.8),
                                  //     ),textAlign: TextAlign.center,
                                  //   ),
                                  // ),
                                  // SizedBox(
                                  //   height: size.height / 10,
                                  // ),
                                  component(
                                    Icons.account_circle_outlined,
                                    'User Name...',
                                    false,
                                    false,
                                  ),
                                  //show when a otp has sent
                                  otpSent
                                      ? component(
                                          Icons.lock_outline,
                                          'OTP...',
                                          true,
                                          false,
                                        )
                                      : Container(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: size.width / 20),
                                        child: TextButton(
                                          onPressed: (){
                                            Fluttertoast.showToast(
                                              msg: 'A new otp has send.',
                                            );
                                          },
                                          child: RichText(
                                            text: const TextSpan(
                                              text: 'Resend ?',
                                              style:  TextStyle(
                                                color: Colors.white,
                                              ),
                                              // recognizer: TapGestureRecognizer()
                                              //   ..onTap = () {
                                              //     HapticFeedback.lightImpact();
                                              //     Fluttertoast.showToast(
                                              //       msg: 'A new otp has send.',
                                              //     );
                                              //   },
                                            ),
                                          ),
                                        ),
                                      ),
                                      // RichText(
                                      //   text: TextSpan(
                                      //     text: 'Create a new Account',
                                      //     style: const TextStyle(
                                      //       color: Colors.white,
                                      //     ),
                                      //     recognizer: TapGestureRecognizer()
                                      //       ..onTap = () {
                                      //         HapticFeedback.lightImpact();
                                      //         Fluttertoast.showToast(
                                      //           msg:
                                      //           'Create a new Account button pressed',
                                      //         );
                                      //       },
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  SizedBox(height: size.width * .3),
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      HapticFeedback.lightImpact();
                                      //get opt call back
                                      if (!otpSent) {
                                        setState(() {
                                          otpSent = true;
                                        });
                                        Fluttertoast.showToast(
                                          msg: 'Otp sent',
                                        );
                                      }
                                      if (otpSent) {
                                        Timer(Duration(seconds: 3), () {
                                          Fluttertoast.showToast(
                                            msg: 'Verified',
                                          );
                                          setState(() {
                                            otpSent = false;
                                          });
                                          Navigator.of(context).pushReplacement(
                                              ThisIsFadeRoute(route: widget.route));
                                        });
                                      }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                        bottom: size.width * .05,
                                      ),
                                      height: size.width / 8,
                                      width: size.width / 1.25,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        !otpSent ? 'Get OTP' : 'Verify',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Expanded(
                        child: SizedBox(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget component(
      IconData icon, String hintText, bool isPassword, bool isEmail) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.width / 8,
      width: size.width / 1.25,
      alignment: Alignment.center,
      padding: EdgeInsets.only(right: size.width / 30),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        style: TextStyle(
          color: Colors.white.withOpacity(.9),
        ),
        obscureText: isPassword,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Colors.white.withOpacity(.8),
          ),
          border: InputBorder.none,
          hintMaxLines: 1,
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(.5),
          ),
        ),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) {
    return child;
  }
}

import 'package:crm_application/NewCode/Auth/changePassword.dart';
import 'package:crm_application/NewCode/Auth/forgotPassword.dart';
import 'package:crm_application/NewCode/Provider/AuthProvider.dart';
import 'package:crm_application/NewCode/Widget/faseInRoute.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const routeName ='/loginPage';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController userName = TextEditingController();
  TextEditingController passWord = TextEditingController();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<AuthProviders>(builder: (context, provider, _) {
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
                      'assets/images/education-logo2.png',
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
                              filter: ImageFilter.blur(sigmaY: 25, sigmaX: 25),
                              child: SizedBox(
                                width: size.width * .9,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius:
                                          MediaQuery.of(context).size.width / 6,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset(
                                          'assets/images/app-logo.png',
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              4,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        bottom: size.width * .1,
                                      ),
                                      child: Text(
                                        'Login in to get started',
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white.withOpacity(1),
                                        ),
                                      ),
                                    ),
                                    component(Icons.account_circle_outlined,
                                        'User Name...', false, false, userName),

                                    component(Icons.lock_outline, 'Password...',
                                        true, false, passWord),
                                  /*  Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: size.width / 20),
                                          child: RichText(
                                            text: TextSpan(
                                              text: 'Forgot password ?',
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  HapticFeedback.lightImpact();
                                                  Navigator.of(context).push(
                                                      ThisIsFadeRoute(
                                                          route:
                                                              const ForgotPassword(
                                                    route: ChangePassword(
                                                        route: LoginPage()),
                                                  )));
                                                },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),*/
                                    SizedBox(height: size.width * .3),
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        HapticFeedback.lightImpact();
                                        _isLoading = false;
                                        var f = Provider.of<AuthProviders>(
                                                context,
                                                listen: false)
                                            .isLoading;

                                        await Provider.of<AuthProviders>(
                                                context,
                                                listen: false)
                                            .login(userName.text, passWord.text,
                                                context)
                                            .then((value) => setState(() {
                                                  _isLoading = false;
                                                }));
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
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: provider.isLoading
                                            ? const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            : const Text(
                                                'Sing-In',
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
    });
  }

  Widget component(IconData icon, String hintText, bool isPassword,
      bool isEmail, TextEditingController controller) {
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
        controller: controller,
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

import 'dart:ui';

import 'package:crm_application/NewCode/Auth/LoginPage.dart';
import 'package:crm_application/NewCode/Provider/AuthProvider.dart';
import 'package:crm_application/NewCode/Widget/faseInRoute.dart';
import 'package:crm_application/NewCode/Widget/profilePages/ProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  DrawerWidgetState createState() => DrawerWidgetState();
}

class DrawerWidgetState extends State<DrawerWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> animation1;
  late Animation<double> _animation2;
  late Animation<double> _animation3;

  bool _bool = true;
  String image = '';
  void getProgilePic() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      image = prefs.getString('profile_image')!;
    });
    print(image);
  }

  @override
  void initState() {
    super.initState();
    getProgilePic();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));

    animation1 = Tween<double>(begin: 0, end: 5).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    ))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          _bool = true;
        }
      });
    _animation2 = Tween<double>(begin: 0, end: .3).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    _animation3 = Tween<double>(begin: .9, end: 1).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastLinearToSlowEaseIn,
        reverseCurve: Curves.ease))
      ..addListener(() {
        setState(() {});
      });
    if (_bool == true) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    _bool = false;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        SizedBox(
          height: _height,
          width: _width,
          child: null,
        ),
        customNavigationDrawer(),
      ],
    );
  }

  Widget customNavigationDrawer() {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return BackdropFilter(
      filter:
          ImageFilter.blur(sigmaY: animation1.value, sigmaX: animation1.value),
      child: Container(
        height: _bool ? 0 : _height,
        width: _bool ? 0 : _width,
        color: Colors.transparent,
        child: Center(
          child: Transform.scale(
            scale: _animation3.value,
            child: Container(
              width: _width * .7,
              height: _width * 1.3,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(_animation2.value),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Scaffold.of(context).closeDrawer();
                      Navigator.of(context).push(ThisIsFadeRoute(
                          route: const ProfilePage(), time: 300));
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.black12,
                      radius: 35,
                      backgroundImage: image == ''
                          ? const AssetImage('assets/images/profile.png')
                          : NetworkImage(image) as ImageProvider,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      MyTile(Icons.settings_outlined, 'Settings', () {
                        HapticFeedback.lightImpact();
                        Fluttertoast.showToast(
                          msg: 'Button pressed',
                        );
                      }),
                      MyTile(Icons.find_in_page_outlined, 'Privacy Policy', () {
                        HapticFeedback.lightImpact();
                        Fluttertoast.showToast(
                          msg: 'Button pressed',
                        );
                      }),
                      MyTile(Icons.logout, 'Log Out', () async {
                        HapticFeedback.lightImpact();
                        await Provider.of<AuthProviders>(context, listen: false)
                            .logOut(context);
                      }),
                    ],
                  ),
                  const SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget backgroundImage() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width / 9,
      child: Image.asset(
        'assets/images/education-logo.png',
        fit: BoxFit.fitHeight,
      ),
    );
  }

  Widget MyTile(
    IconData icon,
    String title,
    VoidCallback voidCallback,
  ) {
    return Column(
      children: [
        ListTile(
          tileColor: Colors.black.withOpacity(.08),
          leading: CircleAvatar(
            backgroundColor: Colors.black12,
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
          onTap: voidCallback,
          title: Text(
            title,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1),
          ),
          trailing: const Icon(
            Icons.arrow_right,
            color: Colors.white,
          ),
        ),
        divider()
      ],
    );
  }

  Widget divider() {
    return Container(
      height: 5,
      width: MediaQuery.of(context).size.width,
    );
  }
}

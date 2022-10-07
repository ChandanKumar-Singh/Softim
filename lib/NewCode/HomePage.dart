import 'dart:convert';

import 'package:crm_application/NewCode/Model/UserLoginData.dart';
import 'package:crm_application/NewCode/Widget/drawer/DrawerWidget.dart';
import 'package:crm_application/NewCode/Widget/FavoritePage.dart';
import 'package:crm_application/NewCode/Widget/StudyMaterial/StudyMaterialPage.dart';
import 'package:crm_application/NewCode/Widget/profilePages/FeeDetails.dart';
import 'package:crm_application/NewCode/Widget/profilePages/PresenceDetails.dart';
import 'package:crm_application/NewCode/Widget/profilePages/ProfilePage.dart';
import 'package:crm_application/ThemeManager/ThemeManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';

import 'Widget/QRCodeScanner.dart';
import 'Widget/VideoPlayer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const routeName = '/homePage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  var currentIndex = 0;
  var lastTapped = 0;
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _animation2;
  late ScrollController scrollController;
  late double scrollPosition;
  bool isScrolling = false;
  ThemeManager _themeManager = ThemeManager();
  bool themeModeValue = false;

  scrollListener() {
    setState(() {
      scrollPosition = scrollController.position.pixels;
      if (scrollController.position.activity!.isScrolling) {
        isScrolling = true;
      } else {
        isScrolling = false;
      }
    });
    print(isScrolling);
    // print(scrollPosition);
  }

  int notificationCount = 111;
  late UserLoginData userData;
  bool _visible = false;

  Future<UserLoginData> getUserData() async {
    var prefs = await SharedPreferences.getInstance();
    var response = prefs.getString('loginData');
    // print(response);
    userData = UserLoginData.fromJson(jsonDecode(response!)['results']);
    // print(userData.data!.username!);
    return userData;
  }

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();
    scrollController.addListener(scrollListener);
    scrollPosition = 0;
    setState(() {
      currentIndex = lastTapped;
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut))
      ..addListener(() {
        setState(() {});
      });

    _animation2 = Tween<double>(begin: -30, end: 0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<bool> goBack(BuildContext context) async {
    if (currentIndex != 0) {
      setState(() {
        currentIndex = 0;
      });
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;
    double _h = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        var willBack = await goBack(context);
        print(willBack);
        return willBack;
      },
      child: Scaffold(
        // backgroundColor: Colors.white,
        drawer: const DrawerWidget(),
        body: FutureBuilder(
            future: getUserData(),
            builder: (context, AsyncSnapshot snap) {
              if (snap.hasError) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snap.data != null) {
                  return Stack(
                    children: [
                      currentIndex == 0
                          ? Stack(
                              children: [
                                /// ListView

                                Container(
                                  decoration: const BoxDecoration(
                                      // color: Color.fromRGBO(0, 133, 194, 1),
                                      color: Colors.white60),
                                  height: _h,
                                  child: ListView(
                                    controller: scrollController,
                                    physics: const BouncingScrollPhysics(
                                        parent:
                                            AlwaysScrollableScrollPhysics()),
                                    children: [
                                      ClipPath(
                                        clipper: WaveClipperTwo(),
                                        child: ClipPath(
                                          clipper: OvalBottomBorderClipper(),
                                          child: Container(
                                            color: const Color.fromRGBO(
                                                44, 92, 255, 1.0),
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  _w / 17, _w / 20, 0, _w / 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: scrollPosition
                                                            .isNegative
                                                        ? -scrollPosition +
                                                            kToolbarHeight -
                                                            22
                                                        : 0,
                                                  ),
                                                  Text(
                                                    'Hi,\n${userData.data!.name!.toUpperCase()} 👋',
                                                    style: TextStyle(
                                                      fontSize: 22,
                                                      color: Colors.white
                                                          .withOpacity(.9),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                  SizedBox(height: _w / 35),
                                                  Text(
                                                    '${userData.branchInfo!.name!.toUpperCase()}',
                                                    style: TextStyle(
                                                      fontSize: 19,
                                                      color: Colors.white
                                                          .withOpacity(.9),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                  Text(
                                                    'Course : ${userData.courseInfo!.course!.toUpperCase()}',
                                                    style: TextStyle(
                                                      fontSize: 19,
                                                      color: Colors.white
                                                          .withOpacity(.9),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                  Text(
                                                    'Batch No. : ${userData.batchInfo!.first.batchName!.toUpperCase()}',
                                                    style: TextStyle(
                                                      fontSize: 19,
                                                      color: Colors.white
                                                          .withOpacity(.9),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                  // Text(
                                                  //   'Here you can write something\nabout your app.',
                                                  //   style: TextStyle(
                                                  //     fontSize: 19,
                                                  //     color: Colors.white
                                                  //         .withOpacity(.9),
                                                  //     fontWeight: FontWeight.w500,
                                                  //   ),
                                                  //   textAlign: TextAlign.start,
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      /*SizedBox(
                                      height: _h * 0.2,
                                      // color: Colors.grey,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: _w / 17, vertical: 5),
                                            child: Text(
                                              'Some Title',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 30,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                              itemCount: 13,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                    padding: EdgeInsets.only(
                                                      right: 18.0,
                                                      left: index == 0 ? _w / 17 : 0,
                                                    ),
                                                    child: Container(
                                                      width: _w / 2,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.circular(15),
                                                      ),
                                                    ));
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      height: _h * 0.2,
                                      // color: Colors.grey,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: _w / 17, vertical: 5),
                                            child: Text(
                                              'Some Title',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 30,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                              itemCount: 13,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                    padding: EdgeInsets.only(
                                                      right: 18.0,
                                                      left: index == 0 ? _w / 17 : 0,
                                                    ),
                                                    child: Container(
                                                      width: _w / 2,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.circular(15),
                                                      ),
                                                    ));
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      height: _h * 0.2,
                                      // color: Colors.grey,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: _w / 17, vertical: 5),
                                            child: Text(
                                              'Some Title',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 30,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                              itemCount: 13,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                    padding: EdgeInsets.only(
                                                      right: 18.0,
                                                      left: index == 0 ? _w / 17 : 0,
                                                    ),
                                                    child: Container(
                                                      width: _w / 2,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.circular(15),
                                                      ),
                                                    ));
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      height: _h * 0.2,
                                      // color: Colors.grey,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: _w / 17, vertical: 5),
                                            child: Text(
                                              'Some Title',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 30,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                              itemCount: 13,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                    padding: EdgeInsets.only(
                                                      right: 18.0,
                                                      left: index == 0 ? _w / 17 : 0,
                                                    ),
                                                    child: Container(
                                                      width: _w / 2,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.circular(15),
                                                      ),
                                                    ));
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    homePageCardsGroup(
                                      const Color(0xfff37736),
                                      Icons.analytics_outlined,
                                      'Example example',
                                      context,
                                      RouteWhereYouGo(),
                                      const Color(0xffFF6D6D),
                                      Icons.all_inclusive,
                                      'Example example example',
                                      RouteWhereYouGo(),
                                    ),*/
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Switch(
                                          value: Provider.of<ThemeManager>(
                                                      context,
                                                      listen: false)
                                                  .themeMode ==
                                              ThemeMode.dark,
                                          onChanged: (newValue) {
                                            setState(() {
                                              themeModeValue = !themeModeValue;
                                            });

                                            Provider.of<ThemeManager>(context,
                                                    listen: false)
                                                .toogleTheme(newValue);
                                            var theme =
                                                Provider.of<ThemeManager>(
                                                        context,
                                                        listen: false)
                                                    .themeMode;
                                            print(theme);
                                            print(Theme.of(context)
                                                .platform
                                                .name);
                                          }),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      homePageCardsGroup(
                                          Colors.lightGreen,
                                          Icons.card_travel,
                                          'assets/images/attendance.png',
                                          'Your Attendance',
                                          context,
                                          const PresenceDetails(),
                                          // MyHomePage(
                                          //     title:
                                          //         'Flutter Calendar Carousel Example'),
                                          const Color(0xffffa700),
                                          Icons.article,
                                          'assets/images/fees.png',
                                          'Fee Details',
                                          const FeeDetails()),
                                      homePageCardsGroup(
                                          const Color(0xff63ace5),
                                          Icons.ad_units_outlined,
                                          'assets/images/study-material.png',
                                          'Study Materials',
                                          context,
                                          StudyMaterialPage(
                                              platform:
                                                  Theme.of(context).platform),
                                          const Color(0xfff37736),
                                          Icons.article_sharp,
                                          'assets/images/profile2.png',
                                          'Profile',
                                          const ProfilePage()),
                                      /*homePageCardsGroup(
                                        Color(0xffFF6D6D),
                                        Icons.android,
                                        'Example example',
                                        context,
                                        RouteWhereYouGo(),
                                        Colors.lightGreen,
                                        Icons.text_format,
                                        'Example',
                                        RouteWhereYouGo()),
                                    homePageCardsGroup(
                                        Color(0xffffa700),
                                        Icons.text_fields,
                                        'Example',
                                        context,
                                        RouteWhereYouGo(),
                                        Color(0xff63ace5),
                                        Icons.calendar_today_sharp,
                                        'Example example',
                                        RouteWhereYouGo()),*/
                                      SizedBox(height: _w / 20),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: scrollPosition.isNegative
                                      ? -scrollPosition + kToolbarHeight
                                      : 0,
                                  decoration: const BoxDecoration(
                                    color: Color.fromRGBO(44, 92, 255, 1),
                                  ),
                                ),
                                // : Container(),

                                /// SETTING ICON
                                // currentIndex == 0 ?
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      0, _h * 0.06, _w / 15, 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Stack(
                                        children: [
                                          InkWell(
                                            highlightColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            onTap: () {
                                              HapticFeedback.lightImpact();
                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //     builder: (context) {
                                              //       return RouteWhereYouGo();
                                              //     },
                                              //   ),
                                              // );
                                              Scaffold.of(context).openDrawer();
                                            },
                                            child: Container(
                                              height: _h * 0.06,
                                              width: _h * 0.06,
                                              decoration: const BoxDecoration(
                                                // color: Colors.cyanAccent
                                                //     .withOpacity(.4),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.menu,
                                                  size: _w / 17,
                                                  color: Colors.white
                                                      .withOpacity(1),
                                                ),
                                              ),
                                            ),
                                            // Badge(
                                            //   badgeContent: Padding(
                                            //     padding: const EdgeInsets.all(3.0),
                                            //     child: Text(
                                            //       notificationCount > 99
                                            //           ? '99+'
                                            //           : notificationCount.toString(),
                                            //       style: const TextStyle(
                                            //           color: Colors.white),
                                            //     ),
                                            //   ),
                                            //   child: ClipRRect(
                                            //     borderRadius: const BorderRadius.all(
                                            //         Radius.circular(99)),
                                            //     child: BackdropFilter(
                                            //       filter: ImageFilter.blur(
                                            //           sigmaY: 5, sigmaX: 5),
                                            //       child:
                                            //       Container(
                                            //         height: _h * 0.06,
                                            //         width: _h * 0.06,
                                            //         decoration: BoxDecoration(
                                            //           color: Colors.cyanAccent
                                            //               .withOpacity(.4),
                                            //           shape: BoxShape.circle,
                                            //         ),
                                            //         child: Center(
                                            //           child: Icon(
                                            //             Icons.notifications,
                                            //             size: _w / 17,
                                            //             color:
                                            //                 Colors.white.withOpacity(.6),
                                            //           ),
                                            //         ),
                                            //       ),
                                            //     ),
                                            //   ),
                                            // ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // : Container(),

                                ///Attendance
                                // currentIndex == 0
                                //     ?
                                /* Padding(
                                padding: EdgeInsets.fromLTRB(0, _h * 0.13, _w / 15, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      highlightColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      onTap: () {
                                        HapticFeedback.lightImpact();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return const QRCodeScanner();
                                            },
                                          ),
                                        );
                                      },
                                      child: ClipRRect(
                                        borderRadius:
                                            const BorderRadius.all(Radius.circular(99)),
                                        child: BackdropFilter(
                                          filter:
                                              ImageFilter.blur(sigmaY: 5, sigmaX: 5),
                                          child: Container(
                                            height: _h * 0.06,
                                            width: _h * 0.06,
                                            decoration: BoxDecoration(
                                              color: Colors.cyanAccent.withOpacity(.4),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.qr_code_scanner,
                                                size: _w / 17,
                                                color: Colors.white.withOpacity(.6),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),*/
                                // : Container(),

                                /// Blur the Status bar
                                // blurTheStatusBar(context),

                                ///Bottom Nav Bar
                                // Align(
                                //   // bottom: MediaQuery.of(context).size.height*0.1,
                                //   // left: MediaQuery.of(context).size.height*0.1,
                                //   alignment: Alignment.bottomCenter,
                                //   child: buildBottomNavBar(context),
                                // ),
                              ],
                            )
                          : currentIndex == 1
                              ? const QRCodeScanner()
                              : currentIndex == 2
                                  ? StudyMaterialPage(
                                      platform: Theme.of(context).platform)
                                  : ProfilePage(
                                      currentIndex: currentIndex,
                                    ),
                      // blurTheStatusBar(context),

                      // if (currentIndex != 0)
                      //   Align(
                      //     alignment: Alignment.bottomCenter,
                      //     child: buildBottomNavBar(context),
                      //   ),
                      // isScrolling
                      //     ? Align(
                      //         alignment: Alignment.bottomCenter,
                      //         child: buildBottomNavBar(context),
                      //       )
                      //     : Container(),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: buildBottomNavBar(context),
                      )
                    ],
                  );
                }
                return const Center(
                  child: Text('Please restart the app.'),
                );
              }
            }),
      ),
    );
  }

  Widget buildBottomNavBar(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.all(displayWidth * .05),
      height: displayWidth * .155,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.1),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
        borderRadius: BorderRadius.circular(50),
      ),
      child: ListView.builder(
        itemCount: 4,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: displayWidth * .02),
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            setState(() {
              currentIndex = index;
              HapticFeedback.lightImpact();
              print(currentIndex);
              // Navigator.of(context).push(
              //     MaterialPageRoute(builder: (context) => listOfRoutes[index]));
            });
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(seconds: 1),
                curve: Curves.fastLinearToSlowEaseIn,
                width: index == currentIndex
                    ? displayWidth * .32
                    : displayWidth * .18,
                alignment: Alignment.center,
                child: AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  curve: Curves.fastLinearToSlowEaseIn,
                  height: index == currentIndex ? displayWidth * .12 : 0,
                  width: index == currentIndex ? displayWidth * .32 : 0,
                  decoration: BoxDecoration(
                    color: index == currentIndex
                        ? Colors.blueAccent.withOpacity(.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(seconds: 1),
                curve: Curves.fastLinearToSlowEaseIn,
                width: index == currentIndex
                    ? displayWidth * .31
                    : displayWidth * .18,
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(seconds: 1),
                          curve: Curves.fastLinearToSlowEaseIn,
                          width: index == currentIndex ? displayWidth * .13 : 0,
                        ),
                        AnimatedOpacity(
                          opacity: index == currentIndex ? 1 : 0,
                          duration: const Duration(seconds: 1),
                          curve: Curves.fastLinearToSlowEaseIn,
                          child: Text(
                            index == currentIndex ? listOfStrings[index] : '',
                            style: const TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(seconds: 1),
                          curve: Curves.fastLinearToSlowEaseIn,
                          width:
                              index == currentIndex ? displayWidth * .03 : 20,
                        ),
                        Icon(
                          listOfIcons[index],
                          size: displayWidth * .076,
                          color: index == currentIndex
                              ? Colors.blueAccent
                              : Colors.grey,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<IconData> listOfIcons = [
    Icons.home_rounded,
    Icons.qr_code_scanner,
    // Icons.personal_video,
    Icons.menu_book_rounded,
    Icons.manage_accounts_rounded
  ];
  List listOfRoutes = [
    const HomePage(),
    const FavouritePage(),
    VideoApp(),
    // const StudyMaterialPage(),
  ];

  List<String> listOfStrings = [
    'Home',
    // 'Favorite',
    // 'Videos',
    'Attendance',
    'Study\nMaterial',
    'Profile'
  ];

  Widget homePageCardsGroup(
      Color color,
      IconData icon,
      String image,
      String title,
      BuildContext context,
      Widget route,
      Color color2,
      IconData icon2,
      String image2,
      String title2,
      Widget route2) {
    double _w = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(bottom: _w / 17),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          homePageCard(color, icon, image, title, context, route),
          homePageCard(color2, icon2, image2, title2, context, route2),
        ],
      ),
    );
  }

  Widget homePageCard(Color color, IconData icon, String image, String title,
      BuildContext context, Widget route) {
    double _w = MediaQuery.of(context).size.width;
    return Opacity(
      opacity: _animation.value,
      child: Transform.translate(
        offset: Offset(0, _animation2.value),
        child: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return route;
                },
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(15),
            height: _w / 2,
            width: _w / 2.4,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xff040039).withOpacity(.15),
                  blurRadius: 99,
                ),
              ],
              borderRadius: const BorderRadius.all(
                Radius.circular(25),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(),
                Container(
                    height: _w / 4,
                    width: _w / 4,
                    decoration: const BoxDecoration(
                      // color: color.withOpacity(.1),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      image,
                      width: _w / 6,
                      height: _w / 4,
                    )
                    // Icon(
                    //   icon,
                    //   color: color.withOpacity(.6),
                    // ),
                    ),
                Text(
                  title,
                  maxLines: 4,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black.withOpacity(.5),
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget blurTheStatusBar(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
        child: Container(
          height: kToolbarHeight - 10,
          color: Colors.transparent,
        ),
      ),
    );
  }
}

class RouteWhereYouGo extends StatelessWidget {
  const RouteWhereYouGo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        // backgroundColor: Colors.white,
        elevation: 50,
        centerTitle: true,
        // shadowColor: Colors.black.withOpacity(.5),
        title: const Text(
          'EXAMPLE  PAGE',
          style: TextStyle(
              // color: Colors.black.withOpacity(.7),
              fontWeight: FontWeight.w600,
              letterSpacing: 1),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            // color: Colors.black.withOpacity(.8),
          ),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
    );
  }
}

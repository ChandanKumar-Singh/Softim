


 import 'package:flutter/material.dart';

import '../main.dart';

ThemeData lightTheme = ThemeData(
  // primaryColor: const Color(0xff3b2a98),
  primaryColor: const Color.fromRGBO(44, 92, 208, 1.0),
  primarySwatch: Palette.kToDark,
  fontFamily: 'Georgia',
  textTheme: const TextTheme(
    headline1: TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold),
    headline5: TextStyle(
      fontSize: 25.0,
    ),
    headline6: TextStyle(
      fontSize: 20.0,
    ),
    bodyText1: TextStyle(fontSize: 20.0, fontFamily: 'Hind'),
    bodyText2: TextStyle(fontSize: 15.0, fontFamily: 'Hind'),
  ),
);
 ThemeData darkTheme = ThemeData.dark().copyWith(
  brightness: Brightness.dark,

);
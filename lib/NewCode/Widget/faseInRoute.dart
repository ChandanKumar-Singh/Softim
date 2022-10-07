import 'package:flutter/material.dart';


class ThisIsFadeRoute extends PageRouteBuilder {
  final Widget? page;
  final Widget route;
  final int time;

  ThisIsFadeRoute({this.page, required this.route,this.time = 1000})
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page!,
    transitionDuration:  Duration(milliseconds: time),
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) {
      return FadeTransition(
        opacity: animation,
        child: route,
      );
    },
  );
}
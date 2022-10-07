import 'dart:async';

import 'package:flutter/material.dart';

StreamController<bool> isLightTheme = StreamController();



class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        initialData: true,
        stream: isLightTheme.stream,
        builder: (context, snapshot) {
          return MaterialApp(
              theme: snapshot.data! ? ThemeData.light() : ThemeData.dark(),
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                  appBar: AppBar(title: Text("Dynamic Theme")),
                  body: SettingPage()));
        });
  }
}

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <
                Widget>[
              RaisedButton(
                  color: Colors.blue,
                  child: Text("Light Theme", style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    isLightTheme.add(true);
                  }),
              RaisedButton(
                  color: Colors.black,
                  child: Text("Dark Theme", style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    isLightTheme.add(false);
                  }),
            ])));
  }
}
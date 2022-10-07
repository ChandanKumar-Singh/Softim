import 'dart:io';

import 'package:crm_application/Utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomDialogs {
  static void showErrorDialog(String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occurred!'),
        content: Text(message, style: const TextStyle(color: Colors.red)),
        actions: <Widget>[
          MaterialButton(
            child: const Text('Okay'),
            onPressed: () {
             Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  static void showSuccessToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green.shade200,
      textColor: kToastTextColor,
      fontSize: 16.0,
    );
  }

  static void showWarningToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red.shade300,
      textColor: kToastTextColor,
      fontSize: 16.0,
    );
  }
}

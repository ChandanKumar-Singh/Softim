import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:crm_application/ApiManager/Apis.dart';
import 'package:crm_application/NewCode/Model/UserLoginData.dart';
import 'package:crm_application/NewCode/Widget/profilePages/ProfilePage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/widgets.dart';

import '../../ApiManager/Apis.dart';
import '../Auth/LoginPage.dart';
import '../HomePage.dart';
import '../Widget/faseInRoute.dart';

class AuthProviders with ChangeNotifier {
  late UserLoginData userData;
  var _token, otp;

  late SharedPreferences prefs;
  String TAG = "AuthProvider";
  bool _isLoading = false;

  late Map<String, dynamic> res;

  bool get isLoading => _isLoading;

  Future<void> login(
      String userName, String password, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    var url = ApiManager.BASE_URL + ApiManager.login;
    final headers = {
      'Authorization': ApiManager.authKey,
    };
    Map<String, dynamic> body = {"username": userName, "password": password};
    try {
      final response =
          await http.post(Uri.parse(url), body: body, headers: headers);
      if (kDebugMode) {
        print(response.body);
      }
      var responseData = await json.decode(response.body);
      // var responseData = {};
      debugPrint("$TAG Parameters : $body");
      log("$TAG Response : $responseData");
      if (response.statusCode == 200) {
        if (responseData['status'] == 200) {
          var result = responseData['results'];
          var message = responseData['message'];

          userData = UserLoginData.fromJson(result);

          _token = result['token'];
          prefs = await SharedPreferences.getInstance();
          prefs.setString('token', _token);
          prefs.setInt('userId', userData.data!.id!);
          prefs.setString('username', userData.data!.username!);
          // var usern = prefs.getString('username');
          // print('+++++++++ $usern ++++++++++++++++ ${userData.data!.username!}');
          prefs.setString('father', userData.data!.father!);
          prefs.setString('name', userData.data!.name!);
          prefs.setString('email', userData.data!.email!);
          prefs.setString('address', userData.data!.address ?? '');
          prefs.setString('contact', userData.data!.contact!);
          prefs.setString('profile_image', userData.data!.image!);
          prefs.setString('loginData', jsonEncode(responseData));

          Navigator.of(context)
              .pushReplacement(
                  MaterialPageRoute(builder: (context) => const HomePage()))
              .then((value) { _isLoading = false;notifyListeners();})
              .then((value) => Fluttertoast.showToast(
                    msg: message,
                  ));
          notifyListeners();
        } else {
          _isLoading = false;
          notifyListeners();
          if (responseData['status'] == 400) {
            var message = responseData['message'];
            Fluttertoast.showToast(msg: message);
          }
        }
      } else {
        _isLoading = false;
        notifyListeners();
        if (userName.isEmpty) {
          var nameError = responseData['error']['username'].first;
          Fluttertoast.showToast(msg: nameError);
        } else if (password.isEmpty) {
          var passError = responseData['error']['password'].first;
          Fluttertoast.showToast(msg: passError);
        } else {
          var nameError = responseData['error']['username'].first;
          var passError = responseData['error']['password'].first;
          Fluttertoast.showToast(msg: nameError + '\n$passError');
        }

        throw const HttpException('Auth Failed');
      }
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
    notifyListeners();
  }

  Future<Map<String, dynamic>> forgetPass(String userId) async {
    var url = ApiManager.BASE_URL + ApiManager.forget;
    final headers = {
      'Authorization-token': '3MPHJP0BC63435345341',
    };
    Map<String, dynamic> body = {
      'input': userId,
    };
    try {
      final response =
          await http.post(Uri.parse(url), body: body, headers: headers);
      var responseData = json.decode(response.body);
      debugPrint("$TAG Parameters : $body");
      debugPrint(responseData.toString());

      if (response.statusCode == 200) {
        if (responseData['success'] == 200) {
          var userId = responseData['results']['user_id'];
          otp = responseData['results']['otp'];
          debugPrint("$TAG Success : ${response.body}");
          res = {
            'userId': userId,
            'otp': otp,
          };
          notifyListeners();
        }
      } else {
        throw const HttpException('Failed To Send email');
      }
    } catch (error) {
      rethrow;
    }
    return res;
  }

  Future<void> updateProfile(var userId, var password, var confirmPassword,
      BuildContext context) async {
    prefs = await SharedPreferences.getInstance();
    var url = ApiManager.BASE_URL + ApiManager.updateProfileInfo;
    debugPrint("$TAG UpdateInfoUrl : $url");
    _isLoading = true;
    final headers = {
      'Authorization-token': '3MPHJP0BC63435345341',
      'Authorization': 'Bearer $confirmPassword',
      'Accept': 'application/json',
    };
    Map<String, dynamic> body = {
      "user_id": userId, //"247",
      "password": password, //"dsd",
      "confirmPassword": confirmPassword, //"dsd",
    };
    try {
      final response =
          await http.post(Uri.parse(url), body: body, headers: headers);
      var responseData = json.decode(response.body);
      debugPrint("$TAG UpdateProfileParameters : $body");
      if (response.statusCode == 200) {
        log('$TAG UpdateProfileResponse : $responseData');
        if (responseData['success'] == 200) {
          _isLoading = false;
          String? address = responseData['data']['address'];
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully'),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ProfilePage(),
            ),
          );
          notifyListeners();
        }
      } else {
        _isLoading = false;
        log('Error Message: ${response.body}');
        notifyListeners();
        throw const HttpException('Fail to UpdateProfile');
      }
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateProfileInfo(
      var userId,
      String username,
      String email,
      var phone,
      var password,
      var address,
      var authToken,
      BuildContext context) async {
    prefs = await SharedPreferences.getInstance();
    var url = ApiManager.BASE_URL + ApiManager.updateProfileInfo;
    debugPrint("$TAG UpdateInfoUrl : $url");
    _isLoading = true;
    print(_isLoading);
    final headers = {
      'Authorization': ApiManager.authKey,
    };
    Map<String, dynamic> body = {
      "email": email, //"247",
      "phone": phone, //"12345678911",
      "password": password, //"12345678911",
      "address": address, //"dsd",
    };
    try {
      final response =
          await http.post(Uri.parse(url), body: body, headers: headers);
      var responseData = json.decode(response.body);
      debugPrint("$TAG UpdateProfileParameters : $body");
      if (response.statusCode == 200) {
        log('$TAG UpdateProfileResponse : $responseData');
        if (responseData['success'] == 200) {
          _isLoading = false;
          String? message = responseData['message'];

          prefs.setString('email', email);
          prefs.setString('contact', phone!);
          var p = prefs.getString('contact');
          print(p);
          prefs.setString('address', address!);
          await login(username, password, context);
          Fluttertoast.showToast(msg: message!);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ProfilePage(),
            ),
          );
          _isLoading = false;
          notifyListeners();
        }
        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        log('Error Message: ${response.body}');
        Fluttertoast.showToast(msg: 'Update failed.');
        notifyListeners();
        throw const HttpException('Fail to UpdateProfile');
      }
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
    print(_isLoading);
  }

  Future<void> logOut(BuildContext context) async {
    prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
        context, ThisIsFadeRoute(route: const LoginPage()));
    Fluttertoast.showToast(
      msg: 'Log out',
    );
  }
}

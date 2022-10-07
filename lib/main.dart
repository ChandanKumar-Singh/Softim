import 'dart:io';
import 'package:crm_application/FCM/local_notification_service.dart';
import 'package:crm_application/NewCode/Auth/LoginPage.dart';
import 'package:crm_application/NewCode/HomePage.dart';
import 'package:crm_application/NewCode/Provider/AuthProvider.dart';
import 'package:crm_application/NewCode/SplashScreen.dart';
import 'package:crm_application/Utils/Constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ThemeManager/ThemeManager.dart';
import 'ThemeManager/ThemeConstant.dart';

class Palette {
  static const MaterialColor kToDark = MaterialColor(
    // 0xffe55f48, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    0xff2c5cd0,
    <int, Color>{
      50: const Color(0x153b2a98), //10%
      100: const Color(0x343b2a98), //10%
      200: const Color(0x4c3b2a98), //10%
      300: const Color(0x663b2a98), //10%
      400: const Color(0x813b2a98), //10%
      500: const Color(0x983b2a98), //10%
      600: const Color(0xb53b2a98), //10%
      700: const Color(0xcb3b2a98), //10%
      800: const Color(0xe53b2a98), //10%
      900: const Color(0xff3b2a98), //10%
    },
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Firebase.initializeApp();
  LocalNotificationService.initialize();

  ///Stripe
  Stripe.publishableKey = stripePublishableKey;

  //Flutter downloader
  await FlutterDownloader.initialize(
      debug:
          false, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color.fromRGBO(44, 92, 255, 1),
  ));
  SystemChrome.setEnabledSystemUIOverlays([]);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) => runApp(const SoftimApp()),
  );
}

class SoftimApp extends StatefulWidget {
  const SoftimApp({Key? key}) : super(key: key);

  @override
  State<SoftimApp> createState() => _SoftimAppState();
}

class _SoftimAppState extends State<SoftimApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String _deviceToken = '';
  late SharedPreferences prefs;
  ThemeManager _themeManager = ThemeManager();

  themeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    _themeManager.addListener(themeListener);
    super.initState();

    // enterFullScreen(FullScreenMode.EMERSIVE);
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    _saveDeviceToken();

    _firebaseMessaging.getInitialMessage().then(
      (RemoteMessage? message) {
        debugPrint('getInitialMessage data: ${message?.data}');
      },
    );
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        debugPrint("onMessage data: ${message.data}");
        LocalNotificationService.createanddisplaynotification(message);
      },
    );
    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        debugPrint('onMessageOpenedApp data: ${message.data}');
        Navigator.pushNamed(context, '/homePage');
      },
    );
  }

  @override
  void dispose() {
    _themeManager.addListener(themeListener);

    super.dispose();
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
    if (_deviceToken.isNotEmpty) {
      debugPrint('--------Device Token---------- $_deviceToken');
      await prefs.setString(Const.FCM_TOKEN, _deviceToken);
    }
    return _deviceToken;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => AuthProviders(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ThemeManager(),
        ),
      ],
      child: Consumer<ThemeManager>(builder: (ctx, theme, _) {
        print(theme.themeMode);
        return Consumer<AuthProviders>(
          builder: (ctx, auth, _) {
            return ScreenUtilInit(
              designSize: const Size(375, 770),
              minTextAdapt: true,
              splitScreenMode: true,
              builder: () => MaterialApp(
                title: 'Education Application',
                debugShowCheckedModeBanner: false,
                theme: lightTheme,
                darkTheme: darkTheme,
                themeMode: theme.themeMode,
                home: const WelcomeSplashScreen(),
                routes: {
                  '/homePage': (ctx) => const HomePage(),
                  LoginPage.routeName: (ctx) => const LoginPage(),
                },
              ),
            );
          },
        );
      }),
    );
  }
}

// String stripePublishableKey ='pk_live_51IqZUpSHPuu79x3mGvTo8yro4VkBlVnEM6AxKjlj12Lv1wws66M7Rb4h8GQftSIYXhkJ2Iexx40GgLgZnBe21m3x00eR96Pp7r';

String stripePublishableKey =
    'pk_test_51IqZUpSHPuu79x3mqkrCoErYEdXJu5duG0VIOWqNBRn2kH7k0WqN5iSnxIFgCPmgSkIJF2zjzE8SPlbS0kNTaC7T00UABj2onG';
// String stripeSecretKey ='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';
String stripeSecretKey =
    'sk_test_51IqZUpSHPuu79x3mdu2MZDKnMy8ZhSQQHBqf1sMA4NOT814XA0Av6gUfu8WA9C1on0QODNXvtYMnjvNYOW529WWa005RVl46rR';

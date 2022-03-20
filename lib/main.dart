import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:health/src/config/route.dart';
import 'package:health/src/pages/home_page.dart';
import 'package:health/src/theme/theme.dart';
import 'package:health/startpage.dart';
import 'package:provider/provider.dart';

import 'authentication/signredirect.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var initializationSettingAndroid =
      AndroidInitializationSettings('ic_launcher');
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {});
  var initializationSettings = InitializationSettings(
      android: initializationSettingAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) async {
    if (payload != null) {
      debugPrint('payload' + payload);
    }
  });
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.lightBlue,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark));
  runApp(
      ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
  builder: (context, _) {
  final themeProvider = Provider.of<ThemeProvider>(context);

  return MaterialApp(
    title: 'PocketDoc',
  themeMode: themeProvider.themeMode,
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
    routes: Routes.getRoute(),
    onGenerateRoute: (settings) => Routes.onGenerateRoute(settings),
    debugShowCheckedModeBanner: false,
    home: SignInPage(),
  );}));
}

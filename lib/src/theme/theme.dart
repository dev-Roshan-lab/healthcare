import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'light_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ChangeThemeButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Switch.adaptive(
      value: themeProvider.isDarkMode,
      onChanged: (value) {
        final provider = Provider.of<ThemeProvider>(context, listen: false);
        provider.toggleTheme(value);
      },
    );
  }
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkMode {
    if (themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance!.window.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return themeMode == ThemeMode.dark;
    }
  }

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class AppTheme {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade900,
    primaryColor: Colors.black,
    secondaryHeaderColor: Colors.white,
    colorScheme: ColorScheme.dark(),

      cardTheme: CardTheme(color: LightColor.background),
      textTheme: TextTheme(headline4: TextStyle(color: LightColor.black)),
      iconTheme: IconThemeData(color: LightColor.iconColor),
      bottomAppBarColor: LightColor.background,
      dividerColor: LightColor.grey,
      primaryTextTheme:
      TextTheme(bodyText1: TextStyle(color: LightColor.titleTextColor)));


  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.white,
    secondaryHeaderColor: Colors.black,
    colorScheme: ColorScheme.light(),
      cardTheme: CardTheme(color: LightColor.background),
      textTheme: TextTheme(headline4: TextStyle(color: LightColor.black)),
      iconTheme: IconThemeData(color: LightColor.iconColor),
      bottomAppBarColor: LightColor.background,
      dividerColor: LightColor.grey,
      primaryTextTheme:
      TextTheme(bodyText1: TextStyle(color: LightColor.titleTextColor)));


  static TextStyle titleStyle =
  const TextStyle(color: LightColor.titleTextColor, fontSize: 16);
  static TextStyle subTitleStyle =
  const TextStyle(color: LightColor.subTitleTextColor, fontSize: 12);

  static TextStyle h1Style =
  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
  static TextStyle h2Style = const TextStyle(fontSize: 22);
  static TextStyle h3Style = const TextStyle(fontSize: 20);
  static TextStyle h4Style = const TextStyle(fontSize: 18);
  static TextStyle h5Style = const TextStyle(fontSize: 16);
  static TextStyle h6Style = const TextStyle(fontSize: 14);
  static List<BoxShadow> shadow = <BoxShadow>[
    BoxShadow(color: Color(0xfff8f8f8), blurRadius: 10, spreadRadius: 15),
  ];

  static EdgeInsets padding =
  const EdgeInsets.symmetric(horizontal: 20, vertical: 10);
  static EdgeInsets hPadding = const EdgeInsets.symmetric(
  horizontal: 10,);
  static double fullWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double fullHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}

// class AppTheme {
//   const AppTheme();
//   static ThemeData lightTheme = ThemeData(
//       backgroundColor: LightColor.background,
//       primaryColor: LightColor.purple,
//       cardTheme: CardTheme(color: LightColor.background),
//       textTheme: TextTheme(headline4: TextStyle(color: LightColor.black)),
//       iconTheme: IconThemeData(color: LightColor.iconColor),
//       bottomAppBarColor: LightColor.background,
//       dividerColor: LightColor.grey,
//       primaryTextTheme:
//           TextTheme(bodyText1: TextStyle(color: LightColor.titleTextColor)));
//
//   static TextStyle titleStyle =
//       const TextStyle(color: LightColor.titleTextColor, fontSize: 16);
//   static TextStyle subTitleStyle =
//       const TextStyle(color: LightColor.subTitleTextColor, fontSize: 12);
//
//   static TextStyle h1Style =
//       const TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
//   static TextStyle h2Style = const TextStyle(fontSize: 22);
//   static TextStyle h3Style = const TextStyle(fontSize: 20);
//   static TextStyle h4Style = const TextStyle(fontSize: 18);
//   static TextStyle h5Style = const TextStyle(fontSize: 16);
//   static TextStyle h6Style = const TextStyle(fontSize: 14);
//
//   static List<BoxShadow> shadow = <BoxShadow>[
//     BoxShadow(color: Color(0xfff8f8f8), blurRadius: 10, spreadRadius: 15),
//   ];
//
//   static EdgeInsets padding =
//       const EdgeInsets.symmetric(horizontal: 20, vertical: 10);
//   static EdgeInsets hPadding = const EdgeInsets.symmetric(
//     horizontal: 10,
//   );
//
//   static double fullWidth(BuildContext context) {
//     return MediaQuery.of(context).size.width;
//   }
//
//   static double fullHeight(BuildContext context) {
//     return MediaQuery.of(context).size.height;
//   }
// }

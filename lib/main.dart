import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tidey/screens/forecast.dart';
import 'package:tidey/screens/help.dart';
import 'package:tidey/screens/onBoard.dart';
import 'package:tidey/screens/settings.dart';
import 'package:tidey/screens/splashScreen.dart';
import 'package:tidey/screens/tideScreen.dart';
import 'package:tidey/screens/tideTableScreen.dart';
import 'package:tidey/screens/weatherToday.dart';
import 'package:tidey/screens/webWeather.dart';

void main() async {
  // imageCache.clear();
  WidgetsFlutterBinding.ensureInitialized();
  print("before FB initialization, ${DateTime.now()}");
  await Firebase.initializeApp();
  print("firebase initialized, ${DateTime.now()}");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Tidey',
        debugShowCheckedModeBanner: false,
        initialRoute: SplashScreen.id,
        routes: {
          SplashScreen.id: (context) => SplashScreen(),
          TideScreen.id: (context) => TideScreen(),
          WebWeather.id: (context) => WebWeather(),
          ForecastScreen.id: (context) => ForecastScreen(),
          SettingsScreen.id: (context) => SettingsScreen(),
          TodayScreen.id: (context) => TodayScreen(),
          HelpScreen.id: (context) => HelpScreen(),
          TideTableScreen.id: (context) => TideTableScreen(),
          OnBoardingPage.id: (context) => OnBoardingPage(),
        });
  }
}

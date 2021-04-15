import 'package:flutter/material.dart';
import 'package:tidey/screens/moonScreen.dart';
import 'package:tidey/screens/splashScreen.dart';
import 'package:tidey/screens/tideScreen.dart';

void main() {
//  double globalLatitude;
//  double globalLongitude;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Tidey', initialRoute: SplashScreen.id, routes: {
      SplashScreen.id: (context) => SplashScreen(),
      TideScreen.id: (context) => TideScreen(),
      MoonScreen.id: (context) => MoonScreen(),
    });
  }
}

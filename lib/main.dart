import 'package:flutter/material.dart';
import 'package:tidey/screens/splashScreen.dart';
import 'package:tidey/screens/tideScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Tidey', initialRoute: SplashScreen.id, routes: {
      SplashScreen.id: (context) => SplashScreen(),
      TideScreen.id: (context) => TideScreen(),
    });
  }
}

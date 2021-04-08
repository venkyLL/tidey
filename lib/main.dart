import 'package:flutter/material.dart';
import 'package:tidey/Screens/TideScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(initialRoute: TideScreen.id, routes: {
      TideScreen.id: (context) => TideScreen(),
    });
  }
}

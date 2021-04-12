import 'package:flutter/material.dart';
import 'package:tidey/const.dart';
import 'package:tidey/services/locationServices.dart';
import 'package:tidey/screens/tideScreen.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splashScreen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMyLocation();
  }

  void getMyLocation() async {
    Location location = Location();
    await location.getCurrentLocation();
    Navigator.pushReplacementNamed(context, TideScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Center(
        child: Text("Splish Splash I am taking a bath ... "),
      ),
    );
  }
}

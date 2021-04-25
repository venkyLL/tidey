import 'package:flutter/material.dart';
import 'package:tidey/const.dart';
import 'package:tidey/screens/tideScreen.dart';
import 'package:tidey/services/localWeather.dart';
import 'package:tidey/services/locationServices.dart';
import 'package:tidey/services/marineWeather.dart';
import 'package:tidey/services/tideServices.dart';
import 'package:tidey/services/compass.dart';

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
    WeatherService weatherService = WeatherService();
    await weatherService.getMarineData();

    LocalWeatherService localWeatherService = LocalWeatherService();
    await localWeatherService.getLocalWeatherData();
    mySineWaveData msw = mySineWaveData();
    await msw.computeTidesForPainting();
    Navigator.pushReplacementNamed(context, TideScreen.id);
    MyCompass theCompass = MyCompass();
    theCompass.init();
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    print("Width = " +
        ScreenSize.screenWidth.toString() +
        "Length " +
        ScreenSize.screenHeight.toString());
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Center(
        child: Text("Splish Splash I am taking a bath ... "),
      ),
    );
  }
}

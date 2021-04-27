//import 'dart:html';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tidey/const.dart';
import 'package:tidey/screens/tideScreen.dart';
import 'package:tidey/services/compass.dart';
import 'package:tidey/services/localWeather.dart';
import 'package:tidey/services/locationServices.dart';
import 'package:tidey/services/marineWeather.dart';
import 'package:tidey/services/tideServices.dart';

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
    getProfileData();
  }

  void getProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userSettings.chimeOn = prefs.getBool('chimeOn');
    if (userSettings.chimeOn == null) {
      print("Chime not found");
      prefs.setBool('chimeOn', true);
      userSettings.chimeOn = true;
    } else {
      print("Chime On Found" + userSettings.chimeOn.toString());
      // globalChimeOn = chimeOn;
    }

    userSettings.chimeDoNotDisturb = prefs.getBool('doNotDisturb');
    if (userSettings.chimeDoNotDisturb == null) {
      print("Do not Disturb not found");
      prefs.setBool('doNotDisturb', true);
      userSettings.chimeDoNotDisturb = true;
    } else {
      print("Yes Do not disturb Found" +
          userSettings.chimeDoNotDisturb.toString());
      // globalChimeOn = chimeOn;
    }
    userSettings.imperialUnits = prefs.getBool('imperialUnits');
    if (userSettings.imperialUnits == null) {
      print("Imperial Units not found");
      prefs.setBool('imperialUnits', true);
      userSettings.imperialUnits = true;
    } else {
      print("Yes Imperial Units Found" + userSettings.imperialUnits.toString());
      // globalChimeOn = chimeOn;
    }
    userSettings.transitionTime = prefs.getInt('transitionTime');
    if (userSettings.transitionTime == null) {
      print("Transition Time not found");
      prefs.setInt('transitionTime', kDefaultTransitionTime);
      userSettings.transitionTime = kDefaultTransitionTime;
    } else {
      print("Yes Transition Time Found " +
          userSettings.transitionTime.toString());
      // globalChimeOn = chimeOn;
    }

    String chimeSelectedString = prefs.getString('chimeSelected');
    if (chimeSelectedString == null) {
      print("Chime Selected Not Found");
      prefs.setString('chimeSelected', chimeTypeEnumtoString[ChimeType.single]);
      userSettings.chimeSelected = ChimeType.single;
    } else {
      print("Found " + chimeSelectedString);
      userSettings.chimeSelected = chimeTypeStringToEnum[chimeSelectedString];
      print("Yes Chime Selected Found" + userSettings.chimeSelected.toString());

      // globalChimeOn = chimeOn;
    }
  }

  void getMyLocation() async {
    Location location = Location();
    await location.getCurrentLocation();
    WeatherService weatherService = WeatherService();
    await weatherService.getMarineData();
    packageInfo = await PackageInfo.fromPlatform();

    print(packageInfo.appName);
    print(packageInfo.buildNumber);
    print(packageInfo.version);
    print(packageInfo.packageName);

    LocalWeatherService localWeatherService = LocalWeatherService();
    await localWeatherService.getLocalWeatherData();
    mySineWaveData msw = mySineWaveData();
    await msw.computeTidesForPainting();
    Navigator.pushReplacementNamed(context, TideScreen.id);
    MyCompass theCompass = MyCompass();
    theCompass.init();
    // start audio player service
    AssetsAudioPlayer.setupNotificationsOpenAction((notification) {
      print(notification.audioId);
      return true;
    });
//    AssetsAudioPlayer.playAndForget(Audio('assets/audio/bell.mp3'));
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

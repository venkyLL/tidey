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
import 'package:tidey/services/cronServices.dart';

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

    initAll();
    // getProfileData();
  }

  void getProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userSettings.chimeOn =
        readBoolFromLocal(prefs, userSettings.keyChimeOn, true);
    userSettings.chimeDoNotDisturb =
        readBoolFromLocal(prefs, userSettings.keyChimeDoNotDisturb, true);
    userSettings.imperialUnits =
        readBoolFromLocal(prefs, userSettings.keyImperialUnits, true);
    userSettings.transitionTime =
        readIntFromLocal(prefs, userSettings.keyTransitionTime, 10);
    String chimeSelectedString = readStringFromLocal(prefs,
        userSettings.keyChimeSelected, chimeTypeEnumtoString[ChimeType.single]);
    userSettings.chimeSelected = chimeTypeStringToEnum[chimeSelectedString];
    userSettings.alarmOn =
        readBoolFromLocal(prefs, userSettings.keyAlarmOn, false);

    int hour = readIntFromLocal(prefs, userSettings.keyAlarmTimeHour, 7);
    int min = readIntFromLocal(prefs, userSettings.keyAlarmTimeMin, 30);
    userSettings.alarmTime = TimeOfDay(hour: hour, minute: min);

    hour = readIntFromLocal(prefs, userSettings.keySleepTimeHour, 22);
    min = readIntFromLocal(prefs, userSettings.keySleepTimeMin, 0);
    userSettings.sleepTime = TimeOfDay(hour: hour, minute: min);
    hour = readIntFromLocal(prefs, userSettings.keyWakeTimeHour, 22);
    min = readIntFromLocal(prefs, userSettings.keyWakeTimeMin, 0);
    userSettings.wakeTime = TimeOfDay(hour: hour, minute: min);
    userSettings.useCurrentPosition =
        readBoolFromLocal(prefs, userSettings.keyUseCurrentPosition, true);
    userSettings.manualLat =
        readDoubleFromLocal(prefs, userSettings.keyManualLat, 26.7747);
    userSettings.manualLong =
        readDoubleFromLocal(prefs, userSettings.keyManualLong, -77.3296);

    //   userSettings.chimeOn = prefs.getBool('chimeOn');
//    if (userSettings.chimeOn == null) {
//      print("Chime not found");
//      prefs.setBool('chimeOn', true);
//      userSettings.chimeOn = true;
//    } else {
//      print("Chime On Found" + userSettings.chimeOn.toString());
//      // globalChimeOn = chimeOn;
//    }

//    if (userSettings.chimeDoNotDisturb == null) {
//      print("Do not Disturb not found");
//      prefs.setBool('doNotDisturb', true);
//      userSettings.chimeDoNotDisturb = true;
//    } else {
//      print("Yes Do not disturb Found" +
//          userSettings.chimeDoNotDisturb.toString());
//      // globalChimeOn = chimeOn;
//    }
//    userSettings.imperialUnits = prefs.getBool('imperialUnits');
//    if (userSettings.imperialUnits == null) {
//      print("Imperial Units not found");
//      prefs.setBool('imperialUnits', true);
//      userSettings.imperialUnits = true;
//    } else {
//      print("Yes Imperial Units Found" + userSettings.imperialUnits.toString());
//      // globalChimeOn = chimeOn;
//    }
//    userSettings.transitionTime = prefs.getInt('transitionTime');
//    if (userSettings.transitionTime == null) {
//      print("Transition Time not found");
//      prefs.setInt('transitionTime', kDefaultTransitionTime);
//      userSettings.transitionTime = kDefaultTransitionTime;
//    } else {
//      print("Yes Transition Time Found " +
//          userSettings.transitionTime.toString());
//      // globalChimeOn = chimeOn;
//    }

//    String chimeSelectedString = prefs.getString('chimeSelected');
//    if (chimeSelectedString == null) {
//      print("Chime Selected Not Found");
//      prefs.setString('chimeSelected', chimeTypeEnumtoString[ChimeType.single]);
//      userSettings.chimeSelected = ChimeType.single;
//    } else {
//      print("Found " + chimeSelectedString);
//      userSettings.chimeSelected = chimeTypeStringToEnum[chimeSelectedString];
//      print("Yes Chime Selected Found" + userSettings.chimeSelected.toString());
//
//      // globalChimeOn = chimeOn;
//    }
  }

  String readStringFromLocal(
      SharedPreferences prefs, String settingKey, String defaultValue) {
    String valueRead;
    valueRead = prefs.getString(settingKey);
    if (valueRead == null) {
      print(" $settingKey not found");
      prefs.setString(settingKey, defaultValue);
      return defaultValue;
    } else {
      print("$settingKey Found $valueRead.ttoString()");
      return valueRead;
    }
  }

  double readDoubleFromLocal(
      SharedPreferences prefs, String settingKey, double defaultValue) {
    double valueRead;
    valueRead = prefs.getDouble(settingKey);
    if (valueRead == null) {
      print(" $settingKey not found");
      prefs.setDouble(settingKey, defaultValue);
      return defaultValue;
    } else {
      print("$settingKey Found $valueRead.ttoString()");
      return valueRead;
    }
  }

  int readIntFromLocal(
      SharedPreferences prefs, String settingKey, int defaultValue) {
    int valueRead;
    valueRead = prefs.getInt(settingKey);
    if (valueRead == null) {
      print(" $settingKey not found");
      prefs.setInt(settingKey, defaultValue);
      return defaultValue;
    } else {
      print("$settingKey Found $valueRead.ttoString()");
      return valueRead;
    }
  }

  bool readBoolFromLocal(
      SharedPreferences prefs, String settingKey, bool defaultValue) {
    bool valueRead;
    valueRead = prefs.getBool(settingKey);
    if (valueRead == null) {
      print(" $settingKey not found");
      prefs.setBool(settingKey, defaultValue);
      return defaultValue;
    } else {
      print("$settingKey Found $valueRead.ttoString()");
      return valueRead;
      // globalChimeOn = chimeOn;
    }
  }

  void initAll() async {
    await getProfileData();
    Location location = Location();
    CronJobs myCronJobs = CronJobs();
    myCronJobs.init();
    if (userSettings.useCurrentPosition) {
      await location.getCurrentLocation();
    } else {
      globalLatitude = userSettings.manualLat.toString();
      globalLongitude = userSettings.manualLong.toString();
    }

    packageInfo = await PackageInfo.fromPlatform();

    print(packageInfo.appName);
    print(packageInfo.buildNumber);
    print(packageInfo.version);
    print(packageInfo.packageName);

    WeatherService weatherService = WeatherService();
    await weatherService.getMarineData();
// Note need to run weather service before local weather to correctly populate
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

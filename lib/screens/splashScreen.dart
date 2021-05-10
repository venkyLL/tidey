//import 'dart:html';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tidey/const.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:tidey/screens/onBoard.dart';
import 'package:tidey/screens/tideScreen.dart';
import 'package:tidey/services/compass.dart';
import 'package:tidey/services/cronServices.dart';
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
    hour = readIntFromLocal(prefs, userSettings.keyWakeTimeHour, 07);
    min = readIntFromLocal(prefs, userSettings.keyWakeTimeMin, 0);
    userSettings.wakeTime = TimeOfDay(hour: hour, minute: min);
    userSettings.useCurrentPosition =
        readBoolFromLocal(prefs, userSettings.keyUseCurrentPosition, true);
    userSettings.manualLat =
        readDoubleFromLocal(prefs, userSettings.keyManualLat, 26.7747);
    userSettings.manualLong =
        readDoubleFromLocal(prefs, userSettings.keyManualLong, -77.3296);
    userSettings.localInfoURL = readStringFromLocal(
        prefs, userSettings.keyLocalInfoURL, "https://google.com");
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
      firstTime = true;
      print(" $settingKey not found");
      prefs.setBool(settingKey, defaultValue);
      return defaultValue;
    } else {
      firstTime = false;
      print("$settingKey Found $valueRead.ttoString()");
      return valueRead;
      // globalChimeOn = chimeOn;
    }
  }

  bool firstTime = false;
  void initAll() async {
    var noLocationSnackBar = SnackBar(
        content: Text('Location Services off using default location!'),
        duration: const Duration(milliseconds: 1500));

    var weather1Snackbar = SnackBar(
        content: Text('Yay! Weather data found!'),
        duration: const Duration(milliseconds: 1500));
    final tideSnackbar = SnackBar(
        content: Text('Yay! Tide data found! '),
        duration: const Duration(milliseconds: 1500));
    final tideySnackbar = SnackBar(
        content: Text('Yay! Calculated Tidey Ring! '),
        duration: const Duration(milliseconds: 1500));
    final noNetworkSnackbar = SnackBar(
        content: Text('Network not available no weather data colleted! '),
        duration: const Duration(milliseconds: 1500));

    await checkConnectivity();
    var networkSnackBar = SnackBar(
        content: Text('Yay! Network Found! $_networkStatus1'),
        duration: const Duration(milliseconds: 1500));
    ScaffoldMessenger.of(context).showSnackBar(networkSnackBar);
    await getProfileData();
//    if (await Permission.locationWhenInUse.serviceStatus.isEnabled) {
//      print("Location Service Enabled");
    if (_networkStatus1 != "None") {
      Location location = Location();
      if (userSettings.useCurrentPosition) {
        print("Using Current Position");
        await location.getCurrentLocation();
        var locationSnackBar = SnackBar(
            content:
                Text('Yay! Location Found! $globalLatitude $globalLongitude '),
            duration: const Duration(milliseconds: 1500));
        ScaffoldMessenger.of(context).showSnackBar(locationSnackBar);
      } else {
        globalLatitude = userSettings.manualLat.toString();
        globalLongitude = userSettings.manualLong.toString();
        var defaultLocationSnackBar = SnackBar(
            content:
                Text('Using saved Location! $globalLatitude $globalLongitude'),
            duration: const Duration(milliseconds: 1500));
        ScaffoldMessenger.of(context).showSnackBar(defaultLocationSnackBar);
      }
    } else {
      globalLatitude = userSettings.manualLat.toString();
      globalLongitude = userSettings.manualLong.toString();
      ScaffoldMessenger.of(context).showSnackBar(noLocationSnackBar);
    }

    CronJobs myCronJobs = CronJobs();
    myCronJobs.init();

    packageInfo = await PackageInfo.fromPlatform();

    print(packageInfo.appName);
    print(packageInfo.buildNumber);
    print(packageInfo.version);
    print(packageInfo.packageName);
    globalWeather.weatherAPIError = true;
    // globalNetworkAvailable = false;

    if (_networkStatus1 != "None") {
      WeatherService weatherService = WeatherService();
      await weatherService.getMarineData();
      ScaffoldMessenger.of(context).showSnackBar(weather1Snackbar);

      LocalWeatherService localWeatherService = LocalWeatherService();
      await localWeatherService.getLocalWeatherData();
      ScaffoldMessenger.of(context).showSnackBar(tideSnackbar);
      mySineWaveData msw = mySineWaveData();
      await msw.computeTidesForPainting();
      globalWeather.weatherAPIError = true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(noNetworkSnackbar);
    }

    MyCompass theCompass = MyCompass();
    theCompass.init();
    // start audio player service
    AssetsAudioPlayer.setupNotificationsOpenAction((notification) {
      print(notification.audioId);
      return true;
    });
    ScaffoldMessenger.of(context).showSnackBar(tideySnackbar);

    Future.delayed(const Duration(milliseconds: 2000), () {
// Here you can write your code

      setState(() {
        firstTime
            ? Navigator.pushReplacementNamed(context, OnBoardingPage.id)
            : Navigator.pushReplacementNamed(context, TideScreen.id);
      });
    });

//    AssetsAudioPlayer.playAndForget(Audio('assets/audio/bell.mp3'));
  }

  Connectivity connectivity = Connectivity();
  String _networkStatus1 = '';

  void checkConnectivity() async {
    var connectivityResult = await connectivity.checkConnectivity();
    var conn = getConnectionValue(connectivityResult);
    if (connectivityResult == ConnectivityResult.none) {
      globalNetworkAvailable = false;
    } else {
      globalNetworkAvailable = true;
    }
    setState(() {
      _networkStatus1 = conn;
      print('Check Connection:: ' + _networkStatus1);
    });
  }

// Method to convert the connectivity to a string value
  String getConnectionValue(var connectivityResult) {
    String status = '';
    switch (connectivityResult) {
      case ConnectivityResult.mobile:
        status = 'Mobile';
        break;
      case ConnectivityResult.wifi:
        status = 'Wi-Fi';
        break;
      case ConnectivityResult.none:
        status = 'None';
        break;
      default:
        status = 'None';
        break;
    }
    return status;
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);

    return Scaffold(
      // backgroundColor: kSplashColor,
      body: Container(
        color: Colors.black,
//        decoration: BoxDecoration(
//          image: DecorationImage(
//          //  image: AssetImage('assets/images/background.JPG'),
//            fit: BoxFit.cover,
//            colorFilter: ColorFilter.mode(
//                Colors.white.withOpacity(0.8), BlendMode.dstATop),
//          ),
//        ),
        constraints: BoxConstraints.expand(),
        child: Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width:
                  (MediaQuery.of(context).orientation == Orientation.landscape)
                      ? ScreenSize.screenHeight * 0.8
                      : ScreenSize.screenWidth * 0.8,
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Image.asset('assets/images/tideyIcon2.png'),
              ),
            ),
            Text(
              "by Amberjack Labs",
              style: TextStyle(fontSize: 20, color: Colors.blueAccent),
            ),
          ],
        )),

        //   child: Text("Splish Splash I am taking a bath ... "),
      ),
    );
  }
}

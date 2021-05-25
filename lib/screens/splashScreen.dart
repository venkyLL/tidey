//import 'dart:html';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_appstore/open_appstore.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tidey/const.dart';
import 'package:tidey/screens/onBoard.dart';
import 'package:tidey/screens/tideScreen.dart';
import 'package:tidey/services/compass.dart';
import 'package:tidey/services/cronServices.dart';
import 'package:tidey/services/localWeather.dart';
import 'package:tidey/services/locationServices.dart';
import 'package:tidey/services/marineWeather.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:tidey/services/tideServices.dart';
import 'package:tidey/services/tideyParms.dart';

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
    print("Getting profile Data");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userSettings.chimeOn =
        readBoolFromLocal(prefs, userSettings.keyChimeOn, true);
    userSettings.adsOn = readBoolFromLocal(prefs, userSettings.keyAdsOn, false);
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
    userSettings.showWeather =
        readBoolFromLocal(prefs, userSettings.keyShowWeather, true);
    userSettings.continuousMarquee =
        readBoolFromLocal(prefs, userSettings.keyContinuousMarquee, false);
    userSettings.marqueeText =
        readStringFromLocal(prefs, userSettings.keyMarqueeText, "");
    userSettings.filenames[0] =
        readStringFromLocal(prefs, userSettings.keyFilename0, "");
    userSettings.filenames[1] =
        readStringFromLocal(prefs, userSettings.keyFilename1, "");
    userSettings.filenames[2] =
        readStringFromLocal(prefs, userSettings.keyFilename2, "");
    userSettings.filenames[3] =
        readStringFromLocal(prefs, userSettings.keyFilename3, "");

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
        prefs, userSettings.keyLocalInfoURL, "https://cruiseabaco.com");
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
//  String currentVersionRaw;
//  String currentVersionT;
//  String enforcedVersionRaw;
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
        content: Text('Data Succesfully Loaded! '),
        duration: const Duration(milliseconds: 1500));
    final noNetworkSnackbar = SnackBar(
        backgroundColor: (Colors.red),
        content: Text(
          'Network not available no weather data collected ',
        ),
        duration: const Duration(milliseconds: 2000));

    if (dio == null) {
      BaseOptions options = new BaseOptions(
          baseUrl: "your base url",
          receiveDataWhenStatusError: true,
          connectTimeout: 30 * 1000, // 30 seconds
          receiveTimeout: 30 * 1000 // 30 seconds
          );

      dio = new Dio(options);
    }
    await getProfileData();
    packageInfo = await PackageInfo.fromPlatform();
    await checkConnectivity();

    //   enforcedVersionRaw = await enforcedVersion;
    print("Printing Package Info");
    print(packageInfo.appName);
    print(packageInfo.buildNumber);
    print(packageInfo.version);
    print(packageInfo.packageName);

    if (_networkStatus1 != "None") {
      TideyParmsService tideyParms = TideyParmsService();
      await tideyParms.getTideyParmData();
      print("Did I return");
      if (tideyParms.needsUpdate) {
        print("Update Required");
        await _updateRequiredAlert(context);
      } else {
        if (tideyParms.updateAvailable) {
          print("Update Available");
          await _updateAvailableAlert(context);
        }
      }
    }

//    var networkSnackBar = SnackBar(
//        content: Text('Yay! Network Found! $_networkStatus1'),
//        duration: const Duration(milliseconds: 1500));
//    ScaffoldMessenger.of(context).showSnackBar(networkSnackBar);

//    if (await Permission.locationWhenInUse.serviceStatus.isEnabled) {
//      print("Location Service Enabled");
    print("About to get current locaiton");
    Location location = Location();
    if (userSettings.useCurrentPosition) {
      print("Using Current Position");
      //   bool success = await location.getCurrentLocation();
      if (!await location.getCurrentLocation()) {
        globalLatitude = userSettings.manualLat.toString();
        globalLongitude = userSettings.manualLong.toString();
        var defaultLocationSnackBar = SnackBar(
          //  backgroundColor: (Colors.blue),
          content: Text('Location Services disabled using default location, '),
          duration: const Duration(milliseconds: 3000),
        );
        ScaffoldMessenger.of(context).showSnackBar(defaultLocationSnackBar);
      }
    } else {
      globalLatitude = userSettings.manualLat.toString();
      globalLongitude = userSettings.manualLong.toString();
    }
    globalWeather.weatherAPIError = false;
    globalWeather.tideAPIError = false;

    if (_networkStatus1 != "None") {
      globalNetworkAvailable = true;
      WeatherService weatherService = WeatherService();
      String ans = await weatherService.getMarineData();
      print("Back from Marine Weather baby $ans");
      if (ans != "True") {
        globalWeather.tideAPIError = true;

        var WErrorSnackBar = SnackBar(
            backgroundColor: (Colors.red),
            content: Text('Error connecting to tide service! '),
            duration: const Duration(milliseconds: 3000));
        ScaffoldMessenger.of(context).showSnackBar(WErrorSnackBar);
      }

      LocalWeatherService localWeatherService = LocalWeatherService();
      ans = await localWeatherService.getLocalWeatherData();
      print("Back from local weathe baby $ans");
      if (ans != "True") {
        globalWeather.weatherAPIError = true;
        print("Print we got no data man..");
        var WErrorSnackBar = SnackBar(
            backgroundColor: (Colors.red),
            content: Text(
              'Error connecting to local weather service! ',
            ),
            duration: const Duration(milliseconds: 3000));
        ScaffoldMessenger.of(context).showSnackBar(WErrorSnackBar);
      } else {
        var locationSnackBar = SnackBar(
            content: Text(
                'Weather Data Retrieved for :  ($globalLatitude $globalLongitude) '),
            duration: const Duration(milliseconds: 2000));
        ScaffoldMessenger.of(context).showSnackBar(locationSnackBar);
        if (!globalWeather.tideAPIError) {
          mySineWaveData msw = mySineWaveData();
          await msw.computeTidesForPainting();
          // globalNetworkAvailable = false;
          // globalWeather.weatherAPIError = true;
        }
      }
    } else {
      globalNetworkAvailable = false;
      globalWeather.tideAPIError = true;
      globalWeather.weatherAPIError = true;
      ScaffoldMessenger.of(context).showSnackBar(noNetworkSnackbar);
    }

    CronJobs myCronJobs = CronJobs();
    myCronJobs.init();

    MyCompass theCompass = MyCompass();
    theCompass.init();
    // start audio player service
    AssetsAudioPlayer.setupNotificationsOpenAction((notification) {
      print(notification.audioId);
      return true;
    });

    Future.delayed(const Duration(milliseconds: 2000), () {
// Here you can write your code
      print("zzErrors  " +
          globalWeather.weatherAPIError.toString() +
          " " +
          globalWeather.tideAPIError.toString());
      setState(() {
        firstTime
            ? Navigator.pushReplacementNamed(context, OnBoardingPage.id)
            : Navigator.pushReplacementNamed(context, TideScreen.id);
      });
    });

//    AssetsAudioPlayer.playAndForget(Audio('assets/audio/bell.mp3'));
  }
// Removed Firebase Config
//  static Future<String> get enforcedVersion async {
//    String _ENFORCED_VERSION_KEY = "EnforcedVersionKey";
//    String _Current_VERSION_KEY = "CurrentVersionKey";
//    final RemoteConfig remoteConfig = await RemoteConfig.instance;
//    await remoteConfig.fetch(
//      expiration: Duration(
//        seconds: 0,
//      ),
//    );
//    await remoteConfig.activateFetched();
//    return remoteConfig.getString(_ENFORCED_VERSION_KEY); // 'enforced_version'
//  }

  Future _updateAvailableAlert(BuildContext context) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Release Update Available"),
        content: Text(
            "This is a new release of Tidey Available, please update to take advantage of the latest and greatest features."),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();

              OpenAppstore.launch(
                  androidAppId: androidAppId, iOSAppId: iOSAppId);
            },
            child: Text("Upgrade Now"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text("Later"),
          ),
        ],
      ),
    );
  }

  Future _updateRequiredAlert(BuildContext context) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Tidey " + packageInfo.version + " is Retired"),
        content: Text("Release " +
            packageInfo.version +
            " of Tidey has served you well, but has been retired, please download the latest version to continue."),
//        actions: <Widget>[
//          TextButton(
//            onPressed: () {
//              Navigator.of(ctx).pop();
//              OpenAppstore.launch(
//                  androidAppId: androidAppId, iOSAppId: iOSAppId);
//            },
//            child: Text("Upgrade Now"),
//          ),
//        ],
      ),
    );
  }

  Connectivity connectivity = Connectivity();
  String _networkStatus1 = '';

  void checkConnectivity() async {
    var connectivityResult = await connectivity.checkConnectivity();
    var conn = getConnectionValue(connectivityResult);
    if (connectivityResult == ConnectivityResult.none) {
      globalNetworkAvailable = false;
      globalNeworkErrorMessage =
          "To get current weather data \nPlease restart Tidey when there is a network connection avilable.";
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

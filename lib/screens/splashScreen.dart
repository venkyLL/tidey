//import 'dart:html';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

    marqueeString = getMarqueeString();
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

//String spacer = " \u2022\u2022\u2022\u2022 ";
String spacer = "  \u2022  ";
getMarqueeString() {
  // String spacer = "\u2015\u2015\u2015\u2015";

  String firstHt = (double.parse(
              weatherData.data.weather[0].tides[0].tideData[0].tideHeightMt) /
          3.28084)
      .toStringAsFixed(2);
  String firstDate = DateFormat('hh:mma EE').format(DateTime.parse(
      weatherData.data.weather[0].tides[0].tideData[0].tideDateTime));
  String secondHt = (double.parse(
              weatherData.data.weather[0].tides[0].tideData[1].tideHeightMt) /
          3.28084)
      .toStringAsFixed(2);
  String secondDate = DateFormat('hh:mma EE').format(DateTime.parse(
      weatherData.data.weather[0].tides[0].tideData[1].tideDateTime));
  String thirdHt = (double.parse(
              weatherData.data.weather[0].tides[0].tideData[2].tideHeightMt) /
          3.28084)
      .toStringAsFixed(2);
  String thirdDate = DateFormat('hh:mma EE').format(DateTime.parse(
      weatherData.data.weather[0].tides[0].tideData[2].tideDateTime));
  String fourthHt = (double.parse(
              weatherData.data.weather[0].tides[0].tideData[3].tideHeightMt) /
          3.28084)
      .toStringAsFixed(2);
  String fourthDate = DateFormat('hh:mma EE').format(DateTime.parse(
      weatherData.data.weather[0].tides[0].tideData[3].tideDateTime));

//  String dday = DateFormat('EE').format(localWeather.data.weather[0].date);
//  String todayWeather = dday +
//      "Today's Weather:    " +
//      localWeather.data.weather[0].hourly[0].weatherDesc[0].value +
//      spacer +
//      "Lo " +
//      localWeather.data.weather[0].mintempF +
//      " \u2109" +
//      spacer +
//      "High " +
//      weatherData.data.weather[0].maxtempF +
//      " \u2109" +
//      spacer +
//      "Humidity " +
//      localWeather.data.weather[0].hourly[0].humidity +
//      "%" +
//      spacer +
//      "Barometric Pressure " +
//      localWeather.data.weather[0].hourly[0].pressureInches +
//      spacer +
//      "Chance of Rain " +
//      localWeather.data.weather[0].hourly[0].chanceofrain +
//      "%" +
//      spacer +
//      "Cloud Cover " +
//      localWeather.data.weather[0].hourly[0].cloudcover +
//      "%" +
//      spacer +
//      "Wind Speed " +
//      localWeather.data.weather[0].hourly[0].windspeedMiles +
//      "(mph) gusting to " +
//      localWeather.data.weather[0].hourly[0].windGustMiles +
//      spacer +
//      "Visibility " +
//      localWeather.data.weather[0].hourly[0].visibilityMiles +
//      "miles" +
//      spacer +
//      "Air Quality  " +
//      airQuality[localWeather.data.weather[0].hourly[0].airQuality.usEpaIndex] +
//      spacer +
//      "           ";

  String tides = "Tides: First " +
      weatherData.data.weather[0].tides[0].tideData[0].tideType.toLowerCase() +
      " tide " +
      firstHt +
      "ft@ " +
      firstDate +
      spacer +
      "First " +
      weatherData.data.weather[0].tides[0].tideData[1].tideType.toLowerCase() +
      " tide " +
      secondHt +
      "ft@ " +
      secondDate +
      spacer +
      "Second " +
      weatherData.data.weather[0].tides[0].tideData[2].tideType.toLowerCase() +
      " tide " +
      thirdHt +
      "ft@ " +
      thirdDate +
      spacer +
      "Second " +
      weatherData.data.weather[0].tides[0].tideData[3].tideType.toLowerCase() +
      " tide " +
      fourthHt +
      "ft@ " +
      fourthDate +
      "             ";

  //DateFormat('EE').format(localWeather.data.weather[0].date)
  //String day2 = getWeatherLine("Tuesday", 1);
  String day1 = getWeatherLine("Today\'s", 0);
  String day2 = getWeatherLine(
      DateFormat('EEEE').format(localWeather.data.weather[1].date), 0);
  String day3 = getWeatherLine(
      DateFormat('EEEE').format(localWeather.data.weather[2].date), 0);
  String day4 = getWeatherLine(
      DateFormat('EEEE').format(localWeather.data.weather[3].date), 0);
  return day1 + day2 + day3 + day4;
}

getWeatherLine(String stringDay, int day) {
  return ("     " +
      stringDay +
      " Weather:    " +
      localWeather.data.weather[day].hourly[0].weatherDesc[0].value +
      spacer +
      "Lo " +
      localWeather.data.weather[day].mintempF +
      "\u00B0F" + //\u2109
      spacer +
      "High " +
      weatherData.data.weather[day].maxtempF +
      "\u00B0F" +
      spacer +
      "Humidity " +
      localWeather.data.weather[day].hourly[0].humidity +
      "%" +
      spacer +
      "Barometric Pressure " +
      localWeather.data.weather[day].hourly[0].pressureInches +
      "in" +
      spacer +
      "Chance of Rain " +
      localWeather.data.weather[day].hourly[0].chanceofrain +
      "%" +
      spacer +
      "Cloud Cover " +
      localWeather.data.weather[day].hourly[0].cloudcover +
      "%" +
      spacer +
      "Wind Speed " +
      localWeather.data.weather[day].hourly[0].windspeedMiles +
      "(mph) gusting to " +
      localWeather.data.weather[day].hourly[0].windGustMiles +
      spacer +
      "Visibility " +
      localWeather.data.weather[day].hourly[0].visibilityMiles +
      " miles" +
      spacer +
      "Air Quality  " +
      airQuality[
          localWeather.data.weather[day].hourly[0].airQuality.usEpaIndex] +
      spacer +
      "           ");
}

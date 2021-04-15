import 'package:flutter/material.dart';
import 'package:tidey/services/marineWeather.dart';

String globalLatitude;
String globalLongitude;
MarineWeather weatherData = MarineWeather();

const prodServerURL = 'https://shoebox.veloxe.com/';
const localServerURL = 'http://192.168.1.250:5000/';
const serverURL = localServerURL;
const apiURL = serverURL + 'api/';
//  http://api.worldweatheronline.com/premium/v1/marine.ashx?key=51503debb4b34526a33181926211204&q=26.7747,-77.3296&format=json&tide=yes&tp=3
const weatherServerURL = 'https://api.worldweatheronline.com/premium/v1/';
const rumWeatherServiceURL = 'https://shoeboxrum.veloxe.com/api/tidey';
const weatherAPIKey = 'key=51503debb4b34526a33181926211204';
const marineWeatherService = weatherServerURL + "marine.ashx";
const kTextAndIconColor = Color(0xFFFFFFFF);
const kPrimaryTextColor = Color(0xFF212121);
const kSecondaryTextColor = Color(0xFF757575);
const kPrimaryColor = Colors.indigo;

const kClockTextStyle = TextStyle(
  fontSize: 45,
  color: kPrimaryTextColor,
);
const kMoonTextStyle = TextStyle(
  fontSize: 20,
  color: Colors.white,
);
const kClockTextSmallStyle = TextStyle(
  fontSize: 17,
  color: kPrimaryTextColor,
);

const kClockTrailerTextStyle = TextStyle(
  fontSize: 17,
  color: kPrimaryTextColor,
);

const kMySubTileData = [
  {
    "timeStamp": '3:08 PM',
    "tideHeight": '+ 1.65 ft',
    "tideRising": true,
    "today": true
  },
  {
    "timeStamp": '8:46 PM',
    "tideHeight": '- 1.65 ft',
    "tideRising": false,
    "today": true
  },
  {
    "timeStamp": '1:46 AM',
    "tideHeight": '+ 1.65 ft',
    "tideRising": true,
    "today": false
  },
  {
    "timeStamp": '8:14 AM',
    "tideHeight": '- 1.65 ft',
    "tideRising": false,
    "today": false
  },
];

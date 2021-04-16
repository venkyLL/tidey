import 'package:flutter/material.dart';
import 'package:tidey/services/marineWeather.dart';
import 'package:weather_icons/weather_icons.dart';

String globalLatitude;
String globalLongitude;
MarineWeather weatherData = MarineWeather();
const hourFmt = {
  '0': 'Midnight',
  '300': "3AM",
  "600": "6AM",
  '900': "9AM",
  "1200": "Noon",
  "1500": "3PM",
  "1800": "6PM",
  "2100": "9PM"
};
Map<String, IconData> weatherDayIconMap = {
  "395": WeatherIcons.snow,
  "392": WeatherIcons.snow,
  "389": WeatherIcons.thunderstorm,
  "386": WeatherIcons.storm_showers,
  "377": WeatherIcons.sleet,
  "374": WeatherIcons.sleet,
  "371": WeatherIcons.rain,
  "368": WeatherIcons.snowflake_cold,
  "365": WeatherIcons.rain,
  "362": WeatherIcons.sleet,
  "359": WeatherIcons.rain,
  "356": WeatherIcons.rain,
  "353": WeatherIcons.showers,
  "350": WeatherIcons.sleet,
  "338": WeatherIcons.snowflake_cold,
  "335": WeatherIcons.snowflake_cold,
  "332": WeatherIcons.snowflake_cold,
  "329": WeatherIcons.snowflake_cold,
  "326": WeatherIcons.snowflake_cold,
  "323": WeatherIcons.snowflake_cold,
  "320": WeatherIcons.sleet,
  "317": WeatherIcons.sleet,
  "314": WeatherIcons.sleet,
  "311": WeatherIcons.sleet,
  "308": WeatherIcons.rain,
  "305": WeatherIcons.rain,
  "302": WeatherIcons.rain,
  "299": WeatherIcons.rain,
  "296": WeatherIcons.rain,
  "293": WeatherIcons.showers,
  "284": WeatherIcons.sleet,
  "281": WeatherIcons.sleet,
  "266": WeatherIcons.sprinkle,
  "263": WeatherIcons.sprinkle,
  "260": WeatherIcons.fog,
  "248": WeatherIcons.fog,
  "230": WeatherIcons.snow,
  "227": WeatherIcons.snow_wind,
  "200": WeatherIcons.storm_showers,
  "185": WeatherIcons.hail,
  "182": WeatherIcons.hail,
  "179": WeatherIcons.snow,
  "176": WeatherIcons.showers,
  "143": WeatherIcons.sprinkle,
  "122": WeatherIcons.cloudy,
  "119": WeatherIcons.cloudy,
  "116": WeatherIcons.day_cloudy,
  "113": WeatherIcons.day_sunny,
};

Map<String, IconData> weatherNightIconMap = {
  "395": WeatherIcons.snow,
  "392": WeatherIcons.snow,
  "389": WeatherIcons.night_alt_thunderstorm,
  "386": WeatherIcons.night_alt_storm_showers,
  "377": WeatherIcons.night_alt_sleet,
  "374": WeatherIcons.night_alt_sleet,
  "371": WeatherIcons.night_alt_rain,
  "368": WeatherIcons.snowflake_cold,
  "365": WeatherIcons.night_alt_rain,
  "362": WeatherIcons.night_alt_sleet,
  "359": WeatherIcons.night_alt_rain,
  "356": WeatherIcons.night_alt_rain,
  "353": WeatherIcons.night_alt_rain,
  "350": WeatherIcons.night_alt_sleet,
  "338": WeatherIcons.snowflake_cold,
  "335": WeatherIcons.snowflake_cold,
  "332": WeatherIcons.snowflake_cold,
  "329": WeatherIcons.snowflake_cold,
  "326": WeatherIcons.snowflake_cold,
  "323": WeatherIcons.snowflake_cold,
  "320": WeatherIcons.night_alt_sleet,
  "317": WeatherIcons.night_alt_sleet,
  "314": WeatherIcons.night_alt_sleet,
  "311": WeatherIcons.night_alt_sleet,
  "308": WeatherIcons.night_alt_rain,
  "305": WeatherIcons.night_alt_rain,
  "302": WeatherIcons.night_alt_rain,
  "299": WeatherIcons.night_alt_rain,
  "296": WeatherIcons.night_alt_rain,
  "293": WeatherIcons.night_alt_showers,
  "284": WeatherIcons.night_alt_sleet,
  "281": WeatherIcons.night_alt_sleet,
  "266": WeatherIcons.night_alt_sprinkle,
  "263": WeatherIcons.night_alt_sprinkle,
  "260": WeatherIcons.night_fog,
  "248": WeatherIcons.night_fog,
  "230": WeatherIcons.snow,
  "227": WeatherIcons.night_alt_snow_wind,
  "200": WeatherIcons.night_alt_storm_showers,
  "185": WeatherIcons.night_alt_cloudy,
  "182": WeatherIcons.night_alt_hail,
  "179": WeatherIcons.snow,
  "176": WeatherIcons.night_alt_showers,
  "143": WeatherIcons.night_alt_sprinkle,
  "122": WeatherIcons.night_alt_cloudy,
  "119": WeatherIcons.night_alt_cloudy,
  "116": WeatherIcons.night_alt_cloudy,
  "113": WeatherIcons.night_clear,
};

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

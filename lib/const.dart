import 'dart:math';

import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:tidey/services/localWeather.dart';
import 'package:tidey/services/marineWeather.dart';
import 'package:weather_icons/weather_icons.dart';

String globalLatitude;
String globalLongitude;

// Print debugger
bool globalMarineWeatherPrintDone = false;
int secondsBetweenTransition = 5;

const metersToFeet = 3.28084;
PackageInfo packageInfo = PackageInfo();
PackageInfo _packageInfo = PackageInfo(
  appName: 'Unknown',
  packageName: 'Unknown',
  version: 'Unknown',
  buildNumber: 'Unknown',
);

//globals for the sinewave function y = A sin (omega * t + alpha) + C
double globalA;
double globalC;
double globalOmega;
double globalAlpha;

//
double globalNextHighTidePointerValue = 10;
double globalNextLowTidePointerValue = 6;
double globalNextHighTideHeightInFeet = 99999;
double globalNextLowTideHeightInFeet = 999999;
double currentDirection = 193;

int globalNumberOfDaysOfWeatherData = 1;

MarineWeather weatherData = MarineWeather();
LocalWeather localWeather = LocalWeather();

//gauge constants
double globalCompassDirection;
DateTime globalCompassValueLastReadAt;

const hourFmt = {
  '0': '12:00',
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
const kTitleBoxColor = Color(0xFFBEC2CB);
const kTextSettingSize = 20.0;
const kTextSettingsStyle = TextStyle(fontSize: kTextSettingSize);
const kIconSettingSize = 40.0;
const kClockTextStyle = TextStyle(
  fontSize: 45,
  color: Colors.white,
);
const kTitleTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);
const kTableTitleTextStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);
const kMoonTextStyle = TextStyle(
  fontSize: 20,
  color: Colors.white,
);
const kClockTextSmallStyle = TextStyle(
  fontSize: 17,
  color: Colors.white,
);
const kTableTextStyle =
    TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold);
const kTableTextStyleRed = TextStyle(
  fontSize: 20,
  color: Colors.red,
  fontWeight: FontWeight.bold,
);
const kTableTextStyleGreen = TextStyle(
  fontSize: 20,
  color: Colors.green,
  fontWeight: FontWeight.bold,
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

class ScreenSize {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;
  static double clockSize;
  static double gaugeSize;
  static double clockTop;
  static double gaugeTop;
  static double gaugeBottom;
  static Offset gauge1TopLeft;
  static Offset gauge1BottomRight;
  static double _safeAreaHorizontal;
  static double _safeAreaVertical;
  static double safeBlockHorizontal;
  static double safeBlockVertical;
  static double marqueeHeight;
  static Offset clockTopLeft;
  static Offset clockBottomRight;
  static double portraitClockSpace;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;
    gaugeSize = max(safeBlockHorizontal, safeBlockVertical) * 30;
    clockSize = max(safeBlockHorizontal, safeBlockVertical) * 40;
    clockTop =
        ((min(safeBlockVertical, safeBlockHorizontal) * 100) - clockSize) / 2;
    // portraitClockSpace = ((safeBlockHorizontal * 100) - clockSize) / 2;
    gaugeTop = clockTop / 2;
//    gaugeTop =
//        ((max(safeBlockVertical, safeBlockHorizontal) * 100) - gaugeSize) / 4;
    marqueeHeight = clockTop;

    // gaugeBottom =
    //   (safeBlockVertical * 100) - gaugeSize - gaugeTop - marqueeHeight;
    //  gaugeBottom = ((clockTop * 2) + clockSize) - (gaugeSize + (gaugeTop)) - 150;
    gaugeBottom = clockTop + clockSize - gaugeSize - gaugeTop;
    gauge1TopLeft = Offset(0, gaugeTop);
    gauge1BottomRight = Offset(gaugeSize, gaugeTop + gaugeSize);
    clockTopLeft = Offset(gaugeSize, clockTop);
    clockBottomRight = Offset(gaugeSize + clockSize, clockTop + clockSize);
    print(_mediaQueryData.orientation);
    print("Total height = ${safeBlockVertical * 100}");
    print("Total width = ${safeBlockHorizontal * 100}");
    print("GaugeTop = ${gaugeTop}");
    print("Gauge Size = ${gaugeSize}");
    print("ClockTop = ${clockTop}");
    print("Clock Size = ${clockSize}");
    print("Box below gauge = ${gaugeBottom}");
    print("Total height = ${safeBlockVertical * 100}");

    print("GaugeTop = ${gaugeTop}");
    print("Gauge Size = ${gaugeSize}");
    print("ClockTop = ${clockTop}");
    print("Clock Size = ${clockSize}");
    print("Box below gauge = ${gaugeBottom}");

    print("Gauge TopLeft , ${gauge1TopLeft.dx} ${gauge1TopLeft.dy}");
    print("Gauge TopRight , ${gauge1BottomRight.dx} ${gauge1BottomRight.dy}");
    print("Clock TopLeft , ${clockTopLeft.dx} ${clockTopLeft.dy}");
    print("Clock TopRight , ${clockBottomRight.dx} ${clockBottomRight.dy}");
  }
}

BoxedIcon getWeatherIconBox({String time, String code}) {
  // var iconName = "WeatherIcons.day_cloudy";
  print("Time is" + time);
  switch (time) {
    case "0":
    case "300":
    case "2100":
      {
        return BoxedIcon((weatherNightIconMap[code]), color: Colors.white);
      }
      break;

    default:
      {
        return BoxedIcon((weatherDayIconMap[code]), color: Colors.white);
      }
      break;
  }
}

enum BarometerChange {
  rising,
  falling,
  flat,
}
getBarometerChange() {
  // var iconName = "WeatherIcons.day_cloudy";
  double current =
      double.parse(weatherData.data.weather[0].hourly[0].pressureInches);
  double future =
      double.parse(weatherData.data.weather[0].hourly[1].pressureInches);
  if (current == future)
    return BarometerChange.flat;
  else if (current > future)
    return BarometerChange.falling;
  else
    return BarometerChange.rising;
}

String getMoonImageName() {
  switch (weatherData.data.weather[0].astronomy[0].moonPhase) {
    case "New Moon":
      {
        return "moon0.png";
      }
      break;
    case "Waxing Crescent":
      {
        return "moon6.png";
      }
      break;
    case "First Quarter":
      {
        return "moon9.png";
      }
      break;
    case "Waxing Gibbous":
      {
        return "moon11.png";
      }
      break;
    case "Full Moon":
      {
        return "moon15.png";
      }
      break;
    case "Waning Gibbous":
      {
        return "moon18.png";
      }
      break;
    case "Last Quarter":
      {
        return "moon20.png";
      }
      break;
    case "Waning Crescent":
      {
        return "moon23.png";
      }
      break;
    default:
      {
        return "assets/images/moons/moon1.png";
      }
      break;
  }
}

class GaugeContainer extends StatelessWidget {
  final String imageName;
  final String textLabel;
  final Color textColor;
  final Color textBackgroundColor;
  final double fontSize;
  final int textPosition;
  final Color backgroundColor;
  final Color bezelColor;
  final double bezelWidth;
  final double imageInset;
  final Widget child;

  GaugeContainer({
    this.imageName,
    this.textLabel = "",
    this.textColor = Colors.white,
    this.textBackgroundColor = Colors.white30,
    this.fontSize = 24,
    this.textPosition = 67,
    this.backgroundColor = Colors.black,
    this.bezelColor = const Color(0xFF999999),
    this.bezelWidth = 5,
    this.imageInset = 30,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: ScreenSize.gaugeSize,
          height: ScreenSize.gaugeSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: bezelColor,
          ),
        ),
        Positioned.fill(
          top: bezelWidth,
          right: bezelWidth,
          left: bezelWidth,
          bottom: bezelWidth,
          child: Container(
            width: ScreenSize.gaugeSize,
            height: ScreenSize.gaugeSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor,
            ),
          ),
        ),
        Positioned.fill(
            top: imageInset,
            right: imageInset,
            bottom: imageInset,
            left: imageInset,
            child: child),
      ],
    );
  }
}

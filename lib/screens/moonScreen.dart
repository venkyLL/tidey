import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tidey/const.dart';
import 'package:tidey/screens/forecast.dart';
import 'package:weather_icons/weather_icons.dart';

class MoonScreen extends StatefulWidget {
  static const String id = 'MoonScreen';
  @override
  _MoonScreenState createState() => _MoonScreenState();
}

class _MoonScreenState extends State<MoonScreen> {
  String moonPhaseImageName = null;

  void initState() {
    // TODO: implement initState
    super.initState();
    switch (weatherData.data.weather[0].astronomy[0].moonPhase) {
      case "First Quarter":
        {
          moonPhaseImageName = "assets/images/firstQuarter.jpg";
        }
        break;

      case "Full Moon":
        {
          moonPhaseImageName = "assets/images/fullMoon.jpg";
        }
        break;

      default:
        {
          moonPhaseImageName = "assets/images/fullMoon.jpg";
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(weatherData.data.weather[0].astronomy[0].moonPhase),
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: <Widget>[
//          Padding(
//              padding: EdgeInsets.only(right: 20.0),
//              child: GestureDetector(
//                onTap: () {},
//                child: Icon(
//                  Icons.search,
//                  size: 26.0,
//                ),
//              )),
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, ForecastScreen.id);
                },
                child: Icon(Icons.chevron_right),
              )),
        ],
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Center(child: Image.asset(moonPhaseImageName)),
            Text(
              'Illumination ${weatherData.data.weather[0].astronomy[0].moonIllumination}%',
              style: kMoonTextStyle,
            ),
            SizedBox(
              height: 10,
            ),
            Row(children: <Widget>[
              BoxedIcon((WeatherIcons.moonrise), color: Colors.white),
              Text(
                ' Moon Rise:  ${weatherData.data.weather[0].astronomy[0].moonrise}',
                style: kMoonTextStyle,
              ),
            ]),

            Row(children: <Widget>[
              BoxedIcon((WeatherIcons.moonset), color: Colors.white),
              Text(
                ' Moon Set:  ${weatherData.data.weather[0].astronomy[0].moonset}',
                style: kMoonTextStyle,
              )
            ]),

            Row(children: <Widget>[
              BoxedIcon((WeatherIcons.sunrise), color: Colors.white),
              Text(
                ' Sun Rise:  ${weatherData.data.weather[0].astronomy[0].sunrise}',
                style: kMoonTextStyle,
              )
            ]),

            Row(children: <Widget>[
              BoxedIcon((WeatherIcons.sunset), color: Colors.white),
              Text(
                ' Sun Rise:  ${weatherData.data.weather[0].astronomy[0].sunset}',
                style: kMoonTextStyle,
              )
            ]),

//            Row(children: <Widget>[
//              BoxedIcon((WeatherIcons.moon_alt_full), color: Colors.white),
//              Text(
//                ' Next Full Moon:  tbd',
//                style: kMoonTextStyle,
//              )
//            ]),

            //
          ],
        ),
      ),
    );

    Container(child: Text("Hello Moon")
        // Image.asset('safew8ManagerBanner.png'),
        );
  }
}

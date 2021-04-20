import 'package:flutter/material.dart';
import 'package:tidey/const.dart';
import 'package:weather_icons/weather_icons.dart';

var fontScale = 6;

class MoonTable extends StatefulWidget {
  @override
  _MoonTableState createState() => _MoonTableState();
}

class _MoonTableState extends State<MoonTable> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.blue,
      height: SizeConfig.safeBlockVertical * 45,
      child: Container(
        height: SizeConfig.safeBlockVertical * 45,
        width: SizeConfig.safeBlockHorizontal * 90,
        child: Column(
          children: [
            Text(weatherData.data.weather[0].astronomy[0].moonPhase,
                style: kTableTitleTextStyle),
            SizedBox(height: 10),
            Row(
              children: [
                Container(
                    width: SizeConfig.safeBlockHorizontal * 35,
                    height: SizeConfig.safeBlockHorizontal * 35,
                    child: Image.asset(
                      "assets/images/fullMoon2.png",
//            width: MediaQuery.of(context).size.width / 2.5,
//            height: MediaQuery.of(context).size.width / 2.5,
                    )),
                Container(
                    // color: Colors.black,
                    width: SizeConfig.safeBlockHorizontal * 55,
                    height: SizeConfig.safeBlockHorizontal * 35,
                    child: Column(
                      children: [
                        SizedBox(height: 10),
//                        Text(
//                          'Illumination ${weatherData.data.weather[0].astronomy[0].moonIllumination}%',
//                          style: TextStyle(
//                            fontSize:
//                                SizeConfig.safeBlockHorizontal * fontScale,
//                            color: Colors.white,
//                          ),
//                        ),
//                        SizedBox(
//                          height: 10,
//                        ),
                        Row(children: <Widget>[
                          BoxedIcon((WeatherIcons.moonrise),
                              color: Colors.white),
                          Text(
                            ' Rise: ${weatherData.data.weather[0].astronomy[0].moonrise}',
                            style: TextStyle(
                              fontSize:
                                  SizeConfig.safeBlockHorizontal * fontScale,
                              color: Colors.white,
                            ),
                          ),
                        ]),
                        Row(children: <Widget>[
                          BoxedIcon((WeatherIcons.moonset),
                              color: Colors.white),
                          Text(
                            ' Set:   ${weatherData.data.weather[0].astronomy[0].moonset}',
                            style: TextStyle(
                              fontSize:
                                  SizeConfig.safeBlockHorizontal * fontScale,
                              color: Colors.white,
                            ),
                          )
                        ]),
                        Row(children: <Widget>[
                          BoxedIcon((WeatherIcons.moon_alt_new),
                              color: Colors.white),
                          Text(
                            ' Illumination:  ${weatherData.data.weather[0].astronomy[0].moonIllumination}',
                            style: TextStyle(
                              fontSize:
                                  SizeConfig.safeBlockHorizontal * fontScale,
                              color: Colors.white,
                            ),
                          )
                        ]),
                      ],
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SunTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.blue,
      height: SizeConfig.safeBlockVertical * 45,
      child: Container(
        height: SizeConfig.safeBlockVertical * 45,
        width: SizeConfig.safeBlockHorizontal * 90,
        child: Column(
          children: [
            Text("Sunrise and Sunset", style: kTableTitleTextStyle),
            SizedBox(height: 10),
            Row(
              children: [
                Container(
                    width: SizeConfig.safeBlockHorizontal * 35,
                    height: SizeConfig.safeBlockHorizontal * 35,
                    child: Image.asset(
                      "assets/images/sunrise.jpg",
//            width: MediaQuery.of(context).size.width / 2.5,
//            height: MediaQuery.of(context).size.width / 2.5,
                    )),
                Container(
                    // color: Colors.black,
                    width: SizeConfig.safeBlockHorizontal * 55,
                    height: SizeConfig.safeBlockHorizontal * 35,
                    child: Column(
                      children: [
                        SizedBox(height: 30),
                        Row(children: <Widget>[
                          BoxedIcon((WeatherIcons.sunrise),
                              color: Colors.white),
                          Text(
                            ' Rise:  ${weatherData.data.weather[0].astronomy[0].sunrise}',
                            style: TextStyle(
                              fontSize:
                                  SizeConfig.safeBlockHorizontal * fontScale,
                              color: Colors.white,
                            ),
                          ),
                        ]),
                        Row(children: <Widget>[
                          BoxedIcon((WeatherIcons.sunset), color: Colors.white),
                          Text(
                            ' Set:  ${weatherData.data.weather[0].astronomy[0].sunset}',
                            style: TextStyle(
                              fontSize:
                                  SizeConfig.safeBlockHorizontal * fontScale,
                              color: Colors.white,
                            ),
                          )
                        ]),
                      ],
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tidey/const.dart';
import 'package:weather_icons/weather_icons.dart';

class MoonRow extends StatelessWidget {
  const MoonRow({
    Key key,
    @required this.moonPhaseImageName,
  }) : super(key: key);

  final String moonPhaseImageName;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.blue,
      height: ScreenSize.safeBlockVertical * 45,
      child: Column(
        children: [
          SizedBox(
            height: 30,
            child: Container(
                //color: Colors.black,
                ),
          ),
          Container(
              // color: Colors.black,
              width: double.infinity,
              child: Text(
                weatherData.data.weather[0].astronomy[0].moonPhase,
                style: kTableTitleTextStyle,
              )),
          Row(
            children: [
              Container(
                  // color: Colors.black,
                  width: MediaQuery.of(context).size.width * .4,
                  height: MediaQuery.of(context).size.width * .4,
                  child: Image.asset(
                    moonPhaseImageName,
//            width: MediaQuery.of(context).size.width / 2.5,
//            height: MediaQuery.of(context).size.width / 2.5,
                  )),
              Container(
                // color: Colors.black,
                width: MediaQuery.of(context).size.width * .6,
                height: MediaQuery.of(context).size.width * .4,
                child: Column(
                  children: [
                    SizedBox(height: 50),
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

//

                    //
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SunRise extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.blue,
      height: ScreenSize.safeBlockVertical * 45,
      child: Column(
        children: [
          SizedBox(
            height: 30,
            child: Container(
                //color: Colors.black,
                ),
          ),
          Container(
              // color: Colors.black,
              width: double.infinity,
              child: Text(
                weatherData.data.weather[0].astronomy[0].moonPhase,
                style: kTableTitleTextStyle,
              )),
          Row(
            children: [
              Container(
                  // color: Colors.black,
                  width: MediaQuery.of(context).size.width * .4,
                  height: MediaQuery.of(context).size.width * .4,
                  child: Image.asset(
                    "Sunrise",
//            width: MediaQuery.of(context).size.width / 2.5,
//            height: MediaQuery.of(context).size.width / 2.5,
                  )),
              Container(
                // color: Colors.black,
                width: MediaQuery.of(context).size.width * .6,
                height: MediaQuery.of(context).size.width * .4,
                child: Column(
                  children: [
                    SizedBox(height: 50),

                    Row(children: <Widget>[
                      BoxedIcon((WeatherIcons.sunrise), color: Colors.white),
                      Text(
                        ' Moon Rise:  ${weatherData.data.weather[0].astronomy[0].sunrise}',
                        style: kMoonTextStyle,
                      ),
                    ]),

                    Row(children: <Widget>[
                      BoxedIcon((WeatherIcons.sunset), color: Colors.white),
                      Text(
                        ' Moon Set:  ${weatherData.data.weather[0].astronomy[0].sunset}',
                        style: kMoonTextStyle,
                      )
                    ]),

//

                    //
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

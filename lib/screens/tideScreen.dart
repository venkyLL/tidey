import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/box.dart';
import 'package:marquee/marquee.dart';
import 'package:tidey/components/directionAndSpeedGauge.dart';
import 'package:tidey/components/imageGauge.dart';
import 'package:tidey/components/moonTable.dart';
import 'package:tidey/components/zeClockSync.dart';
import 'package:tidey/const.dart';
import 'package:tidey/screens/moonScreen.dart';
import 'package:tidey/screens/weatherToday.dart';
import 'package:timer_builder/timer_builder.dart';

class TideScreen extends StatelessWidget {
  static const String id = 'TideScreen';
//  final String passedValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar:
            // AppBar(title: Text(globalLatitude == null ? "bob" : globalLatitude)),
            AppBar(
          //    title: Text(globalLatitude == null ? "Tide" : globalLatitude),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          //  backgroundColor: Color(0x44000000),
          elevation: 0,
          leading: GestureDetector(
            onTap: () {/* Write listener code here */},
            child: Icon(
              Icons.menu, // add custom icons also
            ),
          ),
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
                    Navigator.pushNamed(context, MoonScreen.id);
                  },
                  child: Icon(Icons.chevron_right),
                )),
          ],
        ),
        body: OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.portrait) {
              return PortraitMode();
            } else {
              return LandScapeMode();
            }
          },
        ));
  }
}

class LandScapeMode extends StatefulWidget {
  @override
  _LandScapeModeState createState() => _LandScapeModeState();
}

class _LandScapeModeState extends State<LandScapeMode> {
  HourlyDataSource hourlyDataSource;
  @override
  void initState() {
    hourlyDataSource =
        HourlyDataSource(hourlyData: weatherData.data.weather[0].hourly);
    print("Number of hourly records is " +
        weatherData.data.weather[0].hourly.length.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bgBlue2.JPG'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.8), BlendMode.dstATop),
        ),
      ),
      constraints: BoxConstraints.expand(),
      child: maingGaugeView(),
    );
  }
}

class maingGaugeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Column(
              children: [
                //  CompassGauge(),
                //ImageGauge(imageName: "gaugeMoon.png", textLabel: ""),

                ImageGauge(
                  imageName: "gaugeWater.png",
                  textLabel: "Water 87 \u2109",
                  textColor: Colors.black,
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(
                  height: 140,
                ),
                zeClockSync(),
              ],
            ),
            Column(
              children: [
//                  SizedBox(
//                    height: 10,
//                  ),
                DirectionAndSpeedGauge(),
                //  ImageGauge(imageName: "gaugeSunset.png", textLabel: "8:15PM"),
//                ImageGauge(
//                    imageName: "gaugeStars.png",
//                    textLabel: "Waxing Crescent\nRise: 12:PM\nSet: 03:00AM",
//                    textPosition: 40,
//                    textBackgroundColor: Colors.transparent,
//                    fontSize: 20),
              ],
//          Container(
//            width: SizeConfig.safeBlockHorizontal * 28,
//            child: Column(
//              // mainAxisAlignment: MainAxisAlignment.center,
//              children: [
//                SizedBox(height: 85),
//                Expanded(
//                  child: WeatherTodayTable(hourlyDataSource: hourlyDataSource),
//                ),
//              ],
//            ),
//          ),
            ),
          ],
        ),
        Container(
          width: 1000,
          height: 120,
          color: Colors.transparent,
          // color: Colors.green,
          child: ListView(
            padding: EdgeInsets.only(top: 50.0),
            children: [
              // _buildMarquee(),
              _buildComplexMarquee(),
            ].map(_wrapWithStuff).toList(),
          ),
        ),
      ],
    );
  }
}

Widget _buildMarquee() {
  return Marquee(
    text: 'There once was a boy who told this story about a boy: "',
  );
}

Widget _buildComplexMarquee() {
  return Marquee(
    text:
        'The weather outside is frightful. Let it snow, Let it Snow, Let it Snow',
    style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 40,
        //    backgroundColor: Colors.white30,
        color: Colors.grey), // Color(0xFFBEC2CB)),
    scrollAxis: Axis.horizontal,
    crossAxisAlignment: CrossAxisAlignment.start,
    blankSpace: 20.0,
    velocity: 100.0,
    pauseAfterRound: Duration(seconds: 1),
    showFadingOnlyWhenScrolling: true,
    fadingEdgeStartFraction: 0.1,
    fadingEdgeEndFraction: 0.1,
    numberOfRounds: 3,
    startPadding: 10.0,
    accelerationDuration: Duration(seconds: 1),
    accelerationCurve: Curves.linear,
    decelerationDuration: Duration(milliseconds: 500),
    decelerationCurve: Curves.easeOut,
  );
}

Widget _wrapWithStuff(Widget child) {
  return Padding(
    padding: EdgeInsets.all(16.0),
    child: Container(height: 120.0, color: Colors.transparent, child: child),
  );
}

class PortraitMode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/blueTexture.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.8), BlendMode.dstATop),
        ),
      ),
      constraints: BoxConstraints.expand(),
      child: Column(
//            crossAxisAlignment: CrossAxisAlignment.stretch,
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(height: SizeConfig.safeBlockVertical * 2),
            zeClockSync(),
//                ClockExample(),
            SizedBox(height: SizeConfig.safeBlockVertical * 2),
            // MoonRow(moonPhaseImageName: "assets/images/fullMoon.jpg"),
            TimerWidget(),
          ]),
    );
  }
}

// hello
class buildMyTideTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.blue,
      height: SizeConfig.safeBlockVertical * 45,

      child: Container(
        height: SizeConfig.safeBlockVertical * 45,
        width: SizeConfig.safeBlockHorizontal * 80,
        child: Column(
          children: [
            Text("Tides", style: kTableTitleTextStyle),
            SizedBox(height: 10),
//          Padding(
//            padding: const EdgeInsets.only(left: , right: 65),
//            child:
            Table(children: [
              tideTableRow(
                  day: 'Today',
                  time:
                      weatherData.data.weather[0].tides[0].tideData[0].tideTime,
                  level: (double.parse(weatherData
                      .data.weather[0].tides[0].tideData[0].tideHeightMt)),
                  direction: weatherData
                      .data.weather[0].tides[0].tideData[0].tideType),
              tideTableRow(
                  day: 'Today',
                  time:
                      weatherData.data.weather[0].tides[0].tideData[1].tideTime,
                  level: (double.parse(weatherData
                      .data.weather[0].tides[0].tideData[1].tideHeightMt)),
                  direction: weatherData
                      .data.weather[0].tides[0].tideData[1].tideType),
              tideTableRow(
                  day: 'Tomorrow',
                  time:
                      weatherData.data.weather[0].tides[0].tideData[2].tideTime,
                  level: (double.parse(weatherData
                      .data.weather[0].tides[0].tideData[2].tideHeightMt)),
                  direction: weatherData
                      .data.weather[0].tides[0].tideData[2].tideType),
              tideTableRow(
                  day: 'Tomorrow',
                  time:
                      weatherData.data.weather[0].tides[0].tideData[3].tideTime,
                  level: (double.parse(weatherData
                      .data.weather[0].tides[0].tideData[3].tideHeightMt)),
                  direction: weatherData
                      .data.weather[0].tides[0].tideData[3].tideType),
            ]),
            // mySubTile(kMySubTileData),
            //         ),
          ],
        ),
      ),
    );
  }
}

TableRow tideTableRow(
    {String day, String time, double level, String direction}) {
  print("Direction is $day,$time, $level,$direction");
  // static htInFeet = double.parse(level)/3.28084;
  final String pos = level > 2.0 ? "+" : "-";
  const fontScale = 5;
  return TableRow(
    children: [
      Text(day,
          style: TextStyle(
            fontSize: SizeConfig.safeBlockHorizontal * fontScale,
            color: Colors.white,
          )),
      Text(
        time,
        style: TextStyle(
          fontSize: SizeConfig.safeBlockHorizontal * fontScale,
          color: Colors.white,
        ),
        textAlign: TextAlign.right,
      ),
      direction == "LOW"
          ? RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                /*defining default style is optional */
                children: <TextSpan>[
                  TextSpan(
                    text:
                        ("    " + (level * 3.28084).toStringAsFixed(2)) + 'ft ',
                    style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * fontScale,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                      text: 'L',
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * fontScale,
                        color: Colors.red,
                      )),
                ],
              ),
            )
          : RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                /*defining default style is optional */
                children: <TextSpan>[
                  TextSpan(
                    text:
                        ("    " + (level * 3.28084).toStringAsFixed(2)) + 'ft ',
                    style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * fontScale,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                      text: 'H',
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * fontScale,
                        color: Colors.green,
                      )),
                ],
              ),
            ),
    ],
  );
}

class Swapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    switch (counter) {
      case 0:
        return buildMyTideTable();
        break;
      case 1:
        return SunTable();
        break;
      case 2:
        return MoonTable();
        break;

      default:
        {
          print("Error");
        }
        break;
    }
//    return counter == 0
//        ? buildMyTideTable()
//        : SunTable(); // (moonPhaseImageName: "assets/images/fullMoon.jpg");
  }
}

int counter = 0;

class TimerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TimerBuilder.periodic(Duration(seconds: 5), builder: (context) {
      counter = (counter + 1) % 3;
      // counter == 0 ? counter = 1 : counter = 0;
      return Swapper();
    });
  }
}

//  Container buildTideTable() {
//    return Container(
//      child: Column(
//        children: [
//          Text("Tides", style: kTableTitleTextStyle),
//          SizedBox(height: 10),
//          Padding(
//            padding: const EdgeInsets.only(left: 65, right: 65),
//            child: Table(
////            columnWidths: {
////          0: FractionColumnWidth(.32),
////          1: FractionColumnWidth(.33),
////          2: FractionColumnWidth(.30),
////          //   3: FractionColumnWidth(.05),
////        } ,
//                children: [
//                  tideTableRow(
//                      day: 'Today',
//                      time: weatherData
//                          .data.weather[0].tides[0].tideData[0].tideTime,
//                      level: (double.parse(weatherData
//                          .data.weather[0].tides[0].tideData[0].tideHeightMt)),
//                      direction: weatherData
//                          .data.weather[0].tides[0].tideData[0].tideType),
//                  tideTableRow(
//                      day: 'Today',
//                      time: weatherData
//                          .data.weather[0].tides[0].tideData[1].tideTime,
//                      level: (double.parse(weatherData
//                          .data.weather[0].tides[0].tideData[1].tideHeightMt)),
//                      direction: weatherData
//                          .data.weather[0].tides[0].tideData[1].tideType),
//                  tideTableRow(
//                      day: 'Tomorrow',
//                      time: weatherData
//                          .data.weather[0].tides[0].tideData[2].tideTime,
//                      level: (double.parse(weatherData
//                          .data.weather[0].tides[0].tideData[2].tideHeightMt)),
//                      direction: weatherData
//                          .data.weather[0].tides[0].tideData[2].tideType),
//                  tideTableRow(
//                      day: 'Tomorrow',
//                      time: weatherData
//                          .data.weather[0].tides[0].tideData[3].tideTime,
//                      level: (double.parse(weatherData
//                          .data.weather[0].tides[0].tideData[3].tideHeightMt)),
//                      direction: weatherData
//                          .data.weather[0].tides[0].tideData[3].tideType),
//                ]),
//            // mySubTile(kMySubTileData),
//          ),
//        ],
//      ),
//    );
//
//  }
//
//// 3.28084
//  TableRow tideTableRow(
//      {String day, String time, double level, String direction}) {
//    print("Direction is $day,$time, $level,$direction");
//    // static htInFeet = double.parse(level)/3.28084;
//    final String pos = level > 2.0 ? "+" : "-";
//    return TableRow(
//      children: [
//        Text(day, style: kTableTextStyle),
//        Text(
//          time,
//          style: kTableTextStyle,
//          textAlign: TextAlign.right,
//        ),
//        direction == "LOW"
//            ? RichText(
//                textAlign: TextAlign.right,
//                text: TextSpan(
//                  /*defining default style is optional */
//                  children: <TextSpan>[
//                    TextSpan(
//                      text: ((level * 3.28084).toStringAsFixed(2)) + 'ft ',
//                      style: kTableTextStyle,
//                    ),
//                    TextSpan(text: 'L', style: kTableTextStyleRed),
//                  ],
//                ),
//              )
//            : RichText(
//                textAlign: TextAlign.right,
//                text: TextSpan(
//                  /*defining default style is optional */
//                  children: <TextSpan>[
//                    TextSpan(
//                      text: ((level * 3.28084).toStringAsFixed(2)) + 'ft ',
//                      style: kTableTextStyle,
//                    ),
//                    TextSpan(text: 'H', style: kTableTextStyleGreen),
//                  ],
//                ),
//              ),
//
////        Text(
////            //  (level > 0.0 ? "+" : "-") +
////            ((level * 3.28084).toStringAsFixed(2)) + 'ft',
////            style: kClockTextSmallStyle),
////        direction == "LOW"
////            ? Text("L", style: kTableTextStyleRed)
////            : Text("H", style: kTableTextStyleGreen),
//      ],
//    );
//  }
//}

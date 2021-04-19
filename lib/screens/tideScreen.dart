import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tidey/components/moonRow.dart';
import 'package:tidey/components/zeClockSync.dart';
import 'package:tidey/const.dart';
import 'package:tidey/screens/moonScreen.dart';
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
        body: Container(
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
                SizedBox(height: 50),
                zeClockSync(),
//                ClockExample(),
                SizedBox(height: 20),
                // MoonRow(moonPhaseImageName: "assets/images/fullMoon.jpg"),
                TimerWidget(),
              ]),
        ));
  }
}

// hello
class buildMyTideTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text("Tides", style: kTableTitleTextStyle),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 65, right: 65),
            child: Table(
//            columnWidths: {
//          0: FractionColumnWidth(.32),
//          1: FractionColumnWidth(.33),
//          2: FractionColumnWidth(.30),
//          //   3: FractionColumnWidth(.05),
//        } ,
                children: [
                  tideTableRow(
                      day: 'Today',
                      time: weatherData
                          .data.weather[0].tides[0].tideData[0].tideTime,
                      level: (double.parse(weatherData
                          .data.weather[0].tides[0].tideData[0].tideHeightMt)),
                      direction: weatherData
                          .data.weather[0].tides[0].tideData[0].tideType),
                  tideTableRow(
                      day: 'Today',
                      time: weatherData
                          .data.weather[0].tides[0].tideData[1].tideTime,
                      level: (double.parse(weatherData
                          .data.weather[0].tides[0].tideData[1].tideHeightMt)),
                      direction: weatherData
                          .data.weather[0].tides[0].tideData[1].tideType),
                  tideTableRow(
                      day: 'Tomorrow',
                      time: weatherData
                          .data.weather[0].tides[0].tideData[2].tideTime,
                      level: (double.parse(weatherData
                          .data.weather[0].tides[0].tideData[2].tideHeightMt)),
                      direction: weatherData
                          .data.weather[0].tides[0].tideData[2].tideType),
                  tideTableRow(
                      day: 'Tomorrow',
                      time: weatherData
                          .data.weather[0].tides[0].tideData[3].tideTime,
                      level: (double.parse(weatherData
                          .data.weather[0].tides[0].tideData[3].tideHeightMt)),
                      direction: weatherData
                          .data.weather[0].tides[0].tideData[3].tideType),
                ]),
            // mySubTile(kMySubTileData),
          ),
        ],
      ),
    );
  }
}

TableRow tideTableRow(
    {String day, String time, double level, String direction}) {
  print("Direction is $day,$time, $level,$direction");
  // static htInFeet = double.parse(level)/3.28084;
  final String pos = level > 2.0 ? "+" : "-";
  return TableRow(
    children: [
      Text(day + counter.toString(), style: kTableTextStyle),
      Text(
        time,
        style: kTableTextStyle,
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
                    style: kTableTextStyle,
                  ),
                  TextSpan(text: 'L', style: kTableTextStyleRed),
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
                    style: kTableTextStyle,
                  ),
                  TextSpan(text: 'H', style: kTableTextStyleGreen),
                ],
              ),
            ),
    ],
  );
}

class Swapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return counter == 0
        ? buildMyTideTable()
        : MoonRow(moonPhaseImageName: "assets/images/fullMoon.jpg");
  }
}

int counter = 0;

class TimerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TimerBuilder.periodic(Duration(seconds: 5), builder: (context) {
      counter == 0 ? counter = 1 : counter = 0;
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

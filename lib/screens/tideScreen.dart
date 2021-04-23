import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:tidey/components/barometer.dart';
import 'package:tidey/components/directionAndSpeedGauge.dart';
import 'package:tidey/components/imageGauge.dart';
import 'package:tidey/components/moonTable.dart';
import 'package:tidey/components/oldZeClock.dart';
import 'package:tidey/components/temp.dart';
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
      //constraints: BoxConstraints.expand(),
      child: MakeContainers(),
    );
  }
}

class MakeContainers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            LandscapeTimerWidget(),
            ClockRow(),
          ],
        ),
        Container(
          color: Colors.transparent,
          width: ScreenSize.safeBlockHorizontal * 100,
          height: ScreenSize.marqueeHeight,
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

class ClockRow extends StatelessWidget {
  // Size ted = (Size(w));
  @override
  Widget build(BuildContext context) {
    // Size ted = Size(width: 30, length:30 );

    return Row(
      children: [
        // guageColumn(gaugeType: CircleContainer()),
        gaugeColumn(),
        clockColumn(clockType: zeClockSync()),
        // gaugeColumn(),
      ],
    );
  }
}

class clockColumn extends StatelessWidget {
  Widget clockType;
  Color containerColor;
  clockColumn({
    this.clockType,
    this.containerColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: (ScreenSize.clockTop)),
        Container(
          color: containerColor,
          width: ScreenSize.clockSize,
          height: ScreenSize.clockSize,
          child: clockType,
        ),
      ],
    );
  }
}

class gaugeColumn extends StatelessWidget {
  Widget gaugeType;
  Color containerColor;
  gaugeColumn({
    this.gaugeType,
    this.containerColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: ScreenSize.gaugeTop),
        Container(
          width: ScreenSize.gaugeSize,
          height: ScreenSize.gaugeSize,
          color: containerColor,
          child: gaugeType,
        ),
        SizedBox(height: ScreenSize.gaugeBottom),
      ],
    );
  }
}

class CircleContainer extends StatelessWidget {
//  final double cwidth;
//  CircleContainer(this.cwidth);
  @override
  Widget build(BuildContext context) {
    Size _topLeft =
        Size(ScreenSize.gauge1TopLeft.dx, ScreenSize.gauge1TopLeft.dy);
    Size _bottomRight =
        Size(ScreenSize.gauge1BottomRight.dx, ScreenSize.gauge1BottomRight.dy);

    // print("Print parent size ${cwidth} ");
    // print("My Size is ${_size.width}");
    return Container(
        color: Colors.grey,
//        width: SizeConfig.safeBlockHorizontal * 30,
//        height: SizeConfig.safeBlockHorizontal * 30,
        // Size _size = MediaQuery.of(context).size;
        child:
            //Text("Hello " + _size.width.toString() + " "));
            DrawShape(
          _topLeft,
          _bottomRight,
          100.0,
        ));
  }
}

class DrawShape extends StatelessWidget {
  Size _topLeft;
  Size _bottomRight;
  double radius;
  DrawShape(this._topLeft, this._bottomRight, this.radius);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
//      painter: PathPainter(),
      painter: CurvePainter(),
    );
  }
}

class CurvePainter extends CustomPainter {
//  Size _topLeft;
//  Size _bottomRight;
//  double radius;
//  CurvePainter(this._topLeft, this._bottomRight, this.radius);

  @override
  void paint(Canvas canvas, Size containerSize) {
    print("contaierSize ${containerSize.height} ${containerSize.width}");
    //  Size _containerSize = this._topLeft;
//    print(
//        "Top Left ${_containerSize.width.toString()} ${_containerSize.height}");
//    print(
//        "Botom Right ${_bottomRight.width.toString()} ${_bottomRight.height}");
//    double _boxHeight = this._bottomRight.height - this._topLeft.height;
//    double _boxWidth = this._bottomRight.width - this._topLeft.width;
//    double _centerX = _topLeft.width + (_boxWidth / 2);
//    double _centerY = _topLeft.height + (_boxHeight / 2);

    var myPaint = Paint();
    myPaint.color = Colors.redAccent;
    myPaint.style = PaintingStyle.fill;
//    var paintLowTide = Paint();
//    paintLowTide.color = Colors.blueAccent;
//    paintLowTide.style = PaintingStyle.fill;
//    canvas.drawCircle(Offset(0.0, 0.0), 20, myPaint);
//    canvas.drawCircle(Offset(153.3, 153.3), 153.3, myPaint);
    canvas.drawCircle(Offset(containerSize.width / 2, containerSize.height / 2),
        containerSize.height / 2, myPaint);

//    canvas.drawCircle(Offset(centerX + radius + 7, centerY), 10, paintHighTide);
//    canvas.drawCircle(Offset(centerX - radius - 3, centerY), 10, paintLowTide);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class DialRow extends StatelessWidget {
  final Widget gaugeType1;
  final Widget gaugeType2;

  DialRow({
    this.gaugeType1,
    this.gaugeType2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        gaugeColumn(gaugeType: gaugeType1, containerColor: Colors.transparent),
        clockColumn(),
        gaugeColumn(gaugeType: gaugeType2, containerColor: Colors.transparent),
      ],
    );

//
//    return Row(
//      children: [
//        Container(
//          color: Colors.red,
//          width: ScreenSize.safeBlockHorizontal * 30,
//          height: ScreenSize.safeBlockHorizontal * 30,
//          child: gaugeType1,
//        ),
//        //  DrawShape(SizeConfig.safeBlockHorizontal * 30),
//        Column(
//          children: [
//            SizedBox(
//              height: (ScreenSize.safeBlockVertical * 100 -
//                      ScreenSize.safeBlockHorizontal * 40) /
//                  2,
//            ),
//            Container(
//              color: Colors.transparent,
//              width: ScreenSize.safeBlockHorizontal * 40,
//              height: ScreenSize.safeBlockHorizontal * 40,
//            ),
//          ],
//        ),
//        Container(
//          color: Colors.red,
//          width: ScreenSize.safeBlockHorizontal * 30,
//          height: ScreenSize.safeBlockHorizontal * 30,
//          child: gaugeType2,
//        ),
//      ],
//    );
  }
}

//  AnimatedCrossFade(
//    crossFadeState: _crossFadeState,
//    duration: const Duration(seconds: 2),
//    firstChild: const Icon(Icons.text_rotate_up, size: 150),
//    secondChild: const Icon(Icons.text_rotate_vertical, size: 150),
//  ),
class LandScapeSwapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    switch (counter) {
      case 0:
        return DialRow(
          gaugeType1: TempGauge(),
          gaugeType2: BarometerGauge(),
        );
        break;
      case 1:
//        return AnimatedCrossFade(
//            crossFadeState: _crossFadeState,
//            firstChild: DialRow(
//              gaugeType1: TempGauge(),
//              gaugeType2: BarometerGauge(),
//            ),
//            secondChild: DialRow(
//                gaugeType1: ImageGauge(
//                    imageName: "gaugeSunrise.png", textLabel: "6:110PM"),
//                gaugeType2: ImageGauge(
//                    imageName: "gaugeSunset.png", textLabel: "8:15PM")),
//            // crossFadeState: crossFadeState,
//            duration: const Duration(seconds: 2));
        return DialRow(
            gaugeType1:
                ImageGauge(imageName: "gaugeSunrise.png", textLabel: "6:110PM"),
            gaugeType2:
                ImageGauge(imageName: "gaugeSunset.png", textLabel: "8:15PM"));
        break;
//      case 1:
//        return DialRow(
//            gaugeType1:
//                ImageGauge(imageName: "gaugeSunset.png", textLabel: "8:15PM"),
//            gaugeType2:
//                ImageGauge(imageName: "gaugeSunset.png", textLabel: "8:15PM"));
//        break;
      case 2:
        return DialRow(
          gaugeType1: ImageGauge(imageName: "gaugeMoon.png", textLabel: ""),
          gaugeType2: ImageGauge(
              imageName: "gaugeStars.png",
              textLabel: "Waxing Crescent\nRise: 12:PM\nSet: 03:00AM",
              textPosition: 40,
              textBackgroundColor: Colors.transparent,
              fontSize: 20),
        );
        break;

      case 3:
        return DialRow(
          gaugeType1: DirectionAndSpeedGauge(),
          gaugeType2: DirectionAndSpeedGauge(
            gaugeType: "Waves",
            gaugeUnit: "ft",
            gaugeDirection: "NW",
            gaugeValue: 3,
            gaugeMax: 10,
            gaugeInterval: 1,
          ),
        );
        break;
      case 4:
        return DialRow(
            gaugeType1: ImageGauge(
              imageName: "gaugeWater.png",
              textLabel: "Water 87 \u2109",
              textColor: Colors.black,
            ),
            gaugeType2: ImageGauge(
              imageName: "gaugeBoatDrone.png",
              textLabel: "",
            ));

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

class LandscapeTimerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TimerBuilder.periodic(Duration(seconds: 5), builder: (context) {
      counter = (counter + 1) % 5;
      // counter == 0 ? counter = 1 : counter = 0;
      return LandScapeSwapper();
    });
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
        color: Colors.white), // Color(0xFFBEC2CB)),
    scrollAxis: Axis.horizontal,
    crossAxisAlignment: CrossAxisAlignment.start,
    blankSpace: 20.0,
    velocity: 100.0,
    pauseAfterRound: Duration(seconds: 1),
    showFadingOnlyWhenScrolling: true,
    fadingEdgeStartFraction: 0.1,
    fadingEdgeEndFraction: 0.1,
    // numberOfRounds: 3,
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
      // constraints: BoxConstraints.expand(),
      child: Column(
//            crossAxisAlignment: CrossAxisAlignment.stretch,
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(height: ScreenSize.safeBlockVertical * 2),
            oldzeClockSync(),
//                ClockExample(),
            SizedBox(height: ScreenSize.safeBlockVertical * 2),
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
      height: ScreenSize.safeBlockVertical * 45,

      child: Container(
        height: ScreenSize.safeBlockVertical * 45,
        width: ScreenSize.safeBlockHorizontal * 80,
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
            fontSize: ScreenSize.safeBlockHorizontal * fontScale,
            color: Colors.white,
          )),
      Text(
        time,
        style: TextStyle(
          fontSize: ScreenSize.safeBlockHorizontal * fontScale,
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
                      fontSize: ScreenSize.safeBlockHorizontal * fontScale,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                      text: 'L',
                      style: TextStyle(
                        fontSize: ScreenSize.safeBlockHorizontal * fontScale,
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
                      fontSize: ScreenSize.safeBlockHorizontal * fontScale,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                      text: 'H',
                      style: TextStyle(
                        fontSize: ScreenSize.safeBlockHorizontal * fontScale,
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

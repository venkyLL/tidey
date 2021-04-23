import 'dart:math';

import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:tidey/const.dart';

List<double> tideHeightArray = [];
calcTideHeightArray() {
  String _firstTide = weatherData.data.weather[0].tides[0].tideData[0].tideType;

  double _highTideFeet = (double.parse(
      weatherData.data.weather[0].tides[0].tideData[0].tideHeightMt));
  double _lowTideFeet = (double.parse(
      weatherData.data.weather[0].tides[0].tideData[0].tideHeightMt));
}

// void main() => runApp(
//       MaterialApp(
//         home: PathExample(),
//       ),
//     );

class TideServicesPainter extends StatelessWidget {
  Size _containerSize;
  TideServicesPainter(this._containerSize);
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
//      painter: PathPainter(),
      painter: CurvePainter(),
    );
  }
}

class CurvePainter extends CustomPainter {
  int numberOfSecondsInTwelveHours = 12 * 60 * 60;
//  Size containerSize;
//  CurvePainter(this.containerSize);
  @override
  void paint(Canvas canvas, Size containerSize) {
//    print("arrived in paint subroutine");
    Size _containerSize = containerSize;
    var paint = Paint();
    paint.color = Colors.white24;
    paint.style = PaintingStyle.fill; // Change this to fill
    num degToRad(num deg) => deg * (3.14159 / 180.0);
    var path = Path();
    //  Offset center = _containerSize.center(Offset(0, 0));
    Offset centerOffSet =
        Offset(containerSize.width / 2, containerSize.height / 2);
    double centerX = centerOffSet.dx;
    double centerY = centerOffSet.dy;
//    double containerW = _containerSize.width;
//    double containerH = _containerSize.height;
    double radius = 181.0;
    double _scaling_factor = 2.5;
    path.moveTo(centerX, centerY - radius);

    for (var i = 0; i <= 360; i++) {
      double t = i / 360 * numberOfSecondsInTwelveHours;
      double radius1 = radius +
          (globalA * sin(globalOmega * t + globalAlpha) + globalC) *
              _scaling_factor;
      path.lineTo(sin(degToRad(i)) * radius1 + centerX,
          centerY - cos(degToRad(i)) * radius1);
    }
    radius -= 10.0;

    path.lineTo(centerX, centerY - radius);

    for (var i = 360; i >= 0; i--) {
      path.lineTo(sin(degToRad(i)) * radius + centerX,
          centerY - cos(degToRad(i)) * radius);
    }
    canvas.drawPath(path, paint);
    paintSlackTides(centerX, centerY, radius, canvas);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

void paintSlackTides(centerX, centerY, radius, canvas) {
  var paintHigh = Paint();
  var paintLow = Paint();
  var pathHigh = Path();
  var pathLow = Path();
  int pointerAngle, i;
  int startAngleLow, startAngleHigh;
  int endAngleLow, endAngleHigh;
  int myAngleHigh, myAngleLow;
  paintHigh.color = Colors.green;
  paintLow.color = Colors.green;

  double radius1;
  num degToRad(num deg) => deg * (3.14159 / 180.0);

  pointerAngle =
      num.parse((globalNextHighTidePointerValue / 12 * 360).toStringAsFixed(0));
  startAngleHigh = pointerAngle - 30;
  endAngleHigh = pointerAngle + 30;

  pointerAngle =
      num.parse((globalNextLowTidePointerValue / 12 * 360).toStringAsFixed(0));
  startAngleLow = pointerAngle - 30;
  endAngleLow = pointerAngle + 30;

  pathHigh.moveTo(sin(degToRad(startAngleHigh)) * radius + centerX,
      centerY - cos(degToRad(startAngleHigh)) * radius);

  pathLow.moveTo(sin(degToRad(startAngleLow)) * radius + centerX,
      centerY - cos(degToRad(startAngleLow)) * radius);

  radius1 = radius;
  //print("se angle is $startAngle, $endAngle");
  for (i = 0; i <= 60; i++) {
    myAngleHigh = startAngleHigh + i;
    myAngleLow = startAngleLow + i;
    //  print("$i, $myAngle");
    pathHigh.lineTo(sin(degToRad(myAngleHigh)) * radius1 + centerX,
        centerY - cos(degToRad(myAngleHigh)) * radius1);
    pathLow.lineTo(sin(degToRad(myAngleLow)) * radius1 + centerX,
        centerY - cos(degToRad(myAngleLow)) * radius1);
  }
  radius1 = radius - 5;
  pathHigh.lineTo(sin(degToRad(myAngleHigh)) * radius1 + centerX,
      centerY - cos(degToRad(myAngleHigh)) * radius1);
  pathLow.lineTo(sin(degToRad(myAngleLow)) * radius1 + centerX,
      centerY - cos(degToRad(myAngleLow)) * radius1);
  for (i = 0; i <= 60; i++) {
    radius1 = radius - 5;
    myAngleHigh = startAngleHigh + 60 - i;
    myAngleLow = startAngleLow + 60 - i;
//    print("$i, $myAngle");
    pathHigh.lineTo(sin(degToRad(myAngleHigh)) * radius1 + centerX,
        centerY - cos(degToRad(myAngleHigh)) * radius1);
    pathLow.lineTo(sin(degToRad(myAngleLow)) * radius1 + centerX,
        centerY - cos(degToRad(myAngleLow)) * radius1);
  }
  pathHigh.lineTo(sin(degToRad(myAngleHigh)) * radius + centerX,
      centerY - cos(degToRad(myAngleHigh)) * radius);
  pathLow.lineTo(sin(degToRad(myAngleLow)) * radius + centerX,
      centerY - cos(degToRad(myAngleLow)) * radius);

  canvas.drawPath(pathHigh, paintHigh);
  canvas.drawPath(pathLow, paintLow);
}

class mySineWaveData {
  // the equation for the sinewave used here is y = a (sin(w.t)) + c
  // notice that the phase is set to zero because w is set to 1/t @ high tide
  double a; // A -> Amplitude
  double w; // angular velocity
  int t; // t is the number of seconds from noon or midnight depending on the 12 hour period we are in.
  double c; // const
  DateTime _highTideTime, _lowTideTime;
  var todayTomorrowTideData = [];

  void computeTidesForPainting() {
    double _lowTideFeet, _highTideFeet;
    var current_tide;
    bool data_failure = true;
    for (int day = 0; day < weatherData.data.weather.length; day++) {
      var parsedDateJSON = weatherData.data.weather[day];
      print("day, parsedDateJSON, $day, $parsedDateJSON");
      if (((weatherData.data.weather[day].date).isToday) ||
          ((weatherData.data.weather[day].date).isTomorrow)) {
        data_failure = false;
        DateTime _x = weatherData.data.weather[day].date;
        print("day inside, parsedDateJSON, $_x, $parsedDateJSON, ");
        for (int j = 0;
            j < weatherData.data.weather[day].tides[0].tideData.length;
            j++) {
          todayTomorrowTideData
              .add(weatherData.data.weather[day].tides[0].tideData[j].toJson());
          var _y = weatherData.data.weather[day].tides[0].tideData[j].toJson();
          print("adding this to array $_y");
        }
      }
    }

    if (data_failure) {
      globalNextHighTideHeightInFeet = 99999.0;
      globalNextLowTideHeightInFeet = 99999.0;
      return;
    }

    print('my tide data');
    // find exactly 2 tides
    // first find the high tide;
    for (var i = 0; i < todayTomorrowTideData.length; i++) {
      current_tide = todayTomorrowTideData[i];
      print("Current tide: $current_tide");
      if ((DateTime.parse(current_tide["tideDateTime"]))
          .addHours(2)
          .isSameOrAfter(DateTime.now())) {
        if (current_tide["tide_type"] == "HIGH") {
          _highTideFeet =
              double.parse(current_tide["tideHeight_mt"]) * metersToFeet;
          _highTideTime = DateTime.parse(current_tide["tideDateTime"]);
          break;
        }
      }
    }
    print("hightides: $_highTideTime,$_highTideFeet");
    for (var i = 0; i < todayTomorrowTideData.length; i++) {
      current_tide = todayTomorrowTideData[i];
      if (DateTime.parse(current_tide["tideDateTime"])
          .addHours(2)
          .isSameOrAfter(DateTime.now())) {
        if (current_tide["tide_type"] == "LOW") {
          _lowTideFeet =
              double.parse(current_tide["tideHeight_mt"]) * metersToFeet;
          _lowTideTime = DateTime.parse(current_tide["tideDateTime"]);
          break;
        }
      }
    }
    print("lowtides: $_lowTideTime,$_lowTideFeet");

    globalNextHighTidePointerValue = getPointerPosition(_highTideTime);
    globalNextLowTidePointerValue = getPointerPosition(_lowTideTime);
    globalNextHighTideHeightInFeet = _highTideFeet;
    globalNextLowTideHeightInFeet = _lowTideFeet;

    double c = _lowTideFeet;
    double a = _highTideFeet - _lowTideFeet;
    DateTime firstDate = _highTideTime;
    DateTime secondDate = _lowTideTime;
    int period = (secondDate.difference(firstDate).inSeconds)
        .abs(); // return absolute value of the period.
    globalA = a;
    globalC = c;
    globalOmega =
        pi / period; // since we are only going from high to low for period
    globalAlpha =
        (pi / 2 - getSecondsFromDateTime(_highTideTime) * globalOmega);

    print("A,w,alpha, c, $a, $globalOmega, $globalAlpha, $c");
  }

  double getDegreesFromDateTime(DateTime myTime) {
    return getRadiansFromDateTime(myTime) * 360 / (2 * pi);
  }

  int getSecondsFromDateTime(DateTime myTime) {
    int computedSeconds = 0;
    int myHour = myTime.hour >= 12
        ? myTime.hour - 12
        : myTime
            .hour; // my Hour needs to be between 0 and 11 for the fraction to work correctly.
    int myMinute = myTime.minute;
    int mySecond = myTime.second;
    computedSeconds = myHour * 60 * 60 + myMinute * 60 + mySecond;
    return computedSeconds;
  }

  double getPointerPosition(DateTime myTime) {
    double myFraction = getSecondsFromDateTime(myTime) / (12 * 60 * 60);
    double myPointerPosition = 12 * myFraction;
    return myPointerPosition;
  }

  double getRadiansFromDateTime(DateTime myTime) {
    double myRadians = 0.0;
    int myHour = myTime.hour >= 12
        ? myTime.hour - 12
        : myTime
            .hour; // my Hour needs to be between 0 and 11 for the fraction to work correctly.
    int myMinute = myTime.minute;
    int mySecond = myTime.second;
    double fractionalTime =
        (myHour * 60.0 * 60.0 + myMinute * 60.0 + mySecond) /
            (12.0 * 60.0 * 60.0);
    myRadians = fractionalTime * 2 * pi;
//    print("myRadians is $myRadians, $fractionalTime");
    return myRadians;
  }
}

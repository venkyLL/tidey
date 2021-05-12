import 'dart:math';

import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:tidey/components/drawTools.dart';
import 'package:tidey/const.dart';

List<double> tideHeightArray = [];
calcTideHeightArray() {
  String _firstTide = weatherData.data.weather[0].tides[0].tideData[0].tideType;

  double _highTideFeet = (double.parse(
      weatherData.data.weather[0].tides[0].tideData[0].tideHeightMt));
  double _lowTideFeet = (double.parse(
      weatherData.data.weather[0].tides[0].tideData[0].tideHeightMt));
}

class DirectionAndSpeedPainter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: GaugePainter(),
    );
  }
}

class GaugePainter extends CustomPainter {
  int numberOfSecondsInTwelveHours = 12 * 60 * 60;
  double _deviceScalingFactor =
      ScreenSize.clockSize / 564.0; // based on 14 inch ipad
  double _sineWaveScalingFactor = 20.0 / (globalA * 2.0);
  DrawingTools myDraw = DrawingTools();

  @override
  void paint(Canvas canvas, Size containerSize) {
    Offset _topLeft = ScreenSize.clockTopLeft;
    Offset _bottomRight = ScreenSize.clockBottomRight;

    var paintClockFace = Paint();
    paintClockFace.color = Colors.transparent;
    paintClockFace.style = PaintingStyle.fill; // Change this to fill

    var path = Path();
    double centerX = ScreenSize.clockSize / 2;
    double centerY = ScreenSize.clockSize / 2;
    myDraw.drawFilledCircle(
        centerX, centerY, ScreenSize.clockSize / 2, paintClockFace, canvas);

    var gaugeBezel = Paint();
    gaugeBezel.color = Color(0xFF999999);
    myDraw.drawRing(
        centerX, centerY, ScreenSize.clockSize / 2, 5.0, gaugeBezel, canvas);

    myDraw.drawRing(
        centerX, centerY, ScreenSize.clockSize / 4, 2.0, gaugeBezel, canvas);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class TideServicesPainter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CurvePainter(),
    );
  }
}

class CurvePainter extends CustomPainter {
  int numberOfSecondsInTwelveHours = 12 * 60 * 60;

  double _deviceScalingFactor =
      ScreenSize.clockSize / 564.0; // based on 14 inch ipad
  double _sineWaveScalingFactor = 20.0 / (globalA * 2.0);
  DrawingTools myDraw = DrawingTools();

  @override
  void paint(Canvas canvas, Size containerSize) {
    double _failedTideyRingThickness = 20;
    double _minThicknessSineWave = 5;
    double _sineWaveScaleDownFactor = 0.75;
    double _clockBezelRadius = ScreenSize.clockSize / 2;
    double _clockBezelThickness = 2;
    double _tidePaddingInner = 6;
    double _tidePaddingOuter = 6;
    double _highTideRadius =
        _clockBezelRadius - _clockBezelThickness - _tidePaddingOuter;
    double _clockRimThickness = 2;
    double _clockRimRadius = _clockBezelRadius * 0.8;
    double _lowTideRadius = _clockRimRadius + _tidePaddingInner;
    double centerX = ScreenSize.clockSize / 2;
    double centerY = ScreenSize.clockSize / 2;
    double _slackTideThickness = 10;
    double _slackTideRadius = _clockRimRadius - _clockRimThickness;
    double _clockFaceRadius = _clockRimRadius;

    var paintClockBezel = Paint();
    paintClockBezel.color = Color(0xFF999999);
    paintClockBezel.style = PaintingStyle.fill;

    var paintClockFace = Paint();
    paintClockFace.color = Colors.black;
    paintClockFace.style = PaintingStyle.fill;

    var paintClockRim = Paint();
    paintClockRim.color = Colors.white;
    paintClockFace.style = PaintingStyle.fill;

    var paint = Paint();
    paint.color = Colors.white24;
    paint.style = PaintingStyle.fill;

    num degToRad(num deg) => deg * (3.14159 / 180.0);
    var path = Path();

    myDraw.drawFilledCircle(
        centerX, centerY, _clockBezelRadius, paintClockFace, canvas);
    double radius = _lowTideRadius;
    path.moveTo(centerX, centerY - radius);
    if (globalWeather.tideAPIError) {
      double _ringWidth = (_highTideRadius - _lowTideRadius) / 3.0;
      myDraw.drawRing(centerX, centerY, _lowTideRadius + 2 * _ringWidth,
          _ringWidth, paint, canvas);
    } else {
      // we have tide data - draw tide.

      TideSineDrawingParams myTSDP = TideSineDrawingParams();
      myTSDP.computeTideSineDrawingParams();
      double _w = myTSDP.drawOmega;
      double _sineWaveScaler =
          (_highTideRadius - _lowTideRadius) / 2 * _sineWaveScaleDownFactor;
      if (globalDebugPrint)
        print("globalHigh, low: $_highTideRadius ,$_lowTideRadius");

      for (var i = 0; i <= 350; i++) {
        double radius1 = radius +
            _minThicknessSineWave +
            (sin(_w * i + myTSDP.drawAlpha) + 1) * _sineWaveScaler;
        // if (globalDebugPrint)
        //   print("sinewave calcs, ${i.toInt()}, ${(radius1 - radius)}");
        path.lineTo(sin(degToRad(i)) * radius1 + centerX,
            centerY - cos(degToRad(i)) * radius1);
      }
      globalDebugPrint = false;
      radius = _lowTideRadius;
//      path.lineTo(centerX, centerY - radius);
      for (var i = 350; i >= 0; i--) {
        path.lineTo(sin(degToRad(i)) * radius + centerX,
            centerY - cos(degToRad(i)) * radius);
        // if (globalDebugPrint) print("Inner circle in realSineTidey, $i, $radius");
      }
      canvas.drawPath(path, paint);
    }

    myDraw.drawRing(centerX, centerY, _clockFaceRadius, _clockRimThickness,
        paintClockRim, canvas);

    myDraw.drawRing(centerX, centerY, (ScreenSize.clockSize / 2),
        _clockBezelThickness, paintClockBezel, canvas);

    if (!globalWeather.tideAPIError)
      paintSlackTides(
          centerX, centerY, _slackTideRadius, _slackTideThickness, canvas);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

void paintSlackTides(centerX, centerY, radius, _slackTideThickness, canvas) {
  var paintHigh = Paint();
  var paintLow = Paint();
  var pathHigh = Path();
  var pathLow = Path();
  int pointerAngle, i;
  int startAngleLow, startAngleHigh;
  int endAngleLow, endAngleHigh;
  int myAngleHigh, myAngleLow;
  paintHigh.color = const Color(0xFF3366CC);
  paintLow.color = const Color(0xFF3366CC);

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

  radius1 = radius - _slackTideThickness;
  for (i = 0; i <= 60; i++) {
    myAngleHigh = startAngleHigh + i;
    myAngleLow = startAngleLow + i;
    //  print("$i, $myAngle");
    pathHigh.lineTo(sin(degToRad(myAngleHigh)) * radius1 + centerX,
        centerY - cos(degToRad(myAngleHigh)) * radius1);
    pathLow.lineTo(sin(degToRad(myAngleLow)) * radius1 + centerX,
        centerY - cos(degToRad(myAngleLow)) * radius1);
  }
  radius1 = radius + 5;
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

  if (globalNextHighTideTimeStamp // don't paint slack tides that are more than 12 hours in the future.
      .subtract(Duration(hours: 12))
      .isBefore(DateTime.now())) {
    canvas.drawPath(pathHigh, paintHigh);
  }
  if (globalNextLowTideTimeStamp
      .subtract(Duration(hours: 12))
      .isBefore(DateTime.now())) {
    canvas.drawPath(pathLow, paintLow);
  }
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
    for (var i = 0; i < todayTomorrowTideData.length; i++) {
      current_tide = todayTomorrowTideData[i];
      print("Current tide: $current_tide");
      if ((DateTime.parse(current_tide["tideDateTime"]))
          .addMinutes(30)
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
          .addMinutes(30)
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
    globalNextHighTideTimeStamp = _highTideTime;
    globalNextLowTideTimeStamp = _lowTideTime;
    globalNextHighTidePointerValue = getPointerPosition(_highTideTime);
    globalNextLowTidePointerValue = getPointerPosition(_lowTideTime);
    globalNextHighTideHeightInFeet = _highTideFeet;
    globalNextLowTideHeightInFeet = _lowTideFeet;

    double c = (_lowTideFeet + _highTideFeet) / 2;
    double a = _highTideFeet - c;
    double _smallNumber =
        ((_lowTideFeet - _highTideFeet) / _highTideFeet).abs();
    if (_smallNumber < 0.1) a = 1.0;

    DateTime firstDate = _highTideTime;
    DateTime secondDate = _lowTideTime;
    int period = (secondDate.difference(firstDate).inSeconds)
        .abs(); // return absolute value of the period.
    globalA = a;
    globalC = c;
    globalOmega =
        pi / period; // since we are only going from high to low for period

    if (firstDate.isBefore(secondDate)) {
      globalAlpha =
          (pi / 2 - getSecondsFromDateTime(_highTideTime) * globalOmega);
    } else {
      globalAlpha =
          (3 * pi / 2 - getSecondsFromDateTime(_lowTideTime) * globalOmega);
    }

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
    return myRadians;
  }

  void checkWhetherToShowPointers() {
    if (globalWeather.tideAPIError) {
      globalShowHighTidePointer = false;
      globalShowLowTidePointer = false;
      return;
    }
    if (globalNextHighTideTimeStamp
        .subtract(Duration(hours: 12))
        .isBefore(DateTime.now())) {
      globalShowHighTidePointer = true;
    } else {
      globalShowHighTidePointer = false;
    }
    if (globalNextLowTideTimeStamp
        .subtract(Duration(hours: 12))
        .isBefore(DateTime.now())) {
      globalShowLowTidePointer = true;
    } else {
      globalShowLowTidePointer = false;
    }
  }
}

class TideSineDrawingParams {
  double drawStartDegrees;
  double drawOmega;
  double drawAlpha;
  bool nextTideHigh = false;
  bool nextTideLow = false;
  bool drawStartClock = false;
  int deltaT = 0;
  void computeTideSineDrawingParams() {
    DateTime _firstTide, _secondTide, _referenceTide;
    if (globalNextHighTideTimeStamp.isAfter(globalNextLowTideTimeStamp)) {
      _firstTide = globalNextLowTideTimeStamp;
      _secondTide = globalNextHighTideTimeStamp;
      nextTideLow = true;
    } else {
      _secondTide = globalNextLowTideTimeStamp;
      _firstTide = globalNextHighTideTimeStamp;
      nextTideHigh = true;
    }
    _referenceTide = _secondTide;

    _referenceTide = DateTime.now().subtract(Duration(minutes: 10));
    drawStartDegrees = mySineWaveData().getDegreesFromDateTime(_referenceTide);
    drawOmega = globalOmega * 12 * 60 * 60 / 360;
    if (nextTideHigh) {
      deltaT = globalNextHighTideTimeStamp.hour * 60 * 60 +
          globalNextHighTideTimeStamp.minute * 60 +
          globalNextHighTideTimeStamp.second;
      if (deltaT > 12 * 60 * 60) deltaT -= 12 * 60 * 60;
      drawAlpha = 3.14159 / 2 - (deltaT / (12 * 60 * 60) * 360) * drawOmega;
    } else {
      deltaT = globalNextLowTideTimeStamp.hour * 60 * 60 +
          globalNextLowTideTimeStamp.minute * 60 +
          globalNextLowTideTimeStamp.second;
      if (deltaT > 12 * 60 * 60) deltaT -= 12 * 60 * 60;
      drawAlpha = 3 * 3.14159 / 2 - (deltaT / (12 * 60 * 60) * 360) * drawOmega;
    }
    if (globalDebugPrint)
      print(
          "globalNextHighTideTimeStamp, $globalNextHighTideTimeStamp, $drawAlpha");
  }
}

// Dart imports
import 'dart:async';

import 'package:dart_date/dart_date.dart';

/// Flutter package imports
import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tidey/components/alarmSounder.dart';
import 'package:tidey/components/hourlyBell.dart';
import 'package:tidey/const.dart';
import 'package:tidey/services/tideServices.dart';

import '../services/tideServices.dart';

/// Local imports
//import 'sample_view.dart';

/// Renders the gauge clock sample.
class zeClockSync extends StatefulWidget {
  /// Creates the gauge clock sample.
//  const ClockExample(Key key) : super(key: key);

  @override
  _zeClockSyncState createState() => _zeClockSyncState();
}

class _zeClockSyncState extends State<zeClockSync> {
  _zeClockSyncState();
//  late Timer timer;
  DateTime alarmLastRungAt;
  int countDownTimerSecondsRemaining = 0;
  int localCountDownTimer = 0;
  Timer timer;
  Timer timer2;
  Timer timer3;
  HourlyBellRinger myHourlyBell = HourlyBellRinger();
  // Timer compassTimer;

  @override
  void initState() {
    super.initState();
    myHourlyBell.init();
    alarmLastRungAt = DateTime.now().subtract(Duration(minutes: 1));
    // update the needle pointer in 1 second interval
    timer = Timer.periodic(const Duration(milliseconds: 1000), _updateData);
    timer2 =
        Timer.periodic(const Duration(minutes: 30), _kickOffTideComputation);
//    timer3 = Timer.periodic(const Duration(minutes: 1), _kickOffClockTesting);
    // compassTimer = Timer.periodic(const Duration(milliseconds: 1000), _kickOffCompass);
  }

  void _updateData(Timer timer) {
    mySineWaveData msw = mySineWaveData();
    msw.checkWhetherToShowPointers(); // hide out of range tide pointers.

    //  print("global compass direction is $globalCompassDirection");
    if (userSettings.chimeOn) myHourlyBell.ringTheBellIfItIsTime();
    setState(() {
      _value = DateTime.now();
      if (globalCompassDirection != null) {
        if (MediaQuery.of(context).orientation == Orientation.portrait) {
          _curDir = globalCompassDirection;
        } else {
          _curDir = globalCompassDirection + 90;
        }
      } else {
        _curDir = 270;
      }
    });
    if (userSettings.alarmOn) {
      if ((TimeOfDay.now().hour ==
              userSettings.alarmTime
                  .hour) && // could use just DateTime Comparison but it depends on the seconds when the alarm was set leading to confusion
          (TimeOfDay.now().minute == userSettings.alarmTime.minute) &&
          (DateTime.now().differenceInMinutes(alarmLastRungAt) > 1)) {
        alarmLastRungAt = DateTime.now();
        AlarmSounder().soundAlarm();
      }
    }
    if ((userSettings.countDownTimer != 0) && (userSettings.countDownStart)) {
      if (localCountDownTimer != userSettings.countDownTimer) {
        localCountDownTimer = userSettings.countDownTimer;
        countDownTimerSecondsRemaining = localCountDownTimer * 60;
      }
      print(
          "timer values ${userSettings.countDownTimer},$countDownTimerSecondsRemaining");
      if (countDownTimerSecondsRemaining > 0) countDownTimerSecondsRemaining--;
      userSettings.countDownTimerRemaining =
          (countDownTimerSecondsRemaining / 60.0).ceil();
      userSettings.countDownTimerSecondsRemaining =
          countDownTimerSecondsRemaining;
      if (countDownTimerSecondsRemaining == 0) {
        userSettings.countDownStart = false;
        userSettings.countDownTimer = 0;
        AlarmSounder().soundTimerAlarm();
        localCountDownTimer = 0;
      }
    }
  }

  void _kickOffTideComputation(Timer timer) {
    mySineWaveData msw = mySineWaveData();
    if (!globalWeather.tideAPIError) msw.computeTidesForPainting();
  }

  // void _kickOffClockTesting(Timer timer) {
  //   myHourlyBell.ringTheBellIfItIsTime();
  // }

  // void _kickOffCompass(Timer timer) {
  //   print("Compass reading in zeSyncClock ${globalCompassDirection}");
  // }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
//    final Size _size = MediaQuery.of(context).size;
//    final double _containerSize = math.min(_size.width, _size.height);
    return Center(
      child: Container(
          child: Stack(
              //alignment:new Alignment(x, y)
              children: <Widget>[
//            CurvePainter(),
            TideServicesPainter(),
//            GenericTideCurveWidget(),
            _buildMyClock(),
          ])),
    );
  }

  /// Returns the gauge clock
  SfRadialGauge _buildMyClock() {
    return SfRadialGauge(axes: <RadialAxis>[
      RadialAxis(
          startAngle: 270,
          endAngle: 270,
          minimum: 0,
          maximum: 12,
          showFirstLabel: false,
          interval: 1,
          radiusFactor: 0.8,
          //  labelsPosition: ElementsPosition.outside,
          labelOffset: 0.1,
          offsetUnit: GaugeSizeUnit.factor,
          minorTicksPerInterval: 4,
          tickOffset: 0.03,
          minorTickStyle: MinorTickStyle(
              length: 0.06, lengthUnit: GaugeSizeUnit.factor, thickness: 1),
          majorTickStyle: MajorTickStyle(
              length: 0.1, lengthUnit: GaugeSizeUnit.factor, thickness: 1.5),
          axisLabelStyle: GaugeTextStyle(fontSize: 10, color: Colors.white),
          axisLineStyle: AxisLineStyle(
              thickness: 0.025,
              thicknessUnit: GaugeSizeUnit.factor,
              color: Colors.black38),
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
                angle: 270,
                positionFactor: 0.4,
                widget: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      //    borderRadius: BorderRadius.circular(5.0),
                      color: Colors.transparent,
                      border: Border.all(
                        color: Colors.white60,
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(getDirectionLabel(_curDir.toInt()),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenSize.small ? 18 : 25,
                            color: Colors.red, // kBezelColor

                            //  const Color(0xFF3366CC),
                          )),
                    ))),
            GaugeAnnotation(
                angle: 90,
                positionFactor: 0.6,
                widget: Container(
                  child: userSettings.countDownStart
                      ? Text(
                          ((countDownTimerSecondsRemaining / 60.0).ceil() - 1)
                                  .toString() +
                              ":" +
                              (((countDownTimerSecondsRemaining -
                                              ((countDownTimerSecondsRemaining /
                                                          60.0)
                                                      .ceil() *
                                                  60)) +
                                          60) -
                                      1)
                                  .toString()
                                  .padLeft(2, "0"),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenSize.small ? 15 : 20,
                            color: const Color(0xFF3366CC),
                          ))
                      : null,
                ))
          ],
          pointers: <GaugePointer>[
            MarkerPointer(
              markerHeight: globalShowLowTidePointer ? 20 : 0,
              markerWidth: globalShowLowTidePointer ? 20 : 0,
              markerType: MarkerType.triangle,
              markerOffset: 20,
              value: globalNextLowTidePointerValue,
              enableAnimation: true,
              animationType: AnimationType.linear,
              color: Colors.red,
            ),
            MarkerPointer(
              markerHeight: 20,
              markerWidth: 20,
              markerType: MarkerType.text,
              markerOffset: ScreenSize.clockPointerTextOffset,
              value: globalNextLowTidePointerValue,
              enableAnimation: true,
              animationType: AnimationType.linear,
              text: globalShowLowTidePointer
                  ? globalNextLowTideHeightInFeet > 1000
                      ? "DataFailure"
                      : (globalNextLowTideHeightInFeet > 0
                          ? "+" +
                              globalNextLowTideHeightInFeet.toStringAsFixed(1) +
                              " ft"
                          : globalNextLowTideHeightInFeet.toStringAsFixed(1) +
                              " ft")
                  : "",
              textStyle: GaugeTextStyle(
                  fontSize: ScreenSize.small ? 15 : 20,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Colors.red),
            ),
//                  color: Colors.red),
            MarkerPointer(
              markerHeight: 20,
              markerWidth: 20,
              markerType: MarkerType.text,
              markerOffset: ScreenSize.clockPointerTextOffset,
              value: globalNextHighTidePointerValue,
              enableAnimation: true,
              animationType: AnimationType.linear,
              text: globalShowHighTidePointer
                  ? globalNextHighTideHeightInFeet > 1000
                      ? "DataFailure"
                      : (globalNextHighTideHeightInFeet > 0
                          ? "+" +
                              globalNextHighTideHeightInFeet
                                  .toStringAsFixed(1) +
                              " ft"
                          : globalNextHighTideHeightInFeet.toStringAsFixed(1) +
                              " ft")
                  : "",
              textStyle: GaugeTextStyle(
                  fontSize: ScreenSize.small ? 15 : 20,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Colors.green),
            ),
//                  color: Colors.red),

            MarkerPointer(
              markerHeight: globalShowHighTidePointer ? 20 : 0,
              markerWidth: globalShowHighTidePointer ? 20 : 0,
              markerType: MarkerType.triangle,
              markerOffset: 20,
              value: globalNextHighTidePointerValue,
              enableAnimation: true,
              animationType: AnimationType.linear,
              color: Colors.green,
            ),

            NeedlePointer(
                needleLength: 0.6,
                lengthUnit: GaugeSizeUnit.factor,
                needleStartWidth: 1,
                needleEndWidth: 2,
                value: _value.hour >= 12
                    ? _value.hour - 12.0 + _value.minute / 60.0
//                      : _value.hour == 0 && _value.minute == 0
//                          ? 12.0
                    : _value.hour + _value.minute / 60.0,
                needleColor: _needleColor,
                knobStyle: KnobStyle(knobRadius: 0)),
            NeedlePointer(
                needleLength: 0.85,
                lengthUnit: GaugeSizeUnit.factor,
                needleStartWidth: 0.5,
                needleEndWidth: 1.5,
                value:
                    _value.minute / 60.0 * 12.0 + (_value.second / 60.0 * 0.2),
                knobStyle: KnobStyle(
                    color: const Color(0xFF00A8B5),
                    sizeUnit: GaugeSizeUnit.factor,
                    knobRadius: 0.05),
                needleColor: _needleColor),
            NeedlePointer(
                needleLength: 0.9,
                lengthUnit: GaugeSizeUnit.factor,
                enableAnimation: true,
                animationType: AnimationType.bounceOut,
                needleStartWidth: 0.8,
                needleEndWidth: 0.8,
                value: _value.second == 0 ? 12 : _value.second / 60.0 * 12.0,
                needleColor: const Color(0xFF00A8B5),
                tailStyle: TailStyle(
                    width: 0.8,
                    length: 0.2,
                    lengthUnit: GaugeSizeUnit.factor,
                    color: const Color(0xFF00A8B5)),
                knobStyle: KnobStyle(
                    knobRadius: 0.03,
                    sizeUnit: GaugeSizeUnit.factor,
                    color: Colors.white)),
          ]),
    ]);
  }

//  double _value = 0;
  DateTime _value = DateTime.now();
  double _curDir = 270;
  final Color _needleColor = const Color(0xFFFFFFFF);

  void _handleLabelCreated(AxisLabelCreatedArgs args) {
    int oldLabel = int.parse(args.text);

    double units = (80 / 360) * _curDir;

    double answer = ((oldLabel / 360) * 80);
    double argsNew = (answer + units) % 80;
    // double argsNew = oldLabel + units % 80;

    // argsNew = curDir + oldLabel % 360;

    if (argsNew == 80 || argsNew == 0) {
      args.text = 'N';
    } else if (argsNew == 10) {
      args.text = ScreenSize.small ? '' : 'NE';
    } else if (argsNew == 20) {
      args.text = 'E';
    } else if (argsNew == 30) {
      args.text = ScreenSize.small ? '' : 'SE';
    } else if (argsNew == 40) {
      args.text = 'S';
    } else if (argsNew == 50) {
      args.text = ScreenSize.small ? '' : 'SW';
    } else if (argsNew == 60) {
      args.text = 'W';
    } else if (argsNew == 70) {
      args.text = ScreenSize.small ? '' : 'NW';
    } else
      args.text = '';

    /*
   if (args.text == '80' || args.text == '0') {
    args.text = 'N';
  } else if (args.text == '10') {
    args.text = ScreenSize.small ? '' : 'NE';
  } else if (args.text == '20') {
    args.text = 'E';
  } else if (args.text == '30') {
    args.text = ScreenSize.small ? '' : 'SE';
  } else if (args.text == '40') {
    args.text = 'S';
  } else if (args.text == '50') {
    args.text = ScreenSize.small ? '' : 'SW';
  } else if (args.text == '60') {
    args.text = 'W';
  } else if (args.text == '70') {
    args.text = ScreenSize.small ? '' : 'NW';
  } else args.text = '';
   */
  }

  String getDirectionLabel(int direction) {
    final dirMap = {
      0: "N",
      1: "NE",
      2: "E",
      3: "SE",
      4: "S",
      5: "SW",
      6: "W",
      7: "NW",
      8: "N"
    };

    int index = (direction / 45).round();

    return dirMap[index];
  }
}

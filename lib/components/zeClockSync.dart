// Dart imports
import 'dart:async';
import 'dart:math' as math;
import 'package:tidey/services/compass.dart';
import 'package:tidey/components/hourlyBell.dart';

/// Flutter package imports
import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';
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
  Timer timer;
  Timer timer2;
  HourlyBellRinger bellRinger = HourlyBellRinger();
  // Timer compassTimer;

  @override
  void initState() {
    super.initState();
    bellRinger.init();
    // update the needle pointer in 1 second interval
    timer = Timer.periodic(const Duration(milliseconds: 1000), _updateData);
    timer2 =
        Timer.periodic(const Duration(minutes: 30), _kickOffTideComputation);
    // compassTimer = Timer.periodic(const Duration(milliseconds: 1000), _kickOffCompass);
  }

  void _updateData(Timer timer) {
    setState(() {
      _value = DateTime.now();
    });
    print("Compass reading in zeSyncClock ${globalCompassDirection}");
    bellRinger.ringTheBellIfItIsTime();
  }

  void _kickOffTideComputation(Timer timer) {
    mySineWaveData msw = mySineWaveData();
    msw.computeTidesForPainting();
  }

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
            _buildMyClock(),
          ])),
    );
  }

  /// Returns the gauge clock
  SfRadialGauge _buildMyClock() {
    return SfRadialGauge(
      axes: <RadialAxis>[
        /// Renders inner axis and positioned it using CenterX and
        /// CenterY properties and reduce the radius using radiusFactor
        RadialAxis(
//            backgroundImage: const AssetImage('assets/images/blackCircle.png'),
            startAngle: 270,
            endAngle: 270,
            minimum: 0,
            maximum: 12,
            showFirstLabel: false,
            interval: 1,
            radiusFactor: 0.8,
            labelOffset: 0.1,
            offsetUnit: GaugeSizeUnit.factor,
            minorTicksPerInterval: 4,
            tickOffset: 0.03,
            minorTickStyle: MinorTickStyle(
                length: 0.06, lengthUnit: GaugeSizeUnit.factor, thickness: 1),
            majorTickStyle: MajorTickStyle(
                length: 0.1, lengthUnit: GaugeSizeUnit.factor, thickness: 1.5),
            axisLabelStyle: GaugeTextStyle(fontSize: 12, color: Colors.white),
            axisLineStyle: AxisLineStyle(
                thickness: 0.025,
                thicknessUnit: GaugeSizeUnit.factor,
                color: Colors.black38),
            pointers: <GaugePointer>[
              MarkerPointer(
                markerHeight: 20,
                markerWidth: 20,
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
                markerOffset: -30,
                value: globalNextLowTidePointerValue,
                enableAnimation: true,
                animationType: AnimationType.linear,
                text: globalNextLowTideHeightInFeet > 1000
                    ? "DataFailure"
                    : (globalNextLowTideHeightInFeet > 0
                        ? "+" +
                            globalNextLowTideHeightInFeet.toStringAsFixed(1) +
                            " ft"
                        : globalNextLowTideHeightInFeet.toStringAsFixed(1) +
                            " ft"),
                textStyle: GaugeTextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.red),
              ),
//                  color: Colors.red),
              MarkerPointer(
                markerHeight: 20,
                markerWidth: 20,
                markerType: MarkerType.text,
                markerOffset: -40,
                value: globalNextHighTidePointerValue,
                enableAnimation: true,
                animationType: AnimationType.linear,
                text: globalNextHighTideHeightInFeet > 1000
                    ? "DataFailure"
                    : (globalNextHighTideHeightInFeet > 0
                        ? "+" +
                            globalNextHighTideHeightInFeet.toStringAsFixed(1) +
                            " ft"
                        : globalNextHighTideHeightInFeet.toStringAsFixed(1) +
                            " ft"),
                textStyle: GaugeTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.green),
              ),
//                  color: Colors.red),

              MarkerPointer(
                markerHeight: 20,
                markerWidth: 20,
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
                  value: _value.minute / 60.0 * 12.0 +
                      (_value.second / 60.0 * 0.2),
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
      ],
    );
  }

//  double _value = 0;
  DateTime _value = DateTime.now();
  final Color _needleColor = const Color(0xFFFFFFFF);
}

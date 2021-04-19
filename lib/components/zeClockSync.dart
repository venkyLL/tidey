// Dart imports
import 'dart:async';
import 'dart:math' as math;

/// Flutter package imports
import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

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

  @override
  void initState() {
    super.initState();
    // update the needle pointer in 1 second interval
    timer = Timer.periodic(const Duration(milliseconds: 1000), _updateData);
  }

  void _updateData(Timer timer) {
    DateTime _previous_value = _value;
    setState(() {
      _value = DateTime.now();
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final double _containerSize = math.min(_size.width, _size.height);
    return Center(
      child: Container(
        height: _containerSize,
        width: _containerSize,
        child: _buildClockExample(),
      ),
    );
  }

  /// Returns the gauge clock
  SfRadialGauge _buildClockExample() {
    return SfRadialGauge(
      axes: <RadialAxis>[
        /// Renders inner axis and positioned it using CenterX and
        /// CenterY properties and reduce the radius using radiusFactor
        RadialAxis(
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
                thickness: 0.1,
                thicknessUnit: GaugeSizeUnit.factor,
                color: Colors.white24),
            pointers: <GaugePointer>[
              NeedlePointer(
                  needleLength: 0.6,
                  lengthUnit: GaugeSizeUnit.factor,
                  needleStartWidth: 1,
                  needleEndWidth: 2,
                  value: _value.hour > 12
                      ? _value.hour / 24.0 * 12.0 + _value.minute / 60.0
                      : _value.hour == 0 && _value.minute == 0
                          ? 12.0
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

// RadialAxis(
// startAngle: 270,
// endAngle: 270,
// radiusFactor: 0.2,
// axisLabelStyle: GaugeTextStyle(fontSize: 6),
// minimum: 0,
// maximum: 12,
// showFirstLabel: false,
// offsetUnit: GaugeSizeUnit.factor,
// interval: 2,
// centerY: 0.66,
// tickOffset: 0.03,
// minorTicksPerInterval: 5,
// labelOffset: 0.2,
// minorTickStyle: MinorTickStyle(
// length: 0.09, lengthUnit: GaugeSizeUnit.factor, thickness: 0.5),
// majorTickStyle: MajorTickStyle(
// length: 0.15, lengthUnit: GaugeSizeUnit.factor, thickness: 1),
// axisLineStyle: AxisLineStyle(
// thickness: 0.03, thicknessUnit: GaugeSizeUnit.factor),
// pointers: <GaugePointer>[
// NeedlePointer(
// value: 5,
// needleLength: 0.7,
// lengthUnit: GaugeSizeUnit.factor,
// needleColor: const Color(0xFF00A8B5),
// needleStartWidth: 0.5,
// needleEndWidth: 1,
// knobStyle: KnobStyle(
// knobRadius: 0,
// ),
// )
// ]),
//
// /// Renders inner axis and positioned it using CenterX and
// /// CenterY properties and reduce the radius using radiusFactor
// RadialAxis(
// startAngle: 270,
// endAngle: 270,
// axisLabelStyle: GaugeTextStyle(
// fontSize: 6,
// ),
// radiusFactor: 0.2,
// labelOffset: 0.2,
// offsetUnit: GaugeSizeUnit.factor,
// minimum: 0,
// maximum: 12,
// showFirstLabel: false,
// interval: 2,
// centerX: 0.48,
// minorTicksPerInterval: 5,
// tickOffset: 0.03,
// minorTickStyle: MinorTickStyle(
// length: 0.09, lengthUnit: GaugeSizeUnit.factor, thickness: 0.5),
// majorTickStyle: MajorTickStyle(
// length: 0.15,
// lengthUnit: GaugeSizeUnit.factor,
// thickness: 1,
// ),
// axisLineStyle: AxisLineStyle(
// thicknessUnit: GaugeSizeUnit.factor, thickness: 0.03),
// pointers: <GaugePointer>[
// NeedlePointer(
// value: 8,
// needleLength: 0.7,
// lengthUnit: GaugeSizeUnit.factor,
// needleColor: const Color(0xFF00A8B5),
// needleStartWidth: 0.5,
// needleEndWidth: 1,
// knobStyle: KnobStyle(knobRadius: 0),
// )
// ]),
// // Renders outer axis

import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../const.dart';

/// Locals imports

class CompassGauge2 extends StatefulWidget {
  @override
  _CompassGauge2State createState() => _CompassGauge2State();
}

class _CompassGauge2State extends State<CompassGauge2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenSize.gaugeSize,
      height: ScreenSize.gaugeSize,
      child: GaugeContainer(
          child: CompassGauge(
        direction: currentDirection,
      )),
    );
  }
}

class CompassGauge extends StatefulWidget {
  CompassGauge({double direction});
  @override
  _CompassGaugeState createState() => _CompassGaugeState();
}

class _CompassGaugeState extends State<CompassGauge> {
  final double direction;
  _CompassGaugeState({
    this.direction = 31.0,
  });

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      _annotationTextSize = 22;
      _markerOffset = 0.71;
      _positionFactor = 0.025;
      _markerHeight = 10;
      _markerWidth = 15;
      _labelFontSize = 11;
    } else {
      _annotationTextSize = 16;
      _markerOffset = 0.69;
      _positionFactor = 0.02;
      _markerHeight = 5;
      _markerWidth = 10;
      _labelFontSize = 10;
    }
    final Widget _widget = SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
            showAxisLine: false,
            radiusFactor: 1,
            canRotateLabels: true,
            tickOffset: 0.32,
            offsetUnit: GaugeSizeUnit.factor,
            onLabelCreated: _handleAxisLabelCreated,
            startAngle: 270,
            endAngle: 270,
            labelOffset: 0.05,
            maximum: 360,
            minimum: 0,
            interval: ScreenSize.small ? 90 : 30,
            minorTicksPerInterval: 4,
            axisLabelStyle: GaugeTextStyle(
                color: const Color(0xFF949494), fontSize: _labelFontSize),
            minorTickStyle: MinorTickStyle(
                color: const Color(0xFF616161),
                thickness: 1.6,
                length: 0.058,
                lengthUnit: GaugeSizeUnit.factor),
            majorTickStyle: MajorTickStyle(
                color: const Color(0xFF949494),
                thickness: 2.3,
                length: 0.087,
                lengthUnit: GaugeSizeUnit.factor),
//            backgroundImage:
//                const AssetImage('assets/images/dark_theme_gauge.png'),
            pointers: <GaugePointer>[
//              NeedlePointer(
//                  value: 70,
//                  lengthUnit: GaugeSizeUnit.factor,
//                  needleLength: 0.6,
//                  needleEndWidth: 10,
//                  gradient: const LinearGradient(colors: <Color>[
//                    Color(0xFFFF6B78),
//                    Color(0xFFFF6B78),
//                    Color(0xFFE20A22),
//                    Color(0xFFE20A22)
//                  ], stops: <double>[
//                    0,
//                    0.5,
//                    0.5,
//                    1
//                  ]),
//                    needleColor: const Color(0xFFF67280),
//                  knobStyle: KnobStyle(
//                      knobRadius: 0.09,
//                      sizeUnit: GaugeSizeUnit.factor,
//                      color: Colors.transparent)),
              NeedlePointer(
                value: direction,
                needleLength: 0.6,
                lengthUnit: GaugeSizeUnit.factor,
                needleStartWidth: 1,
                needleEndWidth: 8,
                animationType: AnimationType.easeOutBack,
                enableAnimation: true,
                animationDuration: 1200,
                knobStyle: KnobStyle(
                    knobRadius: 0.175,
                    sizeUnit: GaugeSizeUnit.factor,
                    borderColor: const Color(0xFFBEC2CB),
                    color: Colors.black,
                    borderWidth: 0.05),
//                tailStyle: TailStyle(
//                    color: const Color(0xFFDF5F2D),
//                    width: 8,
//                    lengthUnit: GaugeSizeUnit.factor,
//                    length: 0.2),
                gradient: const LinearGradient(colors: <Color>[
                  Color(0xFFFF6B78),
                  Color(0xFFFF6B78),
                  Color(0xFFE20A22),
                  Color(0xFFE20A22)
                ], stops: <double>[
                  0,
                  0.5,
                  0.5,
                  1
                ]),
                needleColor: const Color(0xFFDF5F2D),
              )
//              MarkerPointer(
//                  value: 90,
//                  color: const Color(0xFFDF5F2D),
//                  enableAnimation: true,
//                  animationDuration: 1200,
//                  markerOffset: _markerOffset,
//                  offsetUnit: GaugeSizeUnit.factor,
//                  markerType: MarkerType.triangle,
//                  markerHeight: _markerHeight,
//                  markerWidth: _markerWidth)
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  angle: 270,
                  positionFactor: _positionFactor,
                  widget: Text(
                    direction.toStringAsFixed(0),
                    style: TextStyle(
                        color: const Color(0xFFDF5F2D),
                        fontWeight: FontWeight.bold,
                        fontSize: _annotationTextSize),
                  ))
            ])
      ],
    );

    return Container(
      child: _widget,
//      height: ScreenSize.gaugeSize,
//      width: ScreenSize.gaugeSize,
    );
  }

  /// Handled callback for change numeric value to compass directional letter.
  void _handleAxisLabelCreated(AxisLabelCreatedArgs args) {
    if (args.text == '90') {
      args.text = 'E';
      args.labelStyle = GaugeTextStyle(
          color: const Color(0xFFDF5F2D), fontSize: _labelFontSize);
    } else if (args.text == '360') {
      args.text = '';
    } else {
      if (args.text == '0') {
        args.text = 'N';
      } else if (args.text == '180') {
        args.text = 'S';
      } else if (args.text == '270') {
        args.text = 'W';
      }

      args.labelStyle = GaugeTextStyle(
          color: const Color(0xFFFFFFFF), fontSize: _labelFontSize);
    }
  }

  double _annotationTextSize = ScreenSize.small ? 15 : 22;
  double _positionFactor = 0.025;
  double _markerHeight = 10;
  double _markerWidth = 15;
  double _markerOffset = 0.71;
  double _labelFontSize = 10;
}

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tidey/const.dart';

// Renders the gauge multiple needle pointers sample

//class MultipleNeedleExample extends StatelessWidget {
//  /// Creates the gauge multiple needle pointers sample
//  const MultipleNeedleExample(Key key) : super(key: key);
//
//  @override
//  _MultipleNeedleExampleState createState() => _MultipleNeedleExampleState();
//}

class DirectionAndSpeedGauge extends StatelessWidget {
  final String gaugeType;
  final String gaugeUnit;
  final String gaugeDirection;
  final double gaugeValue;
  final double gaugeMax;
  final double gaugeInterval;

  DirectionAndSpeedGauge(
      {this.gaugeType = "Wind",
      this.gaugeUnit = "mph",
      this.gaugeDirection = "SSE",
      this.gaugeValue = 20,
      this.gaugeMax = 45,
      this.gaugeInterval = 5});

  final dirMap = {
    "N": 0.0,
    "NNE": 5.0,
    "NE": 10.0,
    "ENE": 15.0,
    "E": 20.0,
    "ESE": 25.0,
    "SE": 30.0,
    "SSE": 35.0,
    "S": 40.0,
    "SSW": 45.0,
    "SW": 50.0,
    "WSW": 55.0,
    "W": 60.0,
    "WNW": 65.0,
    "NW": 70.0,
    "NNW": 75.0
  };
  @override
  Widget build(BuildContext context) {
    return Container(
//      width: ScreenSize.gaugeSize,
//      height: ScreenSize.gaugeSize,
      child: GaugeContainer(
        child: SfRadialGauge(
          //  backgroundColor: Colors.white,
          axes: <RadialAxis>[
            RadialAxis(
              // useRangeColorForAxis: true,
// //                backgroundImage:
//                     const AssetImage('assets/images/blackCircle.png'),
              axisLineStyle: AxisLineStyle(
                  thicknessUnit: GaugeSizeUnit.factor,
                  thickness: 0.10,
                  color: const Color(0xFF3366CC)),
//              startAngle: 32,
//              endAngle: 212,
              minimum: 0,
              maximum: gaugeMax,
              labelsPosition: ElementsPosition.outside,
              labelOffset: 15,
              interval: gaugeInterval,
              radiusFactor: 0.9,
              //  showFirstLabel: false,
              axisLabelStyle: GaugeTextStyle(fontSize: 20, color: Colors.white),
              minorTicksPerInterval: 0,
              onLabelCreated: _handleAxisLabelCreated,
              showTicks: false,
              minorTickStyle: MinorTickStyle(
                  lengthUnit: GaugeSizeUnit.factor, length: 0.05, thickness: 1),
              majorTickStyle:
                  MajorTickStyle(lengthUnit: GaugeSizeUnit.factor, length: 0.1),
              pointers: <GaugePointer>[
//              NeedlePointer(
//                  value: dirMap[gaugeDirection],
//                  needleLength: 0.35,
//                  needleColor: const Color(0xFFF67280),
//                  lengthUnit: GaugeSizeUnit.factor,
//                  needleStartWidth: 0,
//                  needleEndWidth: 5,
//                  enableAnimation: true,
//                  knobStyle: KnobStyle(knobRadius: 0),
//                  animationType: AnimationType.ease),
                NeedlePointer(
                    value: gaugeValue,
                    needleLength: .9,
                    lengthUnit: (GaugeSizeUnit.factor),
                    needleColor: Color(0xFFE20A22),
                    needleStartWidth: 0,
                    needleEndWidth: 8,
                    enableAnimation: true,
                    animationType: AnimationType.ease,
                    knobStyle: KnobStyle(
                        borderColor: const Color(0xFFE20A22),
                        borderWidth: 0.015,
                        color: Colors.white,
                        sizeUnit: GaugeSizeUnit.factor,
                        knobRadius: 0.05)),
              ],
              annotations: <GaugeAnnotation>[
//              GaugeAnnotation(
//                  angle: 90,
//                  positionFactor: 0.35,
//                  widget: Container(
//                      child: const Text('Temp.°C',
//                          style: TextStyle(
//                              color: Color(0xFFF8B195), fontSize: 16)))),
                GaugeAnnotation(
                    angle: 90,
                    positionFactor: 0.8,
                    widget: Container(
                      child: Text(
                        "\n" + gaugeType + "\n " + gaugeUnit,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF3366CC)),
                      ),
                    ))
              ],
            ),
            RadialAxis(
                startAngle: 270,
                endAngle: 270,
                radiusFactor: 0.52,
                minimum: 0,
                maximum: 80,
                pointers: <GaugePointer>[
                  //      MarkerPointer(
//                    value: dirMap[gaugeDirection],
//                    markerType: MarkerType.triangle,
//                    markerWidth: 30,
//                    markerHeight: 20,
//                    markerOffset: 40,
//                    color: Color(0xFFF67280)),
                  NeedlePointer(
                    value: dirMap[gaugeDirection],
                    lengthUnit: GaugeSizeUnit.factor,
                    needleLength: 0.5,
                    needleEndWidth: 10,
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
                    knobStyle: KnobStyle(
                        borderColor: const Color(0xFFF67280),
                        borderWidth: 0.0,
                        color: Colors.white,
                        sizeUnit: GaugeSizeUnit.factor,
                        knobRadius: 0.05),
                  )
//                NeedlePointer(
//                    value: dirMap[gaugeDirection],
//                    needleLength: 0.9,
//                    needleColor: const Color(0xFFF67280),
//                    lengthUnit: GaugeSizeUnit.factor,
//                    needleStartWidth: 0,
//                    needleEndWidth: 5,
//                    enableAnimation: true,
//                    knobStyle: KnobStyle(knobRadius: 0),
//                    animationType: AnimationType.ease),
//                NeedlePointer(
//                    value: gaugeValue,
//                    needleLength: .9,
//                    lengthUnit: (GaugeSizeUnit.factor),
//                    needleColor: const Color(0xFFF67280),
//                    needleStartWidth: 0,
//                    needleEndWidth: 8,
//                    enableAnimation: true,
//                    animationType: AnimationType.ease,
//                    knobStyle: KnobStyle(
//                        borderColor: const Color(0xFFF67280),
//                        borderWidth: 0.015,
//                        color: Colors.white,
//                        sizeUnit: GaugeSizeUnit.factor,
//                        knobRadius: 0.05)),
                ],
                axisLineStyle: AxisLineStyle(
                    thicknessUnit: GaugeSizeUnit.factor,
                    thickness: 0.1,
                    color: const Color(0xFF3366CC)),
                interval: 10,
                canRotateLabels: true,
                axisLabelStyle: GaugeTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                minorTicksPerInterval: 0,
                majorTickStyle: MajorTickStyle(
                    thickness: 1.5,
                    lengthUnit: GaugeSizeUnit.factor,
                    length: 0.07),
                showLabels: true,
                onLabelCreated: _handleLabelCreated),
          ],
        ),
      ),
    );
  }

  /// Appended the hours letter by handling the onLabelCreated callback
  void _handleAxisLabelCreated(AxisLabelCreatedArgs args) {
    if (args.text == '0') {
      // args.text = '0\n' + gaugeUnit;
    }
  }
}

void _handleLabelCreated(AxisLabelCreatedArgs args) {
  if (args.text == '80' || args.text == '0') {
    args.text = 'N';
  } else if (args.text == '10') {
    args.text = 'NE';
  } else if (args.text == '20') {
    args.text = 'E';
  } else if (args.text == '30') {
    args.text = 'SE';
  } else if (args.text == '40') {
    args.text = 'S';
  } else if (args.text == '50') {
    args.text = 'SW';
  } else if (args.text == '60') {
    args.text = 'W';
  } else if (args.text == '70') {
    args.text = 'NW';
  }
}

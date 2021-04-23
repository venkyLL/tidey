import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:weather_icons/weather_icons.dart';

/// Locals imports
class BarometerGauge extends StatefulWidget {
  @override
  _BarometerGaugeState createState() => _BarometerGaugeState();
}

class _BarometerGaugeState extends State<BarometerGauge> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        height: 300,
        child: _buildRadialEaseExample(),
      ),
    );
  }

  /// Return the gauge pointer ease animation gauge
  SfRadialGauge _buildRadialEaseExample() {
    const isCardView = false;
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
            backgroundImage: const AssetImage('assets/images/blackCircle.png'),
            showAxisLine: false,
            ticksPosition: ElementsPosition.outside,
            labelsPosition: ElementsPosition.outside,
            startAngle: 0,
            endAngle: 0,
            minorTicksPerInterval: 0,
            minimum: 27,
            maximum: 31,
            showFirstLabel: false,
            interval: 1,
            labelOffset: 20,
            majorTickStyle:
                MajorTickStyle(length: 0.16, lengthUnit: GaugeSizeUnit.factor),
            minorTickStyle: MinorTickStyle(
                length: 0.16, lengthUnit: GaugeSizeUnit.factor, thickness: 1),
            axisLabelStyle: GaugeTextStyle(fontSize: 40, color: Colors.white),
            pointers: <GaugePointer>[
              NeedlePointer(
                  value: 2,
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
              //       MarkerPointer(value: 90, markerType: MarkerType.triangle),
              NeedlePointer(
                  value: 310,
                  needleLength: 0.5,
                  lengthUnit: GaugeSizeUnit.factor,
                  needleColor: const Color(0xFFC4C4C4),
                  needleStartWidth: 1,
                  needleEndWidth: 1,
                  knobStyle: KnobStyle(knobRadius: 0),
                  tailStyle: TailStyle(
                      color: const Color(0xFFC4C4C4),
                      width: 1,
                      lengthUnit: GaugeSizeUnit.factor,
                      length: 0.5)),
              NeedlePointer(
                value: 221,
                needleLength: 0.5,
                lengthUnit: GaugeSizeUnit.factor,
                needleColor: const Color(0xFFC4C4C4),
                needleStartWidth: 1,
                needleEndWidth: 1,
                knobStyle:
                    KnobStyle(knobRadius: 0, sizeUnit: GaugeSizeUnit.factor),
              ),
              NeedlePointer(
                value: 40,
                needleLength: 0.5,
                lengthUnit: GaugeSizeUnit.factor,
                needleColor: const Color(0xFFC4C4C4),
                needleStartWidth: 1,
                needleEndWidth: 1,
                knobStyle: KnobStyle(knobRadius: 0),
              )
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  angle: 230,
                  positionFactor: 0.38,
                  widget: Container(
                    child: BoxedIcon((WeatherIcons.day_cloudy),
                        size: 35, color: Colors.white30),
                  )),
              GaugeAnnotation(
                  angle: 310,
                  positionFactor: 0.38,
                  widget: Container(
                    child: BoxedIcon((WeatherIcons.day_sunny),
                        size: 35, color: Colors.white30),
                  )),
              GaugeAnnotation(
                  angle: 129,
                  positionFactor: 0.38,
                  widget: Container(
                    child: BoxedIcon((WeatherIcons.thunderstorm),
                        size: 35, color: Colors.white30),
                  )),
//              GaugeAnnotation(
//                  angle: 50,
//                  positionFactor: 0.38,
//                  widget: Container(
//                    child: Text('E',
//                        style: TextStyle(
//                            fontFamily: 'Times',
//                            fontWeight: FontWeight.bold,
//                            fontSize: isCardView ? 12 : 18)),
//                  ))
            ])
      ],
    );
  }

  /// Handled callback to hide last label value.
  void _handleLabelCreated(AxisLabelCreatedArgs args) {
    if (args.text == '15M') {
      args.text = '';
    }
  }

  final double _interval = 1;
}

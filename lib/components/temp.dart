import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tidey/const.dart';
import 'package:weather_icons/weather_icons.dart';

/// Locals imports
class TempGauge extends StatefulWidget {
  final double high;
  final double low;
  final IconData conditionIcon;
  TempGauge(
      {this.high = 45,
      this.low = 86,
      this.conditionIcon = WeatherIcons.day_cloudy});

  @override
  _TempGaugeState createState() =>
      _TempGaugeState(high: high, low: low, conditionIcon: conditionIcon);
}

class _TempGaugeState extends State<TempGauge> {
  final double high;
  final double low;
  final IconData conditionIcon;

  _TempGaugeState(
      {this.high = 45,
      this.low = 86,
      this.conditionIcon = WeatherIcons.day_cloudy});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: ScreenSize.gaugeSize,
        height: ScreenSize.gaugeSize,
        child: GaugeContainer(child: _buildRadialEaseExample()),
      ),
    );
  }

  /// Return the gauge pointer ease animation gauge
  SfRadialGauge _buildRadialEaseExample() {
    const isCardView = false;
    return SfRadialGauge(
      animationDuration: 2000,
      enableLoadingAnimation: true,
      //  backgroundColor: Colors.white,
      axes: <RadialAxis>[
        RadialAxis(
            backgroundImage: const AssetImage('assets/images/blackCircle.png'),
            startAngle: 130,
            endAngle: 50,
            minimum: 0,
            maximum: 110,
            //  interval: isCardView ? 20 : _interval,
            minorTicksPerInterval: 9,
            showAxisLine: false,
            labelsPosition: ElementsPosition.outside,
            labelOffset: 15,
            interval: 10,
            radiusFactor: 0.9,
            //labelOffset: 8,
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  angle: 90,
                  positionFactor: 0.1,
                  widget: Container(
                    child: BoxedIcon((conditionIcon),
                        size: 50, color: const Color(0xFF3366CC)),
                  )),
//                      const Text('Temp.°F',
//                          style: TextStyle(
//                              color: Color(0xff000000), fontSize: 16)))),
              GaugeAnnotation(
                  angle: 90,
                  positionFactor: 0.85,
                  widget: Container(
                    child: const Text(
                      'Temp\nHi & Lo',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: const Color(0xFF3366CC)),
                    ),
                  ))
            ],
            ranges: <GaugeRange>[
              GaugeRange(
                  startValue: -10,
                  endValue: 32,
                  startWidth: 0.265,
                  sizeUnit: GaugeSizeUnit.factor,
                  endWidth: 0.265,
                  color: const Color.fromRGBO(34, 144, 199, 0.75)),
              GaugeRange(
                  startValue: 32,
                  endValue: 55,
                  startWidth: 0.265,
                  sizeUnit: GaugeSizeUnit.factor,
                  endWidth: 0.265,
                  color: const Color.fromRGBO(34, 195, 199, 0.75)),
              GaugeRange(
                  startValue: 55,
                  endValue: 70,
                  startWidth: 0.265,
                  sizeUnit: GaugeSizeUnit.factor,
                  endWidth: 0.265,
                  color: const Color.fromRGBO(123, 199, 34, 0.75)),
              GaugeRange(
                  startValue: 70,
                  endValue: 85,
                  startWidth: 0.265,
                  sizeUnit: GaugeSizeUnit.factor,
                  endWidth: 0.265,
                  color: const Color.fromRGBO(238, 193, 34, 0.75)),
              GaugeRange(
                  startValue: 85,
                  endValue: 110,
                  startWidth: 0.265,
                  sizeUnit: GaugeSizeUnit.factor,
                  endWidth: 0.265,
                  color: const Color.fromRGBO(238, 79, 34, 0.65)),
            ],
            pointers: <GaugePointer>[
//              RangePointer(
//                value: 68,
//                width: 18,
//                pointerOffset: 25,
//                cornerStyle: CornerStyle.bothCurve,
//                color: const Color(0xFFF67280),
//                gradient: const SweepGradient(
//                    colors: <Color>[Color(0xFFFF7676), Color(0xFFF54EA2)],
//                    stops: <double>[0.25, 0.75]),
//              ),
//              MarkerPointer(
//                value: 68,
//                color: Colors.black,
//                markerType: MarkerType.circle,
//                markerOffset: 25,
//              )
              MarkerPointer(
                color: Colors.red,
                value: high,
                markerHeight: 20,
                markerWidth: 20,
                markerType: MarkerType.triangle,
                markerOffset: 40,
              ),
              MarkerPointer(
                color: const Color(0xFF3366CC),
                value: low,
                markerHeight: 20,
                markerWidth: 20,
                markerType: MarkerType.triangle,
                markerOffset: 40,
              )
//              NeedlePointer(
//                value: 68.5,
//                needleLength: 0.6,
//                lengthUnit: GaugeSizeUnit.factor,
//                needleStartWidth: isCardView ? 0 : 1,
//                needleEndWidth: isCardView ? 5 : 8,
//                animationType: AnimationType.easeOutBack,
//                enableAnimation: true,
//                animationDuration: 1200,
//                knobStyle: KnobStyle(
//                    knobRadius: isCardView ? 0.06 : 0.09,
//                    sizeUnit: GaugeSizeUnit.factor,
//                    borderColor: const Color(0xFFF8B195),
//                    color: Colors.white,
//                    borderWidth: isCardView ? 0.035 : 0.05),
//                tailStyle: TailStyle(
//                    color: const Color(0xFFF8B195),
//                    width: isCardView ? 4 : 8,
//                    lengthUnit: GaugeSizeUnit.factor,
//                    length: isCardView ? 0.15 : 0.2),
//                needleColor: const Color(0xFFF8B195),
//              )
            ],
            axisLabelStyle: GaugeTextStyle(fontSize: 20, color: Colors.white),
            majorTickStyle: MajorTickStyle(
                length: 0.25, lengthUnit: GaugeSizeUnit.factor, thickness: 2),
            minorTickStyle: MinorTickStyle(
                length: 0.13, lengthUnit: GaugeSizeUnit.factor, thickness: 1))
        //),
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

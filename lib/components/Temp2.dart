import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tidey/const.dart';
import 'package:weather_icons/weather_icons.dart';

/// Locals imports
class TempGauge2 extends StatefulWidget {
  final double high;
  final double low;
  final IconData conditionIcon;
  TempGauge2(
      {this.high = 45,
      this.low = 86,
      this.conditionIcon = WeatherIcons.day_cloudy});

  @override
  _TempGauge2State createState() =>
      _TempGauge2State(high: high, low: low, conditionIcon: conditionIcon);
}

class _TempGauge2State extends State<TempGauge2> {
  final double high;
  final double low;
  final IconData conditionIcon;

  _TempGauge2State(
      {this.high = 45,
      this.low = 86,
      this.conditionIcon = WeatherIcons.day_cloudy});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: ScreenSize.gaugeSize,
        height: ScreenSize.gaugeSize,
        child: GaugeContainer(child: _buildTemperatureMonitorExample()),
      ),
    );
  }

  /// Return the gauge pointer ease animation gauge
  SfRadialGauge _buildTemperatureMonitorExample() {
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return SfRadialGauge(
      //  key: _key,
      // backgroundColor: Colors.white,
      //    : Color.fromRGBO(33, 33, 33, 1),
      enableLoadingAnimation: true,

      axes: <RadialAxis>[
        RadialAxis(
            startAngle: 130,
            endAngle: 50,
            minimum: (((low / 10).round()) * 10) - 10.toDouble(),
            maximum: (((high / 10).round()) * 10) + 20.toDouble(),
            interval: 10,
            minorTicksPerInterval: 10,
            radiusFactor: 0.9,
            labelOffset: 8,
            axisLabelStyle: GaugeTextStyle(
                fontSize: ScreenSize.small ? 15 : 20, color: Colors.white),
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  angle: 270,
                  positionFactor: 0.1,
                  widget: Container(
                    child: BoxedIcon((conditionIcon),
                        size: ScreenSize.small ? 20 : 40,
                        color: const Color(0xFF3366CC)),
                  )),
              GaugeAnnotation(
                positionFactor: .85,
                widget: Container(
                  child: Text('\nTemp °F',
                      style: TextStyle(
                          color: const Color(0xFF3366CC),
                          fontSize: ScreenSize.small ? 10 : 20)),
                ),
                angle: 90,
              )
              //  positionFactor: 0)
            ],
            pointers: <GaugePointer>[
              MarkerPointer(
                  color: const Color(0xFF3366CC),
                  value: low,
                  markerOffset: isPortrait ? -20 : -10,
                  markerHeight: 15,
                  markerWidth: 15),
              MarkerPointer(
                  color: Colors.red,
                  value: high,
                  markerOffset: isPortrait ? -20 : -10,
                  markerHeight: 15,
                  markerWidth: 15)
            ],
            axisLineStyle: AxisLineStyle(
              cornerStyle: CornerStyle.bothCurve,
              gradient: SweepGradient(
                  colors: <Color>[Colors.grey.shade200, Color(0xFF3366CC)],
                  stops: <double>[0.25, 0.75]),
              thickness: 5,
            ))
      ],
    );
  }

//  final double _interval = 1;
}

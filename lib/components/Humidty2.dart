import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tidey/const.dart';
import 'package:weather_icons/weather_icons.dart';

/// Locals imports
class Humidity2Gauge extends StatefulWidget {
  final double gaugeValue;
  // final double low;
  final IconData conditionIcon;
  Humidity2Gauge(
      {this.gaugeValue = 45,
      //    this.low = 86,
      this.conditionIcon = WeatherIcons.day_cloudy});

  @override
  _Humidity2GaugeState createState() =>
      _Humidity2GaugeState(humidity: gaugeValue, conditionIcon: conditionIcon);
}

class _Humidity2GaugeState extends State<Humidity2Gauge> {
  final double humidity;
  // final double low;
  final IconData conditionIcon;

  _Humidity2GaugeState(
      {this.humidity = 45,
      // this.low = 86,
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
            minimum: 0,
            maximum: 100,
            interval: 20,
            minorTicksPerInterval: 2,
            radiusFactor: 0.9,
            labelOffset: 8,
            axisLabelStyle: GaugeTextStyle(
                fontSize: ScreenSize.small ? 15 : 20, color: Colors.white),
            annotations: <GaugeAnnotation>[
//              GaugeAnnotation(
//                  angle: 270,
//                  positionFactor: 0.1,
//                  widget: Container(
//                    child: BoxedIcon((conditionIcon),
//                        size: ScreenSize.small ? 20 : 35,
//                        color: const Color(0xFF3366CC)),
//                  )),
              GaugeAnnotation(
                positionFactor: .85,
                widget: Container(
                  child: Text('\nHumidity',
                      style: TextStyle(
                          color: Colors.white, fontSize: isPortrait ? 10 : 12)),
                ),
                angle: 90,
              )
              //  positionFactor: 0)
            ],
            pointers: <GaugePointer>[
              MarkerPointer(
                  color: const Color(0xFF3366CC),
                  value: double.parse(globalWeather.dailyWeather[di].humidity),
                  markerOffset: isPortrait ? -20 : -10,
                  markerHeight: 15,
                  markerWidth: 15),
//              MarkerPointer(
//                  color: Colors.red,
//                  value: high,
//                  markerOffset: isPortrait ? -20 : -10,
//                  markerHeight: 15,
//                  markerWidth: 15)
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

import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tidey/const.dart';

/// Locals imports
class DS2Gauge extends StatefulWidget {
  final String gaugeType;
  final String gaugeUnit;
  final String gaugeDirection;
  final double gaugeValue;
  final double gaugeMax;
  final double gaugeInterval;

  DS2Gauge(
      {this.gaugeType = "Wind",
      this.gaugeUnit = "mph",
      this.gaugeDirection = "SSE",
      this.gaugeValue = 20,
      this.gaugeMax = 50,
      this.gaugeInterval = 10});

  @override
  _DS2GaugeState createState() => _DS2GaugeState(
      gaugeType: gaugeType,
      gaugeDirection: gaugeDirection,
      gaugeValue: gaugeValue,
      gaugeMax: gaugeMax,
      gaugeInterval: gaugeInterval);
}

class _DS2GaugeState extends State<DS2Gauge> {
  final String gaugeType;
  final String gaugeUnit;
  final String gaugeDirection;
  final double gaugeValue;
  final double gaugeMax;
  final double gaugeInterval;

  _DS2GaugeState(
      {this.gaugeType = "Wind",
      this.gaugeUnit = "mph",
      this.gaugeDirection = "SSE",
      this.gaugeValue = 20,
      this.gaugeMax = 50,
      this.gaugeInterval = 10});

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
            maximum: gaugeMax,
            interval: gaugeInterval,
            minorTicksPerInterval: 0,
            radiusFactor: 0.9,
            labelOffset: 8,
            axisLabelStyle: GaugeTextStyle(
                fontSize: ScreenSize.small ? 15 : 20, color: Colors.white),
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  angle: 270,
                  positionFactor: 0.1,
                  widget: Container(
                    child: Text(
                      gaugeDirection,
                      style: TextStyle(
                          color: Color(0xFF3366CC),
                          fontSize: isPortrait ? 12 : 25),
                    ),
                  )),
              GaugeAnnotation(
                positionFactor: .85,
                widget: Container(
                  child: Text(gaugeType,
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
                  value: gaugeValue,
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

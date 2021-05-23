import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:google_fonts/google_fonts.dart";
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tidey/const.dart';

/// Locals imports
class HumidityGauge extends StatefulWidget {
  final String gaugeType;
  final String gaugeUnit;
  final double gaugeValue;
  final double gaugeMax;
  final double gaugeInterval;

  HumidityGauge(
      {this.gaugeType = "Humidity",
      this.gaugeUnit = "",
      this.gaugeValue = 0,
      this.gaugeMax = 100,
      this.gaugeInterval = 10});

  @override
  _HumidityGaugeState createState() => _HumidityGaugeState(
      gaugeType: gaugeType,
      gaugeValue: gaugeValue,
      gaugeMax: gaugeMax,
      gaugeInterval: gaugeInterval);
}

class _HumidityGaugeState extends State<HumidityGauge> {
  final String gaugeType;
  final String gaugeUnit;
  final double gaugeValue;
  final double gaugeMax;
  final double gaugeInterval;

  _HumidityGaugeState(
      {this.gaugeType = "Wind",
      this.gaugeUnit = "",
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
    return Center(
      child: Container(
//        width: ScreenSize.gaugeSize,
//        height: ScreenSize.gaugeSize,
        child: GaugeContainer(child: _buildRadialEaseExample()),
      ),
    );
  }

  /// Return the gauge pointer ease animation gauge
  SfRadialGauge _buildRadialEaseExample() {
    const isCardView = false;
    return SfRadialGauge(
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
          interval: ScreenSize.small ? 20 : 10,
          radiusFactor: 1.0,
          //  showFirstLabel: false,
          axisLabelStyle: GaugeTextStyle(
              fontSize: ScreenSize.small ? 10 : 20, color: Colors.white),
          minorTicksPerInterval: 0,
          onLabelCreated: _handleAxisLabelCreated,
          showTicks: false,
          minorTickStyle: MinorTickStyle(
              lengthUnit: GaugeSizeUnit.factor, length: 0.05, thickness: 1),
          majorTickStyle:
              MajorTickStyle(lengthUnit: GaugeSizeUnit.factor, length: 0.1),
          annotations: <GaugeAnnotation>[
//              GaugeAnnotation(
//                  angle: 90,
//                  positionFactor: 0.35,
//                  widget: Container(
//                      child: const Text('Temp.°C',
//                          style: TextStyle(
//                              color: Color(0xFFF8B195), fontSize: 16)))),
//            GaugeAnnotation(
//                angle: 90,
//                positionFactor: .3,
//                widget: Container(
//                  child: BoxedIcon(
//                      (weatherDayIconMap[
//                          globalWeather.dailyWeather[0].hourly[0].weatherCode]),
//                      size: ScreenSize.small ? 20 : 40,
//                      color: const Color(0xFF3366CC)),
//                )),
            GaugeAnnotation(
                angle: 90,
                positionFactor: 0.9,
                widget: Container(
                  child: Text(
                    gaugeType,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.notoSans(
                        fontSize: ScreenSize.small ? 10 : 20,
                        //  fontWeight: FontWeight.bold,
                        color: const Color(0xFF3366CC)),
                  ),
                ))
          ],
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
                value: double.parse(globalWeather.dailyWeather[di].humidity),
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
        ),
      ],
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
    args.text = ScreenSize.small ? ' ' : 'NE';
  } else if (args.text == '20') {
    args.text = 'E';
  } else if (args.text == '30') {
    args.text = ScreenSize.small ? ' ' : 'SE';
  } else if (args.text == '40') {
    args.text = 'S';
  } else if (args.text == '50') {
    args.text = ScreenSize.small ? ' ' : 'SW';
  } else if (args.text == '60') {
    args.text = 'W';
  } else if (args.text == '70') {
    args.text = ScreenSize.small ? ' ' : 'NW';
  }
}

import 'package:flutter/material.dart';

/// Gauge imports
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// Locals imports
class TempGauge extends StatefulWidget {
  @override
  _TempGaugeState createState() => _TempGaugeState();
}

class _TempGaugeState extends State<TempGauge> {
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
    return SfRadialGauge(
      backgroundColor: Colors.white,
      axes: <RadialAxis>[
        RadialAxis(
            startAngle: 0,
            endAngle: 360,
            showLabels: false,
            showTicks: false,
            radiusFactor: 0.9,
            axisLineStyle: AxisLineStyle(
                thicknessUnit: GaugeSizeUnit.factor, thickness: 0.1)),
        RadialAxis(
            startAngle: 170,
            endAngle: 170,
            showTicks: false,
            labelFormat: '{value}M',
            onLabelCreated: _handleLabelCreated,
            showAxisLine: false,
            radiusFactor: 0.9,
            minimum: 0,
            maximum: 15,
            axisLabelStyle: GaugeTextStyle(
                fontSize: 12, color: Colors.pink, fontWeight: FontWeight.w500),
            labelOffset: 25,
            interval: _interval,
            canRotateLabels: true,
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  positionFactor: 1,
                  axisValue: 0,
                  widget: Container(
                      height: 45,
                      width: 45,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: ExactAssetImage('images/shotput.png'),
                          fit: BoxFit.fitHeight,
                        ),
                      ))),
              GaugeAnnotation(
                  widget: Container(
                color: Colors.yellow,
                child: const Text('Distance', style: TextStyle(fontSize: 20)),
              ))
            ],
            pointers: <GaugePointer>[
              RangePointer(
                value: 11.5,
                width: 0.1,
                color: const Color(0xFFFFCC33),
                enableAnimation: true,
                sizeUnit: GaugeSizeUnit.factor,
                animationType: AnimationType.ease,
                gradient: const SweepGradient(
                    colors: <Color>[Color(0xFFE484), Color(0xFFFFCC33)],
                    stops: <double>[0.25, 0.75]),
              ),
              MarkerPointer(
                value: 11.5,
                markerType: MarkerType.image,
                enableAnimation: true,
                animationType: AnimationType.ease,
                imageUrl: 'images/ball_progressbar.png',
                markerHeight: 40,
                markerOffset: 4,
                markerWidth: 40,
              )
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

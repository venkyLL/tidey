import 'package:flutter_analog_clock/flutter_analog_clock.dart';
import 'package:flutter/material.dart';

class zeClock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlutterAnalogClock(
      dateTime: DateTime.now(),
      dialPlateColor: Colors.amber,
      hourHandColor: Colors.black,
      minuteHandColor: Colors.black,
      secondHandColor: Colors.black,
      numberColor: Colors.black,
      borderColor: Colors.black,
      tickColor: Colors.black,
      centerPointColor: Colors.black,
      showBorder: true,
      showTicks: true,
      showMinuteHand: true,
      showSecondHand: true,
      showNumber: true,
      borderWidth: 20.0,
      hourNumberScale: 0.6,
      hourNumbers: [
        '',
        '',
        '3',
        '',
        '',
        '6',
        '',
        '',
        '9',
        '',
        '',
        '12',
      ],
      isLive: true,
      width: 500.0,
      height: 500.0,
      decoration: const BoxDecoration(),
      child: Text(''),
    );
  }
}
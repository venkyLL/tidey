import 'dart:async';

import 'package:flutter_sensor_compass/flutter_sensor_compass.dart';
import 'package:tidey/const.dart';

class MyCompass {
  bool compassEnabled = false;
  double degrees = 0.0;
  StreamSubscription _compassSubscription;

  void init() {
    print("entered compass - checking for availability");
    checkCompassAvailability();
  }

  void checkCompassAvailability() async {
    print("checking to see if compass is available ");
    Compass().isCompassAvailable().then((value) {
      compassEnabled = value;
      if (compassEnabled) {
        readCompass();
      } else {
        print("sorry compass not enabled, setting compass value to 270");
        globalCompassDirection = 270.0;
      }
    });
  }

  void readCompass() {
    if (_compassSubscription != null) return;
    _compassSubscription = Compass()
        .compassUpdates(interval: Duration(milliseconds: 100))
        .listen((value) {
      degrees = value;
      globalCompassDirection = value;
      //  print("compass heading: $globalCompassDirection, ${DateTime.now()}");
    });
  }

  void stopCompass() {
    if (_compassSubscription == null) return;
    _compassSubscription.cancel();
    _compassSubscription = null;
  }

  //
  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     home: Scaffold(
  //       appBar: AppBar(
  //         title: const Text('Compass example'),
  //       ),
  //       body: Container(
  //         padding: EdgeInsets.all(16.0),
  //         alignment: AlignmentDirectional.topCenter,
  //         child: Column(
  //           children: <Widget>[
  //             Text("Compass Enabled: $compassEnabled"),
  //             Padding(padding: EdgeInsets.only(top: 16.0)),
  //             Text("Degrees: $degrees"),
  //             Padding(padding: EdgeInsets.only(top: 16.0)),
  //             MaterialButton(
  //               child: Text("Start"),
  //               color: Colors.green,
  //               onPressed: compassEnabled ? () => _startCompass() : null,
  //             ),
  //             MaterialButton(
  //               child: Text("Stop"),
  //               color: Colors.red,
  //               onPressed: compassEnabled ? () => _stopCompass() : null,
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tidey/const.dart';
import 'package:tidey/screens/help.dart';

class TimerScreen extends StatefulWidget {
  static const String id = 'TimerScreen';
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  bool _timerOn = false;
  bool _countDownStart = userSettings.countDownStart;
  int _currentValue = userSettings.countDownTimer;
  int _countDownTimeRemaining = UserSettings().countDownTimerSecondsRemaining;
  Timer ted;

  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      _countDownTimeRemaining = userSettings.countDownTimerSecondsRemaining;
    });
    if (_countDownTimeRemaining != 0 && _countDownStart) {
      ted = Timer.periodic(const Duration(milliseconds: 1000), _bobX);
      // _countDownStart = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: kHeadingColor,
        //  backgroundColor: Color(0x44000000),
        //elevation: 0,
        //backgroundColor: Colors.blue,
        title: Text(
          "Settings",
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.help_outline,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pushNamed(context, HelpScreen.id);
            },
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.JPG'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: Column(
          children: [
            // var age = 25;

//        showMaterialNumberPicker(
//        context: context,
//          title: "Pick Your Age",
//          maxNumber: 100,
//          minNumber: 14,
//          selectedNumber: age,
//          onChanged: (value) => setState(() => age = value),
//        );

//            MenuListTile(
//              title: "Start a timer",
//              icon: Icons.hourglass_bottom,
//              onTap: () => {
//            ShowMaterialNumberPicker(
//              headerColor: kAppBlueColor,
//              maxLongSide: 400,
//              context: context,
//              title: "Minutes",
//              selectedNumber: 10,
//              maxNumber: 120,
//              minNumber: 1,
//              onChanged: (value) {
//                ted = Timer.periodic(const Duration(milliseconds: 1000), _bobX);
//                setState(() {
//                  _currentValue = value;
//                  userSettings.countDownTimer = value;
//                  _countDownTimeRemaining = value * 60;
//                  _countDownStart = true;
//                  userSettings.countDownStart = true;
//                });
////
//              },
//            ),
            //  },
            // ),
            Column(
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 80.0, bottom: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        // margin: EdgeInsets.all(100.0),
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            color: Colors.orange, shape: BoxShape.circle),
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: 95,
                            height: 95,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade800,
                                shape: BoxShape.circle),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                  ((_countDownTimeRemaining / 60.0).ceil() - 1)
                                          .toString() +
                                      ":" +
                                      (((_countDownTimeRemaining -
                                                      ((_countDownTimeRemaining /
                                                                  60.0)
                                                              .ceil() *
                                                          60)) +
                                                  60) -
                                              1)
                                          .toString()
                                          .padLeft(2, "0"),
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: Row(
                    //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey.shade500, // background
                            onPrimary: Colors.white, // foreground
                          ),
                          onPressed: () {
                            if (ted.isActive) {
                              ted.cancel();
                            }
                            setState(() {
                              _countDownTimeRemaining = 0;
                              userSettings.countDownTimerSecondsRemaining = 0;
                              _countDownStart = false;
                            });

                            userSettings.countDownStart = false;
                          },
                          child: Text('Cancel',
                              style: TextStyle(color: Colors.black)),
                        ),
                      ),
                      !_countDownStart
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.grey.shade500, // background
                                onPrimary: Colors.white, // foreground
                              ),
                              onPressed: () {
                                ted = Timer.periodic(
                                    const Duration(milliseconds: 1000), _bobX);
                                _currentValue = _currentValue;
                                userSettings.countDownTimer = _currentValue;
                                _countDownTimeRemaining = _currentValue * 60;
                                _countDownStart = true;
                                userSettings.countDownStart = true;
                              },
                              child: Text('Continue',
                                  style: TextStyle(color: Colors.black)),
                            )
                          : ElevatedButton(
                              onPressed: () {
                                userSettings.countDownStart = false;
                                if (ted.isActive) {
                                  ted.cancel();
                                }
                                setState(() {
                                  _countDownStart = false;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.grey.shade500, // background
                                onPrimary: Colors.white, // foreground
                              ),
                              child: Text('Pause',
                                  style: TextStyle(color: Colors.black)),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _bobX(Timer timer) {
    print("Checking countdown remaining = " +
        userSettings.countDownTimerRemaining.toString());
    if (_countDownTimeRemaining !=
        userSettings.countDownTimerSecondsRemaining) {
      setState(() {
        _countDownTimeRemaining = userSettings.countDownTimerSecondsRemaining;
      });
    }
    if (_countDownTimeRemaining == 0) {
      if (ted.isActive) {
        ted.cancel();
      }
    }
  }
}

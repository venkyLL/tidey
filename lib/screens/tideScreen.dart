import 'dart:async';

import 'package:dart_date/dart_date.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:swipe_gesture_recognizer/swipe_gesture_recognizer.dart';
import 'package:tidey/components/DS2.dart';
import 'package:tidey/components/Humidty2.dart';
import 'package:tidey/components/Temp2.dart';
import 'package:tidey/components/barometer.dart';
import 'package:tidey/components/compass.dart';
import 'package:tidey/components/dsGauge.dart';
import 'package:tidey/components/fabMenu.dart';
import 'package:tidey/components/humidyGauge.dart';
import 'package:tidey/components/imageGauge.dart';
import 'package:tidey/components/temp.dart';
import 'package:tidey/components/zeClockSync.dart';
import 'package:tidey/const.dart';
import 'package:tidey/screens/help.dart';
import 'package:tidey/screens/settings.dart';
import 'package:tidey/screens/weatherToday.dart';
import 'package:tidey/screens/webWeather.dart';
import 'package:tidey/services/MapUtils.dart';
import 'package:timer_builder/timer_builder.dart';

bool marqueeCompleted = false;
int counter = 0;
bool pauseGauge = false;

//enum WhyFarther { harder, smarter, selfStarter, tradingCharter }

class TideScreen extends StatefulWidget {
  static const String id = 'TideScreen';

  @override
  _TideScreenState createState() => _TideScreenState();
}

List<String> ringOptions = <String>[
  chimeTypeEnumtoString[ChimeType.single],
  chimeTypeEnumtoString[ChimeType.hourly],
  chimeTypeEnumtoString[ChimeType.nautical],
];

class _TideScreenState extends State<TideScreen> {
  @override
  void initState() {
    super.initState();
    ExpandableFab();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar:
            // AppBar(title: Text(globalLatitude == null ? "bob" : globalLatitude)),
            AppBar(
          //    title: Text(globalLatitude == null ? "Tide" : globalLatitude),
          centerTitle: true,
          backgroundColor: Colors.transparent,

          elevation: 0,
        ),
        floatingActionButton: FABMenu(),

//        FloatingActionButton(
//
        body: SwipeGestureRecognizer(
          onSwipeRight: () {
            Navigator.pushNamed(context, SettingsScreen.id);
          },
          onSwipeLeft: () {
            Navigator.pushNamed(context, TodayScreen.id);
          },
          child: GestureDetector(
            onTap: () {
              print("Touched everywhere");
              _settingModalBottomSheet(context);
            },
            onDoubleTap: () {
              print("Did a double tap");
              pauseGauge = !pauseGauge;
            },
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: OrientationBuilder(
                builder: (context, orientation) {
                  //  if (MediaQuery.of(context).orientation == Orientation.landscape) {
//         //   }
                  if (orientation == Orientation.portrait) {
                    return PortraitMode();
                  } else {
                    return LandScapeMode();
                  }
                },
              ),
            ),
          ),
        ));
  }
}

class FABMenu extends StatelessWidget {
  const FABMenu({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
      distance: 90.0,
      children: [
        ActionButton(
          onPressed: () => Navigator.pushNamed(context, SettingsScreen.id),
          // _showAction(context, 2),
          icon: const Icon(Icons.settings),
        ),
        ActionButton(
          onPressed: () => Navigator.pushNamed(context, TodayScreen.id),
          //   _showAction(context, 0),
          icon: const Icon(Icons.wb_sunny),
        ),
        ActionButton(
          onPressed: () {
            destinationURL = userSettings.localInfoURL;
            Navigator.pushNamed(context, WebWeather.id);
          },
          //   _showAction(context, 0),
          icon: const Icon(Icons.info),
        ),
        ActionButton(
          onPressed: () {
            (MediaQuery.of(context).orientation == Orientation.landscape)
                ? startMarquee = true
                : showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          content: Text(
                              "Marquee is only available in Landscape Mode"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                              child: Text("okay"),
                            ),
                          ],
                        ));
          },
          icon: const Icon(Icons.view_day),
        ),
      ],
    );
  }
}

void _settingModalBottomSheet(context) {
  showModalBottomSheet(
      context: context,
      // backgroundColor: Colors.white70,
      // barrierColor: Colors.red,
      builder: (BuildContext bc) {
        return Container(
          child: ListView(
            children: <Widget>[
              ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                  onTap: () =>
                      {Navigator.pushNamed(context, SettingsScreen.id)}),
              ListTile(
                leading: Icon(Icons.wb_sunny),
                title: Text('View Weather Table'),
                onTap: () => {Navigator.pushNamed(context, TodayScreen.id)},
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text('Local Information'),
                onTap: () {
                  {
                    destinationURL = userSettings.localInfoURL;
                    Navigator.pushNamed(context, WebWeather.id);
                  }
                },
              ),
              ListTile(
                  leading: Icon(
                    Icons.stop,
                  ),
                  title: Text(
                    'Pause/Restart Gauge Swap',
                  ),
                  onTap: () => {
                        pauseGauge = !pauseGauge,
                        Navigator.of(context).pop(),
                      }),
              ListTile(
                leading: Icon(Icons.map),
                title: Text('Open Map'),
                onTap: () {
                  MapUtils.openMap(double.parse(globalLatitude),
                      double.parse(globalLongitude));
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.view_day),
                title: Text('Start Weather Marquee (Landscape Mode Only)'),
                enabled: (MediaQuery.of(context).orientation ==
                    Orientation.landscape),
                onTap: () => {
                  Navigator.of(context).pop(),
                  (MediaQuery.of(context).orientation == Orientation.landscape)
                      ? startMarquee = true
                      : showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                                // title: Text("Marquee "),
                                content: Text(
                                    "Marquee is only available in Landscape Mode"),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                    },
                                    child: Text("okay"),
                                  ),
                                ],
                              ))
                },
              ),
              ListTile(
                  leading: Icon(Icons.help),
                  title: Text(
                    'Help',
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, HelpScreen.id);
                  }),
            ],
          ),
        );
      });
}

class LandScapeMode extends StatefulWidget {
  @override
  _LandScapeModeState createState() => _LandScapeModeState();
}

class _LandScapeModeState extends State<LandScapeMode> {
  HourlyDataSource hourlyDataSource;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.JPG'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.8), BlendMode.dstATop),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: ScreenSize.hasNotch ? 40 : 0,
          ),
          LandscapeView(),
        ],
      ),
    );
  }
}

class LandscapeView extends StatefulWidget {
  @override
  _LandscapeViewState createState() => _LandscapeViewState();
}

bool startMarquee = false;

class _LandscapeViewState extends State<LandscapeView> {
  Timer timer;
  DateTime bellLastRungDateTime = DateTime.now();
  //int currentTransitionTime = 0;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 1000), _bobX);
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  _bobX(Timer timer) {
    // print("Should be checking for marquee" +
    DateTime.now().getMinutes.toString();

    if (DateTime.now().getMinutes == 00) {
      //  print("Should be starting Marquee");
      DateTime myDate = bellLastRungDateTime.addMinutes(1);
      if (bellLastRungDateTime.addMinutes(1).isPast) {
        bellLastRungDateTime = DateTime.now();
        print("Should be starting Marquee2");
        setState(() {
          marqueeCompleted = false;
          startMarquee = true;
        });
      } //has the bell already rung for this hour
    } else {
      if (startMarquee) {
        print("Setting MarqueeCompled = false");
        setState(() {
          startMarquee = false;
          marqueeCompleted = false;
        });
      }
      ;

      // are we at the top of the hour

    }
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            VenkySwap(),
            // LandscapeTimerWidget(),
            ClockRow(),
          ],
        ),
        !marqueeCompleted
            ? Container(
                color: marqueeColor,
                width: ScreenSize.safeBlockHorizontal * 100,
                height: ScreenSize.marqueeHeight,
                child: ListView(
                  padding: EdgeInsets.only(top: 50.0),
                  children: [
                    buildMarquee(),
                    // _buildComplexMarquee(),
                  ].map(_wrapWithStuff).toList(),
                ),
              )
            : Container(
                color: Colors.transparent,
                width: ScreenSize.safeBlockHorizontal * 100,
                height: ScreenSize.marqueeHeight),
      ],
    );
  }

  //pollForChanges() {}

  Widget buildMarquee() {
    return Marquee(
        text: marqueeString,
        style: kMarqueeTextstyle,
        scrollAxis: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.start,
        blankSpace: 20.0,
        velocity: 100.0,
        //  pauseAfterRound: Duration(seconds: 1),
        showFadingOnlyWhenScrolling: true,
        fadingEdgeStartFraction: 0.1,
        fadingEdgeEndFraction: 0.1,
        numberOfRounds: 2,
        //  startPadding: 10.0,
        accelerationDuration: Duration(seconds: 1),
        accelerationCurve: Curves.linear,
        decelerationDuration: Duration(milliseconds: 500),
        decelerationCurve: Curves.easeOut,
        onDone: () {
          setState(() {
            marqueeCompleted = true;

            //   marqueeColor = Colors.blue;
          });
        }
//
        );
  }
}

class ClockRow extends StatelessWidget {
  // Size ted = (Size(w));
  @override
  Widget build(BuildContext context) {
    // Size ted = Size(width: 30, length:30 );

    return Row(
      children: [
        gaugeColumn(),
        clockColumn(clockType: zeClockSync()),
      ],
    );
  }
}

class clockColumn extends StatelessWidget {
  Widget clockType;
  Color containerColor;
  clockColumn({
    this.clockType,
    this.containerColor = Colors.transparent,
  });
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  // final String formatted = DateFormat.format(now);

//  String formattedDate = DateFormat('MM-dd').format(now);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: (ScreenSize.clockTop),
        ),
        Container(
          color: containerColor,
          width: ScreenSize.clockSize,
          height: ScreenSize.clockSize,
          child: clockType,
        ),
      ],
    );
  }
}

class gaugeColumn extends StatelessWidget {
  Widget gaugeType;
  Color containerColor;
  gaugeColumn({
    this.gaugeType,
    this.containerColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: ScreenSize.gaugeTop),
        Container(
          width: ScreenSize.gaugeSize,
          height: ScreenSize.gaugeSize,
          color: containerColor,
          child: gaugeType,
        ),
        SizedBox(height: ScreenSize.gaugeBottom),
      ],
    );
  }
}

class DialRow extends StatelessWidget {
  final Widget gaugeType1;
  final Widget gaugeType2;

  DialRow({
    this.gaugeType1,
    this.gaugeType2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        gaugeColumn(gaugeType: gaugeType1, containerColor: Colors.transparent),
        clockColumn(),
        gaugeColumn(gaugeType: gaugeType2, containerColor: Colors.transparent),
      ],
    );
  }
}

List<Widget> gaugeSequenceList = [
  DialRow(
      gaugeType1: ScreenSize.small
          ? TempGauge2(
              high: double.parse(globalWeather.dailyWeather[di].highTemp),
              low: double.parse(globalWeather.dailyWeather[di].lowTemp),
              conditionIcon: weatherDayIconMap[
                  globalWeather.dailyWeather[di].hourly[0].weatherCode])
          : TempGauge(
              high: double.parse(globalWeather.dailyWeather[di].highTemp),
              low: double.parse(globalWeather.dailyWeather[di].lowTemp),
              conditionIcon: weatherDayIconMap[
                  globalWeather.dailyWeather[di].hourly[0].weatherCode]),
      gaugeType2: HumidityGauge(
        gaugeValue: double.parse(globalWeather.dailyWeather[di].humidity),
      )),
  DialRow(
      gaugeType1: ImageGaugeNew(
        imageName: "sunset1.gif",
        textLabel: globalWeather.dailyWeather[di].sunrise,
        textBackgroundColor: Colors.transparent,
      ),
      gaugeType2: ImageGaugeNew(
        imageName: "sunset2.gif",
        textLabel: globalWeather.dailyWeather[di].sunset,
        textBackgroundColor: Colors.transparent,
      )),
  DialRow(
    gaugeType1: ImageGaugeNew(
      imageName: getMoonImageName(),
      innerLineColor: Colors.transparent,
    ),
//ImageGauge(imageName: "gaugeMoon.png", textLabel: ""),
    gaugeType2: ImageGaugeNew(
        imageName: "shootingStar.gif",
        innerLineColor: Colors.transparent,
        textLabel: globalWeather.dailyWeather[di].moonPhase +
            "\nRise: " +
            globalWeather.dailyWeather[di].moonrise +
            "\nSet:" +
            globalWeather.dailyWeather[di].moonset,
        textPosition: 40,
        textBackgroundColor: Colors.transparent,
        fontSize: 20),
  ),
  DialRow(
    gaugeType1: DSGauge(
      gaugeDirection: globalWeather.dailyWeather[di].hourly[0].windDirection,
      gaugeValue: // 8.0,
          double.parse(globalWeather.dailyWeather[di].hourly[0].windSpeed),
    ),
    gaugeType2: DSGauge(
      gaugeType: "Waves",
      gaugeUnit: "ft",
      gaugeDirection: globalWeather.dailyWeather[di].windDirection,
      gaugeValue: // 5.0,
          double.parse(globalWeather.dailyWeather[di].waveHt),
      gaugeMax: 10,
      gaugeInterval: 1,
    ),
  ),
  DialRow(
    gaugeType1: ImageGaugeNew(
      imageName: "water.gif",
      textLabel: "Water " +
          globalWeather.dailyWeather[di].waterTemp +
//   weatherData.data.weather[0].hourly[0].waterTempF +
          " \u2109",
      textColor: Colors.black,
      textBackgroundColor: Colors.transparent,
    ),
    gaugeType2: BarometerGauge(
      current: double.parse(globalWeather.dailyWeather[di].hourly[0].pressure),
      change: getBarometerChange(),
    ),
  ),
  DialRow(
      gaugeType1: ImageGaugeNew(
        imageName: "boat1.jpg",
      ),
      gaugeType2: ImageGaugeNew(
        imageName: "boat2.jpg",
      ))
];

List<Widget> gaugeSequenceListP = [
  PortraitDialRow(
      gaugeType1: ScreenSize.small
          ? TempGauge2(
              high: double.parse(globalWeather.dailyWeather[di].highTemp),
              low: double.parse(globalWeather.dailyWeather[di].lowTemp),
              conditionIcon: weatherDayIconMap[
                  globalWeather.dailyWeather[di].hourly[0].weatherCode])
          : TempGauge2(
              high: double.parse(globalWeather.dailyWeather[di].highTemp),
              low: double.parse(globalWeather.dailyWeather[di].lowTemp),
              conditionIcon: weatherDayIconMap[
                  globalWeather.dailyWeather[di].hourly[0].weatherCode]),
      gaugeType2: ScreenSize.small
          ? Humidity2Gauge(
              gaugeValue: double.parse(
              globalWeather.dailyWeather[di].humidity,
            ))
          : HumidityGauge(
              gaugeValue: double.parse(
                globalWeather.dailyWeather[di].humidity,
              ),
            )),
  PortraitDialRow(
      gaugeType1: ImageGaugeNew(
        imageName: "sunset1.gif",
        textLabel: globalWeather.dailyWeather[di].sunrise,
        textBackgroundColor: Colors.transparent,
      ),
      gaugeType2: ImageGaugeNew(
        imageName: "sunset2.gif",
        textLabel: globalWeather.dailyWeather[di].sunset,
        textBackgroundColor: Colors.transparent,
      )),
  PortraitDialRow(
    gaugeType1: ImageGaugeNew(
      imageName: getMoonImageName(),
      innerLineColor: Colors.transparent,
    ),
//ImageGauge(imageName: "gaugeMoon.png", textLabel: ""),
    gaugeType2: ImageGaugeNew(
        imageName: "shootingStar.gif",
        innerLineColor: Colors.transparent,
        textLabel: globalWeather.dailyWeather[di].moonPhase +
            "\nRise: " +
            globalWeather.dailyWeather[di].moonrise +
            "\nSet:" +
            globalWeather.dailyWeather[di].moonset,
        textPosition: 40,
        textBackgroundColor: Colors.transparent,
        fontSize: 20),
  ),
  ScreenSize.small
      ? PortraitDialRow(
          gaugeType1: DS2Gauge(
            gaugeDirection:
                globalWeather.dailyWeather[di].hourly[0].windDirection,
            gaugeValue: // 8.0,
                double.parse(
                    globalWeather.dailyWeather[di].hourly[0].windSpeed),
            gaugeMax: 50,
            gaugeInterval: 10,
          ),
          gaugeType2: DS2Gauge(
            gaugeType: "Waves",
            gaugeUnit: "ft",
            gaugeDirection: globalWeather.dailyWeather[di].windDirection,
            gaugeValue: // 5.0,
                double.parse(globalWeather.dailyWeather[di].waveHt),
            gaugeMax: 10,
            gaugeInterval: 2,
          ),
        )
      : PortraitDialRow(
          gaugeType1: DSGauge(
            gaugeDirection:
                globalWeather.dailyWeather[di].hourly[0].windDirection,
            gaugeValue: // 8.0,
                double.parse(
                    globalWeather.dailyWeather[di].hourly[0].windSpeed),
            gaugeMax: 50,
            gaugeInterval: 10,
          ),
          gaugeType2: DSGauge(
            gaugeType: "Waves",
            gaugeUnit: "ft",
            gaugeDirection: globalWeather.dailyWeather[di].windDirection,
            gaugeValue: // 5.0,
                double.parse(globalWeather.dailyWeather[di].waveHt),
            gaugeMax: 10,
            gaugeInterval: 2,
          ),
        ),
  PortraitDialRow(
    gaugeType1: ImageGaugeNew(
      imageName: "water.gif",
      textLabel: "Water " +
          globalWeather.dailyWeather[di].waterTemp +
//   weatherData.data.weather[0].hourly[0].waterTempF +
          " \u2109",
      textColor: Colors.black,
      textBackgroundColor: Colors.transparent,
    ),
    gaugeType2: BarometerGauge(
      current: double.parse(globalWeather.dailyWeather[di].hourly[0].pressure),
      change: getBarometerChange(),
    ),
  ),
  PortraitDialRow(
      gaugeType1: ImageGaugeNew(
        imageName: "boat1.jpg",
      ),
      gaugeType2: ImageGaugeNew(
        imageName: "boat2.jpg",
      ))
];

class VenkySwap extends StatefulWidget {
  VenkySwap({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _VenkySwapState createState() => _VenkySwapState();
}

class _VenkySwapState extends State<VenkySwap> {
  int _counter = 0;
  bool animationSwitcher = false;
  Timer myTimer;
  Timer ted;
  AnimationController controller;
  List<Widget> myWidgetList;
  Widget myFirstWidget = gaugeSequenceList[0];
  Widget mySecondWidget = gaugeSequenceList[1];
  int currentTransitionTime = userSettings.transitionTime;

  /*
   Timer ted;

  int currentTransitionTime = 0;
  @override
  void initState() {
    super.initState();
    // timer = Timer.periodic(const Duration(milliseconds: 1000), _updateData);


  }

  @override
  void dispose() {
    super.dispose();
    ted.cancel();
  }



   */

  @override
  void initState() {
    super.initState();
    ted = Timer.periodic(const Duration(milliseconds: 1000), _bobX);
    myTimer = Timer.periodic(
        Duration(seconds: userSettings.transitionTime), _updateData);
  }

  _bobX(Timer timer) {
    if (currentTransitionTime != userSettings.transitionTime) {
      myTimer.cancel();
      currentTransitionTime = userSettings.transitionTime;
      myTimer = Timer.periodic(
          Duration(seconds: userSettings.transitionTime), _updateData);
    }
  }

  @override
  void dispose() {
    super.dispose();
    myTimer.cancel();
    ted.cancel();
  }

  void _updateData(Timer timer) {
    if (!pauseGauge) {
      counter = (counter + 1) % (gaugeSequenceList.length);
      setState(() {
        animationSwitcher = !animationSwitcher;
      });
      if (MediaQuery.of(context).orientation == Orientation.landscape) {
        if (animationSwitcher) {
          // you need this funky method because animationCrossFade goes back and forth between one image and the other
          // so on each crossfade you have to update the image (and only that image) that you are bringing to foreground;
          myFirstWidget = gaugeSequenceList[counter];
        } else {
          mySecondWidget = gaugeSequenceList[counter];
        }
      } else {
        print("In Portrait Switchter");
        if (animationSwitcher) {
          // you need this funky method because animationCrossFade goes back and forth between one image and the other
          // so on each crossfade you have to update the image (and only that image) that you are bringing to foreground;
          myFirstWidget = gaugeSequenceListP[counter];
        } else {
          mySecondWidget = gaugeSequenceListP[counter];
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    return Center(
      child: AnimatedCrossFade(
        duration: const Duration(milliseconds: 1500),
        firstChild: myFirstWidget,
        secondChild: mySecondWidget,
        crossFadeState: animationSwitcher
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
      ),
    );
  }
}

class VenkySwapP extends StatefulWidget {
  VenkySwapP({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _VenkySwapStateP createState() => _VenkySwapStateP();
}

class _VenkySwapStateP extends State<VenkySwapP> {
  int _counter = 0;
  bool animationSwitcher = false;
  Timer myTimer;
  Timer ted;
  AnimationController controller;
  List<Widget> myWidgetList;
  Widget myFirstWidget = gaugeSequenceListP[0];
  Widget mySecondWidget = gaugeSequenceListP[1];
  int currentTransitionTime = userSettings.transitionTime;

  /*
   Timer ted;

  int currentTransitionTime = 0;
  @override
  void initState() {
    super.initState();
    // timer = Timer.periodic(const Duration(milliseconds: 1000), _updateData);


  }

  @override
  void dispose() {
    super.dispose();
    ted.cancel();
  }



   */

  @override
  void initState() {
    super.initState();
    ted = Timer.periodic(const Duration(milliseconds: 1000), _bobX);
    myTimer = Timer.periodic(
        Duration(seconds: userSettings.transitionTime), _updateData);
  }

  _bobX(Timer timer) {
    if (currentTransitionTime != userSettings.transitionTime) {
      myTimer.cancel();
      currentTransitionTime = userSettings.transitionTime;
      myTimer = Timer.periodic(
          Duration(seconds: userSettings.transitionTime), _updateData);
    }
  }

  @override
  void dispose() {
    super.dispose();
    myTimer.cancel();
    ted.cancel();
  }

  void _updateData(Timer timer) {
    if (!pauseGauge) {
      counter = (counter + 1) % (gaugeSequenceList.length);
      //counter = 0;
      setState(() {
        animationSwitcher = !animationSwitcher;
      });

      if (animationSwitcher) {
        // you need this funky method because animationCrossFade goes back and forth between one image and the other
        // so on each crossfade you have to update the image (and only that image) that you are bringing to foreground;
        myFirstWidget = gaugeSequenceListP[counter];
      } else {
        mySecondWidget = gaugeSequenceListP[counter];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    return Center(
      child: AnimatedCrossFade(
        duration: const Duration(milliseconds: 1500),
        firstChild: myFirstWidget,
        secondChild: mySecondWidget,
        crossFadeState: animationSwitcher
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
      ),
    );
  }
}

//
//class LandscapeTimerWidget extends StatefulWidget {
//  @override
//  _LandscapeTimerWidgetState createState() => _LandscapeTimerWidgetState();
//}
//
//class _LandscapeTimerWidgetState extends State<LandscapeTimerWidget> {
//  Timer ted;
//
//  int currentTransitionTime = 0;
//  @override
//  void initState() {
//    super.initState();
//    // timer = Timer.periodic(const Duration(milliseconds: 1000), _updateData);
//
//    ted = Timer.periodic(const Duration(milliseconds: 1000), _bobX);
//  }
//
//  @override
//  void dispose() {
//    super.dispose();
//    ted.cancel();
//  }
//
//  _bobX(Timer timer) {
//    if (currentTransitionTime != userSettings.transitionTime) {
//      setState(() {
//        currentTransitionTime = userSettings.transitionTime;
//      });
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return TimerBuilder.periodic(Duration(seconds: userSettings.transitionTime),
//        builder: (context) {
//      counter = (counter + 1) % 6;
//      if (globalWeather.weatherAPIError) {
//        counter = 5;
//      }
//      // counter = 4;
//      // counter == 0 ? counter = 1 : counter = 0;
//
//      return LandScapeSwapper2();
//    });
//  }
//}
//
//class LandscapeSwapper extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return gaugeSequenceList[counter];
//  }
//}
//
//class LandScapeSwapper2 extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    switch (counter) {
//      case 0:
//        return DialRow(
//          gaugeType1: TempGauge(
//              high: double.parse(globalWeather.dailyWeather[di].highTemp),
//              low: double.parse(globalWeather.dailyWeather[di].lowTemp),
//              conditionIcon: weatherDayIconMap[
//                  globalWeather.dailyWeather[di].hourly[0].weatherCode]),
//          gaugeType2: BarometerGauge(
//            current:
//                double.parse(globalWeather.dailyWeather[di].hourly[0].pressure),
//            change: getBarometerChange(),
//          ),
//        );
//        break;
//      case 1:
////        return AnimatedCrossFade(
////            crossFadeState: _crossFadeState,
////            firstChild: DialRow(
////              gaugeType1: TempGauge(),
////              gaugeType2: BarometerGauge(),
////            ),
////            secondChild: DialRow(
////                gaugeType1: ImageGauge(
////                    imageName: "gaugeSunrise.png", textLabel: "6:110PM"),
////                gaugeType2: ImageGauge(
////                    imageName: "gaugeSunset.png", textLabel: "8:15PM")),
////            // crossFadeState: crossFadeState,
////            duration: const Duration(seconds: 2));
//        return DialRow(
//            gaugeType1: ImageGaugeNew(
//              imageName: "sunset1.gif",
//              textLabel: globalWeather.dailyWeather[di].sunrise,
//              textBackgroundColor: Colors.transparent,
//            ),
//            gaugeType2: ImageGaugeNew(
//              imageName: "sunset2.gif",
//              textLabel: globalWeather.dailyWeather[di].sunset,
//              textBackgroundColor: Colors.transparent,
//            ));
//        break;
//
//      case 2:
//        return DialRow(
//          gaugeType1: ImageGaugeNew(
//            imageName: getMoonImageName(),
//            innerLineColor: Colors.transparent,
//          ),
//          //ImageGauge(imageName: "gaugeMoon.png", textLabel: ""),
//          gaugeType2: ImageGaugeNew(
//              imageName: "shootingStar.gif",
//              innerLineColor: Colors.transparent,
//              textLabel: globalWeather.dailyWeather[di].moonPhase +
//                  "\nRise: " +
//                  globalWeather.dailyWeather[di].moonrise +
//                  "\nSet:" +
//                  globalWeather.dailyWeather[di].moonset,
//              textPosition: 40,
//              textBackgroundColor: Colors.transparent,
//              fontSize: 20),
//        );
//        break;
//
//      case 3:
//        return DialRow(
//          gaugeType1: DSGauge(
//            gaugeDirection:
//                globalWeather.dailyWeather[di].hourly[0].windDirection,
//            gaugeValue: // 8.0,
//                double.parse(
//                    globalWeather.dailyWeather[di].hourly[0].windSpeed),
//          ),
//          gaugeType2: DSGauge(
//            gaugeType: "Waves",
//            gaugeUnit: "ft",
//            gaugeDirection: globalWeather.dailyWeather[di].windDirection,
//            gaugeValue: // 5.0,
//                double.parse(globalWeather.dailyWeather[di].waveHt),
//            gaugeMax: 10,
//            gaugeInterval: 1,
//          ),
//        );
//        break;
//      case 4:
//        return DialRow(
//            gaugeType1: ImageGaugeNew(
//              imageName: "water.gif",
//              textLabel: "Water " +
//                  globalWeather.dailyWeather[di].waterTemp +
//                  //   weatherData.data.weather[0].hourly[0].waterTempF +
//                  " \u2109",
//              textColor: Colors.black,
//              textBackgroundColor: Colors.transparent,
//            ),
//            gaugeType2: CompassGauge2());
//      case 5:
//        return DialRow(
//            gaugeType1: ImageGaugeNew(
//              imageName: "boat1.jpg",
//            ),
//            gaugeType2: ImageGaugeNew(
//              imageName: "boat2.jpg",
//            ));
//
//      default:
//        {
//          print("Error");
//          return DialRow(
//              gaugeType1: ImageGaugeNew(
//                imageName: "boat1.jpg",
//              ),
//              gaugeType2: ImageGaugeNew(
//                imageName: "boat2.jpg",
//              ));
//        }
//        break;
//    }
////    return counter == 0
////        ? buildMyTideTable()
////        : SunTable(); // (moonPhaseImageName: "assets/images/fullMoon.jpg");
//  }
//}

class PortraitSwapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    switch (counter) {
      case 0:
        return PortraitDialRow(
          gaugeType1: TempGauge(
              high: double.parse(globalWeather.dailyWeather[di].highTemp),
              low: double.parse(globalWeather.dailyWeather[di].lowTemp),
              conditionIcon: weatherDayIconMap[
                  globalWeather.dailyWeather[di].weatherCode]),
          gaugeType2: BarometerGauge(
            current: double.parse(globalWeather.dailyWeather[di].pressure),
            change: getBarometerChange(),
          ),
        );
        break;
      case 1:
//        return AnimatedCrossFade(
//            crossFadeState: _crossFadeState,
//            firstChild: DialRow(
//              gaugeType1: TempGauge(),
//              gaugeType2: BarometerGauge(),
//            ),
//            secondChild: DialRow(
//                gaugeType1: ImageGauge(
//                    imageName: "gaugeSunrise.png", textLabel: "6:110PM"),
//                gaugeType2: ImageGauge(
//                    imageName: "gaugeSunset.png", textLabel: "8:15PM")),
//            // crossFadeState: crossFadeState,
//            duration: const Duration(seconds: 2));
        return PortraitDialRow(
            gaugeType1: ImageGaugeNew(
              imageName: "sunset1.gif",
              textLabel: globalWeather.dailyWeather[di].sunrise,
              textPosition: 60,
            ),
            gaugeType2: ImageGaugeNew(
                imageName: "sunset2.gif",
                textPosition: 60,
                textLabel: globalWeather.dailyWeather[di].sunset));
        break;

      case 2:
        return PortraitDialRow(
          gaugeType2: ImageGaugeNew(
            imageName: getMoonImageName(),
            innerLineColor: Colors.transparent,
          ),
          //ImageGauge(imageName: "gaugeMoon.png", textLabel: ""),
          gaugeType1: ImageGaugeNew(
              imageName: "shootingStar.gif",
              innerLineColor: Colors.transparent,
              textLabel: globalWeather.dailyWeather[di].moonPhase +
                  "\nRise: " +
                  globalWeather.dailyWeather[di].moonrise +
                  "\nSet:" +
                  globalWeather.dailyWeather[di].moonset,
              textPosition: 40,
              textBackgroundColor: Colors.transparent,
              fontSize: 20),
        );
        break;

      case 3:
        return PortraitDialRow(
          gaugeType1: DSGauge(
            gaugeDirection:
                globalWeather.dailyWeather[di].hourly[0].windDirection,
            gaugeValue: double.parse(
                globalWeather.dailyWeather[di].hourly[0].windSpeed),
          ),
          gaugeType2: DSGauge(
            gaugeType: "Waves",
            gaugeUnit: "ft",
            gaugeDirection: globalWeather.dailyWeather[di].waveDirection,
            gaugeValue: double.parse(globalWeather.dailyWeather[di].waveHt),
            gaugeMax: 10,
            gaugeInterval: 1,
          ),
        );
        break;
      case 4:
        return PortraitDialRow(
            gaugeType1: ImageGaugeNew(
              imageName: "water.gif",
              textLabel: "Water " +
                  globalWeather.dailyWeather[di].waterTemp +
                  " \u2109",
              textColor: Colors.black,
              textPosition: 50,
            ),
            gaugeType2: CompassGauge2());
      case 5:
        return PortraitDialRow(
            gaugeType1: ImageGaugeNew(
              imageName: "boat1.jpg",
            ),
            gaugeType2: ImageGaugeNew(
              imageName: "boat2.jpg",
            ));

      default:
        {
          print("Error");
        }
        break;
    }
//    return counter == 0
//        ? buildMyTideTable()
//        : SunTable(); // (moonPhaseImageName: "assets/images/fullMoon.jpg");
  }
}

class PortraitTimerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TimerBuilder.periodic(Duration(seconds: userSettings.transitionTime),
        builder: (context) {
      counter = (counter + 1) % 6;
      if (globalWeather.weatherAPIError) {
        counter = 5;
      }
      // counter = 4;
      // counter == 0 ? counter = 1 : counter = 0;
      return PortraitSwapper();
    });
  }
}

Widget _wrapWithStuff(Widget child) {
  return Padding(
    padding: EdgeInsets.all(16.0),
    child: Container(height: 120.0, color: Colors.transparent, child: child),
  );
}

class PortraitMode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.JPG'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.8), BlendMode.dstATop),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: ScreenSize.hasNotch ? 25 : 0,
          ),
          Stack(
            children: [
              // PortraitTimerWidget(),
              VenkySwapP(),
              Column(children: [
                SizedBox(height: ScreenSize.safeBlockVertical * 4),
                Container(
                    height: ScreenSize.gaugeSize -
                        (ScreenSize.safeBlockVertical * 4)),
                SizedBox(height: ScreenSize.safeBlockVertical * 2),
                PortraitClockRow(),
                SizedBox(height: ScreenSize.safeBlockVertical * 2),
                Container(
                    height: ScreenSize.gaugeSize -
                        (ScreenSize.safeBlockVertical * 4)),
              ]),
            ],
          ),
        ],
      ),
    );
  }

  Container PortraitClockRow() {
    return Container(
        alignment: Alignment.center,
        child: zeClockSync(),
        width: ScreenSize.clockSize, // + 25,
        height: ScreenSize.clockSize);
  }
}

class PortraitDialRow extends StatelessWidget {
  final Widget gaugeType1;
  final Widget gaugeType2;

  PortraitDialRow({
    this.gaugeType1,
    this.gaugeType2,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(height: ScreenSize.safeBlockVertical * 4),
      PortraitGaugeRow(child: gaugeType1),
      SizedBox(height: ScreenSize.safeBlockVertical * 2),
      Container(
          alignment: Alignment.center,
          color: Colors.transparent,
          width: ScreenSize.clockSize, // + 25,
          height: ScreenSize.clockSize),
      SizedBox(height: ScreenSize.safeBlockVertical * 2),
      PortraitGaugeRow(child: gaugeType2),
    ]);
  }
}

class PortraitGaugeRow extends StatelessWidget {
  Widget child;
  PortraitGaugeRow({this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
      height: ScreenSize.gaugeSize - (ScreenSize.safeBlockVertical * 4),
    );
  }
}

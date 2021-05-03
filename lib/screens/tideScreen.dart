import 'dart:async';

import 'package:dart_date/dart_date.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:swipe_gesture_recognizer/swipe_gesture_recognizer.dart';
import 'package:tidey/components/barometer.dart';
import 'package:tidey/components/compass.dart';
import 'package:tidey/components/dsGauge.dart';
import 'package:tidey/components/fabMenu.dart';
import 'package:tidey/components/humidyGauge.dart';
import 'package:tidey/components/imageGauge.dart';
import 'package:tidey/components/temp.dart';
import 'package:tidey/components/zeClockSync.dart';
import 'package:tidey/const.dart';
import 'package:tidey/screens/settings.dart';
import 'package:tidey/screens/weatherToday.dart';
import 'package:timer_builder/timer_builder.dart';

Color marqueeColor = Colors.transparent;
bool marqueeCompleted = false;

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
      distance: 70.0,
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
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: Icon(Icons.settings),
                  title: Text(
                    'Settings',
                  ),
                  onTap: () =>
                      {Navigator.pushNamed(context, SettingsScreen.id)}),
              ListTile(
                leading: Icon(Icons.wb_sunny),
                title: Text('View Weather Table'),
                onTap: () => {Navigator.pushNamed(context, TodayScreen.id)},
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
              )
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
      child: LandscapeView(),
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
      gaugeType1: TempGauge(
          high: double.parse(globalWeather.dailyWeather[0].highTemp),
          low: double.parse(globalWeather.dailyWeather[0].lowTemp),
          conditionIcon: weatherDayIconMap[
              globalWeather.dailyWeather[0].hourly[0].weatherCode]),
      gaugeType2: HumidityGauge(
        gaugeValue: double.parse(globalWeather.dailyWeather[0].humidity),
      )),
  DialRow(
      gaugeType1: ImageGaugeNew(
        imageName: "sunset1.gif",
        textLabel: globalWeather.dailyWeather[0].sunrise,
        textBackgroundColor: Colors.transparent,
      ),
      gaugeType2: ImageGaugeNew(
        imageName: "sunset2.gif",
        textLabel: globalWeather.dailyWeather[0].sunset,
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
        textLabel: globalWeather.dailyWeather[0].moonPhase +
            "\nRise: " +
            globalWeather.dailyWeather[0].moonrise +
            "\nSet:" +
            globalWeather.dailyWeather[0].moonset,
        textPosition: 40,
        textBackgroundColor: Colors.transparent,
        fontSize: 20),
  ),
  DialRow(
    gaugeType1: DSGauge(
      gaugeDirection: globalWeather.dailyWeather[0].hourly[0].windDirection,
      gaugeValue: // 8.0,
          double.parse(globalWeather.dailyWeather[0].hourly[0].windSpeed),
    ),
    gaugeType2: DSGauge(
      gaugeType: "Waves",
      gaugeUnit: "ft",
      gaugeDirection: globalWeather.dailyWeather[0].windDirection,
      gaugeValue: // 5.0,
          double.parse(globalWeather.dailyWeather[0].waveHt),
      gaugeMax: 10,
      gaugeInterval: 1,
    ),
  ),
  DialRow(
    gaugeType1: ImageGaugeNew(
      imageName: "water.gif",
      textLabel: "Water " +
          globalWeather.dailyWeather[0].waterTemp +
//   weatherData.data.weather[0].hourly[0].waterTempF +
          " \u2109",
      textColor: Colors.black,
      textBackgroundColor: Colors.transparent,
    ),
    gaugeType2: BarometerGauge(
      current: double.parse(globalWeather.dailyWeather[0].hourly[0].pressure),
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
    counter = (counter + 1) % (gaugeSequenceList.length);
    setState(() {
      animationSwitcher = !animationSwitcher;
    });
    if (animationSwitcher) {
      // you need this funky method because animationCrossFade goes back and forth between one image and the other
      // so on each crossfade you have to update the image (and only that image) that you are bringing to foreground;
      myFirstWidget = gaugeSequenceList[counter];
    } else {
      mySecondWidget = gaugeSequenceList[counter];
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

class LandscapeTimerWidget extends StatefulWidget {
  @override
  _LandscapeTimerWidgetState createState() => _LandscapeTimerWidgetState();
}

class _LandscapeTimerWidgetState extends State<LandscapeTimerWidget> {
  Timer ted;

  int currentTransitionTime = 0;
  @override
  void initState() {
    super.initState();
    // timer = Timer.periodic(const Duration(milliseconds: 1000), _updateData);

    ted = Timer.periodic(const Duration(milliseconds: 1000), _bobX);
  }

  @override
  void dispose() {
    super.dispose();
    ted.cancel();
  }

  _bobX(Timer timer) {
    if (currentTransitionTime != userSettings.transitionTime) {
      setState(() {
        currentTransitionTime = userSettings.transitionTime;
      });
    }
  }

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

      return LandScapeSwapper2();
    });
  }
}

class LandscapeSwapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return gaugeSequenceList[counter];
  }
}

class LandScapeSwapper2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    switch (counter) {
      case 0:
        return DialRow(
          gaugeType1: TempGauge(
              high: double.parse(globalWeather.dailyWeather[0].highTemp),
              low: double.parse(globalWeather.dailyWeather[0].lowTemp),
              conditionIcon: weatherDayIconMap[
                  globalWeather.dailyWeather[0].hourly[0].weatherCode]),
          gaugeType2: BarometerGauge(
            current:
                double.parse(globalWeather.dailyWeather[0].hourly[0].pressure),
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
        return DialRow(
            gaugeType1: ImageGaugeNew(
              imageName: "sunset1.gif",
              textLabel: globalWeather.dailyWeather[0].sunrise,
              textBackgroundColor: Colors.transparent,
            ),
            gaugeType2: ImageGaugeNew(
              imageName: "sunset2.gif",
              textLabel: globalWeather.dailyWeather[0].sunset,
              textBackgroundColor: Colors.transparent,
            ));
        break;

      case 2:
        return DialRow(
          gaugeType1: ImageGaugeNew(
            imageName: getMoonImageName(),
            innerLineColor: Colors.transparent,
          ),
          //ImageGauge(imageName: "gaugeMoon.png", textLabel: ""),
          gaugeType2: ImageGaugeNew(
              imageName: "shootingStar.gif",
              innerLineColor: Colors.transparent,
              textLabel: globalWeather.dailyWeather[0].moonPhase +
                  "\nRise: " +
                  globalWeather.dailyWeather[0].moonrise +
                  "\nSet:" +
                  globalWeather.dailyWeather[0].moonset,
              textPosition: 40,
              textBackgroundColor: Colors.transparent,
              fontSize: 20),
        );
        break;

      case 3:
        return DialRow(
          gaugeType1: DSGauge(
            gaugeDirection:
                globalWeather.dailyWeather[0].hourly[0].windDirection,
            gaugeValue: // 8.0,
                double.parse(globalWeather.dailyWeather[0].hourly[0].windSpeed),
          ),
          gaugeType2: DSGauge(
            gaugeType: "Waves",
            gaugeUnit: "ft",
            gaugeDirection: globalWeather.dailyWeather[0].windDirection,
            gaugeValue: // 5.0,
                double.parse(globalWeather.dailyWeather[0].waveHt),
            gaugeMax: 10,
            gaugeInterval: 1,
          ),
        );
        break;
      case 4:
        return DialRow(
            gaugeType1: ImageGaugeNew(
              imageName: "water.gif",
              textLabel: "Water " +
                  globalWeather.dailyWeather[0].waterTemp +
                  //   weatherData.data.weather[0].hourly[0].waterTempF +
                  " \u2109",
              textColor: Colors.black,
              textBackgroundColor: Colors.transparent,
            ),
            gaugeType2: CompassGauge2());
      case 5:
        return DialRow(
            gaugeType1: ImageGaugeNew(
              imageName: "boat1.jpg",
            ),
            gaugeType2: ImageGaugeNew(
              imageName: "boat2.jpg",
            ));

      default:
        {
          print("Error");
          return DialRow(
              gaugeType1: ImageGaugeNew(
                imageName: "boat1.jpg",
              ),
              gaugeType2: ImageGaugeNew(
                imageName: "boat2.jpg",
              ));
        }
        break;
    }
//    return counter == 0
//        ? buildMyTideTable()
//        : SunTable(); // (moonPhaseImageName: "assets/images/fullMoon.jpg");
  }
}

class PortraitSwapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    switch (counter) {
      case 0:
        return PortraitDialRow(
          gaugeType1: TempGauge(
              high: double.parse(globalWeather.dailyWeather[0].highTemp),
              low: double.parse(globalWeather.dailyWeather[0].lowTemp),
              conditionIcon:
                  weatherDayIconMap[globalWeather.dailyWeather[0].weatherCode]),
          gaugeType2: BarometerGauge(
            current: double.parse(globalWeather.dailyWeather[0].pressure),
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
              textLabel: globalWeather.dailyWeather[0].sunrise,
              textPosition: 60,
            ),
            gaugeType2: ImageGaugeNew(
                imageName: "sunset2.gif",
                textPosition: 60,
                textLabel: globalWeather.dailyWeather[0].sunset));
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
              textLabel: globalWeather.dailyWeather[0].moonPhase +
                  "\nRise: " +
                  globalWeather.dailyWeather[0].moonrise +
                  "\nSet:" +
                  globalWeather.dailyWeather[0].moonset,
              textPosition: 40,
              textBackgroundColor: Colors.transparent,
              fontSize: 20),
        );
        break;

      case 3:
        return PortraitDialRow(
          gaugeType1: DSGauge(
            gaugeDirection:
                globalWeather.dailyWeather[0].hourly[0].windDirection,
            gaugeValue:
                double.parse(globalWeather.dailyWeather[0].hourly[0].windSpeed),
          ),
          gaugeType2: DSGauge(
            gaugeType: "Waves",
            gaugeUnit: "ft",
            gaugeDirection: globalWeather.dailyWeather[0].waveDirection,
            gaugeValue: double.parse(globalWeather.dailyWeather[0].waveHt),
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
                  globalWeather.dailyWeather[0].waterTemp +
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
      child: Stack(
        children: [
          PortraitTimerWidget(),
          Column(children: [
            SizedBox(height: ScreenSize.safeBlockVertical * 4),
            Container(
                height:
                    ScreenSize.gaugeSize - (ScreenSize.safeBlockVertical * 4)),
            SizedBox(height: ScreenSize.safeBlockVertical * 2),
            PortraitClockRow(),
            SizedBox(height: ScreenSize.safeBlockVertical * 2),
            Container(
                height:
                    ScreenSize.gaugeSize - (ScreenSize.safeBlockVertical * 4)),
          ]),
        ],
      ),
    );
  }

  Container PortraitClockRow() {
    return Container(
        alignment: Alignment.center,
        child: zeClockSync(),
        width: ScreenSize.clockSize + 25,
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
          width: ScreenSize.clockSize + 25,
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

// hello
class buildMyTideTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.blue,
      height: ScreenSize.safeBlockVertical * 45,

      child: Container(
        height: ScreenSize.safeBlockVertical * 45,
        width: ScreenSize.safeBlockHorizontal * 80,
        child: Column(
          children: [
            Text("Tides", style: kTableTitleTextStyle),
            SizedBox(height: 10),
//          Padding(
//            padding: const EdgeInsets.only(left: , right: 65),
//            child:
            Table(children: [
              tideTableRow(
                  day: 'Today',
                  time:
                      weatherData.data.weather[0].tides[0].tideData[0].tideTime,
                  level: (double.parse(weatherData
                      .data.weather[0].tides[0].tideData[0].tideHeightMt)),
                  direction: weatherData
                      .data.weather[0].tides[0].tideData[0].tideType),
              tideTableRow(
                  day: 'Today',
                  time:
                      weatherData.data.weather[0].tides[0].tideData[1].tideTime,
                  level: (double.parse(weatherData
                      .data.weather[0].tides[0].tideData[1].tideHeightMt)),
                  direction: weatherData
                      .data.weather[0].tides[0].tideData[1].tideType),
              tideTableRow(
                  day: 'Tomorrow',
                  time:
                      weatherData.data.weather[0].tides[0].tideData[2].tideTime,
                  level: (double.parse(weatherData
                      .data.weather[0].tides[0].tideData[2].tideHeightMt)),
                  direction: weatherData
                      .data.weather[0].tides[0].tideData[2].tideType),
              tideTableRow(
                  day: 'Tomorrow',
                  time:
                      weatherData.data.weather[0].tides[0].tideData[3].tideTime,
                  level: (double.parse(weatherData
                      .data.weather[0].tides[0].tideData[3].tideHeightMt)),
                  direction: weatherData
                      .data.weather[0].tides[0].tideData[3].tideType),
            ]),
            // mySubTile(kMySubTileData),
            //         ),
          ],
        ),
      ),
    );
  }
}

TableRow tideTableRow(
    {String day, String time, double level, String direction}) {
  print("Direction is $day,$time, $level,$direction");
  // static htInFeet = double.parse(level)/3.28084;
  final String pos = level > 2.0 ? "+" : "-";
  const fontScale = 5;
  return TableRow(
    children: [
      Text(day,
          style: TextStyle(
            fontSize: ScreenSize.safeBlockHorizontal * fontScale,
            color: Colors.white,
          )),
      Text(
        time,
        style: TextStyle(
          fontSize: ScreenSize.safeBlockHorizontal * fontScale,
          color: Colors.white,
        ),
        textAlign: TextAlign.right,
      ),
      direction == "LOW"
          ? RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                /*defining default style is optional */
                children: <TextSpan>[
                  TextSpan(
                    text:
                        ("    " + (level * 3.28084).toStringAsFixed(2)) + 'ft ',
                    style: TextStyle(
                      fontSize: ScreenSize.safeBlockHorizontal * fontScale,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                      text: 'L',
                      style: TextStyle(
                        fontSize: ScreenSize.safeBlockHorizontal * fontScale,
                        color: Colors.red,
                      )),
                ],
              ),
            )
          : RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                /*defining default style is optional */
                children: <TextSpan>[
                  TextSpan(
                    text:
                        ("    " + (level * 3.28084).toStringAsFixed(2)) + 'ft ',
                    style: TextStyle(
                      fontSize: ScreenSize.safeBlockHorizontal * fontScale,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                      text: 'H',
                      style: TextStyle(
                        fontSize: ScreenSize.safeBlockHorizontal * fontScale,
                        color: Colors.green,
                      )),
                ],
              ),
            ),
    ],
  );
}

int counter = 0;

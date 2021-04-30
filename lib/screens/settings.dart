import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipe_gesture_recognizer/swipe_gesture_recognizer.dart';
import 'package:tidey/const.dart';
import 'package:tidey/screens/help.dart';
import 'package:tidey/screens/webWeather.dart';
import 'package:tidey/services/localWeather.dart';
import 'package:tidey/services/locationServices.dart';
import 'package:tidey/services/marineWeather.dart';
import 'package:tidey/services/tideServices.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  static const String id = 'SettingsScreen';
  @override
  _settingsScreenState createState() => _settingsScreenState();
}

class _settingsScreenState extends State<SettingsScreen> {
  double _currentSliderValue = userSettings.transitionTime.toDouble();
  int _sliding = userSettings.imperialUnits ? 0 : 1;
  String selectedRingMode = chimeTypeEnumtoString[userSettings.chimeSelected];
  SharedPreferences prefs;
  bool _chimeEnabled = userSettings.chimeOn;
  bool _sleepTimerEnabled = userSettings.chimeDoNotDisturb;
  TimeOfDay _time = TimeOfDay(hour: 7, minute: 15);
  bool _alarmOn = userSettings.alarmOn;
  bool _chimeDoNotDisturb = userSettings.chimeDoNotDisturb;
  TimeOfDay _sleepTime = userSettings.sleepTime;
  TimeOfDay _wakeTime = userSettings.sleepTime;
  TimeOfDay _alarmTime = userSettings.sleepTime;
  bool _useCurrentPosition = userSettings.useCurrentPosition;
  final _formKey = GlobalKey<FormState>();

  void initState() {
    // TODO: implement initState
    super.initState();

    openPerfs();
  }

  void openPerfs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: SwipeGestureRecognizer(
          onSwipeLeft: () {
            Navigator.of(context).pop();
          },
          child: ListView(
            children: [
              MenuListTileWithSwitch(
                  title: (userSettings.useCurrentPosition)
                      ? "Location Use Current Position (Enabled)"
                      : "Location Use Current Position(Disabled)",
                  value: userSettings.chimeOn,
                  icon: Icons.map,
                  onTap: () {
                    setState(() {
                      userSettings.useCurrentPosition =
                          !userSettings.useCurrentPosition;
                      _useCurrentPosition = userSettings.useCurrentPosition;
                      //     prefs.setBool('chimeOn', userSettings.chimeOn);
                    });
                  }),
              Visibility(
                visible: !_useCurrentPosition,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          width: 300,
                          child: TextFormField(
                              decoration: InputDecoration(
                                // prefix:
                                //    Text("Enter Latitude", style: kTextSettingsStyle),
                                labelText: "Enter Latitude",
                                labelStyle: kTextSettingsStyle,

                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 2.0),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                hintText: 'between -90 and 90',
                              ),
                              textAlign: TextAlign.left,
                              keyboardType: TextInputType.number,
                              validator: (text) {
                                if (text == null) {
                                  return null;
                                }
                                final n = num.tryParse(text);
                                if (n == null) {
                                  return 'Error: Latitude must be a number between -90 and 90';
                                }
                                if (n < -90 || n > 90) {
                                  return 'Error: Latitude must be a number between -90 and 90';
                                }
                                return null;
                              }),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            // TODO submit
                          }
                        },
                        child: Text('Submit',
                            style: TextStyle(color: Colors.black)),
                      )
                    ],
                  ),
                ),
              ),
//              TextField(
//                decoration: InputDecoration(
//                    labelText: "Enter Latitude",
//                    hintText: ("Must be between -90 and 90)")),
//                keyboardType: TextInputType.number,
//              ),
              MenuListTile(
                title: "View Current Weather on Web",
                icon: Icons.cloud_circle_outlined,
                onTap: () => {Navigator.pushNamed(context, WebWeather.id)},
              ),
              Divider(
                height: 10,
                thickness: 5,
              ),
              MenuListTile(
                title: "Refresh Weather Data ",
                icon: Icons.refresh,
                onTap: () => {getMyLocation()},
              ),
              Divider(
                height: 10,
                thickness: 5,
              ),

//              ListTile(
//                leading: Icon(
//                  Icons.straighten,
//                  size: kIconSettingSize,
//                  color: Colors.white,
//                ),
//                title: Text(
//                  "Select Untis",
//                  style: kTextSettingsStyle,
//                ),
//                trailing: CupertinoSlidingSegmentedControl(
//                    children: {
//                      0: Text(
//                        'Imperial',
//                        style: TextStyle(fontSize: kTextSettingSize),
//                      ),
//                      1: Text(
//                        'Metric',
//                        style: TextStyle(fontSize: kTextSettingSize),
//                      ),
//                    },
//                    backgroundColor: Colors.white30,
//                    groupValue: _sliding,
//                    onValueChanged: (newValue) {
//                      setState(() {
//                        _sliding = newValue;
//                        _sliding == 0
//                            ? userSettings.imperialUnits = true
//                            : userSettings.imperialUnits = false;
//                        prefs.setBool(
//                            'imperialUnits', userSettings.imperialUnits);
//                      });
//                    }),
//              ),
//              Divider(
//                height: 10,
//                thickness: 5,
//              ),
              MenuListTileWithSwitch(
                  title: (userSettings.chimeOn)
                      ? "Ship Bell (Enabled)"
                      : "Ship Bell (Disabled)",
                  value: userSettings.chimeOn,
                  icon: Icons.notifications,
                  onTap: () {
                    setState(() {
                      userSettings.chimeOn = !userSettings.chimeOn;
                      _chimeEnabled = userSettings.chimeOn;
                      print("Selected " + userSettings.chimeOn.toString());
                      prefs.setBool('chimeOn', userSettings.chimeOn);
                    });
                  }),
              Visibility(
                visible: _chimeEnabled,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Column(
                    children: [
                      MenuListTileWithSwitch(
                          title: (userSettings.chimeDoNotDisturb)
                              ? "Sleep Mode (Enabled)"
                              : "Sleep at Night",
                          value: userSettings.chimeDoNotDisturb,
                          icon: Icons.notifications_paused,
                          onTap: () {
                            setState(() {
                              userSettings.chimeDoNotDisturb =
                                  !userSettings.chimeDoNotDisturb;
                              _chimeDoNotDisturb =
                                  userSettings.chimeDoNotDisturb;
                              print("Selected " +
                                  userSettings.chimeDoNotDisturb.toString());
                              prefs.setBool('doNotDisturb',
                                  userSettings.chimeDoNotDisturb);
                            });
                          }),
                      Visibility(
                        visible: _chimeDoNotDisturb,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: MenuListTile(
                            title: "Set Sleep Time (" +
                                _sleepTime.format(context) +
                                ")",
                            //  icon: Icons.alarm,
                            onTap: () => {_selectSleepTime()},
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _chimeDoNotDisturb,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: MenuListTile(
                            title:
                                "Wake Time (" + _wakeTime.format(context) + ")",
                            //  icon: Icons.alarm,
                            onTap: () => {_selectWakeTime()},
                          ),
                        ),
                      ),
                      MenuListTile(
                        title: "Bell Ring Schedule (${selectedRingMode})",
                        icon: Icons.notifications_active,
                        onTap: () => {
                          showMaterialScrollPicker(
                              headerColor: kAppBlueColor,
                              maxLongSide: 400,
                              context: context,
                              title: "Select Bell Ring Schedule",
                              items: ringOptions,
                              selectedValue: selectedRingMode,
                              onChanged: (value) {
                                setState(() {
                                  selectedRingMode = value;
                                });
                                userSettings.chimeSelected =
                                    chimeTypeStringToEnum[value];
                                print("Selected " +
                                    userSettings.chimeSelected.toString());
                                prefs.setString('chimeSelected', value);
                              })
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 10,
                thickness: 5,
              ),
              MenuListTileWithSwitch(
                  title: (userSettings.alarmOn)
                      ? "Alarm (Enabled)"
                      : "Alarm (Disabled)",
                  value: userSettings.alarmOn,
                  icon: Icons.notifications,
                  onTap: () {
                    setState(() {
                      userSettings.alarmOn = !userSettings.alarmOn;
                      _alarmOn = userSettings.alarmOn;
                      print("Selected " + userSettings.alarmOn.toString());
                      //    prefs.setBool('alarmOn', userSettings.alarmOn);
                    });
                  }),
              Visibility(
                visible: _alarmOn,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: MenuListTile(
                    title: "Alarm (" + _alarmTime.format(context) + ")",
                    icon: Icons.alarm,
                    onTap: () => {_selectAlarmTime()},
                  ),
                ),
              ),

              Divider(
                height: 10,
                thickness: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.timer,
                      size: kIconSettingSize,
                      color: Colors.white,
                    ),
                    Text(
                      " Seconds between Screens (" +
                          _currentSliderValue.round().toString() +
                          ")     5",
                      style: kTextSettingsStyle,
                    ),
                    Slider(
                      value: _currentSliderValue,
                      min: 5,
                      max: 60,
                      divisions: 55,
                      label: _currentSliderValue.round().toString(),
                      onChanged: (double value) {
                        setState(() {
                          _currentSliderValue = value;
                          userSettings.transitionTime = value.round();
                          prefs.setInt(
                              'transitionTime', userSettings.transitionTime);
                        });
                      },
                    ),
                    Text("60 Seconds", style: kTextSettingsStyle)
                  ],
                ),
              ),
              Container(
                height: 70,
                width: double.infinity,
                color: kHeadingColor,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, bottom: 8),
                    child: Text("Information",
                        style: TextStyle(
                          //   backgroundColor: Colors.grey,
                          fontSize: 20,
                        )),
                  ),
                ),
              ),
              MenuListTile(
                title: "Tell a friend about Tidey",
                icon: Icons.share,
                onTap: () => {
                  Share.share(
                      'Download the Tidey app its an awesome Marine Weather Clock',
                      subject: 'Check Out Tidey Marine Weather Clock')
                },
              ),
              Divider(
                height: 10,
                thickness: 5,
              ),
              MenuListTile(
                  title: "Contact Us",
                  icon: Icons.email,
                  onTap: () => {sendemail()}),
              Divider(
                height: 10,
                thickness: 5,
              ),
              MenuListTile(
                title: "About",
                icon: Icons.info_outline_rounded,
                onTap: () => {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text("Tidey"),
                      content: Text("Version " +
                          packageInfo.version +
                          "Build " +
                          packageInfo.buildNumber +
                          "\n\nDeveloped by Amberjack Labs\n"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child: Text("okay"),
                        ),
                      ],
                    ),
                  )
                },
              ),
              Divider(
                height: 10,
                thickness: 5,
              ),
              MenuListTile(
                title: "Help",
                icon: Icons.help,
                onTap: () => {Navigator.pushNamed(context, HelpScreen.id)},
              ),
              Divider(
                height: 10,
                thickness: 5,
              ),
              ListTile(
                title: Text(
                  "Version",
                  style: kTextSettingsStyle,
                ),
                trailing: Text(
                  packageInfo.version + "(" + packageInfo.buildNumber + ")",
                  style: kTextSettingsStyle,
                ),
              ),
              Divider(
                height: 10,
                thickness: 5,
              ),
            ],
          ),
        ),
      ),
    );
    SafeArea(
      child: Column(
        children: [
          MenuListTile(
              title: "About " + packageInfo.appName,
              onTap: () => print("Hello")),
        ],
      ),
    );
  }

  void _selectAlarmTime() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: _alarmTime,
    );
    if (newTime != null) {
      setState(() {
        _alarmTime = newTime;
      });
    }
  }

  void _selectWakeTime() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: _wakeTime,
    );
    if (newTime != null) {
      setState(() {
        _wakeTime = newTime;
      });
    }
  }

  void _selectSleepTime() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: _sleepTime,
    );
    if (newTime != null) {
      setState(() {
        _sleepTime = newTime;
      });
    }
  }

  AlertDialog buildAlertDialog(BuildContext context) {
    return AlertDialog(
      title: Text("Tidey Version 1.0"),
      content:
          Text("Would you like to click ok, this is a really long tet message"),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Done'))
      ],
    );
  }

  List<String> ringOptions = <String>[
    chimeTypeEnumtoString[ChimeType.single],
    chimeTypeEnumtoString[ChimeType.hourly],
    chimeTypeEnumtoString[ChimeType.nautical],
  ];

  int _selectedValue = 0;
  void _showPicker(BuildContext ctx) {
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
              width: 300,
              height: 250,
              child: CupertinoPicker(
                backgroundColor: Colors.white,
                itemExtent: 30,
                scrollController: FixedExtentScrollController(initialItem: 1),
                children: [
                  Text('Single ring on the hour'),
                  Text('Multiple hourly ring based on time '),
                  Text('Traditional Ship Bell Code'),
                ],
                onSelectedItemChanged: (value) {
                  setState(() {
                    _selectedValue = value;
                  });
                },
              ),
            ));
  }

  void getMyLocation() async {
    Location location = Location();
    await location.getCurrentLocation();
    WeatherService weatherService = WeatherService();
    await weatherService.getMarineData();
    LocalWeatherService localWeatherService = LocalWeatherService();
    await localWeatherService.getLocalWeatherData();
    mySineWaveData msw = mySineWaveData();
    await msw.computeTidesForPainting();
  }

  sendemail() async {
    const url =
        'mailto:support@amberjacklabs.com?subject=Hi from Tidey\'s #1 Fan&body=Hello';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch email';
    }
  }
}

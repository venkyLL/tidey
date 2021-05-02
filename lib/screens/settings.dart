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
  double _countDownSliderValue = 5;
  int _sliding = userSettings.imperialUnits ? 0 : 1;
  String selectedRingMode = chimeTypeEnumtoString[userSettings.chimeSelected];
  SharedPreferences prefs;
  bool _chimeEnabled = userSettings.chimeOn;
  bool _sleepTimerEnabled = userSettings.chimeDoNotDisturb;
  bool _alarmOn = userSettings.alarmOn;
  bool _chimeDoNotDisturb = userSettings.chimeDoNotDisturb;
  TimeOfDay _sleepTime = userSettings.sleepTime;
  TimeOfDay _wakeTime = userSettings.wakeTime;
  TimeOfDay _alarmTime = userSettings.alarmTime;
  bool _useCurrentPosition = userSettings.useCurrentPosition;
  String _city = globalWeather.city;
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  //var myController = TextEditingController();

  void initState() {
    // TODO: implement initState
    super.initState();

    openPerfs();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    // myController.dispose();
    super.dispose();
  }

  void openPerfs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: !globalWeather.weatherAPIError
                          ? Text(
                              "Most Recent Weather Report From\n" +
                                  _city +
                                  ", " +
                                  globalWeather.country +
                                  "\n" +
                                  globalWeather.loadDateString,
                              style: kTextSettingsStyle,
                              textAlign: TextAlign.center,
                            )
                          : Text(
                              "Weather data could not be loaded.\n"
                              "Please check network or change location.",
                              style: TextStyle(
                                  fontSize: kTextSettingSize,
                                  color: Colors.yellow),
                              textAlign: TextAlign.center,
                            ),
                    ),
                    Divider(
                      height: 10,
                      thickness: 5,
                    ),
                    MenuListTile(
                      title: "Refresh Weather Data ",
                      icon: Icons.refresh,
                      onTap: () => {getWeather()},
                    ),
                    Divider(
                      height: 10,
                      thickness: 5,
                    ),

                    MenuListTileWithSwitch(
                        title: (userSettings.useCurrentPosition)
                            ? "Use Current Location (Enabled)"
                            : "Use Current Location (Disabled)",
                        value: userSettings.useCurrentPosition,
                        icon: Icons.location_on,
                        onTap: () {
                          setState(() {
                            userSettings.useCurrentPosition =
                                !userSettings.useCurrentPosition;
                            _useCurrentPosition =
                                userSettings.useCurrentPosition;
                            prefs.setBool(userSettings.keyUseCurrentPosition,
                                userSettings.useCurrentPosition);
                            if (userSettings.useCurrentPosition) {
                              getWeather();
                            }
                            ;
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
                                // width: ScreenSize.screenWidth - 20,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 180,
                                      child: Text("Enter Latitude:     ",
                                          style: kTextSettingsStyle),
                                    ),
                                    SizedBox(
                                      width: 180,
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: TextFormField(
                                            style:
                                                TextStyle(color: Colors.black),
                                            initialValue: userSettings.manualLat
                                                .toString(),
                                            decoration: InputDecoration(
                                              // border: InputBorder.none,
                                              filled: true,
                                              fillColor: Colors.grey[200],
                                              errorStyle: TextStyle(
                                                  color: Colors.red,
                                                  backgroundColor: Colors.white,
                                                  fontSize: 15),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.white,
                                                    width: 2.0),
//                                          borderRadius:
//                                              BorderRadius.circular(25.0),
                                              ),
                                              border: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.white,
                                                    width: 2.0),
//                                          borderRadius:
//                                              BorderRadius.circular(25.0),
                                              ),

                                              hintText: '-90 ... 90',
                                              hoverColor: Colors.white,
                                            ),
                                            textAlign: TextAlign.center,
                                            keyboardType: TextInputType.number,
                                            onSaved: (text) {
                                              userSettings.manualLat =
                                                  double.parse(text);
                                              prefs.setDouble(
                                                  userSettings.keyManualLat,
                                                  userSettings.manualLat);
                                              globalLatitude = text;
                                            },
                                            validator: (text) {
                                              if (text == null) {
                                                return null;
                                              }
                                              final n = num.tryParse(text);
                                              if (n == null) {
                                                return 'Invalid Latitude';
                                              }
                                              if (n < -90 || n > 90) {
                                                return 'Invalid Latitude';
                                              }
                                              return null;
                                            }),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Container(
                                // width: ScreenSize.screenWidth - 20,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 180,
                                      child: Text("Enter Longitude:  ",
                                          style: kTextSettingsStyle),
                                    ),
                                    SizedBox(
                                      width: 180,
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: TextFormField(
                                            initialValue: userSettings
                                                .manualLong
                                                .toString(),
                                            style:
                                                TextStyle(color: Colors.black),
                                            decoration: InputDecoration(
                                              // border: InputBorder.none,
                                              filled: true,
                                              fillColor: Colors.grey[200],
                                              errorStyle: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 15,
                                                  backgroundColor:
                                                      Colors.white),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.white,
                                                    width: 2.0),
//                                          borderRadius:
//                                              BorderRadius.circular(25.0),
                                              ),
                                              border: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.white,
                                                    width: 2.0),
//                                          borderRadius:
//                                              BorderRadius.circular(25.0),
                                              ),

                                              hintText: '-180...180',
                                              hoverColor: Colors.white,
                                            ),
                                            textAlign: TextAlign.center,
                                            keyboardType: TextInputType.number,
                                            onSaved: (text) {
                                              userSettings.manualLong =
                                                  double.parse(text);
                                              prefs.setDouble(
                                                  userSettings.keyManualLong,
                                                  userSettings.manualLong);
                                              globalLongitude = text;
                                            },
                                            validator: (text) {
                                              if (text == null) {
                                                return null;
                                              }
                                              final n = num.tryParse(text);
                                              if (n == null) {
                                                return 'Invalid Longitude';
                                              }
                                              if (n < -180 || n > 180) {
                                                return 'Invalid Longitude';
                                              }
                                              return null;
                                            }),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  // TODO submit
                                  getWeather();
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
                    Divider(
                      height: 10,
                      thickness: 5,
                    ),
                    MenuListTile(
                      title: "View Current Weather on Web",
                      icon: Icons.cloud_circle_outlined,
                      onTap: () =>
                          {Navigator.pushNamed(context, WebWeather.id)},
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
                            print(
                                "Selected " + userSettings.chimeOn.toString());
                            prefs.setBool(
                                userSettings.keyChimeOn, userSettings.chimeOn);
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
                                        userSettings.chimeDoNotDisturb
                                            .toString());
                                    prefs.setBool(
                                        userSettings.keyChimeDoNotDisturb,
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
                                  title: "Wake Time (" +
                                      _wakeTime.format(context) +
                                      ")",
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
                                          userSettings.chimeSelected
                                              .toString());
                                      prefs.setString(
                                          userSettings.keyChimeSelected, value);
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

                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.av_timer,
                            size: kIconSettingSize,
                            color: Colors.white,
                          ),
                          Text(
                            " Timer (" +
                                _countDownSliderValue.round().toString() +
                                ")",
                            style: kTextSettingsStyle,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Row(
                        children: [
                          Text("0", style: kTextSettingsStyle),
                          Slider(
                            value: _countDownSliderValue,
                            min: 0,
                            max: 120,
                            divisions: 120,
                            label: _countDownSliderValue.round().toString(),
                            onChanged: (double value) {
                              setState(() {
                                _countDownSliderValue = value;
                                userSettings.countDownTimer = value.round();
                              });
                            },
                          ),
                          Text("120 Minutes", style: kTextSettingsStyle),
                        ],
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
                            print(
                                "Selected " + userSettings.alarmOn.toString());
                            prefs.setBool(
                                userSettings.keyAlarmOn, userSettings.alarmOn);
                          });
                        }),
                    Visibility(
                      visible: _alarmOn,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25.0),
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
                                ")",
                            style: kTextSettingsStyle,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Row(
                        children: [
                          Text("5", style: kTextSettingsStyle),
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
                                prefs.setInt(userSettings.keyTransitionTime,
                                    userSettings.transitionTime);
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
                      onTap: () => {_showAlert(context)},
                    ),
                    Divider(
                      height: 10,
                      thickness: 5,
                    ),
                    MenuListTile(
                      title: "Help",
                      icon: Icons.help,
                      onTap: () =>
                          {Navigator.pushNamed(context, HelpScreen.id)},
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
                        packageInfo.version +
                            "(" +
                            packageInfo.buildNumber +
                            ")",
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

  Future _showAlert(BuildContext context) {
    return showDialog(
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
        userSettings.alarmTime = _alarmTime;
        prefs.setInt(userSettings.keyAlarmTimeHour, _alarmTime.hour);
        prefs.setInt(userSettings.keyAlarmTimeMin, _alarmTime.minute);
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
        userSettings.wakeTime = _wakeTime;
        prefs.setInt(userSettings.keyWakeTimeHour, _wakeTime.hour);
        prefs.setInt(userSettings.keyWakeTimeMin, _wakeTime.minute);
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
        userSettings.sleepTime = _sleepTime;
        prefs.setInt(userSettings.keySleepTimeHour, _sleepTime.hour);
        prefs.setInt(userSettings.keySleepTimeMin, _sleepTime.minute);
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

  void getWeather() async {
    setState(() {
      _loading = true;
    });
    Location location = Location();
    await location.getCurrentLocation();
    WeatherService weatherService = WeatherService();
    await weatherService.getMarineData();
    LocalWeatherService localWeatherService = LocalWeatherService();
    await localWeatherService.getLocalWeatherData();
    setState(() {
      _city = globalWeather.city;
    });
    mySineWaveData msw = mySineWaveData();
    await msw.computeTidesForPainting();
    setState(() {
      _loading = false;
    });
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

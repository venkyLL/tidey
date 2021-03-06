import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:open_appstore/open_appstore.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:string_validator/string_validator.dart';
import 'package:swipe_gesture_recognizer/swipe_gesture_recognizer.dart';
import 'package:tidey/const.dart';
import 'package:tidey/screens/help.dart';
import 'package:tidey/screens/webWeather.dart';
import 'package:tidey/services/localWeather.dart';
import 'package:tidey/services/locationServices.dart';
import 'package:tidey/services/marineWeather.dart';
import 'package:tidey/services/tideServices.dart';
import 'package:tidey/services/weatherLocation.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  static const String id = 'SettingsScreen';
  @override
  _settingsScreenState createState() => _settingsScreenState();
}

class _settingsScreenState extends State<SettingsScreen> {
  double _currentSliderValue = userSettings.transitionTime.toDouble();
  double _countDownSliderValue = 5;
  bool _timerOn = false;
  bool _countDownStart = userSettings.countDownStart;
  int _currentValue = userSettings.countDownTimer;
  int _countDownTimeRemaining = UserSettings().countDownTimerSecondsRemaining;
  int _sliding = userSettings.imperialUnits ? 0 : 1;
  String selectedRingMode = chimeTypeEnumtoString[userSettings.chimeSelected];
  SharedPreferences prefs;
  bool _chimeEnabled = userSettings.chimeOn;
  bool _sleepTimerEnabled = userSettings.chimeDoNotDisturb;
  bool _alarmOn = userSettings.alarmOn;
  bool _chimeDoNotDisturb = userSettings.chimeDoNotDisturb;
  ImageProvider _image0;
  ImageProvider _image1;
  ImageProvider _image2;
  ImageProvider _image3;

  TimeOfDay _sleepTime = userSettings.sleepTime;
  TimeOfDay _wakeTime = userSettings.wakeTime;
  TimeOfDay _alarmTime = userSettings.alarmTime;
  bool _useCurrentPosition = userSettings.useCurrentPosition;
  String _city = globalWeather.city;
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  var myController = TextEditingController();
  var durationController = TextEditingController();
  bool _loading = false;
  Timer ted;
  //var myController = TextEditingController();
  final adsSnackBar = SnackBar(
      // backgroundColor: (Colors.red),
      content: Text(
          'Changes saved. Exit and Restart Tidey to enable advertising change. '),
      duration: const Duration(milliseconds: 3000));

  void initState() {
    // TODO: implement initState
    super.initState();
    myController = TextEditingController(text: userSettings.marqueeText);
    durationController =
        TextEditingController(text: userSettings.transitionTime.toString());
    setState(() {
      _countDownTimeRemaining = userSettings.countDownTimerSecondsRemaining;
    });
    if (_countDownTimeRemaining != 0 && _countDownStart) {
      ted = Timer.periodic(const Duration(milliseconds: 1000), _bobX);
      // _countDownStart = true;
    }
    openPerfs();
    _image0 = getGaugeImage(0);
    _image1 = getGaugeImage(1);
    _image2 = getGaugeImage(2);
    _image3 = getGaugeImage(3);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    print("She entered " + myController.text);
    userSettings.marqueeText = myController.text;
    marqueeString = userSettings.showWeather
        ? "                                                                     " +
            "                                                             Tidey by Amberjack Labs" +
            marqueeSpacer +
            userSettings.marqueeText +
            marqueeSpacer +
            tideMarqueeString +
            weatherMarqueeString +
            "  "
        : "                                                                     " +
            "                                                             Tidey by Amberjack Labs" +
            marqueeSpacer +
            userSettings.marqueeText;

    prefs.setString(userSettings.keyMarqueeText, userSettings.marqueeText);
    print("Transition Time set to " + durationController.text);
    userSettings.transitionTime = int.parse(durationController.text);
    prefs.setInt(userSettings.keyTransitionTime, userSettings.transitionTime);
    myController.dispose();
    durationController.dispose();
    super.dispose();
    if (ted.isActive) {
      ted.cancel();
    }
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
              child: SwipeGestureRecognizer(
                onSwipeLeft: () {
                  Navigator.of(context).pop();
                },
                child: ListView(
                  children: [
                    SizedBox(
                      height: ScreenSize.hasNotch ? 60 : 0,
                      width: ScreenSize.hasNotch ? 60 : 0,
                    ),
                    Visibility(
                      visible: true, // globalNetworkAvailable,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: !globalWeather.weatherAPIError
                            ? Text(
                                "Most Recent Weather Report From\n" +
                                    _city +
                                    ", " +
                                    globalWeather.region +
                                    " " +
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
                    ),
                    Visibility(
                      visible: false, // !globalNetworkAvailable,
                      child: Text(
                        globalNeworkErrorMessage,
                        style: TextStyle(
                            fontSize: kTextSettingSize, color: Colors.yellow),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Divider(
                      height: 10,
                      thickness: 5,
                    ),
                    Visibility(
                      visible: true, // globalNetworkAvailable
                      child: MenuListTile(
                        title: "Refresh Weather Data ",
                        icon: Icons.refresh,
                        onTap: () => {getWeather()},
                      ),
                    ),
                    Divider(
                      height: 10,
                      thickness: 5,
                    ),

                    Visibility(
                      visible: true, // globalNetworkAvailable
                      child: MenuListTileWithSwitch(
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
                              prefs.setBool(userSettings.keyUseCity, false);
                              if (userSettings.useCurrentPosition) {
                                getWeather();
                                // globalWeather.weatherAPIError = true;
                              }
                              ;
                            });
                          }),
                    ),
                    Visibility(
                      visible: !_useCurrentPosition,
                      child: Form(
                        key: _formKey3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8),
                              child: Container(
                                // width: ScreenSize.screenWidth - 20,
                                child: Column(
                                  children: [
//                                    SizedBox(
//                                      // width: 180,
//                                      child: Align(
//                                        alignment: Alignment.center,
//                                        child: Text("Enter City/State or Zip",
//                                            style: kTextSettingsStyle),
//                                      ),
//                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: TextFormField(
                                          style: TextStyle(color: Colors.white),
                                          initialValue: globalWeather.city +
                                              "," +
                                              globalWeather.region,
                                          decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 8.0),
//                                               border: inputBorder(
//                                                   borderSide: const BorderSide(
//                                                       color: Colors.white,
//                                                       width: 2.0),),
                                              //   filled: true,
                                              fillColor: Colors.grey[100],
                                              errorStyle: TextStyle(
                                                  color: Colors.red,
                                                  backgroundColor: Colors.white,
                                                  fontSize: 15),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.white,
                                                    width: 2.0),
                                                //  borderRadius:
                                                //  BorderRadius.circular(25.0),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.white,
                                                    width: 2.0),
                                              ),
//                                          borderRadius:
//                                              BorderRadius.circular(25.0),
                                              //      ),

                                              //  hintText: 'Marsh Harbour, Bahamas',
                                              hoverColor: Colors.white,
                                              labelStyle: TextStyle(
                                                  color: Colors.white),
                                              labelText:
                                                  "  Enter City/State or Postal Code:"),
                                          //
//                                            keyboardType:
//                                                TextInputType.numberWithOptions(
//                                                    decimal: true),

                                          textAlign: TextAlign.center,
                                          onSaved: (text) {
                                            String _location =
                                                text.replaceAll(" ", "+");

                                            userSettings.cityString = _location;
                                            userSettings.useCity = true;
                                            prefs.setBool(
                                                userSettings.keyUseCity,
                                                userSettings.useCity);
                                            prefs.setString(
                                                userSettings.keyCityString,
                                                userSettings.cityString);
                                          },
//                                            validator: (text) {
//                                              if (text == null) {
//                                                return null;
//                                              }
//                                              final n = num.tryParse(text);
//                                              if (n == null) {
//                                                return 'Invalid Latitude';
//                                              }
//                                              if (n < -90 || n > 90) {
//                                                return 'Invalid Latitude';
//                                              }
//                                              return null;
//                                            }),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: kHeadingColor, // background
                                onPrimary: Colors.white, // foreground
                              ),
                              onPressed: () {
                                _formKey3.currentState.save();
                                // TODO submit
                                getWeatherName();
                              },
                              child: Text('Submit',
                                  style: TextStyle(color: Colors.black)),
                            )
                          ],
                        ),
                      ),
                    ),
//                    Visibility(
//                      visible: !_useCurrentPosition,
//                      child: Form(
//                        key: _formKey,
//                        child: Column(
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          children: <Widget>[
//                            Padding(
//                              padding: const EdgeInsets.only(left: 8.0),
//                              child: Container(
//                                // width: ScreenSize.screenWidth - 20,
//                                child: Row(
//                                  children: [
//                                    SizedBox(
//                                      width: 180,
//                                      child: Text("Enter Latitude:     ",
//                                          style: kTextSettingsStyle),
//                                    ),
//                                    SizedBox(
//                                      width: 180,
//                                      child: Padding(
//                                        padding: const EdgeInsets.all(20.0),
//                                        child: TextFormField(
//                                            style:
//                                                TextStyle(color: Colors.black),
//                                            initialValue: userSettings.manualLat
//                                                .toString(),
//                                            decoration: InputDecoration(
//                                              contentPadding:
//                                                  EdgeInsets.symmetric(
//                                                      vertical: 8.0),
//                                              // border: InputBorder.none,
//                                              filled: true,
//                                              fillColor: Colors.grey[200],
//                                              errorStyle: TextStyle(
//                                                  color: Colors.red,
//                                                  backgroundColor: Colors.white,
//                                                  fontSize: 15),
//                                              focusedBorder: OutlineInputBorder(
//                                                borderSide: const BorderSide(
//                                                    color: Colors.white,
//                                                    width: 2.0),
//                                                borderRadius:
//                                                    BorderRadius.circular(25.0),
//                                              ),
//                                              border: OutlineInputBorder(
//                                                borderSide: const BorderSide(
//                                                    color: Colors.white,
//                                                    width: 2.0),
////                                          borderRadius:
////                                              BorderRadius.circular(25.0),
//                                              ),
//
//                                              hintText: '-90 ... 90',
//                                              hoverColor: Colors.white,
//                                            ),
//                                            textAlign: TextAlign.center,
//                                            keyboardType:
//                                                TextInputType.numberWithOptions(
//                                                    decimal: true),
//                                            onSaved: (text) {
//                                              userSettings.manualLat =
//                                                  double.parse(text);
//                                              prefs.setDouble(
//                                                  userSettings.keyManualLat,
//                                                  userSettings.manualLat);
//                                              globalLatitude = text;
//                                            },
//                                            validator: (text) {
//                                              if (text == null) {
//                                                return null;
//                                              }
//                                              final n = num.tryParse(text);
//                                              if (n == null) {
//                                                return 'Invalid Latitude';
//                                              }
//                                              if (n < -90 || n > 90) {
//                                                return 'Invalid Latitude';
//                                              }
//                                              return null;
//                                            }),
//                                      ),
//                                    ),
//                                  ],
//                                ),
//                              ),
//                            ),
//                            Padding(
//                              padding: const EdgeInsets.only(left: 8.0),
//                              child: Container(
//                                // width: ScreenSize.screenWidth - 20,
//                                child: Row(
//                                  children: [
//                                    SizedBox(
//                                      width: 180,
//                                      child: Text("Enter Longitude:  ",
//                                          style: kTextSettingsStyle),
//                                    ),
//                                    SizedBox(
//                                      width: 180,
//                                      child: Padding(
//                                        padding: const EdgeInsets.all(20.0),
//                                        child: TextFormField(
//                                            initialValue: userSettings
//                                                .manualLong
//                                                .toString(),
//                                            style:
//                                                TextStyle(color: Colors.black),
//                                            decoration: InputDecoration(
//                                              contentPadding:
//                                                  EdgeInsets.symmetric(
//                                                      vertical: 8.0),
//                                              // border: InputBorder.none,
//                                              filled: true,
//                                              fillColor: Colors.grey[200],
//                                              errorStyle: TextStyle(
//                                                  color: Colors.red,
//                                                  fontSize: 15,
//                                                  backgroundColor:
//                                                      Colors.white),
//                                              focusedBorder: OutlineInputBorder(
//                                                borderSide: const BorderSide(
//                                                    color: Colors.white,
//                                                    width: 2.0),
////                                          borderRadius:
////                                              BorderRadius.circular(25.0),
//                                              ),
//                                              border: OutlineInputBorder(
//                                                borderSide: const BorderSide(
//                                                    color: Colors.white,
//                                                    width: 2.0),
////                                          borderRadius:
////                                              BorderRadius.circular(25.0),
//                                              ),
//
//                                              hintText: '-180...180',
//                                              hoverColor: Colors.white,
//                                            ),
//                                            textAlign: TextAlign.center,
//                                            keyboardType: TextInputType.number,
//                                            onSaved: (text) {
//                                              userSettings.manualLong =
//                                                  double.parse(text);
//                                              prefs.setDouble(
//                                                  userSettings.keyManualLong,
//                                                  userSettings.manualLong);
//                                              globalLongitude = text;
//                                            },
//                                            validator: (text) {
//                                              if (text == null) {
//                                                return null;
//                                              }
//                                              final n = num.tryParse(text);
//                                              if (n == null) {
//                                                return 'Invalid Longitude';
//                                              }
//                                              if (n < -180 || n > 180) {
//                                                return 'Invalid Longitude';
//                                              }
//                                              return null;
//                                            }),
//                                      ),
//                                    ),
//                                  ],
//                                ),
//                              ),
//                            ),
//                            ElevatedButton(
//                              style: ElevatedButton.styleFrom(
//                                primary: kHeadingColor, // background
//                                onPrimary: Colors.white, // foreground
//                              ),
//                              onPressed: () {
//                                if (_formKey.currentState.validate()) {
//                                  _formKey.currentState.save();
//                                  // TODO submit
//                                  getWeather();
//                                }
//                              },
//                              child: Text('Submit',
//                                  style: TextStyle(color: Colors.black)),
//                            )
//                          ],
//                        ),
//                      ),
//                    ),

                    /* Enter lat long */

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
                      onTap: () {
                        print("LOcal Weather " +
                            localWeather
                                .data.nearestArea[0].weatherUrl[0].value);
                        destinationURL = localWeather
                            .data.nearestArea[0].weatherUrl[0].value;
                        {
                          Navigator.pushNamed(context, WebWeather.id);
                        }
                      },
                    ),

                    Divider(
                      height: 10,
                      thickness: 5,
                    ),
                    MenuHeading(title: "Alarms and Bells"),

                    MenuListTile(
                      title: "Start a timer",
                      icon: Icons.hourglass_bottom,
                      onTap: () => {
                        showMaterialNumberPicker(
                          headerColor: kAppBlueColor,
                          maxLongSide: 400,
                          context: context,
                          title: "Minutes",
                          selectedNumber: 10,
                          maxNumber: 120,
                          minNumber: 1,
                          onChanged: (value) {
                            ted = Timer.periodic(
                                const Duration(milliseconds: 1000), _bobX);
                            setState(() {
                              _currentValue = value;
                              userSettings.countDownTimer = value;
                              _countDownTimeRemaining = value * 60;
                              _countDownStart = true;
                              userSettings.countDownStart = true;
                            });
//
                          },
                        )
                      },
                    ),
                    Visibility(
                      visible: _countDownTimeRemaining != 0, //_countDownStart,
                      child: Column(
                        children: [
                          Container(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 80.0, bottom: 8),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  // margin: EdgeInsets.all(100.0),
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                      color: Colors.orange,
                                      shape: BoxShape.circle),
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
                                            ((_countDownTimeRemaining / 60.0)
                                                            .ceil() -
                                                        1)
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
                                            style:
                                                TextStyle(color: Colors.white)),
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
                                  padding: const EdgeInsets.only(
                                      left: 40.0, right: 40.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary:
                                          Colors.grey.shade500, // background
                                      onPrimary: Colors.white, // foreground
                                    ),
                                    onPressed: () {
                                      if (ted.isActive) {
                                        ted.cancel();
                                      }
                                      setState(() {
                                        _countDownTimeRemaining = 0;
                                        userSettings
                                            .countDownTimerSecondsRemaining = 0;
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
                                          primary: Colors
                                              .grey.shade500, // background
                                          onPrimary: Colors.white, // foreground
                                        ),
                                        onPressed: () {
                                          ted = Timer.periodic(
                                              const Duration(
                                                  milliseconds: 1000),
                                              _bobX);
                                          _currentValue = _currentValue;
                                          userSettings.countDownTimer =
                                              _currentValue;
                                          _countDownTimeRemaining =
                                              _currentValue * 60;
                                          _countDownStart = true;
                                          userSettings.countDownStart = true;
                                        },
                                        child: Text('Continue',
                                            style:
                                                TextStyle(color: Colors.black)),
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
                                          primary: Colors
                                              .grey.shade500, // background
                                          onPrimary: Colors.white, // foreground
                                        ),
                                        child: Text('Pause',
                                            style:
                                                TextStyle(color: Colors.black)),
                                      ),
                              ],
                            ),
                          ),
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
                    Divider(
                      height: 10,
                      thickness: 5,
                    ),
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
                                  title: "Select Bell Schedule",
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
                                    prefs.setString(
                                        userSettings.keyChimeSelected, value);
                                  },
                                )
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
                    MenuHeading(title: "Display Settings"),
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
                            " Seconds between Gauge Swap ",
                            style: kTextSettingsStyle,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 40.0, right: 40.0, top: 8.0, bottom: 8.0),
                      child: NumberInputPrefabbed.squaredButtons(
                        controller: durationController,
                        min: 5,
                        max: 60,
                        initialValue: _currentSliderValue.toInt(),
                        incIconColor: Colors.white,
                        incDecBgColor: Colors.grey.shade200,
                        decIconColor: Colors.white,
                        style: TextStyle(color: Colors.white),
                        widgetContainerDecoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                          ),
                        ),
                        onIncrement: (num newlyIncrementedValue) {
                          print(
                              'Newly incremented value is $newlyIncrementedValue');
                        },
                        onDecrement: (num newlyDecrementedValue) {
                          print(
                              'Newly decremented value is $newlyDecrementedValue');
                        },
                      ),
                    ),
                    /*
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
                    */
                    Divider(
                      height: 10,
                      thickness: 5,
                    ),
                    MenuListTileWithSwitch(
                        title: (userSettings.continuousMarquee)
                            ? "Continuous Marquee (Enabled) "
                            : "Continuous Marquee (Disabled)",
                        value: userSettings.continuousMarquee,
                        icon: Icons.linear_scale,
                        onTap: () {
                          setState(() {
                            userSettings.continuousMarquee =
                                !userSettings.continuousMarquee;
                            prefs.setBool(userSettings.keyContinuousMarquee,
                                userSettings.continuousMarquee);
                          });
                        }),

                    Divider(
                      height: 10,
                      thickness: 5,
                    ),
                    MenuListTileWithSwitch(
                        title: (userSettings.showWeather)
                            ? "Show Weather in Marquee (Enabled) "
                            : "Show Weather in Maruqee (Disabled)",
                        value: userSettings.showWeather,
                        icon: Icons.wb_sunny_rounded,
                        onTap: () {
                          setState(() {
                            userSettings.showWeather =
                                !userSettings.showWeather;
                            prefs.setBool(userSettings.keyShowWeather,
                                userSettings.showWeather);
                          });
                        }),
                    Divider(
                      height: 10,
                      thickness: 5,
                    ),

                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: TextField(
                          keyboardType: TextInputType.text,
                          maxLines: 3,
                          controller: myController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 8.0),
                              fillColor: Colors.grey[100],
                              errorStyle: TextStyle(
                                  color: Colors.red,
                                  backgroundColor: Colors.white,
                                  fontSize: 15),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 2.0),
                              ),
                              hoverColor: Colors.white,
                              labelStyle: TextStyle(color: Colors.white),
                              labelText: "  Enter Marquee Text:"),

                          textAlign: TextAlign.center,

//                            onChanged: (value) {
//                              print("The value entered is : $value");
//                            }
                        ),
                      ),
                    ),
//                    MenuListTileWithSwitch(
//                        title: (userSettings.adsOn)
//                            ? "Disable Advertising "
//                            : "Enable Advertising",
//                        value: userSettings.adsOn,
//                        icon: Icons.photo,
//                        onTap: () {
//                          ScaffoldMessenger.of(context)
//                              .showSnackBar(adsSnackBar);
//                          setState(() {
//                            userSettings.adsOn = !userSettings.adsOn;
//                            //    _chimeEnabled = userSettings.chimeOn;
//                            print(
//                                "Selected " + userSettings.chimeOn.toString());
//                            prefs.setBool(
//                                userSettings.keyAdsOn, userSettings.adsOn);
//                          });
//                        }),
//                    Divider(
//                      height: 10,
//                      thickness: 5,
//                    ),
                    MenuAvatarListTile(
                      title: "First Gauge Image",
                      avatar: _image0,
                      onTap: () async {
                        await _selectFile(
                            context, userSettings.keyFilename0, 0);
                      },
                    ),
                    Divider(
                      height: 10,
                      thickness: 5,
                    ),
                    MenuAvatarListTile(
                      title: "Second Gauge Image",
                      avatar: _image1,
                      onTap: () async {
                        await _selectFile(
                            context, userSettings.keyFilename1, 1);
                      },
                    ),
                    Divider(
                      height: 10,
                      thickness: 5,
                    ),
                    MenuAvatarListTile(
                      title: "Third Gauge Image",
                      avatar: _image2,
                      onTap: () async {
                        await _selectFile(
                            context, userSettings.keyFilename2, 2);
                      },
                    ),
                    Divider(
                      height: 10,
                      thickness: 5,
                    ),
                    MenuAvatarListTile(
                      title: "Fourth Gauge Image",
                      avatar: _image3,
                      onTap: () async {
                        await _selectFile(
                            context, userSettings.keyFilename3, 3);
                      },
                    ),
                    Divider(
                      height: 10,
                      thickness: 5,
                    ),

                    MenuListTile(
                      title: "URL for More Information",
                      icon: Icons.info,
                    ),
                    Form(
                      key: _formKey2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Container(
                              // width: ScreenSize.screenWidth - 20,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: TextFormField(
                                          initialValue:
                                              userSettings.localInfoURL,
                                          style: TextStyle(color: Colors.white),
                                          decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              fillColor: Colors.grey[100],
                                              errorStyle: TextStyle(
                                                  color: Colors.red,
                                                  backgroundColor: Colors.white,
                                                  fontSize: 15),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.white,
                                                    width: 2.0),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.white,
                                                    width: 2.0),
                                              ),
                                              hoverColor: Colors.white,
                                              labelStyle: TextStyle(
                                                  color: Colors.white),
                                              labelText:
                                                  "  Enter URL for More Information:"),
                                          textAlign: TextAlign.center,
                                          onSaved: (text) {
                                            userSettings.localInfoURL = (text);
                                            prefs.setString(
                                                userSettings.keyLocalInfoURL,
                                                userSettings.localInfoURL);
                                          },
                                          validator: (text) {
                                            if (text == null) {
                                              return null;
                                            }
                                            if (isURL(text)) {
                                              print("field looks good");
                                              return null;
                                            } else {
                                              print("Bad URL");
                                              return 'Invalid URL';
                                            }
                                          }),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.grey.shade200, // background
                              onPrimary: Colors.white, // foreground
                            ),
                            onPressed: () {
                              if (_formKey2.currentState.validate()) {
                                _formKey2.currentState.save();
                                // TODO submit
                                destinationURL = userSettings.localInfoURL;
                                prefs.setString(userSettings.keyLocalInfoURL,
                                    userSettings.localInfoURL);
                                Navigator.pushNamed(context, WebWeather.id);
                              }
                            },
                            child: Text('Submit',
                                style: TextStyle(color: Colors.black)),
                          )
                        ],
                      ),
                    ),

                    MenuHeading(title: "Information"),
                    MenuListTile(
                      title: "Tell a friend about Tidey",
                      icon: Icons.share,
                      onTap: () => {
                        Share.share(
                            'Download the Tidey app its an awesome Marine Weather Clock',
                            subject: 'Check Out Tidey Marine Weather Clock\n  ' +
                                'https://apps.apple.com/us/app/tidey-clock/id1566159762')
                      },
                    ),
                    Divider(
                      height: 10,
                      thickness: 5,
                    ),

                    //
                    MenuListTile(
                        title: "Rate Us",
                        icon: Icons.star,
                        onTap: () => {
                              OpenAppstore.launch(
                                  androidAppId: "tbd", iOSAppId: "1566159762")
                            }),
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

  /*
    showMenu(
                            context: context,
                            position: RelativeRect.fromLTRB(100, 100, 100, 100),
                            items: [
                              PopupMenuItem<int>(
                                value: 0,
                                child: Text('Working a lot harder'),
                              ),
                              PopupMenuItem<int>(
                                value: 1,
                                child: Text('Working a lot less'),
                              ),
                              PopupMenuItem<int>(
                                value: 1,
                                child: Text('Working a lot smarter'),
                              ),
                            ]);


   */

  Future _selectFile(
      BuildContext ctx, String keyFilename, int fileNumber) async {
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => CupertinoActionSheet(
              actions: [
                CupertinoActionSheetAction(
                    onPressed: () async {
                      Navigator.of(ctx).pop();
                      String myFile = await _getPicture();
                      print("Yo My file is $myFile");
                      print("YoYo my key is $keyFilename");
                      prefs.setString(keyFilename, myFile);
                      userSettings.filenames[fileNumber] = myFile;
                      setState(() {
                        print("setting up Images");
                        _image0 = getGaugeImage(0);
                        _image1 = getGaugeImage(1);
                        _image2 = getGaugeImage(2);
                        _image3 = getGaugeImage(3);
                      });
                      rebuildView = true;
                      print("I stored the file here $myFile");
                    },
                    child: Text('Select Photo From Gallery')),
                CupertinoActionSheetAction(
                    onPressed: () {
                      prefs.setString(keyFilename, "");
                      userSettings.filenames[fileNumber] = "";
                      setState(() {
                        _image1 = getGaugeImage(1);
                        _image2 = getGaugeImage(2);
                        _image3 = getGaugeImage(3);
                        _image0 = getGaugeImage(0);
                      });
                      rebuildView = true;
                      Navigator.of(ctx).pop();
                    },
                    child: Text('Use Default Photo')),
              ],
              cancelButton: CupertinoActionSheetAction(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text('Cancel'),
              ),
            ));
  }

  void _close(BuildContext ctx) {
    Navigator.of(ctx).pop();
  }

//

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
    print("zzGetting Location Data1");
    Location location = Location();
    if (await location.getCurrentLocation()) {
      WeatherService weatherService = WeatherService();
      await weatherService.getMarineData();
      print("zzGetting Location Data3");
      LocalWeatherService localWeatherService = LocalWeatherService();
      await localWeatherService.getLocalWeatherData();
      print("zzGetting Location Data4");
      setState(() {
        _city = globalWeather.city;
      });

      if (globalWeather.localWeatherExists) {
        //weatherAPIError
        print("Found local weather data");
        globalWeather.weatherAPIError = false;

        if (globalWeather.tideDataExists) {
          print("Found Tide Data");
          globalWeather.tideAPIError = false;
          mySineWaveData msw = mySineWaveData();
          await msw.computeTidesForPainting();
          // globalNetworkAvailable = true;
        } else {
          const WE2rrorSnackBar = SnackBar(
              backgroundColor: (Colors.red),
              content: Text('No Tide data found for this location '),
              duration: const Duration(milliseconds: 3000));
          ScaffoldMessenger.of(context).showSnackBar(WE2rrorSnackBar);
          globalWeather.tideAPIError = true;
        }
      } else {
        const WErrorSnackBar = SnackBar(
            backgroundColor: (Colors.red),
            content: Text('No Weather data found for this location '),
            duration: const Duration(milliseconds: 3000));
        ScaffoldMessenger.of(context).showSnackBar(WErrorSnackBar);
      }
    } else {
      const WE2rrorSnackBar = SnackBar(
          backgroundColor: (Colors.red),
          content: Text(
              'Current Location Not available, please enable location services '),
          duration: const Duration(milliseconds: 3000));
      ScaffoldMessenger.of(context).showSnackBar(WE2rrorSnackBar);
    }
    setState(() {
      _loading = false;
    });
  }

  void getWeatherSaved() async {
    setState(() {
      _loading = true;
    });
    print("zzGetting Location Data1");
    Location location = Location();
    if (await location.getCurrentLocation()) {
      WeatherService weatherService = WeatherService();
      await weatherService.getMarineData();
      print("zzGetting Location Data3");
      LocalWeatherService localWeatherService = LocalWeatherService();
      await localWeatherService.getLocalWeatherData();
      print("zzGetting Location Data4");
      setState(() {
        _city = globalWeather.city;
      });

      if (globalWeather.localWeatherExists) {
        //weatherAPIError
        print("Found local weather data");
        globalWeather.weatherAPIError = false;

        if (globalWeather.tideDataExists) {
          print("Found Tide Data");
          globalWeather.tideAPIError = false;
          mySineWaveData msw = mySineWaveData();
          await msw.computeTidesForPainting();
          // globalNetworkAvailable = true;
        } else {
          const WE2rrorSnackBar = SnackBar(
              backgroundColor: (Colors.red),
              content: Text('No Tide data found for this location '),
              duration: const Duration(milliseconds: 3000));
          ScaffoldMessenger.of(context).showSnackBar(WE2rrorSnackBar);
          globalWeather.tideAPIError = true;
        }
      } else {
        const WErrorSnackBar = SnackBar(
            backgroundColor: (Colors.red),
            content: Text('No Weather data found for this location '),
            duration: const Duration(milliseconds: 3000));
        ScaffoldMessenger.of(context).showSnackBar(WErrorSnackBar);
      }
    } else {
      const WE2rrorSnackBar = SnackBar(
          backgroundColor: (Colors.red),
          content: Text(
              'Current Location Not available, please enable location services '),
          duration: const Duration(milliseconds: 3000));
      ScaffoldMessenger.of(context).showSnackBar(WE2rrorSnackBar);
    }
    setState(() {
      _loading = false;
    });
  }

  File _storedImage;
  Future<String> _getPicture() async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    );
    if (pickedFile == null) {
      return ("");
    }
    setState(() {
      if (pickedFile != null) {
        _storedImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }

      // _storedImage = imageFile;
    });
    print("Selected Image " + path.basename(pickedFile.path));
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = path.basename(pickedFile.path);
    final savedImage = await _storedImage.copy('${appDir.path}/$fileName');
    //temp = FileImage(File('${appDir.path}/$fileName'));
    return ('${appDir.path}/$fileName');
  }

  ImageProvider temp;

  void getWeatherName() async {
    setState(() {
      _loading = true;
    });
    print("Getting Location Data1");
    WeatherLocationService location = WeatherLocationService();
    if (!await location.getWeatherLocation()) {
      var WErrorSnackBar = SnackBar(
          backgroundColor: (Colors.red),
          content: Text('Error no weather data found for this location '),
          duration: const Duration(milliseconds: 3000));
      ScaffoldMessenger.of(context).showSnackBar(WErrorSnackBar);
    } else {
      WeatherService weatherService = WeatherService();
      print("Getting Weather Data 1");
      await weatherService.getMarineData();
      print("Getting Weather Data2");
      LocalWeatherService localWeatherService = LocalWeatherService();
      await localWeatherService.getLocalWeatherData();
      print("Add Done");
      setState(() {
        _city = globalWeather.city;
      });

      if (globalWeather.localWeatherExists) {
        //weatherAPIError
        print("Found local weather data");
        globalWeather.weatherAPIError = false;
        if (globalWeather.tideDataExists) {
          print("Found Tide Data");
          globalWeather.tideAPIError = false;
          mySineWaveData msw = mySineWaveData();
          await msw.computeTidesForPainting();
          // globalNetworkAvailable = true;
        } else {
          const WErrorSnackBar = SnackBar(
              backgroundColor: (Colors.red),
              content: Text('No Tide data found for this location '),
              duration: const Duration(milliseconds: 3000));
          ScaffoldMessenger.of(context).showSnackBar(WErrorSnackBar);
          globalWeather.tideAPIError = true;
        }
      } else {
        const WErrorSnackBar = SnackBar(
            backgroundColor: (Colors.red),
            content: Text('No Weather data found for this location '),
            duration: const Duration(milliseconds: 3000));
        ScaffoldMessenger.of(context).showSnackBar(WErrorSnackBar);
      }
    }
    setState(() {
      _loading = false;
    });
  }

  sendemail() async {
    const url =
//        'mailto:support@amberjacklabs.com?subject=Hi from Tideys 1 Fan&body=Hello';
        'mailto:support@amberjacklabs.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch email';
    }
  }
}

class MenuHeading extends StatelessWidget {
  String title;
  MenuHeading({
    this.title = "",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenSize.small ? 50 : 70,
      width: double.infinity,
      color: kHeadingColor,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, bottom: 8),
          child: Text(title,
              style: TextStyle(
                //   backgroundColor: Colors.grey,
                fontSize: kTextSettingSize,
              )),
        ),
      ),
    );
  }
}

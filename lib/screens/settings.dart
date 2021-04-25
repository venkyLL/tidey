import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tidey/const.dart';

class SettingsScreen extends StatefulWidget {
  static const String id = 'SettingsScreen';
  @override
  _settingsScreenState createState() => _settingsScreenState();
}

class _settingsScreenState extends State<SettingsScreen> {
  double _currentSliderValue = 10;
  int _sliding = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Settings"),
      ),
      body: SafeArea(
        child: Column(
          children: [
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
                        "\n\nDeveloped by Amberjack Labs"),
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
              onTap: () => {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text("Help"),
                    content: Text("Aint no help for you!"),
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
            ListTile(
              leading: Icon(
                Icons.straighten,
                size: kIconSettingSize,
              ),
              title: Text(
                "Select Untis",
                style: kTextSettingsStyle,
              ),
              trailing: CupertinoSlidingSegmentedControl(
                  children: {
                    0: Text(
                      'Imperial',
                      style: kTextSettingsStyle,
                    ),
                    1: Text(
                      'Metric',
                      style: kTextSettingsStyle,
                    ),
                  },
                  groupValue: _sliding,
                  onValueChanged: (newValue) {
                    setState(() {
                      _sliding = newValue;
                    });
                  }),
            ),
            Divider(
              height: 10,
              thickness: 5,
            ),
            MenuListTileWithSwitch(
                title: "Enable Hourly Chime",
                value: true,
                icon: Icons.notifications),
            Container(
              height: 70,
              width: double.infinity,
              color: Colors.grey,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, bottom: 8),
                  child: Text("Gauge Display Time",
                      style: TextStyle(
                        //   backgroundColor: Colors.grey,
                        fontSize: 20,
                      )),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  // Icon(Icons.timer, size: 40),
                  Text(
                    _currentSliderValue.toString(),
                    style: kTextSettingsStyle,
                  ),
                  Slider(
                    value: _currentSliderValue,
                    min: 5,
                    max: 60,
                    divisions: 5,
                    label: _currentSliderValue.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _currentSliderValue = value;
                      });
                    },
                  ),
                  Text("60 Seconds", style: kTextSettingsStyle)
                ],
              ),
            ),
            Column(
              children: [
                Column(
                  children: [
                    Divider(
                      height: 10,
                      thickness: 5,
                    ),
                  ],
                ),
              ],
            ),
          ],
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
}

class MenuListTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final IconData icon;

  const MenuListTile({Key key, this.title, this.onTap, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: kIconSettingSize),
      title: Text(
        title,
        style: kTextSettingsStyle,
      ),
      trailing: const Icon(
        Icons.chevron_right,
        size: kIconSettingSize,
      ),
      onTap: onTap,
    );
  }
}

class MenuListTileWithSwitch extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool value;
  final IconData icon;

  const MenuListTileWithSwitch({
    Key key,
    this.title,
    this.onTap,
    this.value,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: kIconSettingSize),
      title: Text(
        title,
        style: kTextSettingsStyle,
      ),
      trailing: Container(
        height: 24,
        width: 48,
        child: CupertinoSwitch(
          value: value ?? false,
          onChanged: (_) {
            onTap();
          },
        ),
      ),
      onTap: onTap,
    );
  }
}

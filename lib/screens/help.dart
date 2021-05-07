import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swipe_gesture_recognizer/swipe_gesture_recognizer.dart';
import 'package:tidey/const.dart';

class HelpScreen extends StatefulWidget {
  static const String id = 'HelpScreen';
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Tidey Help'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body:
//      Column  (
//        children: [
          SwipeGestureRecognizer(
        onSwipeLeft: () {
          Navigator.of(context).pop();
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.JPG'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.8), BlendMode.dstATop),
            ),
          ),
          constraints: BoxConstraints.expand(),
          child: ListView(
            children: [
              Column(
                children: [
//                  Container(
//                    alignment: Alignment.center,
//                    height: 30,
//                    child: Text('Tidey Help', style: kTableTitleTextStyle),
//                  ),
                  helpTile(
                      context,
                      "How do I read the Tidey Clock?",
                      "The green arrow points to the time of the next high tide." +
                          "\nThe red arrow points to the time of the next low tide." +
                          "\nThe blue curve indicates slack time," +
                          "\nThe width of silver bezel is proportional to the amount the tide is above or below median low tide at that time." +
                          "\nThe red and green numbers represent the tide at high or low tide in ft" +
                          "\n\n All tide estimates are approximate.  Factors such as exact location, wind, pressure, and rain can affect tides."),
                  helpTile(
                      context,
                      "Why is the silver ring around Tidey not round?",
                      "The width of silver bezel is proportional to the amount the tide is above or below median low tide at that time."),

                  helpTile(
                      context,
                      "Do I need to be connected to Internet to use Tidey?",
                      "Once per day Tidey will access the internet to get the latest weather.  Typically this is done at midnight, but if no connection is available Tidey will keep trying,  Tidey will still function without the internet but the weather data will not be current."),
                  helpTile(context, "Why does it say Weather Data Not Updated?",
                      "You will get this message if Tidey can not connect to the Internet. You can still see the forecast that was previously loaded, but if your location has changed or the forecast has changed it will not be reflected. Tidey tries to update the weather at midnight.  If it is not updated then it will try again every 15 minutes."),
                  helpTile(context, "How can I update the weather data?",
                      "Go to settings and click on Refresh Weather data."),
                  helpTile(
                      context,
                      "How can I change the location used for displaying weather and tide data?",
                      "Go to settings and turn on or off Use Current Location.  If it is off you will be required to enter a latitude and longitude for the location you wish to receive weather data."),
                  helpTile(context, "How can I see more detailed weather data?",
                      "Go to settings view current weather on web.  This requires an internet connection."),
                  helpTile(
                      context,
                      "How do I increase or decrease time between gauges?",
                      "To increase or decrease the time between gauges go to the settings screen and change Seconds between screens parameter"),
                  helpTile(context, "Why are gauges not changing?",
                      "Double tapping on the screen will stop the gauges from changing.  Double tap again to restart"),
                  helpTile(context, "How can I freeze the gauges?",
                      "Double click on the main screen to stop the gauges from changing.  Double click again to restart"),
                  helpTile(context, "How do I turn off the ships bell?",
                      "Go to settings and disable Ships bell "),
                  helpTile(
                      context,
                      "How do I change what bell sequence is played on the hour/half hour?",
                      "Go To Settings Bell Ring Schedule"),
                  helpTile(context, "How do I turn the bells off at night?",
                      "Go to Settings Sleep Mode?"),
                  helpTile(context, "How do I set an Alarm or Timer?",
                      "Go to Settings Alarm or Set a Timer"),
                  helpTile(
                      context,
                      "What is ships bell watch code?",
                      "Unlike civil clock bells, the strikes of a ship's bell do not accord to the number of the hour. Instead, there are eight bells, one for each half-hour of a four-hour watch. In the age of sailing, watches were timed with a 30-minute hourglass. Bells would be struck every time the glass was turned, and in a pattern of pairs for easier counting, with any odd bells at the end of the sequence.  While it takes a little getting used to after a short while it becomes easier to determine the time with this code rather than a traditional grandfather clock schedule.\n  " +
                          "\n     Traditional Schedule\n    4:00 8:00 12:00 = 8 Bells\n    4:30 8:30 12:30 = 1 Bell\n    5:00 9:00 1:00 = 2 Bells\n    5:30 9:30 1:30 = 3 Bells\n    6:00 10:00 2:00 = 4 Bells\n    6:30 10:30 2:30 = 5 Bells\n    7:00 11:00 3:00 = 6 Bells\n    7:30 11:30 3:30 = 7 Bells "),
                  helpTile(context, "Why does Tidey need my Location Data?",
                      "Tidey uses location data to get the local weather and tides.  Tidey does not store your location data."),
                  helpTile(context, "Privacy Policy", " ")
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column helpTile(BuildContext context, String title, String contents) {
    return Column(
      children: [
        MenuListTile(
          title: title,
//      icon: Icons.info_outline_rounded,
          onTap: () => {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                backgroundColor: Colors.black,
                title: Text(
                  title,
                  style: TextStyle(color: Colors.white),
                ),
                content: Text(contents, style: TextStyle(color: Colors.white)),
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
        )
      ],
    );
  }

  AlertDialog buildAlertDialog(
      BuildContext context, String title, String content) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
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

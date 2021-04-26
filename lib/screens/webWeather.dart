import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tidey/const.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebWeather extends StatefulWidget {
  static const String id = 'MoonScreen';
  @override
  _WebWeatherState createState() => _WebWeatherState();
}

class _WebWeatherState extends State<WebWeather> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar:
          // AppBar(title: Text(globalLatitude == null ? "bob" : globalLatitude)),
          AppBar(
        title: Text("Back to Tidey"),
        // centerTitle: true,
        //backgroundColor: Colors.transparent,
        backgroundColor: kHeadingColor,
        // Color(0x44000000),
        // elevation: 0,
      ),
      body: WebView(
        initialUrl: localWeather.data.nearestArea[0].weatherUrl[0].value,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}

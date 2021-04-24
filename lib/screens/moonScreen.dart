import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tidey/const.dart';
import 'package:tidey/screens/forecast.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MoonScreen extends StatefulWidget {
  static const String id = 'MoonScreen';
  @override
  _MoonScreenState createState() => _MoonScreenState();
}

class _MoonScreenState extends State<MoonScreen> {
  String moonPhaseImageName = null;

  void initState() {
    // TODO: implement initState
    super.initState();
    switch (weatherData.data.weather[0].astronomy[0].moonPhase) {
      case "First Quarter":
        {
          moonPhaseImageName = "assets/images/firstQuarter.jpg";
        }
        break;

      case "Full Moon":
        {
          moonPhaseImageName = "assets/images/fullMoon.jpg";
        }
        break;

      default:
        {
          moonPhaseImageName = "assets/images/fullMoon.jpg";
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar:
          // AppBar(title: Text(globalLatitude == null ? "bob" : globalLatitude)),
          AppBar(
        //    title: Text(globalLatitude == null ? "Tide" : globalLatitude),
        centerTitle: true,
        //backgroundColor: Colors.transparent,
        backgroundColor: Colors.blueAccent,
        // Color(0x44000000),
        // elevation: 0,

        actions: <Widget>[
//          Padding(
//              padding: EdgeInsets.only(right: 20.0),
//              child: GestureDetector(
//                onTap: () {},
//                child: Icon(
//                  Icons.search,
//                  size: 26.0,
//                ),
//              )),
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, ForecastScreen.id);
                },
                child: Icon(Icons.chevron_right),
              )),
        ],
      ),
      body: WebView(
        initialUrl: localWeather.data.nearestArea[0].weatherUrl[0].value,
        javascriptMode: JavascriptMode.unrestricted,
      ),

//        Container(
//          decoration: BoxDecoration(
//            image: DecorationImage(
//              image: AssetImage('assets/images/blueTexture.jpg'),
//              fit: BoxFit.cover,
//              colorFilter: ColorFilter.mode(
//                  Colors.white.withOpacity(0.8), BlendMode.dstATop),
//            ),
//          ),
//          constraints: BoxConstraints.expand(),
//          child: Column(
////            crossAxisAlignment: CrossAxisAlignment.stretch,
//              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//              children: [
//                SizedBox(height: 50),
//                zeClock(),
//                SizedBox(height: 20),
//                MoonRow(
//                  moonPhaseImageName: moonPhaseImageName,
//                ),
//                //buildTideTable(),
//              ]),
//        ),
    );
//      Scaffold(
//      appBar: AppBar(
//        title: Text(weatherData.data.weather[0].astronomy[0].moonPhase),
//        backgroundColor: Colors.black,
//        centerTitle: true,
//        actions: <Widget>[
////          Padding(
////              padding: EdgeInsets.only(right: 20.0),
////              child: GestureDetector(
////                onTap: () {},
////                child: Icon(
////                  Icons.search,
////                  size: 26.0,
////                ),
////              )),
//          Padding(
//              padding: EdgeInsets.only(right: 20.0),
//              child: GestureDetector(
//                onTap: () {
//                  Navigator.pushNamed(context, ForecastScreen.id);
//                },
//                child: Icon(Icons.chevron_right),
//              )),
//        ],
//      ),
//      backgroundColor: Colors.black,
//      body: MoonRow(moonPhaseImageName: moonPhaseImageName),
//    );

    Container(child: Text("Hello Moon")
        // Image.asset('safew8ManagerBanner.png'),
        );
  }
}

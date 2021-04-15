import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tidey/const.dart';

class ForecastScreen extends StatefulWidget {
  static const String id = 'ForecastScreen';
  @override
  _ForecastScreenState createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(weatherData.data.weather[0].astronomy[0].moonPhase),
        backgroundColor: Colors.lightGreen,
        centerTitle: true,
      ),
      backgroundColor: Colors.lightGreen,
      body: SafeArea(
        child: Column(
          children: [
            // Center(child: Image.asset('Forecast')),
            Text(
              'Forecast',
              style: kMoonTextStyle,
            ),
            SizedBox(height: 20),
            Align(
                alignment: Alignment.centerLeft,
                child: Text(" Hello: ", style: kMoonTextStyle)),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

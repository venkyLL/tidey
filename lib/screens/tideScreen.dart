import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tidey/components/subTile.dart';
import 'package:tidey/components/zeClock.dart';
import 'package:tidey/const.dart';
import 'package:tidey/screens/moonScreen.dart';

class TideScreen extends StatelessWidget {
  static const String id = 'TideScreen';
//  final String passedValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          // AppBar(title: Text(globalLatitude == null ? "bob" : globalLatitude)),
          AppBar(
        title: Text(globalLatitude == null ? "Tide" : globalLatitude),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {/* Write listener code here */},
          child: Icon(
            Icons.menu, // add custom icons also
          ),
        ),
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
                  Navigator.pushNamed(context, MoonScreen.id);
                },
                child: Icon(Icons.chevron_right),
              )),
        ],
      ),
      body: SafeArea(
        child: Column(
//            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              zeClock(),
              mySubTile(kMySubTileData),
            ]),
      ),
    );
  }
}

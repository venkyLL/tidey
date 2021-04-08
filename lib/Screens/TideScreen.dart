import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tidey/const.dart';
import 'package:tidey/Screens/SubTile.dart';
import 'package:tidey/Screens/MainTile.dart';

class TideScreen extends StatelessWidget {
  static const String id = 'TideScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("tidey")),
      body: SafeArea(
        child: Column(
//            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              mainTile(),
              mySubTile(kMySubTileData),
            ]),
      ),
    );
  }
}

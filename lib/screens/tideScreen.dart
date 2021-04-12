import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tidey/components/mainTile.dart';
import 'package:tidey/components/subTile.dart';
import 'package:tidey/const.dart';

class TideScreen extends StatelessWidget {
  static const String id = 'TideScreen';
//  final String passedValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(globalLatitude == null ? "bob" : globalLatitude)),
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

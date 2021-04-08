import 'package:flutter/material.dart';
import 'package:tidey/const.dart';

class mainTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      color: Colors.green,
      child: Center(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("                "),
          Text(
            "12:10 PM  ",
            style: kClockTextStyle,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Text(
              "  + 1.2 ft ",
              style: kClockTrailerTextStyle,
            ),
            Icon(
              Icons.arrow_circle_up_sharp,
//                          Icons.arrow_upward_sharp,
              color: Colors.green,
              size: 30.0,
            ),
          ]),
        ]),
      ),
    );
  }
}

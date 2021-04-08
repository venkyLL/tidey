import 'package:flutter/material.dart';
import 'package:tidey/const.dart';

class myTile extends StatelessWidget {
  final String timeStamp;
  final String tideHeight;
  final bool tideRising;
  final bool today; // boolean
  myTile({this.timeStamp, this.tideHeight, this.tideRising, this.today});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      color: Colors.black12,
      child: Center(
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Text(
            today ? 'Today' : 'Tomorrow',
            style: kClockTextSmallStyle,
          ),
          Text(
            timeStamp,
            style: kClockTextSmallStyle,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Text(
              tideHeight,
              style: kClockTrailerTextStyle,
            ),
            Icon(
              tideRising
                  ? Icons.arrow_circle_up_sharp
                  : Icons.arrow_circle_down_sharp,
              color: tideRising ? Colors.green : Colors.red,
              size: 30.0,
            ),
          ]),
        ]),
      ),
    );
  }
}

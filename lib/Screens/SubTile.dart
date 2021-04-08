import 'package:flutter/material.dart';
import 'package:tidey/const.dart';

class mySubTile extends StatelessWidget {
  final List myList;
  mySubTile(this.myList);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Container(
            width: double.infinity,
            child: Text("Upcoming Low and High Tides:"),
          ),
        ),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            color: Colors.black12,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(myList[0]['today'] ? "Today" : "Tomorrow",
                          style: kClockTextSmallStyle),
                      Text(myList[1]['today'] ? "Today" : "Tomorrow",
                          style: kClockTextSmallStyle),
                      Text(myList[2]['today'] ? "Today" : "Tomorrow",
                          style: kClockTextSmallStyle),
                      Text(myList[3]['today'] ? "Today" : "Tomorrow",
                          style: kClockTextSmallStyle),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(myList[0]['timeStamp'], style: kClockTextSmallStyle),
                      Text(myList[1]['timeStamp'], style: kClockTextSmallStyle),
                      Text(myList[2]['timeStamp'], style: kClockTextSmallStyle),
                      Text(myList[3]['timeStamp'], style: kClockTextSmallStyle),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(myList[0]['tideHeight'],
                          style: kClockTextSmallStyle),
                      Text(myList[1]['tideHeight'],
                          style: kClockTextSmallStyle),
                      Text(myList[2]['tideHeight'],
                          style: kClockTextSmallStyle),
                      Text(myList[3]['tideHeight'],
                          style: kClockTextSmallStyle),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        myList[0]['tideRising']
                            ? Icons.arrow_circle_up_sharp
                            : Icons.arrow_circle_down_sharp,
                        color:
                            myList[0]['tideRising'] ? Colors.green : Colors.red,
                        size: 20.0,
                      ),
                      Icon(
                        myList[1]['tideRising']
                            ? Icons.arrow_circle_up_sharp
                            : Icons.arrow_circle_down_sharp,
                        color:
                            myList[1]['tideRising'] ? Colors.green : Colors.red,
                        size: 20.0,
                      ),
                      Icon(
                        myList[2]['tideRising']
                            ? Icons.arrow_circle_up_sharp
                            : Icons.arrow_circle_down_sharp,
                        color:
                            myList[2]['tideRising'] ? Colors.green : Colors.red,
                        size: 20.0,
                      ),
                      Icon(
                        myList[3]['tideRising']
                            ? Icons.arrow_circle_up_sharp
                            : Icons.arrow_circle_down_sharp,
                        color:
                            myList[3]['tideRising'] ? Colors.green : Colors.red,
                        size: 20.0,
                      ),
                    ],
                  ),
                ])),
      ],
    );
  }
}

//

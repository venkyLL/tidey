import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swipe_gesture_recognizer/swipe_gesture_recognizer.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tidey/const.dart';
import 'package:tidey/screens/forecast.dart';
import 'package:weather_icons/weather_icons.dart';

class TideTableScreen extends StatefulWidget {
  static const String id = 'TideTableScreen';
  @override
  _TideTableScreenState createState() => _TideTableScreenState();
}

class _TideTableScreenState extends State<TideTableScreen> {
  HourlyDataSource hourlyDataSource;
  Timer ted;

  @override
  void initState() {
    super.initState();
    print("Here I am in Tide Screen");
    hourlyDataSource =
        HourlyDataSource(hourlyData: globalWeather.dailyWeather[di].tides);
//    print("Number of hourly records is " +
//        weatherData.data.weather[0].hourly.length.toString());
    ted = Timer(Duration(seconds: userSettings.transitionTime), () {
      // 5s over, navigate to a new pa;ge
      print("About to pop");
      Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (ted.isActive) {
      ted.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),

        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
//
      ),
      body:
//      Column  (
//        children: [
          SwipeGestureRecognizer(
        onSwipeLeft: () {
          Navigator.of(context).pop();
        },
        onSwipeRight: () {
          Navigator.pushNamed(context, ForecastScreen.id);
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
          child: (globalWeather.tideAPIError)
              ? Container(
                  alignment: Alignment.center,
                  height: ScreenSize.small ? 50 : 200,
                  child: Text('Tide Data Not Available For this Area',
                      style: kTableTitleTextStyle, textAlign: TextAlign.center),
                )
              : Column(
                  children: [
                    SizedBox(
                      height: ScreenSize.hasNotch ? 60 : 0,
                      width: ScreenSize.hasNotch ? 60 : 0,
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: ScreenSize.small ? 50 : 200,
                      child: Text(
                          'Today\'s Tides\n' +
                              globalWeather.city +
                              "," +
                              globalWeather.country,
                          style: kTableTitleTextStyle,
                          textAlign: TextAlign.center),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SfDataGrid(
                          source: hourlyDataSource,
                          columnWidthMode: ColumnWidthMode.fill,
                          columns: <GridColumn>[
                            GridTextColumn(
                                columnName: 'type',
                                label: Container(
                                    padding: EdgeInsets.all(2.0),
                                    alignment: Alignment.center,
                                    color: kTitleBoxColor,
                                    child: Text(
                                      'Tide',
                                      style: kTableTextStyle,
                                    ))),
                            GridTextColumn(
                              columnName: 'time',
                              label: Container(
                                  color: kTitleBoxColor,
                                  padding: EdgeInsets.all(2.0),
                                  alignment: Alignment.center,
                                  child: ScreenSize.small
                                      ? Text(
                                          'Time',
                                          style: kTableTextStyle,
                                        )
                                      : Text(
                                          'Time',
                                          style: kTableTextStyle,
                                        )),
                            ),
                            GridTextColumn(
                                columnName: 'level',
                                label: Container(
                                    color: kTitleBoxColor,
                                    padding: EdgeInsets.all(2.0),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Level',
                                      style: kTableTextStyle,
                                      overflow: TextOverflow.ellipsis,
                                    ))),
                          ],
//                  stackedHeaderRows: <StackedHeaderRow>[
//                    StackedHeaderRow(cells: [
//                      StackedHeaderCell(
//                          columnNames: [
//                            'Hour',
//                            'Condition',
//                            'Temp',
//                            'Wind',
//                            'Wave'
//                          ],
//                          child: Container(
//                              color: kTitleBoxColor,
//                              child: Center(
//                                  child: Text('Today\'s Weather',
//                                      style: kTableTitleTextStyle)))),
////                    StackedHeaderCell(
////                        columnNames: ['productId', 'product'],
////                        child: Container(
////                            color: const Color(0xFFF1F1F1),
////                            child: Center(child: Text('Product Details'))))
//                    ])
//                  ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
//          SizedBox(
//            height: 20,
//          ),

//          Row(
//            children: [
//              BoxedIcon((WeatherIcons.thermometer), color: Colors.blue),
//              Text("Water Temperature " +
//                  weatherData.data.weather[0].hourly[0].waterTempF +
//                  " \u2109"),
//            ],
//          ),
//          SizedBox(
//            height: 10,
//          ),
//          Row(
//            children: [
//              BoxedIcon((WeatherIcons.barometer), color: Colors.blue),
//              Text("Pressure " +
//                  weatherData.data.weather[0].hourly[0].pressureInches +
//                  " in"),
//            ],
//          ),
//        ],
//      ),
    );
  }
}

// BoxedIcon((WeatherIcons.sunset), color: Colors.white)
class HourlyDataSource extends DataGridSource {
  /// Creates the weather data source class with required details.
  HourlyDataSource({List<TideElement> hourlyData}) {
    _hourlyData = hourlyData
        .map<DataGridRow>(
          (e) => DataGridRow(cells: [
            DataGridCell<String>(columnName: 'type', value: e.tideType),

            //     BoxedIcon((WeatherIcons.day_cloudy), color: Colors.blue)),
            DataGridCell<String>(
                columnName: 'time',
                value: DateFormat('hh:mma').format(e.tideDateTime)),

            //DateFormat('hh:mma').format(DateTime.parse(
            //    DataGridCell<String>(
            //      columnName: 'code', value: e.cloudcover + "%"),

            DataGridCell<String>(
                columnName: 'level', value: e.tideHeightFt + "ft"),
          ]),
        )
        .toList();
  }

  List<DataGridRow> _hourlyData = [];

  @override
  List<DataGridRow> get rows => _hourlyData;

//  @override
//  DataGridRowAdapter buildRow(DataGridRow row) {
//    return DataGridRowAdapter(
//        cells: row.getCells().map<Widget>((e) {
//      return Container(
//        alignment: Alignment.center,
//        padding: EdgeInsets.all(8.0),
//        child: Text(e.value.toString()),
//      );
//    }).toList());
//  }

  DataGridRowAdapter buildRow(DataGridRow row) {
    //   print("Creating a row");

    return DataGridRowAdapter(color: Colors.white30, cells: [
      Container(
        padding: EdgeInsets.all(2.0),
        alignment: Alignment.center,
        child: Text(
          row.getCells()[0].value.toString(),
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20 * ScreenSize.fs),
        ),
      ),
      Container(
        alignment: Alignment.center,
        child: Text(
          row.getCells()[1].value.toString(),
          //    overflow: TextOverflow.ellipsis,
          softWrap: true,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20 * ScreenSize.fs),
        ),
      ),
      Container(
        padding: EdgeInsets.all(2.0),
        alignment: Alignment.center,
        child: Text(row.getCells()[2].value.toString(),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20 * ScreenSize.fs)),
      ),
    ]);
  }

  getWeatherIcon({String time, String code}) {
    // var iconName = "WeatherIcons.day_cloudy";
    print("Time is" + time);
    switch (time) {
      case "0":
      case "300":
      case "2100":
        {
          return BoxedIcon((weatherNightIconMap[code]),
              color: Colors.white, size: 20);
        }
        break;

      default:
        {
          return BoxedIcon((weatherDayIconMap[code]),
              color: Colors.white, size: 20);
        }
        break;
    }

//    if (code == "116") {
//      // termination case
//      return BoxedIcon((WeatherIcons.day_cloudy), color: Colors.blue);
//    } else {
//      return BoxedIcon((WeatherIcons.day_sunny), color: Colors.blue);
//      // function invokes itself
//    }
  }
}

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swipe_gesture_recognizer/swipe_gesture_recognizer.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tidey/const.dart';
import 'package:tidey/screens/forecast.dart';
import 'package:weather_icons/weather_icons.dart';

class TodayScreen extends StatefulWidget {
  static const String id = 'TodayScreen';
  @override
  _TodayScreenState createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  HourlyDataSource hourlyDataSource;
  Timer ted;

  @override
  void initState() {
    super.initState();
    hourlyDataSource =
        HourlyDataSource(hourlyData: globalWeather.dailyWeather[di].hourly);
//    print("Number of hourly records is " +
//        weatherData.data.weather[0].hourly.length.toString());
    ted = Timer(Duration(seconds: userSettings.transitionTime), () {
      // 5s over, navigate to a new page
      Navigator.pushReplacementNamed(context, ForecastScreen.id);
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
        onSwipeRight: () {
          Navigator.of(context).pop();
        },
        onSwipeLeft: () {
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
          child: (globalWeather.weatherAPIError)
              ? Container(
                  alignment: Alignment.center,
                  height: ScreenSize.small ? 50 : 200,
                  child: Text(
                      'Local Weather Not Available\nPlease Check Network Connections',
                      style: kTableTitleTextStyle,
                      textAlign: TextAlign.center),
                )
              : Column(
                  children: [
                    SizedBox(
                      height: ScreenSize.hasNotch ? 80 : 0,
                      width: ScreenSize.hasNotch ? 60 : 0,
                    ),
                    Container(
                      alignment: Alignment.center,
                      // height: ScreenSize.small ? 50 : 200,
                      child: Text(
                          'Today\'s Weather \n' +
                              globalWeather.city +
                              "," +
                              globalWeather.country +
                              "\n" +
                              globalWeather.dailyWeather[di].hourly[0]
                                  .weatherConditionDesc,
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
                                columnName: 'Hour',
                                label: Container(
                                    padding: EdgeInsets.all(2.0),
                                    alignment: Alignment.center,
                                    color: kTitleBoxColor,
                                    child: Text(
                                      'Hour',
                                      style: kTableTextStyle,
                                    ))),
                            GridTextColumn(
                              columnName: 'Condition',
                              label: Container(
                                  color: kTitleBoxColor,
                                  padding: EdgeInsets.all(2.0),
                                  alignment: Alignment.center,
                                  child: ScreenSize.small
                                      ? Text(
                                          'Cond',
                                          style: kTableTextStyle,
                                        )
                                      : Text(
                                          'Condition',
                                          style: kTableTextStyle,
                                        )),
                            ),
                            GridTextColumn(
                                columnName: 'Temp',
                                label: Container(
                                    color: kTitleBoxColor,
                                    padding: EdgeInsets.all(2.0),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Temp',
                                      style: kTableTextStyle,
                                      overflow: TextOverflow.ellipsis,
                                    ))),
                            GridTextColumn(
                                columnName: 'Wind',
                                label: Container(
                                    color: kTitleBoxColor,
                                    padding: EdgeInsets.all(2.0),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Wind',
                                      style: kTableTextStyle,
                                    ))),
                            GridTextColumn(
                                columnName: 'Wave',
                                label: Container(
                                    color: kTitleBoxColor,
                                    padding: EdgeInsets.all(2.0),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Waves',
                                      style: kTableTextStyle,
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
  HourlyDataSource({List<HourlyWeather> hourlyData}) {
    _hourlyData = hourlyData
        .map<DataGridRow>(
          (e) => DataGridRow(cells: [
            DataGridCell<String>(columnName: 'time', value: e.timeString),
            DataGridCell<BoxedIcon>(
                columnName: 'condition',
                value: getWeatherIcon(time: e.timeString, code: e.weatherCode)),
            //     BoxedIcon((WeatherIcons.day_cloudy), color: Colors.blue)),
            DataGridCell<String>(columnName: 'temp', value: e.temp + " \u2109"),
            //    DataGridCell<String>(
            //      columnName: 'code', value: e.cloudcover + "%"),

            DataGridCell<String>(
                columnName: 'wind', value: e.windSpeed + " " + e.windDirection),
            DataGridCell<String>(
                columnName: 'wave', value: e.waveHt + " " + e.waveDirection),
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
        padding: EdgeInsets.all(2.0),
        //color: Colors.transparent,
        child: row.getCells()[1].value,
      ),
      Container(
        alignment: Alignment.center,
        child: Text(
          row.getCells()[2].value.toString(),
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
        child: Text(row.getCells()[3].value.toString(),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20 * ScreenSize.fs)),
      ),
      Container(
        padding: EdgeInsets.all(2.0),
        alignment: Alignment.center,
        child: Text(
          row.getCells()[4].value.toString(),
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20 * ScreenSize.fs),
        ),
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

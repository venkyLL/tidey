import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swipe_gesture_recognizer/swipe_gesture_recognizer.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tidey/const.dart';
import 'package:weather_icons/weather_icons.dart';

class ForecastScreen extends StatefulWidget {
  static const String id = 'ForecastScreen';
  @override
  _ForecastScreenState createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  WeatherDataSource weatherDataSource;
  Timer ted;
  @override
  void initState() {
    super.initState();
    weatherDataSource =
        WeatherDataSource(weatherData: globalWeather.dailyWeather);
//    print("Number of hourly records is " +
//        weatherDataSource._weatherData.length.toString());
    ted = Timer(Duration(seconds: userSettings.transitionTime), () {
      Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    super.dispose();
    ted.cancel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Colors.black),
          onPressed: () {
            ted.cancel;
            Navigator.of(context).pop();
          },
        ),
        // title: const Text('Weekly Forecast'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body:
//      Column  (
//        children: [
          SwipeGestureRecognizer(
        onSwipeLeft: () {
          Navigator.of(context).pop();
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
          child: (!globalWeather.localHourlyExists)
              ? Container(
                  alignment: Alignment.center,
                  height: 200,
                  child: Text(
                      'Local Weather Not Available\nPlease Check Network Connections',
                      style: kTableTitleTextStyle,
                      textAlign: TextAlign.center),
                )
              : Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: ScreenSize.small ? 50 : 200,
                      child:
                          Text('Weekly Forecast', style: kTableTitleTextStyle),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SfDataGrid(
                          source: weatherDataSource,
                          columnWidthMode: ColumnWidthMode.fill,
                          columns: <GridColumn>[
                            GridTextColumn(
                                columnName: 'Day',
                                label: Container(
                                    padding: EdgeInsets.all(2.0),
                                    alignment: Alignment.center,
                                    color: kTitleBoxColor,
                                    child: Text(
                                      'Day',
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
                                        'Cond',
                                        style: kTableTextStyle,
                                      ),
                              ),
                            ),
                            GridTextColumn(
                              columnName: 'Deescription',
                              label: Container(
                                color: kTitleBoxColor,
                                padding: EdgeInsets.all(2.0),
                                alignment: Alignment.center,
                                child: ScreenSize.small
                                    ? Text(
                                        'Desc',
                                        style: kTableTextStyle,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    : Text(
                                        'Description',
                                        style: kTableTextStyle,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                              ),
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
    );
  }
}

// BoxedIcon((WeatherIcons.sunset), color: Colors.white)
class WeatherDataSource extends DataGridSource {
  /// Creates the weather data source class with required details.
  WeatherDataSource({List<WeatherDay> weatherData}) {
    _weatherData = weatherData
        .map<DataGridRow>(
          (e) => DataGridRow(cells: [
            DataGridCell<String>(
                columnName: 'day', value: DateFormat('E').format(e.date)),
            DataGridCell<BoxedIcon>(
                columnName: 'condition',
                value: getWeatherIcon(code: e.hourly[0].weatherCode)),
            DataGridCell<String>(
                columnName: 'Description',
                value: e.hourly[0].weatherConditionDesc),
            //  BoxedIcon((WeatherIcons.day_cloudy), color: Colors.blue)),
            DataGridCell<String>(
                columnName: 'temp', value: e.hourly[0].temp + " \u2109"),
            //    DataGridCell<String>(
            //      columnName: 'code', value: e.cloudcover + "%"),

            DataGridCell<String>(
                columnName: 'wind',
                value: e.hourly[0].windSpeed + " " + e.hourly[0].windDirection),
            DataGridCell<String>(
                columnName: 'Description',
                value: e.hourly[0].weatherConditionDesc),
          ]),
        )
        .toList();
  }

  List<DataGridRow> _weatherData = [];

  @override
  List<DataGridRow> get rows => _weatherData;

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
    //  print("Creating a row");

    return DataGridRowAdapter(color: Colors.white30, cells: [
      Container(
        padding: EdgeInsets.all(2.0),
        alignment: Alignment.center,
        child: Text(
          row.getCells()[0].value.toString(),
          overflow: TextOverflow.ellipsis,
          style: kTableTextStyle,
        ),
      ),
      Container(
        padding: EdgeInsets.all(2.0),
        //color: Colors.transparent,
        child: row.getCells()[1].value,
      ),
      Container(
        alignment: Alignment.centerLeft,
        child: Text(
          row.getCells()[2].value.toString(),
          softWrap: true,
          style: kTableTextStyle,
        ),
      ),
      Container(
        padding: EdgeInsets.all(2.0),
        alignment: Alignment.center,
        child: Text(row.getCells()[3].value.toString(),
            overflow: TextOverflow.ellipsis, style: kTableTextStyle),
      ),
      Container(
        padding: EdgeInsets.all(2.0),
        alignment: Alignment.center,
        child: Text(
          row.getCells()[4].value.toString(),
          overflow: TextOverflow.ellipsis,
          style: kTableTextStyle,
        ),
      ),
    ]);
  }

  getWeatherIcon({String time = "0900", String code}) {
    // var iconName = "WeatherIcons.day_cloudy";
    print("Time is" + time);
    switch (time) {
      case "0":
      case "300":
      case "2100":
        {
          return BoxedIcon((weatherNightIconMap[code]), color: Colors.white);
        }
        break;

      default:
        {
          return BoxedIcon((weatherDayIconMap[code]), color: Colors.white);
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

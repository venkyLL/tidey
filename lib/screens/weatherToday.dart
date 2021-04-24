import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tidey/components/zeClock.dart';
import 'package:tidey/const.dart';
import 'package:tidey/services/marineWeather.dart';
import 'package:weather_icons/weather_icons.dart';

class ForecastScreen extends StatefulWidget {
  static const String id = 'ForecastScreen';
  @override
  _ForecastScreenState createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  HourlyDataSource hourlyDataSource;

  @override
  void initState() {
    hourlyDataSource =
        HourlyDataSource(hourlyData: weatherData.data.weather[0].hourly);
    print("Number of hourly records is " +
        weatherData.data.weather[0].hourly.length.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // title: const Text('Today\'s Weather'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body:
//      Column  (
//        children: [
          Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/blueTexture.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: Column(
          children: [
            SizedBox(height: 50),
            zeClock(),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: WeatherTodayTable(hourlyDataSource: hourlyDataSource),
            ),
          ],
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

class WeatherTodayTable extends StatelessWidget {
  const WeatherTodayTable({
    Key key,
    @required this.hourlyDataSource,
  }) : super(key: key);

  final HourlyDataSource hourlyDataSource;

  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
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
                ))),
        GridTextColumn(
            columnName: 'Condition',
            label: Container(
                color: kTitleBoxColor,
                padding: EdgeInsets.all(2.0),
                alignment: Alignment.center,
                child: Text('Cond.'))),
        GridTextColumn(
            columnName: 'Temp',
            label: Container(
                color: kTitleBoxColor,
                padding: EdgeInsets.all(2.0),
                alignment: Alignment.center,
                child: Text(
                  'Temp',
                  overflow: TextOverflow.ellipsis,
                ))),
        GridTextColumn(
            columnName: 'Wind',
            label: Container(
                color: kTitleBoxColor,
                padding: EdgeInsets.all(2.0),
                alignment: Alignment.center,
                child: Text('Wind'))),
        GridTextColumn(
            columnName: 'Wave',
            label: Container(
                color: kTitleBoxColor,
                padding: EdgeInsets.all(2.0),
                alignment: Alignment.center,
                child: Text('Waves'))),
      ],
      stackedHeaderRows: <StackedHeaderRow>[
        StackedHeaderRow(cells: [
          StackedHeaderCell(
              columnNames: ['Hour', 'Condition', 'Temp', 'Wind', 'Wave'],
              child: Container(
                  color: kTitleBoxColor,
                  child: Center(
                      child: Text('Today\'s Weather',
                          style: kTableTitleTextStyle)))),
//                    StackedHeaderCell(
//                        columnNames: ['productId', 'product'],
//                        child: Container(
//                            color: const Color(0xFFF1F1F1),
//                            child: Center(child: Text('Product Details'))))
        ])
      ],
    );
  }
}

// BoxedIcon((WeatherIcons.sunset), color: Colors.white)
class HourlyDataSource extends DataGridSource {
  /// Creates the weather data source class with required details.
  HourlyDataSource({List<Hourly> hourlyData}) {
    _hourlyData = hourlyData
        .map<DataGridRow>(
          (e) => DataGridRow(cells: [
            DataGridCell<String>(columnName: 'time', value: hourFmt[e.time]),
            DataGridCell<BoxedIcon>(
                columnName: 'condition',
                value: getWeatherIconBox(time: e.time, code: e.weatherCode)),
            //     BoxedIcon((WeatherIcons.day_cloudy), color: Colors.blue)),
            DataGridCell<String>(
                columnName: 'temp', value: e.tempF + " \u2109"),
            //    DataGridCell<String>(
            //      columnName: 'code', value: e.cloudcover + "%"),

            DataGridCell<String>(
                columnName: 'wind',
                value: e.windspeedMiles + " " + e.winddir16Point),
            DataGridCell<String>(
                columnName: 'wave', value: e.swellHeightFt + "ft"),
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
    print("Creating a row");

    return DataGridRowAdapter(color: Colors.white30, cells: [
      Container(
        padding: EdgeInsets.all(2.0),
        alignment: Alignment.center,
        //color: Colors.blue,
        child: Text(
          row.getCells()[0].value.toString(),
          overflow: TextOverflow.ellipsis,
          style: kTableTextStyle,
        ),
      ),
      Container(
        padding: EdgeInsets.all(2.0),
        // color: kTitleBoxColor,
        child: row.getCells()[1].value,
      ),
      Container(
        alignment: Alignment.center,
        child: Text(
          row.getCells()[2].value.toString(),
          style: kTableTextStyle,
          softWrap: true,
        ),
      ),
      Container(
        padding: EdgeInsets.all(2.0),
        alignment: Alignment.center,
        child: Text(
          row.getCells()[3].value.toString(),
          overflow: TextOverflow.ellipsis,
          style: kTableTextStyle,
        ),
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

//    if (code == "116") {
//      // termination case
//      return BoxedIcon((WeatherIcons.day_cloudy), color: Colors.blue);
//    } else {
//      return BoxedIcon((WeatherIcons.day_sunny), color: Colors.blue);
//      // function invokes itself
//    }
}

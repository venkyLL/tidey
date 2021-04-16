import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tidey/const.dart';
import 'package:tidey/services/marineWeather.dart';
import 'package:weather_icons/weather_icons.dart';

class ForecastScreen extends StatefulWidget {
  static const String id = 'ForecastScreen';
  @override
  _ForecastScreenState createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  List<Employee> employees = <Employee>[];
  EmployeeDataSource employeeDataSource;
  HourlyDataSource hourlyDataSource;

  @override
  void initState() {
    super.initState();
    employees = getEmployeeData();
    employeeDataSource = EmployeeDataSource(employeeData: employees);
    hourlyDataSource =
        HourlyDataSource(hourlyData: weatherData.data.weather[0].hourly);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Today\'s Weather'),
      ),
      body: Column(
        children: [
          SfDataGrid(
            source: hourlyDataSource,
            columnWidthMode: ColumnWidthMode.fill,
            columns: <GridColumn>[
              GridTextColumn(
                  columnName: 'ID',
                  label: Container(
                      padding: EdgeInsets.all(2.0),
                      alignment: Alignment.center,
                      child: Text(
                        'Hour',
                      ))),
              GridTextColumn(
                  columnName: 'name',
                  label: Container(
                      padding: EdgeInsets.all(2.0),
                      alignment: Alignment.center,
                      child: Text('Condition'))),
              GridTextColumn(
                  label: Container(
                      padding: EdgeInsets.all(2.0),
                      alignment: Alignment.center,
                      child: Text(
                        'Temp',
                        overflow: TextOverflow.ellipsis,
                      ))),
              GridTextColumn(
                  columnName: 'salary',
                  label: Container(
                      padding: EdgeInsets.all(2.0),
                      alignment: Alignment.center,
                      child: Text('Wind'))),
              GridTextColumn(
                  columnName: 'salary',
                  label: Container(
                      padding: EdgeInsets.all(2.0),
                      alignment: Alignment.center,
                      child: Text('Waves'))),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              BoxedIcon((WeatherIcons.thermometer), color: Colors.blue),
              Text("Water Temperature " +
                  weatherData.data.weather[0].hourly[0].waterTempF +
                  " \u2109"),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              BoxedIcon((WeatherIcons.barometer), color: Colors.blue),
              Text("Pressure " +
                  weatherData.data.weather[0].hourly[0].pressureInches +
                  " in"),
            ],
          ),
        ],
      ),
    );
  }

  List<Employee> getEmployeeData() {
    return [
      Employee(10001, 'James', 'Project Lead', 20000),
      Employee(10002, 'Kathryn', 'Manager', 30000),
      Employee(10003, 'Lara', 'Developer', 15000),
      Employee(10004, 'Michael', 'Designer', 15000),
      Employee(10005, 'Martin', 'Developer', 15000),
      Employee(10006, 'Newberry', 'Developer', 15000),
      Employee(10007, 'Balnc', 'Developer', 15000),
      Employee(10008, 'Perry', 'Developer', 15000),
      Employee(10009, 'Gable', 'Developer', 15000),
      Employee(10010, 'Grimes', 'Developer', 15000)
    ];
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the employee which will be rendered in datagrid.
class Employee {
  /// Creates the employee class with required details.
  Employee(this.id, this.name, this.designation, this.salary);

  /// Id of an employee.
  final int id;

  /// Name of an employee.
  final String name;

  /// Designation of an employee.
  final String designation;

  /// Salary of an employee.
  final int salary;
}

/// An object to set the employee collection data source to the datagrid. This
/// is used to map the employee data to the datagrid widget.
class EmployeeDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  EmployeeDataSource({List<Employee> employeeData}) {
    _employeeData = employeeData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'id', value: e.id),
              DataGridCell<String>(columnName: 'name', value: e.name),
              DataGridCell<String>(
                  columnName: 'designation', value: e.designation),
              DataGridCell<int>(columnName: 'salary', value: e.salary),
            ]))
        .toList();
  }

  List<DataGridRow> _employeeData = [];

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(e.value.toString()),
      );
    }).toList());
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
                value:
                    BoxedIcon((WeatherIcons.day_cloudy), color: Colors.blue)),
            DataGridCell<String>(
                columnName: 'temp', value: e.tempF + " \u2109"),
            //    DataGridCell<String>(
            //      columnName: 'code', value: e.cloudcover + "%"),

            DataGridCell<String>(
                columnName: 'wind',
                value: e.windspeedMiles + " " + e.winddir16Point),
            DataGridCell<String>(
                columnName: 'wave',
                value: e.swellHeightFt + " " + e.swellDir16Point),
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
    return DataGridRowAdapter(cells: [
      Container(
        padding: EdgeInsets.all(2.0),
        alignment: Alignment.center,
        child: Text(
          row.getCells()[0].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        padding: EdgeInsets.all(2.0),
        child: row.getCells()[1].value,
      ),
      Container(
        alignment: Alignment.center,
        child: Text(
          row.getCells()[2].value.toString(),
          softWrap: true,
        ),
      ),
      Container(
        padding: EdgeInsets.all(2.0),
        alignment: Alignment.center,
        child: Text(
          row.getCells()[3].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        padding: EdgeInsets.all(2.0),
        alignment: Alignment.center,
        child: Text(
          row.getCells()[4].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ]);
  }
}

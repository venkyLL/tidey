import 'package:flutter/material.dart';

class TableExample extends StatefulWidget {
  @override
  _TableExampleState createState() => _TableExampleState();
}

class _TableExampleState extends State<TableExample> {
  Widget checkIcon() => Padding(
        padding: EdgeInsets.only(bottom: 16, top: 8),
        child: Icon(
          Icons.check_circle,
          color: Colors.green,
        ),
      );

  Widget cancelIcon() => Padding(
        padding: const EdgeInsets.only(bottom: 16, top: 8),
        child: Icon(
          Icons.cancel,
          color: Colors.red,
        ),
      );

  Widget coloredBox(Widget child, {bool top = false, bool bottom = false}) =>
      Container(
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    color: top ? Colors.blue.shade900 : Colors.transparent,
                    width: 2),
                bottom: BorderSide(
                    color: bottom ? Colors.blue.shade900 : Colors.transparent,
                    width: 2),
                left: BorderSide(color: Colors.blue.shade900, width: 2),
                right: BorderSide(color: Colors.blue.shade900, width: 2))),
        child: child,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple.shade900,
          title: Text('Table Example'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            border: TableBorder(
                verticalInside: BorderSide(color: Colors.grey.shade200),
                horizontalInside: BorderSide(color: Colors.grey.shade200)),
            columnWidths: {
              0: FractionColumnWidth(.4),
              1: FractionColumnWidth(.2),
              2: FractionColumnWidth(.2),
              3: FractionColumnWidth(.2)
            },
            children: [
              TableRow(children: [
                SizedBox(),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 16,
                    ),
                    Icon(Icons.home),
                    Text('Home'),
                    SizedBox(
                      height: 16,
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 16,
                    ),
                    Icon(
                      Icons.star_border,
                    ),
                    Text('Favorite'),
                    SizedBox(
                      height: 16,
                    ),
                  ],
                ),
                coloredBox(
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                          height: 16,
                        ),
                        Icon(Icons.save, color: Colors.blue.shade900),
                        Text('Saved'),
                        SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                    top: true)
              ]),
              TableRow(children: [
                Text(
                  'Vivek',
                  textAlign: TextAlign.center,
                ),
                cancelIcon(),
                cancelIcon(),
                coloredBox(checkIcon()),
              ]),
              TableRow(children: [
                Text(
                  'Matt',
                  textAlign: TextAlign.center,
                ),
                cancelIcon(),
                cancelIcon(),
                coloredBox(checkIcon()),
              ]),
              TableRow(children: [
                Text(
                  'Khizar',
                  textAlign: TextAlign.center,
                ),
                cancelIcon(),
                cancelIcon(),
                coloredBox(checkIcon()),
              ]),
              TableRow(children: [
                Text(
                  'Joey',
                  textAlign: TextAlign.center,
                ),
                cancelIcon(),
                cancelIcon(),
                coloredBox(checkIcon(), bottom: true),
              ]),
              TableRow(
                  children: [SizedBox(), SizedBox(), SizedBox(), SizedBox()])
            ],
          ),
        ));
  }
}

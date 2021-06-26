import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class WeeklyData extends StatelessWidget {
  final Map<String, dynamic> data;

  WeeklyData({this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 450,
      height: 400,
      child: SelectionCallbackExample.transformData(data),
    );
    // return Container(
    //   height: 400,
    //   width: 450,
    //   //child: SelectionCallbackExample.withSampleData(),
    // );
  }
}

class SelectionCallbackExample extends StatefulWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SelectionCallbackExample(this.seriesList, {this.animate});

  /// Creates a [charts.TimeSeriesChart] with sample data and no transition.
  factory SelectionCallbackExample.transformData(Map<String, dynamic> map) {
    return new SelectionCallbackExample(
      _createSampleData(map),
      // Disable animations for image tests.
      animate: true,
    );
  }

  // We need a Stateful widget to build the selection details with the current
  // selection as the state.
  @override
  State<StatefulWidget> createState() => new _SelectionCallbackState();

  /// Create one series with sample hard coded data.
  static List<charts.Series<TimeSeriesCases, DateTime>> _createSampleData(
      Map<String, dynamic> map) {
    List<TimeSeriesCases> status0 = List.empty(growable: true);
    for (var day in map['0']) {
      status0.add(TimeSeriesCases(DateTime.parse(day[0]), day[1]));
    }
    List<TimeSeriesCases> status1 = List.empty(growable: true);
    for (var day in map['1']) {
      status1.add(TimeSeriesCases(DateTime.parse(day[0]), day[1]));
    }
    List<TimeSeriesCases> status2 = List.empty(growable: true);
    for (var day in map['2']) {
      status2.add(TimeSeriesCases(DateTime.parse(day[0]), day[1]));
    }

    return [
      new charts.Series<TimeSeriesCases, DateTime>(
        id: 'Status 0',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (TimeSeriesCases sales, _) => sales.time,
        measureFn: (TimeSeriesCases sales, _) => sales.qtd,
        data: status0,
      ),
      new charts.Series<TimeSeriesCases, DateTime>(
        id: 'Status 1',
        colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
        domainFn: (TimeSeriesCases sales, _) => sales.time,
        measureFn: (TimeSeriesCases sales, _) => sales.qtd,
        data: status1,
      ),
      new charts.Series<TimeSeriesCases, DateTime>(
        id: 'Status 2',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (TimeSeriesCases sales, _) => sales.time,
        measureFn: (TimeSeriesCases sales, _) => sales.qtd,
        data: status2,
      )
    ];
  }
}

class _SelectionCallbackState extends State<SelectionCallbackExample> {
  DateTime _time;
  Map<String, num> _measures;

  // Listens to the underlying selection changes, and updates the information
  // relevant to building the primitive legend like information under the
  // chart.
  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    DateTime time;
    final measures = <String, num>{};

    // We get the model that updated with a list of [SeriesDatum] which is
    // simply a pair of series & datum.
    //
    // Walk the selection updating the measures map, storing off the sales and
    // series name for each selection point.
    if (selectedDatum.isNotEmpty) {
      time = selectedDatum.first.datum.time;
      selectedDatum.forEach((charts.SeriesDatum datumPair) {
        measures[datumPair.series.displayName] = datumPair.datum.qtd;
      });
    }

    // Request a build.
    setState(() {
      _time = time;
      _measures = measures;
    });
  }

  @override
  Widget build(BuildContext context) {
    // The children consist of a Chart and Text widgets below to hold the info.
    final children = <Widget>[
      Row(
        children: [
          SizedBox(
              height: 300,
              width: 450,
              child: new charts.TimeSeriesChart(
                widget.seriesList,
                animate: widget.animate,
                selectionModels: [
                  new charts.SelectionModelConfig(
                    type: charts.SelectionModelType.info,
                    changedListener: _onSelectionChanged,
                  )
                ],
              )),
          // SizedBox(
          //     height: 350,
          //     child: Column(
          //       children: <Widget>[
          //         Row(
          //           children: [
          //             Text(
          //               'Status 0',
          //               style: TextStyle(color: Colors.white),
          //             ),
          //             Icon(
          //               Icons.check_box_outlined,
          //               color: Colors.green,
          //             ),
          //           ],
          //         ),
          //         Row(
          //           children: [
          //             Text(
          //               'Status 1',
          //               style: TextStyle(color: Colors.white),
          //             ),
          //             Icon(
          //               Icons.indeterminate_check_box_outlined,
          //               color: Colors.yellow,
          //             ),
          //           ],
          //         ),
          //         Row(
          //           children: [
          //             Text(
          //               'Status 2',
          //               style: TextStyle(color: Colors.white),
          //             ),
          //             Icon(
          //               Icons.indeterminate_check_box_outlined,
          //               color: Colors.red,
          //             ),
          //           ],
          //         ),
          //       ],
          //     ))
        ],
      ),
    ];

    // If there is a selection, then include the details.
    if (_time != null) {
      children.add(new Padding(
          padding: new EdgeInsets.only(top: 5.0, bottom: 5.0),
          child: new Text(
            "Data: ${_time.day}/${_time.month}/${_time.year}",
            style: TextStyle(color: Colors.white),
          )));
    }
    _measures?.forEach((String series, num value) {
      switch (series) {
        case 'Status 0':
          children.add(new Padding(
              padding: EdgeInsets.only(top: 2.5, bottom: 2.5),
              child: Text(
                'Utilizando máscara [qtd]: $value',
                style: TextStyle(color: Colors.green),
              )));
          break;
        case 'Status 1':
          children.add(new Padding(
              padding: EdgeInsets.only(top: 2.5, bottom: 2.5),
              child: Text(
                'Sem máscara e sem cadastro [qtd]: $value',
                style: TextStyle(color: Colors.yellow),
              )));
          break;
        case 'Status 2':
          children.add(new Padding(
              padding: EdgeInsets.only(top: 2.5, bottom: 2.5),
              child: Text(
                'Sem máscara e cadastrado [qtd]: $value',
                style: TextStyle(color: Colors.red),
              )));
          break;
        default:
      }
    });

    return new Column(children: children);
  }
}

class TimeSeriesCases {
  final DateTime time;
  final int qtd;

  TimeSeriesCases(this.time, this.qtd);
}

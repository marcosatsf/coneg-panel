import 'package:coneg/models/design_color_model.dart';
import 'package:coneg/ui/help_view.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class PredictionData extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool animate;
  final String location;

  PredictionData({this.data, this.animate, this.location});

  @override
  Widget build(BuildContext context) {
    return SelectionCallbackExample.transformData(data, animate, location);
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
  final String location;

  SelectionCallbackExample(this.seriesList, {this.animate, this.location});

  /// Creates a [charts.TimeSeriesChart] with sample data and no transition.
  factory SelectionCallbackExample.transformData(
      Map<String, dynamic> map, bool animate, String location) {
    return new SelectionCallbackExample(
      _createSampleData(map),
      // Disable animations for image tests.
      animate: animate,
      location: location,
    );
  }

  // We need a Stateful widget to build the selection details with the current
  // selection as the state.
  @override
  State<StatefulWidget> createState() => new _SelectionCallbackState();

  /// Create one series with sample hard coded data.
  static List<charts.Series<TimeSeriesCases, String>> _createSampleData(
      Map<String, dynamic> map) {
    List<TimeSeriesCases> daysCases = List.empty(growable: true);
    for (var day in map.keys) {
      daysCases.add(TimeSeriesCases(DateTime.parse(day), map[day][1],
          predicted: map[day][0]));
    }
    return [
      new charts.Series<TimeSeriesCases, String>(
        id: 'Casos novos por dia',
        colorFn: (TimeSeriesCases ts, __) {
          switch (ts.predicted) {
            case 0:
              return charts.ColorUtil.fromDartColor(Colors.indigo.shade400);
              break;
            case 1:
              return charts.ColorUtil.fromDartColor(Colors.redAccent.shade700);
              break;
            default:
              return charts.ColorUtil.fromDartColor(Colors.indigo.shade400);
              break;
          }
        },
        domainFn: (TimeSeriesCases ts, int idx) =>
            DateFormat('dd/MM').format(ts.time),
        measureFn: (TimeSeriesCases ts, _) => ts.qtd,
        data: daysCases,
        labelAccessorFn: (TimeSeriesCases ts, _) => '${ts.qtd.toString()}',
      ),
    ];
  }
}

class _SelectionCallbackState extends State<SelectionCallbackExample> {
  DateTime _time;
  Map<String, num> _measures;
  ConegDesign weeklyDesign = GetIt.I<ConegDesign>();
  String predData = "Quadro Atual Regional";
  HelpView helpPredData = HelpView('assets/helpPredicao.txt');

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
      Padding(
          padding: EdgeInsets.all(1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: <Widget>[
                  // Stroked text as border.
                  Text(
                    predData,
                    style: TextStyle(
                      fontSize: 18,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 6
                        ..color = weeklyDesign.getBlue(),
                    ),
                  ),
                  // Solid text as fill.
                  Text(
                    predData,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ),
              Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: IconButton(
                      splashRadius: 10,
                      icon: Icon(
                        Icons.help_outline_rounded,
                        color: weeklyDesign.getPurple(),
                      ),
                      onPressed: () {
                        helpPredData.showHelp(
                            context, "Ajuda em Quadro Atual Regional");
                      })),
            ],
          )),
      Text(
          'Situação em ${widget.location} de ${DateFormat('dd/MM/yyyy').format(widget.seriesList.first.data.first.time)} para ${DateFormat('dd/MM/yyyy').format(widget.seriesList.first.data.last.time)}'),
      SizedBox(
          height: 400,
          width: 800,
          child: charts.BarChart(
            widget.seriesList,
            animate: widget.animate,
            animationDuration: new Duration(seconds: 2),
            // Configure a stroke width to enable borders on the bars.
            defaultRenderer: new charts.BarRendererConfig(
                strokeWidthPx: 2.0,
                barRendererDecorator: charts.BarLabelDecorator<String>()),
          )

          // new charts.TimeSeriesChart(
          //   widget.seriesList,
          //   animate: widget.animate,
          //   animationDuration: new Duration(seconds: 3),
          //   selectionModels: [
          //     new charts.SelectionModelConfig(
          //       type: charts.SelectionModelType.info,
          //       changedListener: _onSelectionChanged,
          //     )
          //   ],
          // ),
          ),
    ];

    // If there is a selection, then include the details.
    // if (_time != null) {
    //   children.add(new Padding(
    //       padding: new EdgeInsets.only(top: 5.0, bottom: 5.0),
    //       child: new Text(
    //         DateFormat('dd/MM/yyyy').format(_time),
    //         style: TextStyle(color: Colors.black),
    //       )));
    // }
    // _measures?.forEach((String series, num value) {
    //   switch (series) {
    //     case 'Casos novos por dia':
    //       children.add(new Padding(
    //           padding: EdgeInsets.only(top: 2.5, bottom: 2.5),
    //           child: Text(
    //             'Quantidade: $value',
    //             style: TextStyle(
    //                 color: Colors.indigo.shade400, fontWeight: FontWeight.bold),
    //           )));
    //       break;
    //     default:
    //   }
    // });

    return new Column(
        crossAxisAlignment: CrossAxisAlignment.center, children: children);
  }
}

class TimeSeriesCases {
  final DateTime time;
  final int qtd;
  final int predicted;

  TimeSeriesCases(this.time, this.qtd, {this.predicted});
}

import 'package:coneg/models/design_color_model.dart';
import 'package:coneg/ui/help_view.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'package:get_it/get_it.dart';

class UsageData extends StatelessWidget {
  final List data;
  final bool animate;

  UsageData({this.data, this.animate});

  @override
  Widget build(BuildContext context) {
    return SimplePieChart.transformData(data, animate);
    // return Container(
    //   height: 400,
    //   width: 450,
    //   child: SimplePieChart.withRandomData(),
    // );
  }
}

class SimplePieChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  final ConegDesign usageDesign = GetIt.I<ConegDesign>();
  final String usageData = "Registros Totais";
  final HelpView helpUsageData = HelpView('assets/helpUsage.txt');

  SimplePieChart(this.seriesList, {this.animate});

  /// Creates a [PieChart] with sample data and no transition.
  factory SimplePieChart.transformData(List data, bool animate) {
    return new SimplePieChart(
      _createSampleData(data),
      // Disable animations for image tests.
      animate: animate,
    );
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      Padding(
          padding: EdgeInsets.all(1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Stack(
                  children: <Widget>[
                    // Stroked text as border.
                    Text(
                      usageData,
                      style: TextStyle(
                        fontSize: 18,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 6
                          ..color = usageDesign.getBlue(),
                      ),
                    ),
                    // Solid text as fill.
                    Text(
                      usageData,
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
                          color: usageDesign.getPurple(),
                        ),
                        onPressed: () {
                          helpUsageData.showHelp(
                              context, "Ajuda em $usageData");
                        })),
              ]),
              Text(
                "Data: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}",
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ],
          )),
      SizedBox(
        height: 300,
        width: 300,
        child: new charts.PieChart(seriesList,
            animate: animate,
            behaviors: [new charts.DatumLegend()],
            defaultRenderer: new charts.ArcRendererConfig(
                arcRendererDecorators: [new charts.ArcLabelDecorator()])),
      ),
    ];

    return new Column(
        crossAxisAlignment: CrossAxisAlignment.center, children: children);
  }

  static List<charts.Series<LinearCases, String>> _createSampleData(List data) {
    try {
      final dataList = [
        new LinearCases('CM', data[0]),
        new LinearCases('DSM', data[1]),
        new LinearCases('CSM', data[2])
      ];

      return [
        new charts.Series<LinearCases, String>(
          id: 'Status',
          domainFn: (LinearCases cases, _) => cases.status,
          measureFn: (LinearCases cases, _) => cases.qtd,
          colorFn: (LinearCases cases, _) {
            switch (cases.status) {
              case 'CM':
                return charts.ColorUtil.fromDartColor(
                    Colors.greenAccent.shade700);
                break;
              case 'DSM':
                return charts.ColorUtil.fromDartColor(
                    Colors.yellowAccent.shade700);
                break;
              case 'CSM':
                return charts.ColorUtil.fromDartColor(
                    Colors.redAccent.shade700);
                break;
              default:
                return charts.ColorUtil.fromDartColor(Colors.blue.shade800);
                break;
            }
          },
          data: dataList,
          labelAccessorFn: (LinearCases row, _) => '${row.status}: ${row.qtd}',
        )
      ];
    } catch (e) {
      print('Got an error :(');
    }
  }
}

/// Sample linear data type.
class LinearCases {
  final String status;
  final int qtd;

  LinearCases(this.status, this.qtd);
}

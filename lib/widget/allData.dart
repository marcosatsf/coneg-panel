/// Bar chart example
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class AllData extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool animate;

  AllData({this.data, this.animate});

  Widget _buildRow() {
    List<Widget> children = List.empty(growable: true);
    for (var cams in data.keys) {
      children.add(Flexible(
          child: Column(
        children: [
          Stack(
            children: <Widget>[
              // Stroked text as border.
              Text(
                cams,
                style: TextStyle(
                  fontSize: 15,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 6
                    ..color = Color(0xFF1F41B4),
                ),
              ),
              // Solid text as fill.
              Text(
                cams,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[300],
                ),
              ),
            ],
          ),
          Flexible(
              child:
                  GroupedFillColorBarChart.transformData(data[cams], animate))
        ],
      )));
    }
    return Row(children: children);
  }

  @override
  Widget build(BuildContext context) {
    return _buildRow();
    // return Container(
    //   height: 400,
    //   width: 450,
    //   //child: SelectionCallbackExample.withSampleData(),
    // );
  }
}

/// Example of a grouped bar chart with three series, each rendered with
/// different fill colors.
class GroupedFillColorBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  GroupedFillColorBarChart(this.seriesList, {this.animate});

  factory GroupedFillColorBarChart.transformData(
      List<dynamic> data, bool animate) {
    return new GroupedFillColorBarChart(
      _createSampleData(data),
      // Disable animations for image tests.
      animate: animate,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      // Configure a stroke width to enable borders on the bars.
      defaultRenderer: new charts.BarRendererConfig(
          strokeWidthPx: 2.0,
          barRendererDecorator: charts.BarLabelDecorator<String>()),
      domainAxis: new charts.OrdinalAxisSpec(),
    );
  }

  /// Create series list with multiple series
  static List<charts.Series<OrdinalCases, String>> _createSampleData(
      List<dynamic> data) {
    final allStatusData = [
      new OrdinalCases('CM', data[0]), //CM
      new OrdinalCases('DSM', data[1]), //DSM
      new OrdinalCases('CSM', data[2]) //CSM
    ];

    return [
      // Blue bars with a lighter center color.
      new charts.Series<OrdinalCases, String>(
          id: 'Utilizacao',
          domainFn: (OrdinalCases sales, _) => sales.status,
          measureFn: (OrdinalCases sales, _) => sales.cases,
          data: allStatusData,
          colorFn: (uso, __) {
            switch (uso.status) {
              case 'CM':
                return charts.ColorUtil.fromDartColor(
                    Colors.green.withOpacity(0.75));
                break;
              case 'DSM':
                return charts.ColorUtil.fromDartColor(
                    Colors.yellow.shade700.withOpacity(0.75));
                break;
              case 'CSM':
                return charts.ColorUtil.fromDartColor(
                    Colors.red.withOpacity(0.75));
                break;
              default:
                return charts.ColorUtil.fromDartColor(
                    Colors.blue.shade800.withOpacity(0.75));
                break;
            }
          },
          fillColorFn: (uso, __) {
            switch (uso.status) {
              case 'CM':
                return charts.ColorUtil.fromDartColor(Colors.green);
                break;
              case 'DSM':
                return charts.ColorUtil.fromDartColor(Colors.yellow.shade700);
                break;
              case 'CSM':
                return charts.ColorUtil.fromDartColor(Colors.red);
                break;
              default:
                return charts.ColorUtil.fromDartColor(Colors.blue.shade800);
                break;
            }
          },
          labelAccessorFn: (uso, __) => '${uso.cases.toString()}'),
    ];
  }
}

/// Sample ordinal data type.
class OrdinalCases {
  final String status;
  final int cases;

  OrdinalCases(this.status, this.cases);
}

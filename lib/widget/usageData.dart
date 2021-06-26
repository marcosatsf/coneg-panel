import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:math';

class UsageData extends StatelessWidget {
  final List data;

  UsageData({this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 450,
      height: 400,
      child: SimplePieChart.transformData(data),
    );
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

  SimplePieChart(this.seriesList, {this.animate});

  /// Creates a [PieChart] with sample data and no transition.
  factory SimplePieChart.transformData(List data) {
    return new SimplePieChart(
      _createSampleData(data),
      // Disable animations for image tests.
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(seriesList,
        animate: animate,
        defaultRenderer: new charts.ArcRendererConfig(
            arcRendererDecorators: [new charts.ArcLabelDecorator()]));
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearCases, int>> _createSampleData(List data) {
    final dataList = [
      new LinearCases(data[0][0], data[0][1]),
      new LinearCases(data[1][0], data[1][1]),
      new LinearCases(data[2][0], data[2][1]),
    ];

    return [
      new charts.Series<LinearCases, int>(
        id: 'Status',
        domainFn: (LinearCases sales, _) => sales.status,
        measureFn: (LinearCases sales, _) => sales.qtd,
        colorFn: (LinearCases sales, _) {
          switch (sales.status) {
            case 0:
              return charts.ColorUtil.fromDartColor(Colors.green);
              break;
            case 1:
              return charts.ColorUtil.fromDartColor(Colors.yellow);
              break;
            case 2:
              return charts.ColorUtil.fromDartColor(Colors.red);
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
  }
}

/// Sample linear data type.
class LinearCases {
  final int status;
  final int qtd;

  LinearCases(this.status, this.qtd);
}

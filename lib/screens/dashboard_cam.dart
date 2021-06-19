import 'package:flutter/material.dart';
import 'package:coneg/widget/appbarpanel.dart';
import 'package:coneg/widget/drawerpanel.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:math';

class DashboardCam extends StatefulWidget {
  const DashboardCam({Key key}) : super(key: key);

  @override
  _DashboardCamState createState() => _DashboardCamState();
}

class _DashboardCamState extends State<DashboardCam> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600,
      height: 600,
      child: SimplePieChart.withRandomData(),
    );
  }
}
// //Substitute by root_page
// class DashboardCam extends StatelessWidget {
//   String text;
//   DashboardCam(this.text);
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.blue.shade800,
//       height: 200,
//       child: Text(text),
//     );
//   }
// }

class SimplePieChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimplePieChart(this.seriesList, {this.animate});

  /// Creates a [PieChart] with sample data and no transition.
  factory SimplePieChart.withSampleData() {
    return new SimplePieChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  // EXCLUDE_FROM_GALLERY_DOCS_START
  // This section is excluded from being copied to the gallery.
  // It is used for creating random series data to demonstrate animation in
  // the example app only.
  factory SimplePieChart.withRandomData() {
    return new SimplePieChart(_createRandomData());
  }

  /// Create random data.
  static List<charts.Series<LinearSales, int>> _createRandomData() {
    final random = new Random();

    final data = [
      new LinearSales(0, random.nextInt(100)),
      new LinearSales(1, random.nextInt(100)),
      new LinearSales(2, random.nextInt(100)),
      new LinearSales(3, random.nextInt(100)),
    ];
    for (var item in data) {
      print(item.sales);
    }
    return [
      new charts.Series<LinearSales, int>(
        id: 'Sales',
        colorFn: (LinearSales sales, _) {
          switch (sales.year) {
            case 0:
              return charts.ColorUtil.fromDartColor(Colors.red.shade700);
              break;
            case 1:
              return charts.ColorUtil.fromDartColor(Colors.blue.shade700);
              break;
            case 2:
              return charts.ColorUtil.fromDartColor(Colors.amber.shade700);
              break;
            case 3:
              return charts.ColorUtil.fromDartColor(Colors.green.shade700);
              break;
            default:
              return charts.ColorUtil.fromDartColor(Colors.amber.shade700);
          }
        },
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
        labelAccessorFn: (LinearSales row, _) => '${row.year}: ${row.sales}',
      )
    ];
  }
  // EXCLUDE_FROM_GALLERY_DOCS_END

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(seriesList,
        animate: animate,
        defaultRenderer: new charts.ArcRendererConfig(
            arcRendererDecorators: [new charts.ArcLabelDecorator()]));
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearSales, int>> _createSampleData() {
    final data = [
      new LinearSales(0, 100),
      new LinearSales(1, 75),
      new LinearSales(2, 25),
      new LinearSales(3, 5),
    ];

    return [
      new charts.Series<LinearSales, int>(
        id: 'Sales',
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
        labelAccessorFn: (LinearSales row, _) => '${row.year}: ${row.sales}',
      )
    ];
  }
}

/// Sample linear data type.
class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}

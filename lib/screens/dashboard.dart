import 'dart:async';

import 'package:coneg/models/design_color_model.dart';
import 'package:coneg/models/request_model.dart';
import 'package:coneg/widget/allData.dart';
import 'package:coneg/widget/dailyData.dart';
import 'package:coneg/widget/infoData.dart';
import 'package:coneg/widget/usageData.dart';
import 'package:coneg/widget/weeklyData.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  ConegDesign design = GetIt.I<ConegDesign>();
  Map<String, dynamic> res, resOld;
  Map<String, Widget> _build = {
    "alldata": CircularProgressIndicator(),
    "table_alldata": CircularProgressIndicator()
  };
  Timer caller;
  Duration callerDuration = Duration(minutes: 1);
  String nowInfoFormatted;

  _DashboardState();

  @override
  void initState() {
    super.initState();
    _loadData(true);
    caller = Timer.periodic(callerDuration, (e) {
      _loadData(false);
      print(e.tick);
    });
  }

  void _loadData(bool option) async {
    if (option == false) resOld = res;
    res = await RequestConeg().getJsonAuth(endpoint: '/route_all_info');
    DateTime now = DateTime.now();
    setState(() {
      nowInfoFormatted = DateFormat('dd/MM/yyyy - HH:mm').format(now);
      //"${now.day}/${now.month}/${now.year} às ${now.hour}:${now.minute}";
      _build['alldata'] = AllData(
        data: res,
        animate: option,
      );
      _build['table_alldata'] = _buildDataTable(option);
    });
    print(res);
  }

  Widget _buildText(int value) {
    if (value > 0) {
      return Container(
        margin: EdgeInsets.only(left: 5),
        padding: EdgeInsets.only(left: 5, right: 5),
        decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(width: 2, color: Colors.green.shade400)),
        child: Row(
          children: [
            Icon(
              Icons.arrow_upward,
              color: Colors.green.shade400,
            ),
            Text(
              '${value.toString()}',
              style: TextStyle(color: Colors.green.shade400),
            )
          ],
        ),
      );
      //return Text(' + ${value.toString()}', style: ,)
    } else {
      if (value < 0) {
        return Container(
          margin: EdgeInsets.only(left: 5),
          padding: EdgeInsets.only(left: 5, right: 5),
          decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(width: 2, color: Colors.red)),
          child: Row(
            children: [
              Icon(
                Icons.arrow_downward,
                color: Colors.red,
              ),
              Text(
                '${value.toString()}',
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
        );
      } else {
        return Container(
          margin: EdgeInsets.only(left: 5),
          padding: EdgeInsets.only(left: 5, right: 5),
          decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(width: 2, color: Colors.yellow)),
          child: Row(
            children: [
              Icon(
                Icons.horizontal_rule,
                color: Colors.yellow,
              ),
              Text(
                '${value.toString()}',
                style: TextStyle(color: Colors.yellow),
              )
            ],
          ),
        );
      }
    }
  }

  Widget _buildDataTable(bool option) {
    List<DataRow> rows = List.empty(growable: true);
    if (option == false) {
      for (var cams in res.keys) {
        int status0 = res[cams][0] - resOld[cams][0];
        int status1 = res[cams][1] - resOld[cams][1];
        int status2 = res[cams][2] - resOld[cams][2];
        rows.add(DataRow(cells: [
          DataCell(Text(cams)),
          DataCell(Row(
            children: [Text('${res[cams][0].toString()}'), _buildText(status0)],
          )),
          DataCell(Row(
            children: [Text('${res[cams][1].toString()}'), _buildText(status1)],
          )),
          DataCell(Row(
            children: [Text('${res[cams][2].toString()}'), _buildText(status2)],
          ))
        ]));
      }
    } else {
      for (var cams in res.keys) {
        rows.add(DataRow(cells: [
          DataCell(Text(cams)),
          DataCell(Text(res[cams][0].toString())),
          DataCell(Text(res[cams][1].toString())),
          DataCell(Text(res[cams][2].toString()))
        ]));
      }
    }

    //return Container();
    return SingleChildScrollView(
      child: DataTable(columns: [
        DataColumn(label: Text('Localização camera')),
        DataColumn(label: Text('Utilizando máscara hoje')),
        DataColumn(label: Text('Desconhecido sem máscara')),
        DataColumn(label: Text('Cadastrado sem máscara'))
      ], rows: rows),
    );
  }

  @override
  void dispose() {
    caller.cancel();
    super.dispose();
  }

  Widget _buildContainer(Widget childWidget, {double h, double w}) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Color(0xFF17DFD3),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          border: Border.all(width: 5, color: Color(0xFF23A39B))),
      child: childWidget,
      height: h != null ? h : 900,
      width: w != null ? w : 900,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8),
        width: 1000,
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.all(5),
                child: Tooltip(
                  message: "Última vez atualizado em $nowInfoFormatted",
                  child: Icon(
                    Icons.help_outline_rounded,
                    color: design.getPurple(),
                  ),
                )),
            _buildContainer(_build['alldata'], h: 350),
            _buildContainer(_build['table_alldata'], h: 400),
          ],
        ));
  }
}

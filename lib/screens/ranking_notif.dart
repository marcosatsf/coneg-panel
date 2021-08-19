import 'dart:io';

import 'package:coneg/models/auth_model.dart';
import 'package:coneg/models/design_color_model.dart';
import 'package:coneg/models/request_model.dart';
import 'package:coneg/ui/help_view.dart';
import 'package:coneg/utils/routes.dart';
import 'package:coneg/widget/appbarpanel.dart';
import 'package:coneg/widget/drawerpanel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:typed_data';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:velocity_x/velocity_x.dart';

class RankingNotif extends StatefulWidget {
  @override
  _RankingNotifState createState() => _RankingNotifState();
}

class _RankingNotifState extends State<RankingNotif> {
  Widget buildTable = Container(
    height: 50,
    width: 50,
    child: CircularProgressIndicator(),
  );
  Timer caller;
  Duration callerDuration = Duration(minutes: 1);
  Map<String, dynamic> res, resOld;
  RequestConeg requestSystem = RequestConeg();
  ConegDesign rankingNotifDesign = GetIt.I<ConegDesign>();
  String title = "Ranking de Cadastrados Sem Máscara";
  HelpView helpRankingNotif = HelpView('assets/helpRankingNotif.txt');
  bool initial = true;

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
    res = await RequestConeg().getJsonAuth(endpoint: '/get_ranking');
    print(res);
    setState(() {
      buildTable = _buildDataTable(option, res['notified']);
    });
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

  Widget _buildDataTable(bool option, Map<String, dynamic> ranking) {
    List<DataRow> rows = List.empty(growable: true);
    if (option == false) {
      for (var pesid in ranking.keys) {
        int delta = ranking[pesid]['qtd'] - resOld[pesid]['qtd'];
        rows.add(DataRow(cells: [
          DataCell(Text(pesid)),
          DataCell(Text(ranking[pesid]['name'].toString())),
          DataCell(Row(
            children: [
              Text('${ranking[pesid]['qtd'].toString()}'),
              _buildText(delta)
            ],
          )),
        ]));
      }
    } else {
      for (var pesid in ranking.keys) {
        rows.add(DataRow(cells: [
          DataCell(Text(pesid)),
          DataCell(Text(ranking[pesid]['name'].toString())),
          DataCell(Text(ranking[pesid]['qtd'].toString())),
        ]));
      }
    }
    rows.sort((a, b) => (b.cells.last.child as Text)
        .data
        .compareTo((a.cells.last.child as Text).data));

    return Column(children: [
      SingleChildScrollView(
          child: DataTable(
              sortColumnIndex: 2,
              sortAscending: false,
              headingRowColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.hovered))
                  return rankingNotifDesign.getPurple().withOpacity(0.20);
                return rankingNotifDesign
                    .getPurple()
                    .withOpacity(0.50); // Use the default value.
              }),
              columns: [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Nome')),
                DataColumn(
                  label: Text('Capturas totais sem máscara'),
                  numeric: true,
                ),
              ],
              rows: rows)),
    ]);
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
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: <Widget>[
                    // Stroked text as border.
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 40,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 6
                          ..color = rankingNotifDesign.getBlue(),
                      ),
                    ),
                    // Solid text as fill.
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 40,
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
                          color: rankingNotifDesign.getPurple(),
                        ),
                        onPressed: () {
                          helpRankingNotif.showHelp(context, "Ajuda em $title");
                        })),
              ],
            ),
          ),
          _buildContainer(buildTable, h: 500, w: 700),
        ],
      ),
    );
  }
}

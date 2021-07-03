import 'dart:async';

import 'package:coneg/models/design_color_model.dart';
import 'package:coneg/models/request_model.dart';
import 'package:coneg/widget/dailyData.dart';
import 'package:coneg/widget/infoData.dart';
import 'package:coneg/widget/usageData.dart';
import 'package:coneg/widget/weeklyData.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class DashboardCam extends StatefulWidget {
  DashboardCam({Key key, this.local}) : super(key: key);

  final String local;

  @override
  _DashboardCamState createState() => _DashboardCamState(local);
}

class _DashboardCamState extends State<DashboardCam> {
  ConegDesign design = GetIt.I<ConegDesign>();
  String local;
  Map<String, dynamic> res;
  Map<String, Widget> _build = {
    "weeklydata": CircularProgressIndicator(),
    "usagedata": CircularProgressIndicator(),
    "infodata": CircularProgressIndicator()
  };
  Timer caller;
  Duration callerDuration = Duration(minutes: 1);
  String nowInfoFormatted;

  _DashboardCamState(this.local);

  @override
  void initState() {
    super.initState();
    _loadData(local, true);
    caller = Timer.periodic(callerDuration, (e) {
      _loadData(local, false);
      print(e.tick);
    });
  }

  void _loadData(String where, bool option) async {
    res = await RequestConeg().getJsonAuth(
        endpoint: '/route_info',
        query: [where, "weeklydata", "usagedata", "infodata", "dailydata"]);
    DateTime now = DateTime.now();
    setState(() {
      nowInfoFormatted = DateFormat('dd/MM/yyyy - HH:mm').format(now);
      //"${now.day}/${now.month}/${now.year} às ${now.hour}:${now.minute}";
      _build['weeklydata'] = WeeklyData(
        data: res['weeklydata'],
        animate: option,
      );
      _build['usagedata'] = UsageData(
        data: res['usagedata'],
        animate: option,
      );
      _build['infodata'] = InfoData(
        data: res['infodata'],
        titulo: "Estatística de $where",
      );
      _build['dailydata'] = DailyData(
        data: res['dailydata'],
        animate: option,
      );
    });
    print(res);
  }

  @override
  void dispose() {
    caller.cancel();
    super.dispose();
  }

  Widget _buildContainer(Widget childWidget, {double h, double w}) {
    return Container(
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
        height: 800,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: <Widget>[
                    _buildContainer(_build['weeklydata'], h: 400, w: 450),
                    _buildContainer(_build['infodata'], h: 380, w: 450),
                  ],
                ),
                Column(
                  children: <Widget>[
                    _buildContainer(_build['dailydata'], h: 400, w: 450),
                    _buildContainer(_build['usagedata'], h: 380, w: 450),
                  ],
                ),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Tooltip(
                      message: "Última vez atualizado em $nowInfoFormatted",
                      child: Icon(
                        Icons.help_outline_rounded,
                        color: design.getPurple(),
                      ),
                    )),
              ],
            ),
          ],
        ));
  }
}

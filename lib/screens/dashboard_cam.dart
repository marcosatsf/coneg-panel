import 'dart:async';

import 'package:coneg/models/design_color_model.dart';
import 'package:coneg/models/request_model.dart';
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
        query: [where, "weeklydata", "usagedata", "infodata"]);
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
    });
    print(res);
  }

  @override
  void dispose() {
    caller.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8),
        width: 900,
        height: 800,
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Tooltip(
                      message: "Última vez atualizado em $nowInfoFormatted",
                      child: Stack(
                        children: <Widget>[
                          // Stroked text as border.
                          Text(
                            "Dashboard de $local",
                            style: TextStyle(
                              fontSize: 22,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 6
                                ..color = design.getBlue(),
                            ),
                          ),
                          // Solid text as fill.
                          Text(
                            "Dashboard de $local",
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.grey[300],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: _build['weeklydata'],
                ),
                Expanded(
                  child: _build['usagedata'],
                ),
                //WeeklyData(data: res['weeklydata']),
                //UsageData(),
              ],
            ),
            Expanded(
              child: _build['infodata'],
            ),
            //InfoData(),
          ],
        ));
  }
}

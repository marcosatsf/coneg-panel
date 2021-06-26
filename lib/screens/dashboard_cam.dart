import 'package:coneg/models/design_color_model.dart';
import 'package:coneg/models/request_model.dart';
import 'package:coneg/widget/infoData.dart';
import 'package:coneg/widget/usageData.dart';
import 'package:coneg/widget/weeklyData.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

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

  _DashboardCamState(this.local);

  @override
  void initState() {
    super.initState();
    _loadData(local);
    // t = Timer.periodic(Duration(seconds: 5), (e) => print(e.tick));
  }

  void _loadData(String where) async {
    res = await RequestConeg().getJsonAuth(
        endpoint: '/route_info',
        query: [where, "weeklydata", "usagedata", "infodata"]);
    setState(() {
      _build['weeklydata'] = WeeklyData(data: res['weeklydata']);
      _build['usagedata'] = UsageData(data: res['usagedata']);
      _build['infodata'] = InfoData(data: res['infodata']);
    });
    print(res);
  }

  // @override
  // void dispose() {
  //   t.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 1000,
        height: 800,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _build['weeklydata'],
                _build['usagedata'],
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

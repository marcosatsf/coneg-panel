import 'package:coneg/widget/infoData.dart';
import 'package:coneg/widget/usageData.dart';
import 'package:coneg/widget/weeklyData.dart';
import 'package:flutter/material.dart';

class DashboardCam extends StatefulWidget {
  DashboardCam({Key key, this.local}) : super(key: key);

  final String local;

  @override
  _DashboardCamState createState() => _DashboardCamState(local);
}

class _DashboardCamState extends State<DashboardCam> {
  String local;

  _DashboardCamState(this.local);

  @override
  void initState() {
    super.initState();
    //_loadRes(masterRoute);
    // t = Timer.periodic(Duration(seconds: 5), (e) => print(e.tick));
  }

  // @override
  // void dispose() {
  //   t.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 900,
        height: 800,
        child: Column(
          children: [
            Row(
              children: [
                WeeklyData(),
                UsageData(),
              ],
            ),
            InfoData(),
          ],
        ));
  }
}

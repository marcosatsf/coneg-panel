import 'dart:async';

import 'package:coneg/models/design_color_model.dart';
import 'package:coneg/models/request_model.dart';
import 'package:coneg/widget/predictionData.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class DashboardPred extends StatefulWidget {
  DashboardPred({Key key}) : super(key: key);

  @override
  _DashboardPredState createState() => _DashboardPredState();
}

Widget waitPrediction() {
  return Container(
    padding: EdgeInsets.all(10),
    margin: EdgeInsets.all(5),
    decoration: BoxDecoration(
        color: Color(0xFF17DFD3),
        borderRadius: BorderRadius.all(Radius.circular(20)),
        border: Border.all(width: 5, color: Color(0xFF970062))),
    child: Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(20),
          child: Text(
              'Por favor aguarde enquanto a predição de hoje é realizada!'),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(),
        ),
      ],
    ),
    height: 200,
    width: 200,
  );
}

class _DashboardPredState extends State<DashboardPred> {
  ConegDesign design = GetIt.I<ConegDesign>();
  Map<String, dynamic> res, resOld;
  Map<String, Widget> _build = {"timeseries": waitPrediction()};
  Timer caller;
  Duration callerDuration = Duration(hours: 1);
  String nowInfoFormatted;
  String informations =
      "Informações de localização ainda não disponível, aguarde...";

  _DashboardPredState();

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
    DateTime now = DateTime.now();
    res = await RequestConeg().getJsonAuthListQuery(
        endpoint: '/route_info',
        query: [DateFormat('dd/MM/yyyy').format(now), "timeseries"]);
    setState(() {
      nowInfoFormatted = DateFormat('dd/MM/yyyy - HH:mm').format(now);
      //"${now.day}/${now.month}/${now.year} às ${now.hour}:${now.minute}";
      _build['timeseries'] = PredictionData(
          data: res['timeseries']['prediction'],
          animate: option,
          location: res['timeseries']['locale']);
      informations = 'Situação hoje em ${res['timeseries']['locale']}';
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
            _buildContainer(_build['timeseries'], h: 550),
            //_buildContainer(Text(informations), h: 300),
          ],
        ));
  }
}

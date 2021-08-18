import 'dart:collection';
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

class HistNotif extends StatefulWidget {
  @override
  _HistNotifState createState() => _HistNotifState();
}

class _HistNotifState extends State<HistNotif> {
  final GlobalKey<FormState> _formKeySearch = GlobalKey<FormState>();
  Widget buildTable = Container(
    height: 50,
    width: 50,
    child: CircularProgressIndicator(),
  );
  Timer caller;
  Duration callerDuration = Duration(minutes: 1);
  TextEditingController idPessoa = TextEditingController();
  RequestConeg requestSystem = RequestConeg();
  ConegDesign histNotifDesign = GetIt.I<ConegDesign>();
  List<dynamic> gotCases = List<dynamic>.empty();
  String title = "Histórico de cadastrados sem máscara";
  HelpView helpRankingNotif = HelpView('assets/helpHistNotif.txt');
  String _search;
  int _offset = 0;
  bool initial = true;

  // @override
  // void initState() {
  //   super.initState();
  //   // _loadData();
  //   // caller = Timer.periodic(callerDuration, (e) {
  //   //   _loadData();
  //   //   print(e.tick);
  //   // });
  // }

  void _loadData() async {
    var res = await RequestConeg().getJsonAuthResList(
        endpoint: '/get_hist_notif',
        query: {'pesid': idPessoa.value.text, 'offset': _offset.toString()});
    print(res);
    setState(() {
      gotCases = res;
      print(gotCases);
    });
  }

  // @override
  // void dispose() {
  //   caller.cancel();
  //   super.dispose();
  // }

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
    return Column(
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
                        ..color = histNotifDesign.getBlue(),
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
                        color: histNotifDesign.getPurple(),
                      ),
                      onPressed: () {
                        // helpCadastroUnico.showHelp(
                        //     context, "Ajuda em Cadastro Único");
                      })),
            ],
          ),
        ),
        Form(
          key: _formKeySearch,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Container(
              height: 600,
              width: 700,
              decoration: BoxDecoration(
                  color: Color(0xFF17DFD3),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  border: Border.all(width: 5, color: Color(0xFF23A39B))),
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(50),
                        child: Container(
                          width: 400,
                          child: TextFormField(
                            controller: idPessoa,
                            decoration: InputDecoration(
                              labelText: "ID da pessoa cadastrada",
                              labelStyle:
                                  TextStyle(color: histNotifDesign.getBlue()),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFF23A39B), width: 2.0),
                              ),
                            ),
                            style: TextStyle(
                                color: histNotifDesign.getBlue(), fontSize: 18),
                            textAlign: TextAlign.center,
                            validator: (value) {
                              if (value.isEmpty)
                                return "ID não pode ser vazio!";
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5, bottom: 10),
                        child: Container(
                          width: 100,
                          height: 30,
                          child: MaterialButton(
                            onPressed: () async {
                              if (_formKeySearch.currentState.validate()) {
                                _loadData();
                                print('ihuuuu');
                              }
                            },
                            color: histNotifDesign.getPurple(),
                            elevation: 10,
                            highlightElevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            textColor: Colors.white,
                            child: Text('Procurar'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: 500,
                      child: _loadCorrectWidget(gotCases),
                      //  FutureBuilder(
                      //     future: _loadData(),
                      //     builder: (context, snapshot) {
                      //       switch (snapshot.connectionState) {
                      //         case ConnectionState.waiting:
                      //         case ConnectionState.none:
                      //           return Container(
                      //             width: 200,
                      //             height: 200,
                      //             alignment: Alignment.center,
                      //             child: CircularProgressIndicator(
                      //               valueColor: AlwaysStoppedAnimation<Color>(
                      //                   Colors.white),
                      //               strokeWidth: 5,
                      //             ),
                      //           );
                      //         default:
                      //           if (snapshot.hasError)
                      //             return Container();
                      //           else
                      //             return _createCasesTable(gotCases);
                      //       }
                      //     }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _loadCorrectWidget(List<dynamic> cases) {
    if (cases.isNotEmpty)
      return _createCasesTable(cases);
    else
      return Container();
  }

  Widget _createCasesTable(List<dynamic> cases) {
    return ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.add_alert_sharp),
            title: Text(cases[index]['ts']),
          );
        },
        separatorBuilder: (context, index) => SizedBox(
              width: 15,
            ),
        itemCount: cases.length);
  }
}

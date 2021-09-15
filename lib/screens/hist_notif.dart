import 'dart:collection';
import 'dart:io';

import 'package:coneg/models/design_color_model.dart';
import 'package:coneg/models/request_model.dart';
import 'package:coneg/ui/help_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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
  String title = "Histórico de Cadastrados Sem Máscara";
  HelpView helpRankingNotif = HelpView('assets/helpHistNotif.txt');
  Map<String, dynamic> currentCase;
  List<bool> isSelected;
  bool showInfo = false;
  int indexMoreDetails = 0;
  double widthCont = 0;
  int _offset = 0;
  String savedID;
  bool started = true;

  void _loadData() async {
    var res = await RequestConeg()
        .getJsonAuthResList(endpoint: '/get_hist_notif', query: {
      'pesid': _offset != 0 ? savedID : idPessoa.value.text,
      'offset': _offset.toString()
    });
    print(res);
    setState(() {
      gotCases = res;
      savedID = idPessoa.value.text;
      isSelected = List.filled(gotCases.length, false);
      print(gotCases);
    });
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
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
                        helpRankingNotif.showHelp(context, "Ajuda em $title");
                      })),
            ],
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                                onFieldSubmitted: (value) {
                                  if (_formKeySearch.currentState.validate()) {
                                    _offset = 0;
                                    _loadData();
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: "ID da pessoa cadastrada",
                                  labelStyle: TextStyle(
                                      color: histNotifDesign.getBlue()),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 2.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xFF23A39B), width: 2.0),
                                  ),
                                ),
                                style: TextStyle(
                                    color: histNotifDesign.getBlue(),
                                    fontSize: 18),
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
                                    _offset = 0;
                                    _loadData();
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
                          decoration: BoxDecoration(
                              color: Color(0xFF006E68),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              border: Border.all(
                                  width: 3, color: Color(0xFF23A39B))),
                          child: _loadCorrectWidget(gotCases),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              width: widthCont,
              height: 500,
              child: _buildDetailsInfo(currentCase),
              curve: Curves.easeOutCubic,
              decoration: BoxDecoration(
                  color: Color(0xFF17DFD3),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  border: Border.all(width: 5, color: Color(0xFF23A39B))),
            ),
          ],
        ),
      ],
    );
  }

  Widget _loadCorrectWidget(List<dynamic> cases) {
    if (cases.isNotEmpty)
      return _createCasesTable(cases);
    else
      return Container(
        child: Center(
          child: Text(
            'Sem dados...',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
  }

  Widget _createCasesTable(List<dynamic> cases) {
    return ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          if (index == 10)
            return ListTile(
              title: MaterialButton(
                onPressed: () {
                  setState(() {
                    _offset += 10;
                    _loadData();
                  });
                },
                color: histNotifDesign.getPurple(),
                elevation: 10,
                highlightElevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                textColor: Colors.white,
                child: Text('Carregar mais antigos'),
              ),
            );
          String datetime = DateFormat('dd/MM/yyyy - HH:mm')
              .format(DateTime.parse(cases[index]['ts']));
          List<ListTile> tmp = List.empty(growable: true);
          if (cases[index]['notified'] == 1)
            return ListTile(
              leading: Icon(
                Icons.mark_email_read_outlined,
                color: Colors.red.shade800,
              ),
              title: Text(
                '[Reg. ${index + _offset + 1}] Notificado neste momento, captura em: $datetime',
                style: TextStyle(color: Colors.white),
              ),
              trailing: MaterialButton(
                onPressed: //started == false &&
                    isSelected.contains(true) && isSelected[index] == false
                        ? null
                        : () {
                            setState(() {
                              isSelected =
                                  _loadDetails(index, cases[index], isSelected);
                            });
                          },
                color: isSelected[index]
                    ? histNotifDesign.getBlue()
                    : histNotifDesign.getPurple(),
                elevation: 10,
                highlightElevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                textColor: Colors.white,
                child: Text('Mais detalhes'),
              ),
            );
          else
            return ListTile(
              leading: Icon(
                Icons.horizontal_rule,
                color: Colors.yellow.shade600,
              ),
              title: Text(
                '[Reg. ${index + _offset + 1}] Já notificado neste dia, captura em: $datetime',
                style: TextStyle(color: Colors.white),
              ),
              trailing: MaterialButton(
                onPressed: //started == false &&
                    isSelected.contains(true) && isSelected[index] == false
                        ? null
                        : () {
                            setState(() {
                              isSelected =
                                  _loadDetails(index, cases[index], isSelected);
                            });
                          },
                color: isSelected[index]
                    ? histNotifDesign.getBlue()
                    : histNotifDesign.getPurple(),
                elevation: 10,
                highlightElevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                textColor: Colors.white,
                child: Text('Mais detalhes'),
              ),
            );
        },
        separatorBuilder: (context, index) => Divider(
              color: Color(0xFF23A39B),
            ),
        itemCount: cases.length == 10 ? cases.length + 1 : cases.length);
  }

  List<bool> _loadDetails(int idx, Map cases, List selections) {
    indexMoreDetails = idx;
    if (widthCont == 0) {
      for (var i = 0; i < selections.length; i++) {
        selections[i] = false;
      }
      selections[idx] = true;
      showInfo = true;
      widthCont = 400;
      currentCase = {
        'pesid': cases['pesid'],
        'name': cases['name'],
        'ts': DateFormat('dd/MM/yyyy - HH:mm')
            .format(DateTime.parse(cases['ts'])),
        'local': cases['local'],
        'notified': cases['notified'],
        'image': cases['image']
      };
    } else {
      for (var i = 0; i < selections.length; i++) {
        selections[i] = false;
      }
      showInfo = false;
      widthCont = 0;
    }
    // started = false;
    return selections;
  }

  Widget _buildDetailsInfo(Map<String, dynamic> detailsMap) {
    String notificado;
    var image;
    if (showInfo) {
      if (detailsMap['notified'] == 1)
        notificado = 'Sim';
      else
        notificado = 'Não';
      if (detailsMap['image'].isEmpty)
        image = Center(
          child: Row(
            children: [
              Icon(Icons.broken_image_rounded),
              Text(' Sem imagem de captura! '),
            ],
          ),
        );
      else {
        Uint8List bytes = Base64Decoder().convert(detailsMap['image']);
        image = Center(child: Image.memory(bytes));
      }
      return ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          ListTile(
              title: Text(detailsMap['pesid'].toString()),
              leading: Text('ID: ')),
          ListTile(
              title: Text(detailsMap['name'].toString()),
              leading: Text('Nome: ')),
          ListTile(
              title: Text(detailsMap['ts'].toString()),
              leading: Text('Data/Hora: ')),
          ListTile(
              title: Text(detailsMap['local'].toString()),
              leading: Text('Local: ')),
          ListTile(
              title: Text(notificado.toString()),
              leading: Text('Notificado: ')),
          ListTile(
              title: Text(
            'Captura/prova: ',
            style: TextStyle(fontSize: 14),
          )),
          ListTile(title: image),
        ],
      );
    } else
      return Container();
  }
}

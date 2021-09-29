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

class ListaUser extends StatefulWidget {
  @override
  _ListaUserState createState() => _ListaUserState();
}

class _ListaUserState extends State<ListaUser> {
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
  ConegDesign listUserDesign = GetIt.I<ConegDesign>();
  List<dynamic> gotUsers = List<dynamic>.empty();
  String title = "Consulta de Usuários cadastrados";
  HelpView helpListUsers = HelpView('assets/helpListUser.txt');
  Map<String, dynamic> currentCase;
  List<bool> isSelected;
  bool showInfo = false;
  int indexMoreDetails = 0;
  double widthCont = 0;
  int _offset = 0;
  String savedID;
  bool started = true;

  @override
  void initState() {
    super.initState();
    _loadData(0);
  }

  void _loadData(int option) async {
    if (option == 0) {
      var res = await RequestConeg().getJsonAuth(
          endpoint: '/get_lista_user', query: {'offset': _offset.toString()});
      print(res);
      setState(() {
        gotUsers = res['users'];
        savedID = idPessoa.value.text;
        isSelected = List.filled(gotUsers.length, false);
        print(gotUsers);
      });
    } else {
      var res =
          await RequestConeg().getJsonAuth(endpoint: '/get_lista_user', query: {
        'pesid': idPessoa.value.text,
      });
      if (res['alreadyHasId'] == false) {
        helpListUsers.showInfo(context, "Consulta do ID ${idPessoa.value.text}",
            "Este ID ainda não existe, use-o para cadastrar uma nova pessoa!");
      } else {
        helpListUsers.showInfo(context, "Consulta do ID ${idPessoa.value.text}",
            "Este ID já existe no cadastro de uma pessoa!");
      }
    }
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
                        ..color = listUserDesign.getBlue(),
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
                        color: listUserDesign.getPurple(),
                      ),
                      onPressed: () {
                        helpListUsers.showHelp(context, "Ajuda em $title");
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
                                    _loadData(1);
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: "ID da pessoa cadastrada",
                                  labelStyle: TextStyle(
                                      color: listUserDesign.getBlue()),
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
                                    color: listUserDesign.getBlue(),
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
                                    _loadData(1);
                                  }
                                },
                                color: listUserDesign.getPurple(),
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
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'ID',
                              style: TextStyle(color: listUserDesign.getBlue()),
                            ),
                            Text(
                              'Nome',
                              style: TextStyle(color: listUserDesign.getBlue()),
                            ),
                            Text(
                              'Email',
                              style: TextStyle(color: listUserDesign.getBlue()),
                            ),
                            Text(
                              'Telefone',
                              style: TextStyle(color: listUserDesign.getBlue()),
                            ),
                          ],
                        ),
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
                          child: _loadCorrectWidget(gotUsers),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _loadCorrectWidget(List<dynamic> users) {
    if (users.isNotEmpty)
      return _createUsersTable(users);
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

  Widget _createUsersTable(List<dynamic> users) {
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
                    _loadData(0);
                  });
                },
                color: listUserDesign.getPurple(),
                elevation: 10,
                highlightElevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                textColor: Colors.white,
                child: Text('Carregar mais'),
              ),
            );
          List<ListTile> tmp = List.empty(growable: true);
          return ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  users[index]['pesid'].toString(),
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  users[index]['name'].toString(),
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  users[index]['email'].toString(),
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  users[index]['tel'].toString(),
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => Divider(
              color: Color(0xFF23A39B),
            ),
        itemCount: users.length == 10 ? users.length + 1 : users.length);
  }
}

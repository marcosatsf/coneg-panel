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

class Configuracao extends StatefulWidget {
  @override
  _ConfiguracaoState createState() => _ConfiguracaoState();
}

class _ConfiguracaoState extends State<Configuracao> {
  final GlobalKey<FormState> _formKeyLocation = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyPW = GlobalKey<FormState>();
  TextEditingController cidade = TextEditingController();
  TextEditingController estado = TextEditingController();
  TextEditingController senhaAtual = TextEditingController();
  TextEditingController senhaNova = TextEditingController();
  RequestConeg requestSystem = RequestConeg();
  ConegDesign cadastroDesign = GetIt.I<ConegDesign>();
  String cadastro = "Configuração";
  HelpView helpConfiguracao = HelpView('assets/helpConfiguracao.txt');
  bool initial = true;

  @override
  void initState() {
    super.initState();
    _loadRes();
  }

  void _loadRes() async {
    var res = await ConegRoutes().getCurrentLocation(requestSystem);
    print('res $res');
    if (initial == false) {
      if (requestSystem.lastStatusCode == 200) {
        print('nice location change 🔝');
        helpConfiguracao.showInfo(context, "Localização do sistema",
            "Nova localização cadastrada no sistema!\nAguarde alguns instantes até que predição para ${res['city']} - ${res['state']} seja totalmente executada.");
      } else {
        print('bad req man ❌');
        helpConfiguracao.showInfo(context, "Impossível alterar localização",
            "Não foi possível alterar a localização do sistema!");
      }
    } else
      initial = false;
    print('initial $initial');
    setState(() {
      cidade.text = res['city'];
      estado.text = res['state'];
    });
  }

  void tryChangePW() async {
    var req = await RequestConeg().postFormAuth(endpoint: '/change_pw', data: {
      'current_pw': senhaAtual.value.text,
      'new_pw': senhaNova.value.text
    });
    if (req.statusCode == 200) {
      print('nice pw change 🔝');
      setState(() {
        senhaAtual.clear();
        senhaNova.clear();
      });
      AuthModel authentication = GetIt.I<AuthModel>();
      authentication.fromJson(jsonDecode(req.body));
      helpConfiguracao.showInfo(context, "Senha alterada com sucesso",
          "Sua nova senha já está cadastrada com sucesso!");
    } else {
      print('bad req man ❌');
      helpConfiguracao.showInfo(context, "Impossível alterar senha",
          "Verifique se a senha atual está correta e tente novamente!");
    }
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
                        cadastro,
                        style: TextStyle(
                          fontSize: 40,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 6
                            ..color = cadastroDesign.getBlue(),
                        ),
                      ),
                      // Solid text as fill.
                      Text(
                        cadastro,
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
                            color: cadastroDesign.getPurple(),
                          ),
                          onPressed: () {
                            // helpCadastroUnico.showHelp(
                            //     context, "Ajuda em Cadastro Único");
                          })),
                ],
              )),
          Padding(
            padding: EdgeInsets.all(20),
            child: Container(
              height: 500,
              width: 500,
              decoration: BoxDecoration(
                  color: Color(0xFF17DFD3),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  border: Border.all(width: 5, color: Color(0xFF23A39B))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Color(0xFF17DFD3),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        border: Border.all(width: 5, color: Color(0xFF23A39B))),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Mudança de senha',
                          style: TextStyle(fontSize: 16),
                        ),
                        Form(
                          key: _formKeyPW,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Flexible(
                                flex: 1,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 20, bottom: 20, left: 5),
                                  child: TextFormField(
                                    controller: senhaAtual,
                                    onFieldSubmitted: (value) {},
                                    decoration: InputDecoration(
                                      labelText: "Senha Atual",
                                      //labelStyle: TextStyle(color: _c_blue),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 2.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFF23A39B),
                                            width: 2.0),
                                      ),
                                    ),
                                    style: TextStyle(
                                        color: cadastroDesign.getBlue(),
                                        fontSize: 15),
                                    textAlign: TextAlign.center,
                                    validator: (value) {
                                      if (value.isEmpty)
                                        return "Senha atual não pode ser vazia!";
                                    },
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 10, left: 10),
                                  child: TextFormField(
                                    controller: senhaNova,
                                    onFieldSubmitted: (value) {},
                                    decoration: InputDecoration(
                                      labelText: "Senha nova",
                                      //labelStyle: TextStyle(color: _c_blue),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 2.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFF23A39B),
                                            width: 2.0),
                                      ),
                                    ),
                                    style: TextStyle(
                                        color: cadastroDesign.getBlue(),
                                        fontSize: 15),
                                    textAlign: TextAlign.center,
                                    validator: (value) {
                                      if (value.isEmpty)
                                        return "Senha nova não pode ser vazio!";
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5, bottom: 10),
                          child: Container(
                            width: 300,
                            height: 30,
                            child: MaterialButton(
                              onPressed: () async {
                                if (_formKeyPW.currentState.validate()) {
                                  tryChangePW();
                                }
                              },
                              color: cadastroDesign.getPurple(),
                              elevation: 10,
                              highlightElevation: 2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              textColor: Colors.white,
                              child: Text('Atualizar senha'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Color(0xFF17DFD3),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        border: Border.all(width: 5, color: Color(0xFF23A39B))),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Localização do sistema',
                          style: TextStyle(fontSize: 16),
                        ),
                        Form(
                          key: _formKeyLocation,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Flexible(
                                flex: 3,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 20, bottom: 20, left: 5),
                                  child: TextFormField(
                                    controller: cidade,
                                    onFieldSubmitted: (value) {},
                                    decoration: InputDecoration(
                                      labelText: "Cidade",
                                      //labelStyle: TextStyle(color: _c_blue),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 2.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFF23A39B),
                                            width: 2.0),
                                      ),
                                    ),
                                    style: TextStyle(
                                        color: cadastroDesign.getBlue(),
                                        fontSize: 15),
                                    textAlign: TextAlign.center,
                                    validator: (value) {
                                      if (value.isEmpty)
                                        return "Cidade não pode ser vazia!";
                                      if (value.contains(RegExp(r'[0-9]')))
                                        return "Não condiz com um nome de cidade!";
                                    },
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 10, left: 10),
                                  child: TextFormField(
                                    controller: estado,
                                    onFieldSubmitted: (value) {},
                                    decoration: InputDecoration(
                                      labelText: "Estado",
                                      //labelStyle: TextStyle(color: _c_blue),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 2.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFF23A39B),
                                            width: 2.0),
                                      ),
                                    ),
                                    style: TextStyle(
                                        color: cadastroDesign.getBlue(),
                                        fontSize: 15),
                                    textAlign: TextAlign.center,
                                    validator: (value) {
                                      if (value.isEmpty)
                                        return "Estado não pode ser vazio!";
                                      if (value.contains(RegExp(r'[0-9]')))
                                        return "Não condiz com um nome de estado!";
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5, bottom: 10),
                          child: Container(
                            width: 300,
                            height: 30,
                            child: MaterialButton(
                              onPressed: () async {
                                if (_formKeyLocation.currentState.validate()) {
                                  print('nice dude!');
                                  await ConegRoutes().setCurrentLocation({
                                    "city": cidade.value.text,
                                    "state": estado.value.text
                                  });
                                  _loadRes();
                                }
                              },
                              color: cadastroDesign.getPurple(),
                              elevation: 10,
                              highlightElevation: 2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              textColor: Colors.white,
                              child: Text('Atualizar localização do sistema'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
// import 'package:dio/dio.dart';
// import 'package:dio/adapter.dart';
import 'package:http_parser/http_parser.dart';
import 'package:velocity_x/velocity_x.dart';

class CadastroUnico extends StatefulWidget {
  @override
  _CadastroUnicoState createState() => _CadastroUnicoState();
}

class _CadastroUnicoState extends State<CadastroUnico> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nome = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController telefone = TextEditingController();
  List<int> _selectedZip;
  Uint8List _bytesData;
  html.Worker cadastroWorker;
  String fileName = 'Não selecionado...';
  ConegDesign cadastroDesign = GetIt.I<ConegDesign>();
  String cadastro = "Cadastro Único";
  HelpView helpCadastroUnico = HelpView('assets/helpCadastroUnico.txt');

  void _handleResult(Object result) {
    setState(() {
      _bytesData = Base64Decoder().convert(result.toString().split(",").last);
      _selectedZip = _bytesData;
      // _selectedZip = result;
    });
  }

  _webFilePicker() async {
    html.InputElement uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = false;
    uploadInput.draggable = true;
    uploadInput.accept = '.jpg';
    uploadInput.click();
    uploadInput.onChange.listen((event) {
      final files = uploadInput.files;
      final html.File file = files[0];
      setState(() {
        fileName = file.name;
      });
      final reader = new html.FileReader();

      reader.onLoadEnd.listen((event) {
        _handleResult(reader.result);
      });
      reader.readAsDataUrl(file);
    });
  }

  Future makeRequestMultipart() async {
    AuthModel authentication = GetIt.I<AuthModel>();
    http.MultipartRequest req = http.MultipartRequest(
        "POST", Uri.parse("${RequestConeg.route}/upload_single"));
    req.headers
        .addAll({HttpHeaders.authorizationHeader: authentication.toAuth()});
    req.fields['nome'] = nome.value.text;
    req.fields['email'] = email.value.text;
    req.fields['telefone'] = telefone.value.text;
    req.files.add(await http.MultipartFile.fromBytes('file_rec', _selectedZip,
        contentType: MediaType('multipart', 'form-data'), filename: fileName));
    print(req.fields);
    print(req.files);
    req.send().then((response) {
      print(response.statusCode);
      if (response.statusCode == 200) {
        print("Uploaded!");
        helpCadastroUnico.showInfo(
            context, "Status do upload", "Uploaded com sucesso!");
        // spawnDialog(context, "Status do upload", "Uploaded com sucesso!",
        //     cadastroDesign.getPurple());
      } else {
        print("Not uploaded! ${response.statusCode}");
        helpCadastroUnico.showInfo(context, "Status do upload",
            "Não foi possível realizar o cadastro! Por favor verifique se todos os campos estão preenchidos e contém uma imagem JPG");
        // spawnDialog(
        //     context,
        //     "Status do upload",
        //     "Não foi possível realizar o cadastro! Por favor clique no ícone '?' para entender melhor o padrão do arquivo!",
        //     cadastroDesign.getPurple());
      }
    });
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
                          helpCadastroUnico.showHelp(
                              context, "Ajuda em Cadastro Único");
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
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: TextFormField(
                          controller: nome,
                          onFieldSubmitted: (value) {},
                          decoration: InputDecoration(
                            hintText: "Nome da pessoa a ser registrada",
                            labelText: "Nome",
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
                              color: cadastroDesign.getBlue(), fontSize: 15),
                          textAlign: TextAlign.center,
                          validator: (value) {
                            if (value.isEmpty)
                              return "Nome não pode ser vazio!";
                          },
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: TextFormField(
                          controller: email,
                          onFieldSubmitted: (value) {},
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: "Email da pessoa a ser registrada",
                            labelText: "Email",
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
                              color: cadastroDesign.getBlue(), fontSize: 15),
                          textAlign: TextAlign.center,
                          validator: (value) {
                            if (value.isEmpty)
                              return "Email não pode ser vazio!";
                            if (!value.validateEmail())
                              return "Não condiz com um padrão de email!";
                          },
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: TextFormField(
                          controller: telefone,
                          onFieldSubmitted: (value) {},
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: "Telefone da pessoa a ser registrada",
                            labelText: "Telefone",
                            //labelStyle: TextStyle(color: _c_blue),
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
                              color: cadastroDesign.getBlue(), fontSize: 15),
                          textAlign: TextAlign.center,
                          validator: (value) {
                            if (value.isEmpty)
                              return "Telefone não pode ser vazio!";
                            if (!value.contains(RegExp(r'[0-9#* ]')))
                              return "Não condiz com um padrão de telefone!";
                          },
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          child: MaterialButton(
                            onPressed: () {
                              _webFilePicker();
                            },
                            color: cadastroDesign.getPurple(),
                            elevation: 10,
                            highlightElevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            textColor: Colors.white,
                            child: Text('Selecione um arquivo'),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: ListTile(
                              title: Text(fileName),
                              leading: Icon(Icons.image_outlined),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(50),
                      child: Container(
                        width: 400,
                        height: 50,
                        child: MaterialButton(
                          onPressed: () {
                            if (_formKey.currentState.validate() &&
                                fileName != null) {
                              makeRequestMultipart();
                              print('nice dude!');
                            }
                          },
                          color: cadastroDesign.getPurple(),
                          elevation: 10,
                          highlightElevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          textColor: Colors.white,
                          child: Text('Enviar cadastro'),
                        ),
                      ),
                    ),
                    // MaterialButton(
                    //   onPressed: () {
                    //     makeRequestMultipart();
                    //   },
                    //   color: cadastroDesign.getPurple(),
                    //   elevation: 10,
                    //   highlightElevation: 2,
                    //   shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(20)),
                    //   textColor: Colors.white,
                    //   child: Text('Enviar cadastro'),
                    // ),
                    // AnimatedContainer(
                    //   duration: Duration(milliseconds: 500),
                    //   width: 400,
                    //   height: heightCont,
                    //   child: Text(
                    //     userResp,
                    //     textAlign: TextAlign.center,
                    //     style: TextStyle(
                    //         color: colorResp, fontWeight: FontWeight.bold),
                    //   ),
                    // ),
                  ],
                ),
              )),
        ),
      ],
    );
  }
}

import 'dart:io';

import 'package:coneg/models/auth_model.dart';
import 'package:coneg/models/design_color_model.dart';
import 'package:coneg/models/request_model.dart';
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

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  List<int> _selectedZip;
  Uint8List _bytesData;
  GlobalKey _formKey = new GlobalKey();
  html.Worker cadastroWorker;
  String fileName = 'Não selecionado...';
  ConegDesign cadastroDesign = ConegDesign();
  String cadastro = "Cadastro Geral";
  bool helpWindow = false;
  String helpText = '';
  double widthHelp = 0;

  void _showHelp() async {
    helpWindow = !helpWindow;
    if (helpText.isEmpty) helpText = await loadAsset();
    if (helpWindow)
      setState(() {
        widthHelp = 400;
      });
    else
      setState(() {
        widthHelp = 0;
      });
    spawnDialog(context, "Ajuda em Cadastro Geral", helpText);
  }

  Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/helpCadastroGeral.txt');
  }

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
    uploadInput.accept = '.zip';
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
        "POST", Uri.parse("${RequestConeg.route}/upload"));
    req.headers
        .addAll({HttpHeaders.authorizationHeader: authentication.toAuth()});
    req.files.add(await http.MultipartFile.fromBytes('file_rec', _selectedZip,
        contentType: MediaType('multipart', 'form-data'),
        filename: 'uploaded_file.zip'));

    req.send().then((response) {
      print(response.statusCode);
      if (response.statusCode == 200) {
        print("Uploaded!");
        spawnDialog(context, "Status do upload", "Uploaded com sucesso!");
      } else {
        print("Not uploaded! ${response.statusCode}");
        spawnDialog(context, "Status do upload",
            "Não foi possível realizar o cadastro! Por favor clique no ícone '?' para entender melhor o padrão do arquivo!");
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
                          _showHelp();
                        })),
              ],
            )),
        Padding(
          padding: EdgeInsets.all(20),
          child: Container(
            height: 250,
            width: 300,
            decoration: BoxDecoration(
                color: Color(0xFF17DFD3),
                borderRadius: BorderRadius.all(Radius.circular(20)),
                border: Border.all(width: 5, color: Color(0xFF23A39B))),
            child: Form(
                key: _formKey,
                child: Column(
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
                          leading: Icon(Icons.folder_shared_outlined),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: MaterialButton(
                        onPressed: () {
                          makeRequestMultipart();
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
                  ],
                )),
          ),
        ),
      ],
    );
  }

  Future spawnDialog(BuildContext context, String title, String text) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: new Text(title),
              //content: new Text("Hello World"),
              content: new SingleChildScrollView(
                child: new ListBody(
                  children: [
                    new Text(text),
                  ],
                ),
              ),
              actions: [
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: cadastroDesign.getPurple(),
                  elevation: 10,
                  highlightElevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  textColor: Colors.white,
                  child: Text('OK'),
                )
              ]);
        });
  }
}

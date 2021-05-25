import 'package:coneg/utils/routes.dart';
import 'package:flutter/material.dart';
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
  //FileReader reader;
  //File file_saved;
  //Uint8List file_picked;

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
      final reader = new html.FileReader();

      reader.onLoadEnd.listen((event) {
        _handleResult(reader.result);
      });
      reader.readAsDataUrl(file);
    });
  }

  Future makeRequestMultipart() async {
    http.MultipartRequest req = http.MultipartRequest(
        "POST", Uri.parse("http://localhost:5000/upload"));

    req.files.add(await http.MultipartFile.fromBytes('file_rec', _selectedZip,
        contentType: MediaType('multipart', 'form-data'),
        filename: 'uploaded_file.zip'));

    req.send().then((response) {
      print(response.statusCode);
      if (response.statusCode == 200) {
        print("Uploaded!");
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: new Text("Details"),
                  //content: new Text("Hello World"),
                  content: new SingleChildScrollView(
                    child: new ListBody(
                      children: [
                        new Text("Uploaded com sucesso!"),
                      ],
                    ),
                  ),
                  actions: [
                    new ElevatedButton(
                      child: new Text('Aceitar'),
                      onPressed: () {
                        Navigator.pop(context);
                        // context.vxNav.push(Uri.parse(ConegRoutes.dashboard));
                      },
                    ),
                  ]);
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('A Flutter Web file picker'),
      ),
      body: Container(
        child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.only(top: 16, left: 28),
              child: Container(
                width: 350,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    MaterialButton(
                      onPressed: () {
                        _webFilePicker();
                      },
                      color: Colors.pink,
                      elevation: 10,
                      highlightElevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      textColor: Colors.white,
                      child: Text('Selecione um arquivo'),
                    ),
                    Divider(
                      color: Colors.teal,
                    ),
                    MaterialButton(
                      onPressed: () {
                        makeRequestMultipart();
                      },
                      child: Text('Enviar arquivo para servidor'),
                      color: Colors.purple,
                      elevation: 10,
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ),
            )),
      ),
    ));
  }
}

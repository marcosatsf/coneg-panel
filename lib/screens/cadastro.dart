import 'package:coneg/utils/routes.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
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
  //FileReader reader;
  //File file_saved;
  //Uint8List file_picked;

  void _handleResult(Object result) {
    setState(() {
      _bytesData = Base64Decoder().convert(result.toString().split(",").last);
      _selectedZip = _bytesData;
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
      if (files.length == 1) {
        final file = files[0];
        final reader = new html.FileReader();

        reader.onLoadEnd.listen((event) {
          _handleResult(reader.result);
        });
        reader.readAsDataUrl(file);
      }
      //TODO else multiple files or 0
    });
  }

  Future<String> makeRequest() async {
    http.MultipartRequest req =
        http.MultipartRequest("POST", Uri.parse('http://0.0.0.0:5000/upload/'));

    req.files.add(await http.MultipartFile.fromBytes('file', _selectedZip,
        contentType: new MediaType('application', 'zip'), filename: "file_up"));

    req.send().then((response) {
      print("test");
      print(response.statusCode);
      if (response.statusCode == 200) print("Uploaded!");
    });

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
                    context.vxNav.push(Uri.parse(ConegRoutes.dashboard));
                  },
                ),
              ]);
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
            autovalidateMode: AutovalidateMode.always,
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
                        makeRequest();
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

//   void _startFilePicker() async {
//     InputElement uploadInput = FileUploadInputElement();
//     uploadInput.click();
//     String option1Text;

//     uploadInput.onChange.listen((e) {
//       // read file content as dataURL
//       final files = uploadInput.files;
//       if (files.length == 1) {
//         print(files[0]);
//         final file = files[0];
//         reader = FileReader();
//         file_saved = file;
//         reader.onLoadEnd.listen((e) {
//           setState(() {
//             uploadedImage = reader.result;
//           });
//         });

//         reader.onError.listen((fileEvent) {
//           setState(() {
//             option1Text = "Some Error occured while reading the file";
//           });
//         });

//         reader.readAsArrayBuffer(file);
//       }
//     });
//   }

//   Future<String> _uploadFile(filename, url) async {
//     http.MultipartRequest request =
//         http.MultipartRequest('POST', Uri.parse(url));

//     request.files.add(await http.MultipartFile.fromPath('zip_file', filename));
//     print(request.files);

//     http.StreamedResponse r = await request.send();
//     print(r.statusCode);
//     return r.reasonPhrase;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         drawer: DrawerPanel(),
//         appBar: AppBarPanel(
//           height: 60,
//         ),
//         backgroundColor: Colors.black,
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             Container(
//               color: Color(0xFF17DFD3),
//               height: 50,
//             ),
//             //This will change in each page
//             TextButton(
//                 onPressed: () async {
//                   FilePickerResult result = await FilePicker.platform.pickFiles(
//                       type: FileType.any, allowedExtensions: ['zip']);
//                   if (result != null) {
//                     file_picked = result.files.single.bytes;
//                   }
//                   // InputElement uploadInput = FileUploadInputElement();
//                   // uploadInput.accept = '.zip';
//                   // uploadInput.click();
//                   // print(uploadInput.directory);
//                   // uploadInput.onChange.listen((e) {
//                   //   // read file content as dataURL
//                   //   final files = uploadInput.files;
//                   //   print(files);
//                   //   if (files.length == 1) {
//                   //     print(files[0]);
//                   //     reader = FileReader();
//                   //     file_saved = files[0];
//                   //     reader.readAsArrayBuffer(file_saved);
//                   //   }
//                   // });
//                 },
//                 child: Container(
//                   child: Text("Select File!"),
//                   color: Colors.lightGreen.shade900,
//                   height: 200,
//                 )),
//             TextButton(
//                 onPressed: () async {
//                   if (file_picked != null) {
//                     http.MultipartRequest request = http.MultipartRequest(
//                         'POST', Uri.parse('https://localhost:5000/upload'));
//                     request.files.add(
//                         http.MultipartFile.fromBytes('zip_file', file_picked));
//                     print(request.files);

//                     request.send().then((r) {
//                       print(r.statusCode);
//                       if (r.statusCode == 200) print("Uploaded!!! :D");
//                     });
//                   } else {
//                     print("Por favor, insira um arquivo antes!");
//                   }
//                 },
//                 child: Container(
//                   child: Text("Upload File!"),
//                   color: Colors.lightGreen.shade300,
//                   height: 200,
//                 )),
//           ],
//         ));
//   }
// }

// // Define a custom Form widget.
// class MyCustomForm extends StatefulWidget {
//   @override
//   MyCustomFormState createState() {
//     return MyCustomFormState();
//   }
// }

// Define a corresponding State class.
// This class holds data related to the form.
// class MyCustomFormState extends State<MyCustomForm> {
//   // Create a global key that uniquely identifies the Form widget
//   // and allows validation of the form.
//   //
//   // Note: This is a `GlobalKey<FormState>`,
//   // not a GlobalKey<MyCustomFormState>.
//   final _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     // Build a Form widget using the _formKey created above.
//     return Form(
//       key: _formKey,
//       child: Column(
//         children: <Widget>[
//           TextFormField(
//             // The validator receives the text that the user has entered.
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Please enter some text';
//               }
//               return null;
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

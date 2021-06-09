import 'dart:convert';
import 'dart:io';

import 'package:coneg/models/auth_model.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:coneg/utils/routes.dart';
import 'package:coneg/widget/appbarpanel.dart';
import 'package:coneg/widget/drawerpanel.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final user = TextEditingController();
  final pass = TextEditingController();

  void tryLogin() async {
    var req = await http.post(
      Uri.parse("http://localhost:5000/token"),
      //body: jsonEncode(<String, String>{'username': user, 'password': pass}),
      body: {'username': user.value.text, 'password': pass.value.text},
    );
    print(req.request);
    if (req.statusCode == 200) {
      AuthModel authentication = GetIt.I<AuthModel>();
      authentication.fromJson(jsonDecode(req.body));
      print('nice login 🔝');
      Navigator.pushNamed(context, ConegRoutes.dashboard);
    } else
      print('bad req man ❌');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              color: Color(0xFF17DFD3),
              height: 120,
              child: Container(
                alignment: AlignmentDirectional.center,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Image.asset(
                    'assets/images/ConEg.png',
                    height: 80,
                    width: 80,
                  ),
                ),
              ),
            ),
            Divider(
              height: 50,
            ),
            //This will change in each page
            Padding(
              padding: EdgeInsets.all(50),
              child: Container(
                width: 400,
                child: TextField(
                    controller: user,
                    decoration: InputDecoration(
                        labelText: "Usuário",
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder()),
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    textAlign: TextAlign.center),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(50),
              child: Container(
                width: 400,
                child: TextField(
                    controller: pass,
                    decoration: InputDecoration(
                        labelText: "Senha",
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder()),
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    textAlign: TextAlign.center),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(50),
              child: Container(
                width: 400,
                height: 50,
                child: MaterialButton(
                  onPressed: () {
                    tryLogin();
                  },
                  color: Color(0xFF970062),
                  elevation: 10,
                  highlightElevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  textColor: Colors.white,
                  child: Text('Login'),
                ),
              ),
            ),
          ],
        ));
  }
}

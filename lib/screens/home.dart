import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:coneg/widget/appbarpanel.dart';
import 'package:coneg/widget/drawerpanel.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void tryLogin() async {
    var req = await http.post(
      Uri.parse('http://localhost/auth/token'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{'username': 'test', 'password': 'test_pw'}),
    );
    if (req.statusCode == 200)
      print('nice login 🔝');
    else
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
                  decoration: InputDecoration(
                      labelText: "Usuário",
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder()),
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                  onSubmitted: (text) {},
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(50),
              child: Container(
                width: 400,
                child: TextField(
                  decoration: InputDecoration(
                      labelText: "Senha",
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder()),
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                  onSubmitted: (text) {},
                ),
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

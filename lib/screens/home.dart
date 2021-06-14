import 'dart:convert';
import 'dart:io';
import 'package:coneg/models/auth_model.dart';
import 'package:coneg/models/design_color_model.dart';
import 'package:coneg/models/request_model.dart';
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
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();
  ConegDesign homeDesign = GetIt.I<ConegDesign>();
  double heightCont = 0;
  String userResp = '';
  Color colorResp = Colors.black;

  void uiResponse(String resp2user, http.Response resp) {
    setState(() {
      user.clear();
      pass.clear();
      heightCont = 80;
      userResp = resp2user;
      colorResp = resp.statusCode == 200 ? Colors.green.shade900 : Colors.red;
    });
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        heightCont = 0;
        userResp = '';
      });
      if (resp.statusCode == 200) {
        AuthModel authentication = GetIt.I<AuthModel>();
        authentication.fromJson(jsonDecode(resp.body));
        Navigator.pushNamed(context, ConegRoutes.dashboard);
      }
    });
  }

  void tryLogin() async {
    var req = await RequestConeg().postForm(
        endpoint: '/token',
        data: {'username': user.value.text, 'password': pass.value.text});
    print(req.request);
    if (req.statusCode == 200) {
      print('nice login 🔝');
      uiResponse('Login bem sucedido!', req);
    } else {
      print('bad req man ❌');
      uiResponse('Usuário ou senha incorretas!', req);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF006E68),
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
              color: Colors.transparent,
            ),
            //This will change in each page
            Container(
                decoration: BoxDecoration(
                    color: Color(0xFF17DFD3),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    border: Border.all(width: 5, color: Color(0xFF23A39B))),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(50),
                        child: Container(
                          width: 400,
                          child: TextFormField(
                            controller: user,
                            decoration: InputDecoration(
                              labelText: "Usuário",
                              labelStyle:
                                  TextStyle(color: homeDesign.getBlue()),
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
                                color: homeDesign.getBlue(), fontSize: 18),
                            textAlign: TextAlign.center,
                            validator: (value) {
                              if (value.isEmpty)
                                return "Username não pode ser vazio!";
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          width: 400,
                          child: TextFormField(
                            controller: pass,
                            onFieldSubmitted: (value) {},
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: "Senha",
                              labelStyle:
                                  TextStyle(color: homeDesign.getBlue()),
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
                                color: homeDesign.getBlue(), fontSize: 18),
                            textAlign: TextAlign.center,
                            validator: (value) {
                              if (value.isEmpty)
                                return "Senha não pode ser vazio!";
                            },
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
                              if (_formKey.currentState.validate()) tryLogin();
                            },
                            color: homeDesign.getPurple(),
                            elevation: 10,
                            highlightElevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            textColor: Colors.white,
                            child: Text('Login'),
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.all(50),
                      //   child:
                      // )
                      AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        width: 400,
                        height: heightCont,
                        child: Text(
                          userResp,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: colorResp, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ));
  }
}

//  AnimatedContainer(
//               duration: Duration(milliseconds: 500),
//               height: heightCont,
//               width: 800,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 color: colorCont,
//               ),
//             ),

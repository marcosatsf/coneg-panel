import 'package:flutter/material.dart';
import 'package:coneg/widget/appbarpanel.dart';
import 'package:coneg/widget/drawerpanel.dart';

//Substitute by root_page
class Configuracao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: DrawerPanel(),
        appBar: AppBarPanel(
          height: 60,
        ),
        backgroundColor: Colors.black,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              color: Color(0xFF17DFD3),
              height: 50,
            ),
            //This will change in each page
            Container(
              color: Colors.amber.shade800,
              height: 200,
            ),
          ],
        ));
  }
}

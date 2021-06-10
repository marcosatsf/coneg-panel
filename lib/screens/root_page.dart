import 'package:flutter/material.dart';
import 'package:coneg/widget/appbarpanel.dart';
import 'package:coneg/widget/drawerpanel.dart';

class RootPageConeg extends StatelessWidget {
  final Widget object;
  final CrossAxisAlignment cAA;
  RootPageConeg({this.object, this.cAA});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: DrawerPanel(),
        appBar: AppBarPanel(
          height: 60,
        ),
        backgroundColor: Color(0xFF006E68),
        body: Column(
          crossAxisAlignment: cAA,
          children: <Widget>[
            Container(
              color: Color(0xFF17DFD3),
              height: 50,
            ),
            object,
          ],
        ));
  }
}

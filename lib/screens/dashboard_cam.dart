import 'package:flutter/material.dart';
import 'package:coneg/widget/appbarpanel.dart';
import 'package:coneg/widget/drawerpanel.dart';

//Substitute by root_page
class DashboardCam extends StatelessWidget {
  String text;
  DashboardCam(this.text);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue.shade800,
      height: 200,
      child: Text(text),
    );
  }
}

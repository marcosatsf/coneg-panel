import 'package:flutter/material.dart';

class InfoData extends StatelessWidget {
  final List data;

  InfoData({this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue.shade200,
      child: Column(
        children: <Widget>[
          Text(
              "Maior fluxo de pessoas sem máscara: ${data[0][0].toString()} em ${DateTime.parse(data[0][1])}"),
          Text(
              "Menor fluxo de pessoas sem máscara: ${data[1][0].toString()} em ${DateTime.parse(data[1][1])}"),
        ],
      ),
    );
    // return Container(
    //   height: 200,
    //   width: 900,
    //   color: Colors.blue,
    // );
  }
}

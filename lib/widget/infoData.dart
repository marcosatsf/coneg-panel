import 'package:coneg/models/design_color_model.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class InfoData extends StatelessWidget {
  final List data;
  final ConegDesign infoDataDesign = GetIt.I<ConegDesign>();
  final String titulo;

  InfoData({this.data, this.titulo});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xFF17DFD3),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          border: Border.all(width: 5, color: Color(0xFF23A39B))),
      child: Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: <Widget>[
                      // Stroked text as border.
                      Text(
                        titulo,
                        style: TextStyle(
                          fontSize: 18,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 6
                            ..color = infoDataDesign.getBlue(),
                        ),
                      ),
                      // Solid text as fill.
                      Text(
                        titulo,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                ],
              )),
          Text(
            """Maior fluxo de pessoas sem máscara
          [em ${DateTime.parse(data[0][1]).day}/${DateTime.parse(data[0][1]).month}/${DateTime.parse(data[0][1]).year}]
          ${data[0][0].toString()}""",
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          Text(
            """Menor fluxo de pessoas sem máscara:
          [em ${DateTime.parse(data[1][1]).day}/${DateTime.parse(data[1][1]).month}/${DateTime.parse(data[1][1]).year}]
          ${data[1][0].toString()}""",
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
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

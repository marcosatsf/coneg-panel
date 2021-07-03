import 'package:coneg/models/design_color_model.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class InfoData extends StatelessWidget {
  final List data;
  final ConegDesign infoDataDesign = GetIt.I<ConegDesign>();
  final String titulo;

  InfoData({this.data, this.titulo});

  Widget _buildText() {
    if (data.length == 2)
      return Padding(
          padding: EdgeInsets.all(1),
          child: Column(
            children: <Widget>[
              Text(
                "Maior fluxo de pessoas sem máscara [em ${DateFormat('dd/MM/yyyy').format(DateTime.parse(data[0][1]))}]\n${data[0][0].toString()}",
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
              Text(
                "Menor fluxo de pessoas sem máscara [em ${DateFormat('dd/MM/yyyy').format(DateTime.parse(data[1][1]))}]\n${data[1][0].toString()}",
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ],
          ));
    else
      return Padding(
          padding: EdgeInsets.all(1),
          child: Column(
            children: <Widget>[
              Text(
                "Maior fluxo de pessoas sem máscara\n-Sem dados suficientes-",
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
              Text(
                "Menor fluxo de pessoas sem máscara\n-Sem dados suficientes-",
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ],
          ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.all(5),
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
        _buildText(),
      ],
    );
    // return Container(
    //   height: 200,
    //   width: 900,
    //   color: Colors.blue,
    // );
  }
}

import 'package:coneg/models/design_color_model.dart';
import 'package:flutter/material.dart';
import 'package:coneg/widget/appbarpanel.dart';
import 'package:coneg/widget/drawerpanel.dart';

class RootPageConeg extends StatelessWidget {
  final Widget object;
  final CrossAxisAlignment cAA;
  // List<String> innerPages = List.empty();

  RootPageConeg({this.object, this.cAA});

  // Widget getWidgets(List<String> strings) {
  //   List<Widget> list = List.empty();
  //   for (var item in strings) {
  //     list(Padding(
  //       padding: EdgeInsets.only(left: 80, right: 80),
  //       child: MaterialButton(
  //         onPressed: () {},
  //         color: cadastroDesign.getPurple(),
  //         elevation: 10,
  //         highlightElevation: 2,
  //         shape:
  //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //         textColor: Colors.white,
  //         child: Text(item),
  //       ),
  //     ));
  //   }
  //   return new Row(children: list);
  // }

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
            Stack(alignment: AlignmentDirectional.center, children: <Widget>[
              Container(
                color: Color(0xFF17DFD3),
                height: 50,
              ),
              // SingleChildScrollView(
              //     scrollDirection: Axis.horizontal,
              //     padding: EdgeInsets.only(left: 80, right: 80),
              //     child: getWidgets(innerPages))
            ]),
            object,
          ],
        ));
  }
}

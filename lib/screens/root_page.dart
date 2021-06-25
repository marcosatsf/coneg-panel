import 'dart:async';
import 'package:coneg/models/auth_model.dart';
import 'package:coneg/models/design_color_model.dart';
import 'package:coneg/utils/routes.dart';
import 'package:coneg/widget/buttonBar.dart';
import 'package:flutter/material.dart';
import 'package:coneg/widget/appbarpanel.dart';
import 'package:coneg/widget/drawerpanel.dart';
import 'package:get_it/get_it.dart';

class RootPageConeg extends StatefulWidget {
  const RootPageConeg({
    Key key,
    this.object,
    this.cAA,
    this.masterRoute,
  }) : super(key: key);

  final Widget object;
  final CrossAxisAlignment cAA;
  final String masterRoute;

  @override
  _RootPageConegState createState() =>
      _RootPageConegState(masterRoute, cAA, object);
}

class _RootPageConegState extends State<RootPageConeg> {
  Widget currentObject;
  CrossAxisAlignment cAA;
  String masterRoute;

  ConegDesign design = GetIt.I<ConegDesign>();
  List<Text> rowButtons = List.empty(growable: true);
  List<bool> rowButtonsSelected = List.empty(growable: true);
  List<Widget> rowButtonsContent = List.empty(growable: true);
  Map<String, Widget> camList = Map();

  Timer t;

  _RootPageConegState(this.masterRoute, this.cAA, this.currentObject);

  @override
  void initState() {
    super.initState();
    _loadRes(masterRoute);
    // t = Timer.periodic(Duration(seconds: 5), (e) => print(e.tick));
  }

  // @override
  // void dispose() {
  //   t.cancel();
  //   super.dispose();
  // }

  void _loadRes(String map) async {
    camList = await ConegRoutes().getSubRoutesFrom(map);

    rowButtons = List.empty(growable: true);
    rowButtonsSelected = List.empty(growable: true);
    rowButtonsContent = List.empty(growable: true);

    rowButtonsSelected.add(true);
    for (var i = 1; i < camList.length; i++) rowButtonsSelected.add(false);

    setState(() {
      for (var key in camList.keys) {
        rowButtons.add(Text(key));
        rowButtonsContent.add(camList[key]);
      }
    });
  }

  // currentMenu = SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     padding: EdgeInsets.only(left: 80, right: 80),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       children: rowButtons,
  //     ));

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
            if (rowButtons.isNotEmpty)
              CustomButtonBar(
                children: rowButtons,
                isSelected: rowButtonsSelected,
                onPressed: (index) {
                  setState(() {
                    currentObject = rowButtonsContent[index];
                    rowButtonsSelected =
                        rowButtonsSelected.map((e) => false).toList();
                    rowButtonsSelected[index] = true;
                  });
                },
              )
          ]),
          SingleChildScrollView(
            child: currentObject,
          ),
        ],
      ),
    );
  }
}

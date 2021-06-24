import 'package:coneg/models/design_color_model.dart';
import 'package:coneg/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ConegBuilder {
  List<Text> rowButtons;
  List<bool> rowButtonsSelected;
  List<Widget> rowButtonsContent;
  Map<String, Widget> camList;

  ConegBuilder(map) {
    initButtons(map);
  }

  void initButtons(mapRoute) async {
    camList = await ConegRoutes().getSubRoutesFrom(mapRoute);
  }

  loadButtonVars() {
    rowButtons = List.empty(growable: true);
    rowButtonsSelected = List.empty(growable: true);
    rowButtonsContent = List.empty(growable: true);

    rowButtonsSelected.add(true);
    for (var i = 1; i < camList.length; i++) rowButtonsSelected.add(false);

    for (var key in camList.keys) {
      rowButtons.add(Text(key));
      rowButtonsContent.add(camList[key]);
    }
  }
}

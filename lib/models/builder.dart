import 'package:coneg/models/design_color_model.dart';
import 'package:coneg/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ConegBuilder {
  String masterRoute = '/';
  Widget currentMenu, currentObject;

  ConegBuilder();

  dynamic _loadRowSubMenu(String route) async {
    Map<String, Widget> mappedRoute =
        await ConegRoutes().getSubRoutesFrom(route);
    ConegDesign design = GetIt.I<ConegDesign>();
    if (mappedRoute.isNotEmpty) {
      List<Widget> rowButtons = List.empty(growable: true);
      for (var key in mappedRoute.keys) {
        rowButtons.add(Padding(
          padding: EdgeInsets.only(left: 80, right: 80),
          child: MaterialButton(
            onPressed: () {},
            color: design.getPurple(),
            elevation: 10,
            highlightElevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            textColor: Colors.white,
            child: Text(key),
          ),
        ));
      }
      currentMenu = SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(left: 80, right: 80),
          child: Row(
            children: rowButtons,
          ));
      return currentMenu;
    }
  }

  Widget loadCurrentWidget({String route, Widget object}) {
    currentObject = object;
    return currentObject;
  }
}

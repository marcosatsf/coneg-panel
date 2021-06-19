import 'package:coneg/models/design_color_model.dart';
import 'package:coneg/utils/routes.dart';
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
  Widget currentMenu, currentObject;
  CrossAxisAlignment cAA;
  String masterRoute;

  _RootPageConegState(this.masterRoute, this.cAA, this.currentObject);

  SingleChildScrollView _loadRowSubMenu(
      String route, Map<String, Widget> mappedRoute) {
    ConegDesign design = GetIt.I<ConegDesign>();
    List<Widget> rowButtons = List.empty(growable: true);
    if (mappedRoute.isNotEmpty) {
      for (var key in mappedRoute.keys) {
        if (mappedRoute[key].toStringShallow() ==
            currentObject.toStringShallow()) {
          rowButtons.add(Padding(
            padding: EdgeInsets.only(left: 80, right: 80),
            child: MaterialButton(
              onPressed: () {
                setState(() {
                  currentObject = mappedRoute[key];
                });
              },
              color: design.getBlue(),
              elevation: 10,
              highlightElevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              textColor: Colors.white,
              child: Text(key),
            ),
          ));
        } else {
          rowButtons.add(Padding(
            padding: EdgeInsets.only(left: 80, right: 80),
            child: MaterialButton(
              onPressed: () {
                setState(() {
                  currentObject = mappedRoute[key];
                });
              },
              color: design.getPurple(),
              elevation: 10,
              highlightElevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              textColor: Colors.white,
              child: Text(key),
            ),
          ));
        }
      }
    }
    currentMenu = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(left: 80, right: 80),
        child: Row(
          children: rowButtons,
        ));
    return currentMenu;
  }

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
            FutureBuilder(
              future: ConegRoutes().getSubRoutesFrom(masterRoute),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return _loadRowSubMenu(masterRoute, snapshot.data);
                } else {
                  if (currentMenu == null)
                    return CircularProgressIndicator(
                      backgroundColor: ConegDesign().getPurple(),
                    );
                  else
                    return currentMenu;
                }
              },
            )
          ]),
          currentObject,
        ],
        // GetIt.I<ConegBuilder>()
        //     .loadCurrentWidget(route: masterRoute, object: object),
      ),
    );
  }
}

// class RootPageConeg extends StatelessWidget {
//   Widget object;
//   CrossAxisAlignment cAA;
//   String masterRoute;

//   RootPageConeg({this.object, this.cAA, this.masterRoute});

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

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         drawer: DrawerPanel(),
//         appBar: AppBarPanel(
//           height: 60,
//         ),
//         backgroundColor: Color(0xFF006E68),
//         body: Column(
//           crossAxisAlignment: cAA,
//           children: GetIt.I<ConegBuilder>()
//               .loadCurrentWidget(route: masterRoute, object: object),
//         ));
//   }
// }

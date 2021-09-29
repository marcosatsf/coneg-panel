import 'dart:io';
import 'package:coneg/models/design_color_model.dart';
import 'package:coneg/models/request_model.dart';
import 'package:coneg/ui/help_view.dart';
import 'package:coneg/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class SetupUser extends StatefulWidget {
  @override
  _SetupUserState createState() => _SetupUserState();
}

class _SetupUserState extends State<SetupUser> {
  Widget _build = CircularProgressIndicator();
  Map<String, dynamic> chartsDisponiveisReq;
  RequestConeg requestSystem = RequestConeg();
  ConegDesign userPanelDesign = GetIt.I<ConegDesign>();
  String userPanelTitle = "Painel da Transparência ConEg";
  String chartsDisponiveisTitle = "Informações disponíveis";
  String chartsOrganizadosTitle = "Atualmente configurado";
  HelpView helpUserPanel = HelpView('assets/helpUserPanel.txt');
  double chartsOrganizadosHeight = 50;
  double chartsOrganizadosWidth = 50;
  final Map<String, dynamic> emptyModule = {
    'module': '-',
    'name': 'Vazio',
    'size': 1
  };
  Map<String, dynamic> chartsOrganizadosLocations = {
    '0,0': {'module': '-', 'name': 'Vazio', 'size': 1},
    '0,1': {'module': '-', 'name': 'Vazio', 'size': 1},
    '1,0': {'module': '-', 'name': 'Vazio', 'size': 1},
    '1,1': {'module': '-', 'name': 'Vazio', 'size': 1},
  };
  List<bool> chartsOrganizadosModuloExpandido = [false, false];
  int acceptedData = 0;
  bool initial = true;

  @override
  void initState() {
    super.initState();
    _loadRes();
  }

  void _loadRes() async {
    chartsDisponiveisReq =
        await requestSystem.getJsonAuth(endpoint: '/available_infos');
    chartsOrganizadosLocations =
        await requestSystem.getJsonAuth(endpoint: '/current_user_setup');
    updateConfig();
    buildModules();
  }

  void updateConfig() {
    // chartsOrganizadosLocations
    setState(() {
      if (chartsOrganizadosLocations['0,0']['size'] > 1)
        chartsOrganizadosModuloExpandido[0] = true;
      if (chartsOrganizadosLocations['1,0']['size'] > 1)
        chartsOrganizadosModuloExpandido[1] = true;
    });
  }

  void buildModules() {
    // res[features]
    List<Widget> tmp = List.empty(growable: true);
    double moduleSize = 100;
    for (var item in chartsDisponiveisReq['features']) {
      tmp.add(
        Draggable<Map>(
          data: item,
          child: Container(
            width: moduleSize,
            height: moduleSize,
            decoration: BoxDecoration(
                color: item['size'] > 1
                    ? userPanelDesign.getPurple()
                    : userPanelDesign.getBlue(),
                border: Border.all(width: 5, color: Color(0xFF23A39B))),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Center(
                  child: Text(
                item['name'],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              )),
            ),
          ),
          feedback: Container(
            width: moduleSize,
            height: moduleSize,
            decoration: BoxDecoration(
                color: item['size'] > 1
                    ? userPanelDesign.getPurple()
                    : userPanelDesign.getBlue(),
                borderRadius: BorderRadius.all(Radius.circular(20)),
                border: Border.all(width: 5, color: Color(0xFF23A39B))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                item['name'],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              )),
            ),
          ),
          childWhenDragging: Container(
            width: moduleSize,
            height: moduleSize,
            decoration: BoxDecoration(
                color: Color(0xFF23A39B),
                border: Border.all(width: 5, color: Color(0xFF23A39B))),
          ),
        ),
      );
    }

    tmp.add(
      Draggable<Map>(
        data: emptyModule,
        child: Container(
          width: moduleSize,
          height: moduleSize,
          decoration: BoxDecoration(
              color: userPanelDesign.getBlue(),
              border: Border.all(width: 5, color: Color(0xFF23A39B))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Text(
              emptyModule['name'],
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
            )),
          ),
        ),
        feedback: Container(
          width: moduleSize,
          height: moduleSize,
          decoration: BoxDecoration(
              color: userPanelDesign.getBlue(),
              borderRadius: BorderRadius.all(Radius.circular(20)),
              border: Border.all(width: 5, color: Color(0xFF23A39B))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Text(
              emptyModule['name'],
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
            )),
          ),
        ),
        childWhenDragging: Container(
          width: moduleSize,
          height: moduleSize,
          decoration: BoxDecoration(
              color: Color(0xFF23A39B),
              border: Border.all(width: 5, color: Color(0xFF23A39B))),
        ),
      ),
    );

    print(chartsDisponiveisReq);
    setState(() {
      _build = SingleChildScrollView(
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: tmp,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: <Widget>[
                    // Stroked text as border.
                    Text(
                      userPanelTitle,
                      style: TextStyle(
                        fontSize: 40,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 6
                          ..color = userPanelDesign.getBlue(),
                      ),
                    ),
                    // Solid text as fill.
                    Text(
                      userPanelTitle,
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.grey[300],
                      ),
                    ),
                  ],
                ),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: IconButton(
                        splashRadius: 10,
                        icon: Icon(
                          Icons.help_outline_rounded,
                          color: userPanelDesign.getPurple(),
                        ),
                        onPressed: () {
                          helpUserPanel.showHelp(context,
                              "Ajuda em Painel da Transparência ConEg");
                        })),
              ],
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 10,
              child: Container(
                height: 500,
                width: 500,
                decoration: BoxDecoration(
                    color: Color(0xFF17DFD3),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    border: Border.all(width: 5, color: Color(0xFF23A39B))),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Stack(
                        children: <Widget>[
                          // Stroked text as border.
                          Text(
                            chartsDisponiveisTitle,
                            style: TextStyle(
                              fontSize: 18,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 6
                                ..color = userPanelDesign.getBlue(),
                            ),
                          ),
                          // Solid text as fill.
                          Text(
                            chartsDisponiveisTitle,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[300],
                            ),
                          ),
                        ],
                      ),
                    ),
                    _build
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: [
                  Icon(
                    Icons.arrow_forward,
                    size: 50,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Container(
                      width: 200,
                      height: 50,
                      child: MaterialButton(
                        onPressed: () async {
                          print('nice dude!');
                          await requestSystem.postJsonAuth(
                              endpoint: '/update_user_setup',
                              data: chartsOrganizadosLocations);
                          if (requestSystem.lastStatusCode == 200)
                            helpUserPanel.showInfo(context, 'Sistema ConEg',
                                'O Painel da Transparência do usuário foi atualizado com sucesso!');
                          else
                            helpUserPanel.showInfo(
                                context,
                                'Sistema ConEg - Erro',
                                'Não foi possível atualizar o Painel da Transparência. Tente novamente mais tarde!');
                        },
                        color: userPanelDesign.getPurple(),
                        elevation: 10,
                        highlightElevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        textColor: Colors.white,
                        child: Text(
                          'Definir painel da transparência',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 10,
              child: Container(
                height: 500,
                width: 500,
                decoration: BoxDecoration(
                    color: Color(0xFF17DFD3),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    border: Border.all(width: 5, color: Color(0xFF23A39B))),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Stack(
                        children: <Widget>[
                          // Stroked text as border.
                          Text(
                            chartsOrganizadosTitle,
                            style: TextStyle(
                              fontSize: 18,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 6
                                ..color = userPanelDesign.getBlue(),
                            ),
                          ),
                          // Solid text as fill.
                          Text(
                            chartsOrganizadosTitle,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[300],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: SizedBox(
                        child: GridView.count(
                            primary: false,
                            padding: EdgeInsets.all(50),
                            crossAxisSpacing: 50,
                            mainAxisSpacing: 50,
                            crossAxisCount: 2,
                            children: <Widget>[
                              DragTarget<Map>(
                                builder: (
                                  BuildContext context,
                                  List<dynamic> accepted,
                                  List<dynamic> rejected,
                                ) {
                                  return Container(
                                    height: chartsOrganizadosHeight,
                                    width: chartsOrganizadosWidth,
                                    decoration: BoxDecoration(
                                        color: chartsOrganizadosLocations['0,0']
                                                    ['name'] ==
                                                'Vazio'
                                            ? Color(0xFF23A39B)
                                            : Colors.amber.shade900,
                                        border: Border.all(
                                            width: 20,
                                            color: Color(0xFF23A39B))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          chartsOrganizadosModuloExpandido[0]
                                              ? '[0,0]\n\n${chartsOrganizadosLocations['0,0']['name']} (1/2)'
                                              : '[0,0]\n\n${chartsOrganizadosLocations['0,0']['name']}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: chartsOrganizadosLocations[
                                                        '0,0']['name'] ==
                                                    'Vazio'
                                                ? Colors.black
                                                : Colors.white,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                onAccept: (Map data) {
                                  setState(() {
                                    chartsOrganizadosLocations['0,0'] = data;
                                    if (data['size'] > 1) {
                                      chartsOrganizadosModuloExpandido[0] =
                                          true;
                                      chartsOrganizadosLocations['0,1'] = data;
                                    } else {
                                      if (chartsOrganizadosModuloExpandido[0] ==
                                          true)
                                        chartsOrganizadosLocations['0,1'] =
                                            emptyModule;
                                      chartsOrganizadosModuloExpandido[0] =
                                          false;
                                    }
                                  });
                                },
                              ),
                              DragTarget<Map>(
                                builder: (
                                  BuildContext context,
                                  List<dynamic> accepted,
                                  List<dynamic> rejected,
                                ) {
                                  return Container(
                                    height: chartsOrganizadosHeight,
                                    width: chartsOrganizadosWidth,
                                    decoration: BoxDecoration(
                                        color: chartsOrganizadosLocations['0,1']
                                                    ['name'] ==
                                                'Vazio'
                                            ? Color(0xFF23A39B)
                                            : Colors.amber.shade900,
                                        border: Border.all(
                                            width: 20,
                                            color: Color(0xFF23A39B))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          chartsOrganizadosModuloExpandido[0]
                                              ? '[0,1]\n\n${chartsOrganizadosLocations['0,1']['name']} (2/2)'
                                              : '[0,1]\n\n${chartsOrganizadosLocations['0,1']['name']}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: chartsOrganizadosLocations[
                                                        '0,1']['name'] ==
                                                    'Vazio'
                                                ? Colors.black
                                                : Colors.white,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                onAccept: (Map data) {
                                  setState(() {
                                    chartsOrganizadosLocations['0,1'] = data;
                                    if (data['size'] > 1) {
                                      chartsOrganizadosModuloExpandido[0] =
                                          true;
                                      chartsOrganizadosLocations['0,0'] = data;
                                    } else {
                                      if (chartsOrganizadosModuloExpandido[0] ==
                                          true)
                                        chartsOrganizadosLocations['0,0'] =
                                            emptyModule;
                                      chartsOrganizadosModuloExpandido[0] =
                                          false;
                                    }
                                  });
                                },
                              ),
                              DragTarget<Map>(
                                builder: (
                                  BuildContext context,
                                  List<dynamic> accepted,
                                  List<dynamic> rejected,
                                ) {
                                  return Container(
                                    height: chartsOrganizadosHeight,
                                    width: chartsOrganizadosWidth,
                                    decoration: BoxDecoration(
                                        color: chartsOrganizadosLocations['1,0']
                                                    ['name'] ==
                                                'Vazio'
                                            ? Color(0xFF23A39B)
                                            : Colors.amber.shade900,
                                        border: Border.all(
                                            width: 20,
                                            color: Color(0xFF23A39B))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          chartsOrganizadosModuloExpandido[1]
                                              ? '[1,0]\n\n${chartsOrganizadosLocations['1,0']['name']} (1/2)'
                                              : '[1,0]\n\n${chartsOrganizadosLocations['1,0']['name']}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: chartsOrganizadosLocations[
                                                        '1,0']['name'] ==
                                                    'Vazio'
                                                ? Colors.black
                                                : Colors.white,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                onAccept: (Map data) {
                                  setState(() {
                                    chartsOrganizadosLocations['1,0'] = data;
                                    if (data['size'] > 1) {
                                      chartsOrganizadosModuloExpandido[1] =
                                          true;
                                      chartsOrganizadosLocations['1,1'] = data;
                                    } else {
                                      if (chartsOrganizadosModuloExpandido[1] ==
                                          true)
                                        chartsOrganizadosLocations['1,1'] =
                                            emptyModule;
                                      chartsOrganizadosModuloExpandido[1] =
                                          false;
                                    }
                                  });
                                },
                              ),
                              DragTarget<Map>(
                                builder: (
                                  BuildContext context,
                                  List<dynamic> accepted,
                                  List<dynamic> rejected,
                                ) {
                                  return Container(
                                    height: chartsOrganizadosHeight,
                                    width: chartsOrganizadosWidth,
                                    decoration: BoxDecoration(
                                        color: chartsOrganizadosLocations['1,1']
                                                    ['name'] ==
                                                'Vazio'
                                            ? Color(0xFF23A39B)
                                            : Colors.amber.shade900,
                                        border: Border.all(
                                            width: 20,
                                            color: Color(0xFF23A39B))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          chartsOrganizadosModuloExpandido[1]
                                              ? '[1,1]\n\n${chartsOrganizadosLocations['1,1']['name']} (2/2)'
                                              : '[1,1]\n\n${chartsOrganizadosLocations['1,1']['name']}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: chartsOrganizadosLocations[
                                                        '1,1']['name'] ==
                                                    'Vazio'
                                                ? Colors.black
                                                : Colors.white,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                onAccept: (Map data) {
                                  setState(() {
                                    chartsOrganizadosLocations['1,1'] = data;
                                    if (data['size'] > 1) {
                                      chartsOrganizadosModuloExpandido[1] =
                                          true;
                                      chartsOrganizadosLocations['1,0'] = data;
                                    } else {
                                      if (chartsOrganizadosModuloExpandido[1] ==
                                          true)
                                        chartsOrganizadosLocations['1,0'] =
                                            emptyModule;
                                      chartsOrganizadosModuloExpandido[1] =
                                          false;
                                    }
                                  });
                                },
                              ),
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        // Padding(
        //   padding: EdgeInsets.all(20),
        //   child: Container(
        //     height: 500,
        //     width: 500,
        //     decoration: BoxDecoration(
        //         color: Color(0xFF17DFD3),
        //         borderRadius: BorderRadius.all(Radius.circular(20)),
        //         border: Border.all(width: 5, color: Color(0xFF23A39B))),
        //   ),
        // ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:coneg/utils/routes.dart';
import 'package:coneg/models/auth_model.dart';
import 'package:get_it/get_it.dart';
import 'package:rive/rive.dart';

class DrawerPanel extends StatelessWidget {
  final Color buttonColor = Colors.white;
  final List<bool> selected;

  const DrawerPanel({Key key, this.selected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 10,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF23A39B),
              ),
              child: RiveAnimation.asset(
                'assets/coneg_gif.riv',
              )
              // Container(
              //   margin: EdgeInsets.all(30),
              //   alignment: Alignment.center,
              //   child: Text(
              //     'ConEg - Menu',
              //     style: TextStyle(
              //         fontSize: 30,
              //         fontWeight: FontWeight.bold,
              //         color: Colors.white),
              //   ),
              //   decoration: BoxDecoration(
              //     color: Color(0xFF1F41B4),
              //     border: Border.all(
              //       color: Color(0xFF970062),
              //       width: 4.0,
              //     ),
              //     borderRadius: BorderRadius.circular(15),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Color(0xFF970062).withOpacity(0.8),
              //         spreadRadius: 5,
              //         blurRadius: 7, // changes position of shadow
              //       ),
              //     ],
              //   ),
              // ),
              ),
          ListTile(
            selected: selected[0],
            selectedTileColor: Color(0xFF1F41B4),
            hoverColor: Color(0xFF006E68),
            title: Text(
              'Dashboard',
              style: TextStyle(color: buttonColor),
            ),
            leading: Icon(
              Icons.dashboard_rounded,
              color: buttonColor,
            ),
            onTap: () {
              Navigator.popAndPushNamed(context, ConegRoutes.dashboard);
              // context.vxNav.push(
              //   Uri.parse(ConegRoutes.dashboard),
              // );
            },
          ),
          ListTile(
            selected: selected[1],
            selectedTileColor: Color(0xFF1F41B4),
            hoverColor: Color(0xFF006E68),
            title: Text(
              'Cadastro de Pessoas',
              style: TextStyle(color: buttonColor),
            ),
            leading: Icon(
              Icons.add_box_rounded,
              color: buttonColor,
            ),
            onTap: () {
              Navigator.popAndPushNamed(context, ConegRoutes.cadastro);
              // context.vxNav.push(Uri.parse(ConegRoutes.cadastro));
            },
          ),
          ListTile(
            selected: selected[2],
            selectedTileColor: Color(0xFF1F41B4),
            hoverColor: Color(0xFF006E68),
            title: Text(
              'Notificações',
              style: TextStyle(color: buttonColor),
            ),
            leading: Icon(
              Icons.notification_important_rounded,
              color: buttonColor,
            ),
            onTap: () {
              Navigator.popAndPushNamed(context, ConegRoutes.configNotific);
              // context.vxNav.push(Uri.parse(ConegRoutes.configNotific));
            },
          ),
          ListTile(
            selected: selected[3],
            selectedTileColor: Color(0xFF1F41B4),
            hoverColor: Color(0xFF006E68),
            title: Text(
              'Configuração do Administrador',
              style: TextStyle(color: buttonColor),
            ),
            leading: Icon(
              Icons.miscellaneous_services_rounded,
              color: buttonColor,
            ),
            onTap: () {
              Navigator.popAndPushNamed(context, ConegRoutes.configAdm);
              // context.vxNav.push(Uri.parse(ConegRoutes.configAdm));
            },
          ),
          ListTile(
            selectedTileColor: Color(0xFF1F41B4),
            hoverColor: Color(0xFF006E68),
            title: Text(
              'Sair',
              style: TextStyle(color: buttonColor),
            ),
            leading: Icon(
              Icons.exit_to_app_rounded,
              color: buttonColor,
            ),
            onTap: () {
              AuthModel authentication = GetIt.I<AuthModel>();
              authentication.logout();
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
          ),
        ],
      ),
    );
  }
}

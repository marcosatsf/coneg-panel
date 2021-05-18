import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:coneg/utils/routes.dart';

class DrawerPanel extends StatelessWidget {
  const DrawerPanel({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF23A39B),
            ),
            child: Container(
              margin: EdgeInsets.all(30),
              alignment: Alignment.center,
              child: Text(
                'ConEg - Menu',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              decoration: BoxDecoration(
                color: Color(0xFF1F41B4),
                border: Border.all(
                  color: Color(0xFF970062),
                  width: 4.0,
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF970062).withOpacity(0.8),
                    spreadRadius: 5,
                    blurRadius: 7, // changes position of shadow
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            title: Text('Dashboard'),
            leading: Icon(Icons.dashboard_rounded),
            onTap: () {
              context.vxNav.push(
                Uri.parse(ConegRoutes.dashboard),
              );
            },
          ),
          ListTile(
            title: Text('Cadastro de Pessoas'),
            leading: Icon(Icons.add_box_rounded),
            onTap: () {
              context.vxNav.push(Uri.parse(ConegRoutes.cadastro));
            },
          ),
          ListTile(
            title: Text('Configuração de Notificação'),
            leading: Icon(Icons.notification_important_rounded),
            onTap: () {
              context.vxNav.push(Uri.parse(ConegRoutes.configNotific));
            },
          ),
          ListTile(
            title: Text('Configuração do Administrador'),
            leading: Icon(Icons.miscellaneous_services_rounded),
            onTap: () {
              context.vxNav.push(Uri.parse(ConegRoutes.configAdm));
            },
          ),
          ListTile(
            title: Text('Sair'),
            leading: Icon(Icons.exit_to_app_rounded),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
        ],
      ),
    );
  }
}

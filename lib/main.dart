import 'package:coneg/ui/dashboard.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final PageController pageController;
  _HomeState(this.pageController);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
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
                  Navigator.of(context).push(
                      context, MaterialPageRoute(builder: () => Dashboard()));
                },
              ),
              ListTile(
                title: Text('Cadastro de Pessoas'),
                leading: Icon(Icons.add_box_rounded),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                title: Text('Configuração de Notificação'),
                leading: Icon(Icons.notification_important_rounded),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                title: Text('Configuração do Administrador'),
                leading: Icon(Icons.miscellaneous_services_rounded),
                onTap: () {
                  // Update the state of the app.
                  // ...
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
        ),
        appBar: AppBar(
          backgroundColor: Color(0xFF23A39B),
          title: Padding(
            padding: EdgeInsets.all(10),
            child: Image.asset(
              'assets/images/ConEg.png',
              height: 50,
              width: 50,
            ),
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.black,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              color: Color(0xFF17DFD3),
              height: 50,
            ),
          ],
        ));
  }
}

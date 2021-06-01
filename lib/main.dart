import 'package:flutter/material.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:coneg/screens/home.dart';
import 'package:coneg/utils/routes.dart';
import 'package:coneg/screens/dashboard.dart';
import 'package:coneg/screens/cadastro.dart';
import 'package:coneg/screens/notificacao.dart';
import 'package:coneg/screens/configuracao.dart';

void main() {
  setPathUrlStrategy();
  runApp(MaterialApp(
    title: 'ConEg-Front',
    initialRoute: ConegRoutes.dashboard,
    routes: {
      '/': (context) => Home(),
      ConegRoutes.dashboard: (context) => Dashboard(),
      ConegRoutes.cadastro: (context) => Cadastro(),
      ConegRoutes.configNotific: (context) => NotificacaoConfig(),
      ConegRoutes.configAdm: (context) => Configuracao(),
    },
    // routeInformationParser: VxInformationParser(),
    // routerDelegate: VxNavigator(routes: {
    //   "/": (_, __) => MaterialPage(child: Home()),
    //   ConegRoutes.dashboard: (_, __) => MaterialPage(child: Dashboard()),
    //   ConegRoutes.cadastro: (_, __) => MaterialPage(child: Cadastro()),
    //   ConegRoutes.configNotific: (_, __) =>
    //       MaterialPage(child: NotificacaoConfig()),
    //   ConegRoutes.configAdm: (_, __) => MaterialPage(child: Configuracao()),
    // }),
  ));
}

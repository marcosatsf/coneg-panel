import 'package:coneg/models/auth_model.dart';
import 'package:coneg/models/design_color_model.dart';
import 'package:coneg/models/request_model.dart';
import 'package:coneg/screens/cadastro.dart';
import 'package:coneg/screens/cadastro_unico.dart';
import 'package:coneg/screens/configuracao.dart';
import 'package:coneg/ui/piechart.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ConegRoutes {
  static const String dashboard = '/dashboard';
  static const String cadastro = '/cadastro';
  static const String configNotific = '/confignotific';
  static const String configAdm = '/configadm';

  Map<String, Map<String, Widget>> mappedRoutes = {
    dashboard: {'Resumo Geral': CustomPieChart()},
    cadastro: {
      'Cadastro Geral': CadastroCompleto(),
      'Cadastro Único': CadastroUnico(),
    },
    configNotific: {
      // 'Configuração de notificação': NotificacaoConfig()
    },
    configAdm: {'Configuração da conta': Configuracao()}
  };

  Map<String, Widget> getSubRoutesFrom(String route) {
    // if (route == dashboard) {
    //   // TODO route list every inspector location
    //   var res = await RequestConeg().getJsonAuth(endpoint: '/inpector_list');
    //   for (var cam in res['cams']) {
    //     mappedRoutes[dashboard].addEntries({cam: DashboardCam()})
    //   }
    // }
    return mappedRoutes[route];
  }
}

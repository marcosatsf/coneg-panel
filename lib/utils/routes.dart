import 'package:coneg/models/auth_model.dart';
import 'package:coneg/models/design_color_model.dart';
import 'package:coneg/models/request_model.dart';
import 'package:coneg/screens/cadastro.dart';
import 'package:coneg/screens/cadastro_unico.dart';
import 'package:coneg/screens/configuracao.dart';
import 'package:coneg/screens/dashboard.dart';
import 'package:coneg/screens/dashboard_cam.dart';
import 'package:coneg/screens/dashboard_prediction.dart';
import 'package:coneg/screens/hist_notif.dart';
import 'package:coneg/screens/notificacao.dart';
import 'package:coneg/screens/ranking_notif.dart';
import 'package:coneg/ui/piechart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'package:universal_html/js_util.dart';

class ConegRoutes {
  static const String dashboard = '/dashboard';
  static const String cadastro = '/cadastro';
  static const String configNotific = '/confignotific';
  static const String configAdm = '/configadm';

  Map<String, Map<String, Widget>> mappedRoutes = {
    dashboard: {},
    cadastro: {
      'Cadastro Geral': CadastroCompleto(),
      'Cadastro Único': CadastroUnico(),
    },
    configNotific: {
      'Configuração de notificação': NotificacaoConfig(),
      'Ranking de notificações': RankingNotif(),
      'Histórico de notificações': HistNotif(),
    },
    configAdm: {
      'Configuração da conta': Configuracao(),
    }
  };

  Future<Map<String, Widget>> getSubRoutesFrom(String route) async {
    if (route == dashboard) {
      mappedRoutes[dashboard] = {
        'Quadro Atual Regional': DashboardPred(),
        'Resumo Geral Local': Dashboard(),
      };
      var res = await RequestConeg().getJsonAuth(endpoint: '/inpector_list');
      for (var cam in res['cams']) {
        mappedRoutes[dashboard].addAll({
          cam: DashboardCam(
            key: Key(cam),
            local: cam,
          )
        });
      }
    }
    return mappedRoutes[route];
  }

  Future<Map<String, dynamic>> getCurrentNotification() async {
    Map<String, dynamic> res =
        await RequestConeg().getJsonAuth(endpoint: '/current_notif');
    return res;
  }

  Future<void> setCurrentNotification(Map<String, dynamic> map) async {
    await RequestConeg().postJsonAuth(endpoint: '/update_notif', data: map);
  }

  Future<Map<String, dynamic>> getCurrentLocation(RequestConeg reqC) async {
    Map<String, dynamic> res =
        await reqC.getJsonAuth(endpoint: '/current_location');
    return res;
  }

  Future<void> setCurrentLocation(Map<String, dynamic> map) async {
    await RequestConeg().postJsonAuth(endpoint: '/update_location', data: map);
  }
}

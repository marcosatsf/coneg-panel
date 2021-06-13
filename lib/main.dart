import 'package:coneg/models/auth_model.dart';
import 'package:coneg/models/design_color_model.dart';
import 'package:coneg/screens/root_page.dart';
import 'package:coneg/ui/piechart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
// import 'package:url_strategy/url_strategy.dart';
import 'package:coneg/screens/home.dart';
import 'package:coneg/utils/routes.dart';
// import 'package:coneg/screens/dashboard.dart';
import 'package:coneg/screens/cadastro.dart';
import 'package:coneg/screens/notificacao.dart';
import 'package:coneg/screens/configuracao.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  GetIt.I.registerSingleton(AuthModel());
  GetIt.I.registerSingleton(ConegDesign());
  //setPathUrlStrategy();
  runApp(MaterialApp(
    title: 'ConEg-Front',
    initialRoute: '/',
    onGenerateRoute: (settings) {
      switch (settings.name) {
        case '/':
          return NoAnimRoute(
            builder: (context) => Home(),
            settings: settings,
          );
        case ConegRoutes.dashboard:
          return NoAnimRoute(
            builder: (context) => RootPageConeg(
              object: CustomPieChart(),
              cAA: CrossAxisAlignment.stretch,
              masterRoute: ConegRoutes.dashboard,
            ),
            settings: settings,
          );
        case ConegRoutes.cadastro:
          return NoAnimRoute(
            builder: (context) => RootPageConeg(
              object: CadastroCompleto(),
              cAA: CrossAxisAlignment.center,
              masterRoute: ConegRoutes.cadastro,
            ),
            settings: settings,
          );
        case ConegRoutes.configNotific:
          return NoAnimRoute(
            builder: (context) => RootPageConeg(
              object: NotificacaoConfig(),
              cAA: CrossAxisAlignment.center,
              masterRoute: ConegRoutes.configNotific,
            ),
            settings: settings,
          );
        case ConegRoutes.configAdm:
          return NoAnimRoute(
            builder: (context) => RootPageConeg(
              object: Configuracao(),
              cAA: CrossAxisAlignment.center,
              masterRoute: ConegRoutes.configAdm,
            ),
            settings: settings,
          );
        default:
          return NoAnimRoute(
            builder: (context) => Home(),
            settings: settings,
          );
      }
    },
    // routes: {
    //   '/': (context) => Home(),
    //   ConegRoutes.dashboard: (context) => Dashboard(),
    //   ConegRoutes.cadastro: (context) => Cadastro(),
    //   ConegRoutes.configNotific: (context) => NotificacaoConfig(),
    //   ConegRoutes.configAdm: (context) => Configuracao(),
    // },
    theme: ThemeData(
        splashColor: Color(0xFF1F41B4),
        textTheme: GoogleFonts.ubuntuTextTheme()),
  ));
}

class NoAnimRoute<T> extends MaterialPageRoute<T> {
  NoAnimRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:weddingplanner/src/blocs/contratos/contratos_bloc.dart';
import 'package:weddingplanner/src/blocs/estatus/estatus_bloc.dart';
import 'package:weddingplanner/src/blocs/etiquetas/etiquetas_bloc.dart';
import 'package:weddingplanner/src/blocs/eventos/eventos_bloc.dart';
import 'package:weddingplanner/src/blocs/invitados/invitados_bloc.dart';
import 'package:weddingplanner/src/blocs/login/login_bloc.dart';
import 'package:weddingplanner/src/blocs/machotes/machotes_bloc.dart';
import 'package:weddingplanner/src/blocs/planners/planners_bloc.dart';
import 'package:weddingplanner/src/blocs/timings/timings_bloc.dart';
import 'package:weddingplanner/src/blocs/tiposEventos/tiposeventos_bloc.dart';
import 'package:weddingplanner/src/blocs/usuarios/usuarios_bloc.dart';
import 'package:weddingplanner/src/logic/contratos_logic.dart';
import 'package:weddingplanner/src/logic/etiquetas_logic.dart';
import 'package:weddingplanner/src/logic/lista_invitados_logic.dart';
import 'package:weddingplanner/src/logic/login_logic.dart';
import 'package:weddingplanner/src/logic/machotes_logic.dart';
import 'package:weddingplanner/src/logic/planners_logic.dart';
import 'package:weddingplanner/src/logic/timings_logic.dart';
import 'package:weddingplanner/src/logic/tipos_eventos_logic.dart';
import 'package:weddingplanner/src/resources/route_generator.dart';
import 'blocs/paises/paises_bloc.dart';
import 'logic/estatus_logic.dart';
import 'logic/eventos_logic.dart';
import 'logic/paises_logic.dart';
import 'logic/usuarios.logic.dart';

class MyApp extends StatelessWidget {
  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      supportedLocales: [
        const Locale('en'),
        const Locale('fr'),
        const Locale('es')
      ],
      title: 'App',
      theme: ThemeData(
          primarySwatch: createMaterialColor(Color(0xFF880B55)),
          //backgroundColor: createMaterialColor(Color(0xD34444)),
          scaffoldBackgroundColor: hexToColor('#FFF9F9'),
          fontFamily: 'Comfortaa'),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}

class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<LoginBloc>(
        create: (_) => LoginBloc(logic: BackendLoginLogic()),
      ),
      BlocProvider<InvitadosBloc>(
        create: (_) => InvitadosBloc(logic: FetchListaInvitadosLogic()),
      ),
      BlocProvider<EventosBloc>(
        create: (_) => EventosBloc(logic: FetchListaEventosLogic()),
      ),
      BlocProvider<EstatusBloc>(
        create: (_) => EstatusBloc(logic: FetchListaEstatusLogic()),
      ),
      BlocProvider<PlannersBloc>(
          create: (_) => PlannersBloc(logic: FetchListaPlannersLogic())),
      BlocProvider<PaisesBloc>(
          create: (_) => PaisesBloc(logic: FetchListaPaisesLogic())),
      BlocProvider<EtiquetasBloc>(
          create: (_) => EtiquetasBloc(logic: FetchListaEtiquetasLogic())),
      BlocProvider<MachotesBloc>(
          create: (_) => MachotesBloc(logic: FetchListaMachotesLogic())),
      BlocProvider<ContratosBloc>(
          create: (_) => ContratosBloc(logic: FetchListaContratosLogic())),
      BlocProvider<TiposEventosBloc>(
          create: (_) =>
              TiposEventosBloc(logic: FetchListaTiposEventosLogic())),
      BlocProvider<UsuariosBloc>(
          create: (_) => UsuariosBloc(logic: FetchListaUsuariosLogic())),
      BlocProvider<TimingsBloc>(
          create: (_) => TimingsBloc(logic: FetchListaTimingsLogic())),
    ], child: MyApp());
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart' as flc;
import 'package:planning/src/blocs/Mesas/mesas_bloc.dart';
import 'package:planning/src/blocs/contratos/bloc/contratos_bloc.dart';
import 'package:planning/src/blocs/contratos/bloc/add_contratos_bloc.dart';
import 'package:planning/src/blocs/contratos/bloc/ver_contratos_bloc.dart';
import 'package:planning/src/blocs/dashboard/dashboard_bloc.dart';
import 'package:planning/src/blocs/historialPagos/historialpagos_bloc.dart';
import 'package:planning/src/blocs/invitadosMesa/invitadosmesas_bloc.dart';
import 'package:planning/src/blocs/involucrados/involucrados_bloc.dart';
import 'package:planning/src/blocs/mesasAsignadas/mesasasignadas_bloc.dart';
import 'package:planning/src/blocs/pagos/pagos_bloc.dart';
import 'package:planning/src/blocs/plantillasSistema/plantiilas_sistema_bloc.dart';
import 'package:planning/src/blocs/proveedorEvento/proveedoreventos_bloc.dart';
import 'package:planning/src/blocs/proveedores/archivos_especiales/archivos_especiales_bloc.dart';
import 'package:planning/src/blocs/proveedores/view_archivos/view_archivos_bloc.dart';
import 'package:planning/src/blocs/qr_invitado/qr_bloc.dart';
import 'package:planning/src/logic/add_contratos_logic.dart';
import 'package:planning/src/logic/dashboard_logic/dashboard_logic.dart';
import 'package:planning/src/logic/historial_pagos/historial_pagos_logic.dart';
import 'package:planning/src/logic/invitados_mesas_logic/invitados_mesa_logic.dart';
import 'package:planning/src/logic/involucrados_logic.dart';
import 'package:planning/src/logic/mesas_logic/mesa_logic.dart';
import 'package:planning/src/logic/pagos_logic.dart';
import 'package:planning/src/logic/prospecto_logic/prospecto_logic.dart';
import 'package:planning/src/logic/proveedores_evento_logic.dart';
import 'package:planning/src/logic/servicios_logic.dart';
import 'package:planning/src/blocs/actividadesTiming/actividadestiming_bloc.dart';
import 'package:planning/src/blocs/servicios/bloc/servicios_bloc_dart_bloc.dart';
import 'package:planning/src/blocs/contratos/contratos_bloc.dart';
import 'package:planning/src/blocs/estatus/estatus_bloc.dart';
import 'package:planning/src/blocs/etiquetas/etiquetas_bloc.dart';
import 'package:planning/src/blocs/eventos/eventos_bloc.dart';
import 'package:planning/src/blocs/invitados/invitados_bloc.dart';
import 'package:planning/src/blocs/lista/detalle_lista/detalle_listas_bloc.dart';
import 'package:planning/src/blocs/lista/listas_bloc.dart';
import 'package:planning/src/blocs/login/login_bloc.dart';
import 'package:planning/src/blocs/machotes/machotes_bloc.dart';
import 'package:planning/src/blocs/permisos/permisos_bloc.dart';
import 'package:planning/src/blocs/planes/planes_bloc.dart';
import 'package:planning/src/blocs/planners/planners_bloc.dart';
import 'package:planning/src/blocs/roles/formRol/form_rol_bloc.dart';
import 'package:planning/src/blocs/roles/rol/rol_bloc.dart';
import 'package:planning/src/blocs/roles/roles_bloc.dart';
import 'package:planning/src/blocs/timings/timings_bloc.dart';
import 'package:planning/src/blocs/tiposEventos/tiposeventos_bloc.dart';
import 'package:planning/src/blocs/usuarios/usuarios_bloc.dart';
import 'package:planning/src/logic/actividades_timing_logic.dart';
import 'package:planning/src/logic/detalle_listas_logic.dart';
import 'package:planning/src/logic/listas_logic.dart';
import 'package:planning/src/logic/contratos_logic.dart';
import 'package:planning/src/logic/etiquetas_logic.dart';
import 'package:planning/src/logic/lista_invitados_logic.dart';
import 'package:planning/src/logic/login_logic.dart';
import 'package:planning/src/logic/machotes_logic.dart';
import 'package:planning/src/logic/permisos_logic.dart';
import 'package:planning/src/logic/planes_logic.dart';
import 'package:planning/src/logic/roles_logic.dart';
import 'package:planning/src/logic/timings_logic.dart';
import 'package:planning/src/logic/tipos_eventos_logic.dart';
import 'package:planning/src/resources/route_generator.dart';
import 'blocs/paises/paises_bloc.dart';
import 'blocs/perfil/perfil_bloc.dart';
import 'blocs/prospecto/prospecto_bloc.dart';
import 'blocs/usuarios/usuario/usuario_bloc.dart';
import 'logic/estatus_logic.dart';
import 'logic/eventos_logic.dart';
import 'logic/paises_logic.dart';
import 'logic/perfil_logic.dart';
import 'logic/usuarios.logic.dart';
import 'blocs/asistencia/asistencia_bloc.dart';
import 'logic/asistencia_logic.dart';
import 'package:planning/src/blocs/comentariosActividades/comentariosactividades_bloc.dart';
import 'logic/comentarios_actividades_logic.dart';
import 'package:planning/src/blocs/proveedores/archivo_proveedor/bloc/archivo_proveedor_bloc.dart';
import 'package:planning/src/blocs/proveedores/proveedor_bloc.dart';
import 'package:planning/src/logic/archivos_proveedores_logic.dart';
import 'package:planning/src/logic/proveedores_logic.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessegerKey =
    GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int?, Color> swatch = <int?, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch as Map<int, Color>);
  }

  static const MaterialColor primaryColor =
      MaterialColor(0xFFfdf4e5, <int, Color>{
    50: Color(0xFFfdf4e5),
    100: Color(0xFFfdf4e5),
    200: Color(0xFFfdf4e5),
    300: Color(0xFFfdf4e5),
    400: Color(0xFFfdf4e5),
    500: Color(0xFFfdf4e5),
    600: Color(0xFFfdf4e5),
    700: Color(0xFFfdf4e5),
    800: Color(0xFFfdf4e5),
    900: Color(0xFFfdf4e5),
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessegerKey,
      localizationsDelegates: const [
        flc.CountryLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        SfGlobalLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('es'),
        for (var s in flc.supportedLocales) Locale(s)
      ],
      locale: const Locale('es'),
      title: 'Planning',
      theme: ThemeData(
        bottomNavigationBarTheme:
            const BottomNavigationBarThemeData(selectedItemColor: Colors.black),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.black,
          selectionColor: Colors.grey,
        ),
        primarySwatch: primaryColor,
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: Colors.black)),
        inputDecorationTheme: const InputDecorationTheme(
            floatingLabelStyle: TextStyle(color: Colors.black54)),
        scaffoldBackgroundColor: hexToColor('#fff9f9'),
        fontFamily: 'Montserrat-Medium',
      ),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

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
      BlocProvider<PlannersBloc>(create: (_) => PlannersBloc()),
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
      BlocProvider<UsuarioBloc>(
          create: (_) => UsuarioBloc(logic: UsuarioCrud())),
      BlocProvider<TimingsBloc>(
          create: (_) => TimingsBloc(logic: FetchListaTimingsLogic())),
      BlocProvider<ActividadestimingBloc>(
          create: (_) => ActividadestimingBloc(
              logic: FetchListaActividadesTimingsLogic())),
      BlocProvider<AsistenciaBloc>(
          create: (_) => AsistenciaBloc(logic: FetchListaAsistenciaLogic())),
      BlocProvider<PermisosBloc>(
          create: (_) => PermisosBloc(logic: PerfiladoLogic())),
      BlocProvider<RolesBloc>(
          create: (_) => RolesBloc(logic: RolesPlannerLogic())),
      BlocProvider<RolBloc>(create: (_) => RolBloc(logic: RolCrud())),
      BlocProvider<FormRolBloc>(
          create: (_) => FormRolBloc(logic: FormRolLogic())),
      BlocProvider<ListasBloc>(
          create: (_) => ListasBloc(logic: FetchListaLogic())),
      BlocProvider<DetalleListasBloc>(
          create: (_) => DetalleListasBloc(logic: FetchDetalleListaLogic())),
      BlocProvider<ComentariosactividadesBloc>(
        create: (_) =>
            ComentariosactividadesBloc(logic: ConsultasComentarioLogic()),
      ),
      BlocProvider<PlanesBloc>(
        create: (_) => PlanesBloc(logic: ConsultasPlanesLogic()),
      ),
      BlocProvider<ProveedorBloc>(
          create: (_) => ProveedorBloc(logic: FetchProveedoresLogic())),
      BlocProvider<ArchivoProveedorBloc>(
          create: (_) =>
              ArchivoProveedorBloc(logic: FetchArchivoProveedoresLogic())),
      BlocProvider<ArchivosEspecialesBloc>(
          create: (_) =>
              ArchivosEspecialesBloc(logic: FetchArchivoProveedoresLogic())),
      BlocProvider<ServiciosBloc>(
          create: (_) => ServiciosBloc(logic: FetchServiciosLogic())),
      BlocProvider<ViewArchivosBloc>(
          create: (_) =>
              ViewArchivosBloc(logic: FetchArchivoProveedoresLogic())),
      BlocProvider<ProveedoreventosBloc>(
          create: (_) =>
              ProveedoreventosBloc(logic: FetchProveedoresEventoLogic())),
      BlocProvider<AddContratosBloc>(
          create: (_) => AddContratosBloc(logic: ConsultasAddContratosLogic())),
      BlocProvider<ContratosDosBloc>(
          create: (_) => ContratosDosBloc(logic: ConsultasAddContratosLogic())),
      BlocProvider<VerContratosBloc>(
          create: (_) => VerContratosBloc(logic: ConsultasAddContratosLogic())),
      BlocProvider<InvolucradosBloc>(
          create: (_) => InvolucradosBloc(logic: ConsultasInvolucradosLogic())),
      BlocProvider<PerfilBloc>(
          create: (_) => PerfilBloc(logic: ConsultasPerfilLogic())),
      BlocProvider<PagosBloc>(
          create: (_) => PagosBloc(logic: ConsultasPagosLogic())),
      BlocProvider<MesasBloc>(
          create: (_) => MesasBloc(logic: ServiceMesasLogic())),
      BlocProvider<InvitadosMesasBloc>(
          create: (_) =>
              InvitadosMesasBloc(logic: ServiceInvitadosMesasLogic())),
      BlocProvider<HistorialPagosBloc>(
          create: (_) => HistorialPagosBloc(logic: HistorialPagosLogic())),
      BlocProvider<MesasAsignadasBloc>(create: (_) => MesasAsignadasBloc()),
      BlocProvider<DashboardBloc>(
          create: (_) => DashboardBloc(logic: DashboardLogic())),
      BlocProvider<ProspectoBloc>(
        create: (context) => ProspectoBloc(logic: ProspectoLogic()),
      ),
      BlocProvider<QrBloc>(create: (_) => QrBloc()),
      BlocProvider<PlantillasSistemaBloc>(
          create: (_) => PlantillasSistemaBloc()),
    ], child: const MyApp());
  }
}

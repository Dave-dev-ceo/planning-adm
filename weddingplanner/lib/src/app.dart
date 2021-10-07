import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:weddingplanner/src/blocs/contratos/bloc/contratos_bloc.dart';
import 'package:weddingplanner/src/blocs/contratos/bloc/add_contratos_bloc.dart';
import 'package:weddingplanner/src/blocs/contratos/bloc/ver_contratos_bloc.dart';
import 'package:weddingplanner/src/blocs/involucrados/involucrados_bloc.dart';
import 'package:weddingplanner/src/blocs/pagos/pagos_bloc.dart';
import 'package:weddingplanner/src/blocs/proveedorEvento/proveedoreventos_bloc.dart';
import 'package:weddingplanner/src/blocs/proveedores/view_archivos/view_archivos_bloc.dart';
import 'package:weddingplanner/src/logic/add_contratos_logic.dart';
import 'package:weddingplanner/src/logic/involucrados_logic.dart';
import 'package:weddingplanner/src/logic/pagos_logic.dart';
import 'package:weddingplanner/src/logic/proveedores_evento_logic.dart';
import 'package:weddingplanner/src/logic/servicios_logic.dart';
import 'package:weddingplanner/src/blocs/actividadesTiming/actividadestiming_bloc.dart';
import 'package:weddingplanner/src/blocs/servicios/bloc/servicios_bloc_dart_bloc.dart';
import 'package:weddingplanner/src/blocs/contratos/contratos_bloc.dart';
import 'package:weddingplanner/src/blocs/estatus/estatus_bloc.dart';
import 'package:weddingplanner/src/blocs/etiquetas/etiquetas_bloc.dart';
import 'package:weddingplanner/src/blocs/eventos/eventos_bloc.dart';
import 'package:weddingplanner/src/blocs/invitados/invitados_bloc.dart';
import 'package:weddingplanner/src/blocs/lista/detalle_lista/detalle_listas_bloc.dart';
import 'package:weddingplanner/src/blocs/lista/listas_bloc.dart';
import 'package:weddingplanner/src/blocs/login/login_bloc.dart';
import 'package:weddingplanner/src/blocs/machotes/machotes_bloc.dart';
import 'package:weddingplanner/src/blocs/permisos/permisos_bloc.dart';
import 'package:weddingplanner/src/blocs/planes/planes_bloc.dart';
import 'package:weddingplanner/src/blocs/planners/planners_bloc.dart';
import 'package:weddingplanner/src/blocs/roles/formRol/formRol_bloc.dart';
import 'package:weddingplanner/src/blocs/roles/rol/rol_bloc.dart';
import 'package:weddingplanner/src/blocs/roles/roles_bloc.dart';
import 'package:weddingplanner/src/blocs/timings/timings_bloc.dart';
import 'package:weddingplanner/src/blocs/tiposEventos/tiposeventos_bloc.dart';
import 'package:weddingplanner/src/blocs/usuarios/usuarios_bloc.dart';
import 'package:weddingplanner/src/logic/actividades_timing_logic.dart';
import 'package:weddingplanner/src/logic/detalle_listas_logic.dart';
import 'package:weddingplanner/src/logic/listas_logic.dart';
import 'package:weddingplanner/src/logic/contratos_logic.dart';
import 'package:weddingplanner/src/logic/etiquetas_logic.dart';
import 'package:weddingplanner/src/logic/lista_invitados_logic.dart';
import 'package:weddingplanner/src/logic/login_logic.dart';
import 'package:weddingplanner/src/logic/machotes_logic.dart';
import 'package:weddingplanner/src/logic/permisos_logic.dart';
import 'package:weddingplanner/src/logic/planes_logic.dart';
import 'package:weddingplanner/src/logic/planners_logic.dart';
import 'package:weddingplanner/src/logic/roles_logic.dart';
import 'package:weddingplanner/src/logic/timings_logic.dart';
import 'package:weddingplanner/src/logic/tipos_eventos_logic.dart';
import 'package:weddingplanner/src/resources/route_generator.dart';
import 'blocs/paises/paises_bloc.dart';
import 'blocs/perfil/perfil_bloc.dart';
import 'blocs/usuarios/usuario/usuario_bloc.dart';
import 'logic/estatus_logic.dart';
import 'logic/eventos_logic.dart';
import 'logic/paises_logic.dart';
import 'logic/perfil_logic.dart';
import 'logic/usuarios.logic.dart';
import 'blocs/asistencia/asistencia_bloc.dart';
import 'logic/asistencia_logic.dart';
import 'package:weddingplanner/src/blocs/comentariosActividades/comentariosactividades_bloc.dart';
import 'logic/comentarios_actividades_logic.dart';
import 'package:weddingplanner/src/blocs/proveedores/archivo_proveedor/bloc/archivo_proveedor_bloc.dart';
import 'package:weddingplanner/src/blocs/proveedores/proveedor_bloc.dart';
import 'package:weddingplanner/src/logic/archivos_proveedores_logic.dart';
import 'package:weddingplanner/src/logic/proveedores_logic.dart';
import 'package:weddingplanner/src/blocs/autorizacion/autorizacion_bloc.dart';
import 'package:weddingplanner/src/logic/autorizacion_logic.dart';

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
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('fr'),
        const Locale('es')
      ],
      title: 'App',
      theme: ThemeData(
          primarySwatch: createMaterialColor(Color(0xFFfdf4e5)),
          inputDecorationTheme: InputDecorationTheme(
              floatingLabelStyle: TextStyle(color: Colors.black54)),
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
      BlocProvider<ServiciosBloc>(
          create: (_) => ServiciosBloc(logic: FetchServiciosLogic())),
      BlocProvider<ViewArchivosBloc>(
          create: (_) =>
              ViewArchivosBloc(logic: FetchArchivoProveedoresLogic())),
      BlocProvider<ProveedoreventosBloc>(
          create: (_) =>
              ProveedoreventosBloc(logic: FetchProveedoresEventoLogic())),
      BlocProvider<AutorizacionBloc>(
        create: (_) => AutorizacionBloc(logic: ConsultasAutorizacionLogic()),
      ),
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
    ], child: MyApp());
  }
}

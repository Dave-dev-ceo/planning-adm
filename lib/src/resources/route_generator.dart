import 'package:flutter/material.dart';
import 'package:planning/src/animations/custom_page_router.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/models/eventoModel/evento_resumen_model.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/ui/administrar_planners/administrar_planes.dart';
import 'package:planning/src/ui/administrar_planners/detalles_planner.dart';
import 'package:planning/src/ui/administrar_planners/plantillas_edit.dart';
import 'package:planning/src/ui/contratos/add_contrato.dart';
import 'package:planning/src/ui/contratos/view_contrato_pdf.dart';
import 'package:planning/src/ui/dashboardInvitadoPage/dashboard_page_involucrado.dart';
import 'package:planning/src/ui/eventos/dashboard_eventos.dart';
import 'package:planning/src/ui/home/home.dart';
import 'package:planning/src/ui/login/login.dart';
import 'package:planning/src/ui/mesas/crear_mesas_dialog.dart';
import 'package:planning/src/ui/pagos/edit_pago.dart';
import 'package:planning/src/ui/pagos/form_pago.dart';
import 'package:planning/src/ui/perfil/perfil.dart';
import 'package:planning/src/ui/perfil/perfil_planner_page.dart';
import 'package:planning/src/ui/planes/agregar_planes.dart';
import 'package:planning/src/ui/planes/calendario.dart';
import 'package:planning/src/ui/recoverPassword/recover_password.dart';
import 'package:planning/src/ui/scannerQr/scanner_qr.dart';
import 'package:planning/src/ui/timing_evento/table_calendar.dart';
import 'package:planning/src/ui/widgets/FullScreenDialog/full_screen_dialog_agregar_actividades.dart';
import 'package:planning/src/ui/widgets/FullScreenDialog/full_screen_dialog_agregar_archivo_prov_serv.dart';
import 'package:planning/src/ui/widgets/FullScreenDialog/full_screen_dialog_agregar_contrato.dart';
import 'package:planning/src/ui/widgets/FullScreenDialog/full_screen_dialog_agregar_evento.dart';
import 'package:planning/src/ui/widgets/FullScreenDialog/full_screen_dialog_agregar_invitado.dart';
import 'package:planning/src/ui/widgets/FullScreenDialog/full_screen_dialog_agregar_machote.dart';
import 'package:planning/src/ui/widgets/FullScreenDialog/full_screen_dialog_agregar_proveedor.dart';
import 'package:planning/src/ui/widgets/FullScreenDialog/full_screen_dialog_agregar_rol.dart';
import 'package:planning/src/ui/widgets/FullScreenDialog/full_screen_dialog_agregar_usuario.dart';
import 'package:planning/src/ui/widgets/FullScreenDialog/full_screen_dialog_detalle_lista.dart';
import 'package:planning/src/ui/widgets/FullScreenDialog/full_screen_dialog_editar_contranto.dart';
import 'package:planning/src/ui/widgets/FullScreenDialog/full_screen_dialog_editar_evento.dart';
import 'package:planning/src/ui/widgets/FullScreenDialog/full_screen_dialog_editar_invitado.dart';
import 'package:planning/src/ui/widgets/FullScreenDialog/full_screen_dialog_editar_plantilla.dart';
import 'package:planning/src/ui/widgets/FullScreenDialog/full_screen_dialog_reporte_evento.dart';
import 'package:planning/src/ui/widgets/FullScreenDialog/full_screen_dialog_select_contacts.dart';
import 'package:planning/src/ui/widgets/FullScreenDialog/full_screen_dialog_view_file.dart';
import 'package:planning/src/ui/widgets/invitados/invitados.dart';

import '../models/Planes/planes_model.dart';
import '../models/prospectosModel/prospecto_model.dart';
import '../ui/planes/planes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    final ruta = Uri.parse(settings.name!);
    switch (ruta.path) {
      case '/':
        return CustomPageRouter(
            child: FutureBuilder(
          future: checkSession(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data as Widget;
            } else {
              return const LoadingCustom();
            }
          },
        ));
      case '/home':
        return CustomPageRouter(
            child: Home(
          data: args as Map<dynamic, dynamic>?,
        ));
      case '/dasboard':
        return CustomPageRouter(child: const DashboardEventos());
      case '/eventos':
        return CustomPageRouter(
            child: Invitados(
          detalleEvento: args as Map<dynamic, dynamic>?,
        ));

      case '/lectorQr':
        return CustomPageRouter(child: const ScannerQrInvitado());
      case '/addInvitados':
        return CustomPageRouter(
            child: FullScreenDialogAdd(
          id: args as int?,
        ));
      case '/addContrato':
        return CustomPageRouter(child: const FullScreenDialogAddContrato());
      case '/viewContrato':
        return CustomPageRouter(
            child: ViewPdfContrato(data: args as Map<String, dynamic>));
      case '/addMachote':
        return CustomPageRouter(
            child: FullScreenDialogAddMachote(
          dataMachote: args as List<String?>,
        ));
      case '/editPlantilla':
        return CustomPageRouter(
            child: FullScreenDialogEditPlantilla(
          dataPlantilla: args as List<String?>?,
        ));
      case '/addEvento':
        return CustomPageRouter(
            child: FullScreenDialogAddEvento(
          prospecto: args as ProspectoModel?,
        ));
      case '/editarEvento':
        return CustomPageRouter(
            child: FullScreenDialogEditEvento(
          evento: args as Map<String, dynamic>?,
        ));
      case '/addActividadesTiming':
        return CustomPageRouter(
          transicionRouter: TypeTransicionRouter.fadeRouterTransition,
          child: FullScreenDialogAddActividades(
            idTiming: args as int?,
          ),
        );
      case '/addContactos':
        return CustomPageRouter(
            child: FullScreenDialog(
          id: args as int?,
        ));
      case '/addContratoPdf':
        return CustomPageRouter(
            child: ViewPdfContrato(
          data: args as Map<String, dynamic>,
        ));
      case '/editInvitado':
        return CustomPageRouter(
            child: FullScreenDialogEdit(
          idInvitado: args as int?,
        ));
      case '/reporteEvento':
        return CustomPageRouter(
            child: FullScreenDialogReporte(
          reporte: args as String?,
        ));
      case '/crearUsuario':
        return CustomPageRouter(
            child: FullScreenDialogAddUsuario(
                datos: args as Map<String, dynamic>?));
      case '/editarUsuario':
        return CustomPageRouter(
            child: FullScreenDialogAddUsuario(
                datos: args as Map<String, dynamic>?));
      case '/crearRol':
        return CustomPageRouter(
            child:
                FullScreenDialogAddRol(datos: args as Map<String, dynamic>?));
      case '/editarRol':
        return CustomPageRouter(
            child:
                FullScreenDialogAddRol(datos: args as Map<String, dynamic>?));
      case '/eventoCalendario':
        return CustomPageRouter(
            child: TableEventsExample(
          actividadesLista: args as List<dynamic>?,
        ));
      case '/detalleListas':
        return CustomPageRouter(
            child: FullScreenDialogDetalleListasEvent(
                lista: args as Map<String, dynamic>?));
      case '/agregarPlan':
        return CustomPageRouter(
            child: AgregarPlanes(lista: args as List<TimingModel>));
      case '/calendarPlan':
        return CustomPageRouter(
          child:
              CalendarioPlan(actividadesLista: args as List<ActividadPlanner>?),
        );
      case '/agregarProveedores':
        return CustomPageRouter(
            child: FullScreenDialogAgregarProveedorEvent(
                proveedor: args as Map<String, dynamic>?));
      case '/agregarArchivo':
        return CustomPageRouter(
            child: FullScreenDialogAgregarArchivoProvServEvent(
                provsrv: args as Map<String, dynamic>?));
      case '/viewArchivo':
        return CustomPageRouter(
            child: FullScreenDialogViewFileEvent(
                archivo: args as Map<String, dynamic>?));
      case '/perfil':
        return CustomPageRouter(child: const Perfil());
      case '/addContratos':
        return CustomPageRouter(
            child: AddMachote(map: args as Map<dynamic, dynamic>?));
      case '/addPagosForm':
        return CustomPageRouter(
            child: FormPago(
          tipoPresupuesto: args as String?,
        ));
      case '/editPagosForm':
        return CustomPageRouter(child: FormEditPago(id: args as int?));
      case '/editarContratos':
        return CustomPageRouter(
            child: FullScreenDialogEditContrato(
                data: args as Map<String, dynamic>?));
      case '/asignarMesas':
        return CustomPageRouter(
            child: CrearMesasDialog(
          lastnumMesas: args as int?,
        ));
      case '/perfilPlanner':
        return CustomPageRouter(child: const PerfilPlannerPage());
      case '/recoverPassword':
        final token = ruta.queryParameters['token'];
        return CustomPageRouter(
            child: RecoverPasswordPage(
          token: token,
        ));
      case '/dashboardInvolucrado':
        return CustomPageRouter(
            child: DashboardInvolucradoPage(
          detalleEvento: args as EventoResumenModel?,
        ));
      case '/administrarPlanners':
        return CustomPageRouter(child: const AdminPlannerPage());
      case '/detallesPlanner':
        return CustomPageRouter(
            child: DetallesPlanner(
          idPlanner: args as int?,
        ));

      case '/plantillaSistemaEdit':
        return CustomPageRouter(
            child: PlantillaEditPage(
          idPlantilla: args as int?,
        ));
      default:
        return CustomPageRouter(
            child: FutureBuilder(
          future: checkSession(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data as Widget;
            } else {
              return const LoadingCustom();
            }
          },
        ));
    }
  }
}

Future<Widget> checkSession() async {
  final SharedPreferencesT sharedPreferences = SharedPreferencesT();

  bool? sesion = await sharedPreferences.getSession();
  int? involucrado = await sharedPreferences.getIdInvolucrado();
  int? idEvento = await sharedPreferences.getIdEvento();
  String? titulo = await sharedPreferences.getEventoNombre();
  String? nombreUser = await sharedPreferences.getNombre();
  String? image = await sharedPreferences.getImagen();
  String? portada = await sharedPreferences.getPortada();
  String? fechaEvento = await sharedPreferences.getFechaEvento();

  Map data = {'name': await sharedPreferences.getNombre(), 'imag': image};

  if (sesion == true) {
    if (involucrado == null) {
      return Home(data: data);
    } else {
      return DashboardInvolucradoPage(
        detalleEvento: EventoResumenModel(
          idEvento: idEvento,
          descripcion: titulo,
          nombreCompleto: nombreUser,
          boton: false,
          portada: portada,
          img: image,
          fechaEvento: DateTime.tryParse(fechaEvento!)!.toLocal(),
        ),
      );
    }
  } else {
    return const Login();
  }
}

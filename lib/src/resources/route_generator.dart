import 'package:flutter/material.dart';
import 'package:planning/src/ui/autorizacion/galeria_autorizacion.dart';
import 'package:planning/src/ui/contratos/add_contrato.dart';
import 'package:planning/src/ui/contratos/view_contrato_pdf.dart';
import 'package:planning/src/ui/dashboardInvitadoPage/dashboard_page_involucrado.dart';
import 'package:planning/src/ui/eventos/dashboard_eventos.dart';
import 'package:planning/src/ui/home/home.dart';
import 'package:planning/src/ui/home/home_admin.dart';
import 'package:planning/src/ui/login/login.dart';
import 'package:planning/src/ui/mesas/crearMesasDialog.dart';
import 'package:planning/src/ui/pagos/edit_pago.dart';
import 'package:planning/src/ui/pagos/form_pago.dart';
import 'package:planning/src/ui/perfil/perfil.dart';
import 'package:planning/src/ui/perfil/perfil_planner_page.dart';
import 'package:planning/src/ui/planes/agregar_planes.dart';
import 'package:planning/src/ui/planes/calendario.dart';
import 'package:planning/src/ui/recoverPassword/recover_password.dart';
import 'package:planning/src/ui/scannerQr/scannerQr.dart';
import 'package:planning/src/ui/widgets/FullScreenDialog/full_screen_dialog_agregar_actividades.dart';
import 'package:planning/src/ui/widgets/FullScreenDialog/full_screen_dialog_agregar_contrato.dart';
import 'package:planning/src/ui/widgets/FullScreenDialog/full_screen_dialog_agregar_evento.dart';
import 'package:planning/src/ui/widgets/FullScreenDialog/full_screen_dialog_agregar_invitado.dart';
import 'package:planning/src/ui/widgets/FullScreenDialog/full_screen_dialog_agregar_machote.dart';
import 'package:planning/src/ui/widgets/FullScreenDialog/full_screen_dialog_agregar_planners.dart';
import 'package:planning/src/ui/widgets/FullScreenDialog/full_screen_dialog_agregar_rol.dart';
import 'package:planning/src/ui/widgets/FullScreenDialog/full_screen_dialog_agregar_usuario.dart';
import 'package:planning/src/ui/widgets/FullScreenDialog/full_screen_dialog_detalle_lista.dart';
import 'package:planning/src/ui/widgets/FullScreenDialog/full_screen_dialog_editar_contranto.dart';
import 'package:planning/src/ui/widgets/FullScreenDialog/full_screen_dialog_editar_evento.dart';
import 'package:planning/src/ui/widgets/FullScreenDialog/full_screen_dialog_editar_invitado.dart';
import 'package:planning/src/ui/widgets/FullScreenDialog/full_screen_dialog_editar_plantilla.dart';
import 'package:planning/src/ui/widgets/FullScreenDialog/full_screen_dialog_reporte_evento.dart';
import 'package:planning/src/ui/widgets/FullScreenDialog/full_screen_dialog_select_contacts.dart';
import 'package:planning/src/ui/widgets/FullScreenDialog/full_screen_dialog_verPaginaWeb.dart';
import 'package:planning/src/ui/widgets/FullScreenDialog/full_screen_dialog_view_file.dart';
import 'package:planning/src/ui/widgets/invitados/invitados.dart';
import 'package:planning/src/ui/timing_evento/table_calendar.dart';
import 'package:planning/src/ui/widgets/FullScreenDialog/full_screen_dialog_agregar_archivo_prov_serv.dart';
import 'package:planning/src/ui/widgets/FullScreenDialog/full_screen_dialog_agregar_proveedor.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    final ruta = Uri.parse(settings.name);
    switch (ruta.path) {
      case '/':
        //return MaterialPageRoute(builder: (context) => ScannerQrInvitado());
        //return MaterialPageRoute(builder: (context) => Landing());
        //return MaterialPageRoute(builder: (context) => HomeAdmin());
        return MaterialPageRoute(builder: (context) => Login());
      case '/homeAdmin':
        return MaterialPageRoute(builder: (context) => HomeAdmin());
      case '/home':
        return MaterialPageRoute(
            builder: (context) => Home(
                  data: args,
                ));
      case '/dasboard':
        return MaterialPageRoute(builder: (context) => DashboardEventos());
      case '/eventos':
        return MaterialPageRoute(
            builder: (context) => Invitados(
                  detalleEvento: args,
                ));

      case '/lectorQr':
        return MaterialPageRoute(builder: (context) => ScannerQrInvitado());
      case '/addInvitados':
        return MaterialPageRoute(
            builder: (context) => FullScreenDialogAdd(
                  id: args,
                ));
      case '/addContrato':
        return MaterialPageRoute(
            builder: (context) => FullScreenDialogAddContrato());
      case '/viewContrato':
        return MaterialPageRoute(
            builder: (context) => ViewPdfContrato(data: args));
      case '/addMachote':
        return MaterialPageRoute(
            builder: (context) => FullScreenDialogAddMachote(
                  dataMachote: args,
                ));
      case '/editPlantilla':
        return MaterialPageRoute(
            builder: (context) => FullScreenDialogEditPlantilla(
                  dataPlantilla: args,
                ));
      case '/addPlanners':
        return MaterialPageRoute(
            builder: (context) => FullScreenDialogAddPlanners());
      case '/addEvento':
        return MaterialPageRoute(
            builder: (context) => FullScreenDialogAddEvento(
                  prospecto: args,
                ));
      case '/editarEvento':
        return MaterialPageRoute(
            builder: (context) => FullScreenDialogEditEvento(
                  evento: args,
                ));
      case '/addActividadesTiming':
        return MaterialPageRoute(
            builder: (context) => FullScreenDialogAddActividades(
                  idTiming: args,
                ));
      case '/addContactos':
        return MaterialPageRoute(
            builder: (context) => FullScreenDialog(
                  id: args,
                ));
      case '/addContratoPdf':
        return MaterialPageRoute(
            builder: (context) => ViewPdfContrato(
                  data: args,
                ));
      case '/editInvitado':
        return MaterialPageRoute(
            builder: (context) => FullScreenDialogEdit(
                  idInvitado: args,
                ));
      case '/reporteEvento':
        return MaterialPageRoute(
            builder: (context) => FullScreenDialogReporte(
                  reporte: args,
                ));
      case '/crearUsuario':
        return MaterialPageRoute(
            builder: (context) => FullScreenDialogAddUsuario(datos: args));
      case '/editarUsuario':
        return MaterialPageRoute(
            builder: (context) => FullScreenDialogAddUsuario(datos: args));
      case '/crearRol':
        return MaterialPageRoute(
            builder: (context) => FullScreenDialogAddRol(datos: args));
      case '/editarRol':
        return MaterialPageRoute(
            builder: (context) => FullScreenDialogAddRol(datos: args));
      case '/eventoCalendario':
        return MaterialPageRoute(
            builder: (context) => TableEventsExample(
                  actividadesLista: args,
                ));
      case '/detalleListas':
        return MaterialPageRoute(
            builder: (context) =>
                FullScreenDialogDetalleListasEvent(lista: args));
      case '/agregarPlan':
        return MaterialPageRoute(
            builder: (context) => AgregarPlanes(lista: args));
      case '/calendarPlan':
        return MaterialPageRoute(
            builder: (context) => CalendarioPlan(actividadesLista: args));
      case '/agregarProveedores':
        return MaterialPageRoute(
            builder: (context) =>
                FullScreenDialogAgregarProveedorEvent(proveedor: args));
      case '/agregarArchivo':
        return MaterialPageRoute(
            builder: (context) =>
                FullScreenDialogAgregarArchivoProvServEvent(provsrv: args));
      case '/viewArchivo':
        return MaterialPageRoute(
            builder: (context) => FullScreenDialogViewFileEvent(archivo: args));
      case '/galeriaEvidencia':
        return MaterialPageRoute(
            builder: (context) => GaleriaEvidencia(
                  map: args,
                ));
      case '/perfil':
        return MaterialPageRoute(builder: (context) => Perfil());
      case '/addContratos':
        return MaterialPageRoute(builder: (context) => AddMachote(map: args));
      case '/addPagosForm':
        return MaterialPageRoute(builder: (context) => FormPago());
      case '/editPagosForm':
        return MaterialPageRoute(builder: (context) => FormEditPago(id: args));
      case '/verWeb':
        return MaterialPageRoute(
            builder: (context) => FullScreenViewWEB(data: args));
      case '/editarContratos':
        return MaterialPageRoute(
            builder: (context) => FullScreenDialogEditContrato(data: args));
      case '/asignarMesas':
        return MaterialPageRoute(
            builder: (context) => CrearMesasDialog(
                  lastnumMesas: args,
                ));
      case '/perfilPlanner':
        return MaterialPageRoute(builder: (context) => PerfilPlannerPage());
      case '/recoverPassword':
        final token = ruta.queryParameters['token'];
        return MaterialPageRoute(
            builder: (context) => RecoverPasswordPage(
                  token: token,
                ));
      case '/dashboardInvolucrado':
        return MaterialPageRoute(
            builder: (context) => DashboardInvolucradoPage(
                  detalleEvento: args,
                ));
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('ERROR'),
          centerTitle: true,
        ),
        body: Center(
          child: Text('La Página no funciona!'),
        ),
      );
    });
  }
}

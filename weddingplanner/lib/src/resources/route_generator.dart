import 'package:flutter/material.dart';
import 'package:weddingplanner/src/ui/LandingPage/landing.dart';
import 'package:weddingplanner/src/ui/contratos/contrato.dart';
import 'package:weddingplanner/src/ui/contratos/view_contrato_pdf.dart';
import 'package:weddingplanner/src/ui/eventos/dashboard_eventos.dart';
import 'package:weddingplanner/src/ui/home/home.dart';
import 'package:weddingplanner/src/ui/home/home_admin.dart';
import 'package:weddingplanner/src/ui/login/login.dart';
import 'package:weddingplanner/src/ui/scannerQr/scannerQr.dart';
import 'package:weddingplanner/src/ui/widgets/FullScreenDialog/full_screen_dialog_agregar_actividades.dart';
import 'package:weddingplanner/src/ui/widgets/FullScreenDialog/full_screen_dialog_agregar_contrato.dart';
import 'package:weddingplanner/src/ui/widgets/FullScreenDialog/full_screen_dialog_agregar_evento.dart';
import 'package:weddingplanner/src/ui/widgets/FullScreenDialog/full_screen_dialog_agregar_invitado.dart';
import 'package:weddingplanner/src/ui/widgets/FullScreenDialog/full_screen_dialog_agregar_machote.dart';
import 'package:weddingplanner/src/ui/widgets/FullScreenDialog/full_screen_dialog_agregar_planners.dart';
import 'package:weddingplanner/src/ui/widgets/FullScreenDialog/full_screen_dialog_agregar_rol.dart';
import 'package:weddingplanner/src/ui/widgets/FullScreenDialog/full_screen_dialog_agregar_usuario.dart';
import 'package:weddingplanner/src/ui/widgets/FullScreenDialog/full_screen_dialog_editar_evento.dart';
import 'package:weddingplanner/src/ui/widgets/FullScreenDialog/full_screen_dialog_editar_invitado.dart';
import 'package:weddingplanner/src/ui/widgets/FullScreenDialog/full_screen_dialog_editar_plantilla.dart';
import 'package:weddingplanner/src/ui/widgets/FullScreenDialog/full_screen_dialog_reporte_evento.dart';
import 'package:weddingplanner/src/ui/widgets/FullScreenDialog/full_screen_dialog_select_contacts.dart';
import 'package:weddingplanner/src/ui/widgets/invitados/invitados.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        //return MaterialPageRoute(builder: (context) => ScannerQrInvitado());
        //return MaterialPageRoute(builder: (context) => Landing());
        //return MaterialPageRoute(builder: (context) => HomeAdmin());
        return MaterialPageRoute(builder: (context) => Login());
      case '/homeAdmin':
        return MaterialPageRoute(builder: (context) => HomeAdmin());
      case '/home':
        return MaterialPageRoute(builder: (context) => Home());
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
            builder: (context) => ViewPdfContrato(
                  htmlPdf: args,
                ));
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
            builder: (context) => FullScreenDialogAddEvento());
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
                  htmlPdf: args,
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

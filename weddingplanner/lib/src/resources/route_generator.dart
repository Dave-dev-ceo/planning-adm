import 'package:flutter/material.dart';
import 'package:weddingplanner/src/ui/contratos/contrato.dart';
import 'package:weddingplanner/src/ui/contratos/view_contrato_pdf.dart';
import 'package:weddingplanner/src/ui/eventos/dashboard_eventos.dart';
import 'package:weddingplanner/src/ui/home/home.dart';
import 'package:weddingplanner/src/ui/home/home_admin.dart';
import 'package:weddingplanner/src/ui/login/login.dart';
import 'package:weddingplanner/src/ui/login/login2.dart';
import 'package:weddingplanner/src/ui/widgets/FullScreenDialog/full_screen_dialog_agregar_contrato.dart';
import 'package:weddingplanner/src/ui/widgets/FullScreenDialog/full_screen_dialog_agregar_invitado.dart';
import 'package:weddingplanner/src/ui/widgets/FullScreenDialog/full_screen_dialog_agregar_machote.dart';
import 'package:weddingplanner/src/ui/widgets/FullScreenDialog/full_screen_dialog_agregar_planners.dart';
import 'package:weddingplanner/src/ui/widgets/FullScreenDialog/full_screen_dialog_editar_invitado.dart';
import 'package:weddingplanner/src/ui/widgets/FullScreenDialog/full_screen_dialog_reporte_evento.dart';
import 'package:weddingplanner/src/ui/widgets/FullScreenDialog/full_screen_dialog_select_contacts.dart';
import 'package:weddingplanner/src/ui/widgets/invitados/invitados.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        //return MaterialPageRoute(builder: (context) => Contratos());
        //return MaterialPageRoute(builder: (context) => LoginT());
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
                  idEvento: args,
                ));
      case '/addInvitados':
        return MaterialPageRoute(
            builder: (context) => FullScreenDialogAdd(
                  id: args,
                ));
      case '/addContrato':
        return MaterialPageRoute(
            builder: (context) => FullScreenDialogAddContrato());
      case '/addMachote':
        return MaterialPageRoute(
            builder: (context) => FullScreenDialogAddMachote(
                  descripcionMachote: args,
                ));
      case '/addPlanners':
        return MaterialPageRoute(
            builder: (context) => FullScreenDialogAddPlanners());
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

import 'package:flutter/material.dart';
import 'package:weddingplanner/src/ui/eventos/dashboard_eventos.dart';
import 'package:weddingplanner/src/ui/home/home.dart';
import 'package:weddingplanner/src/ui/login/login.dart';
import 'package:weddingplanner/src/ui/widgets/FullScreenDialog/full_screen_dialog_agregar_invitado.dart';
import 'package:weddingplanner/src/ui/widgets/FullScreenDialog/full_screen_dialog_editar_invitado.dart';
import 'package:weddingplanner/src/ui/widgets/FullScreenDialog/full_screen_dialog_reporte_evento.dart';
import 'package:weddingplanner/src/ui/widgets/FullScreenDialog/full_screen_dialog_select_contacts.dart';
import 'package:weddingplanner/src/ui/widgets/invitados/invitados.dart';

class RouteGenerator{
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => Login());
      case '/home':
        return MaterialPageRoute(builder: (context) => Home(idPlanner: args,));
      case '/dasboard':
        return MaterialPageRoute(builder: (context) => DashboardEventos());
      case '/eventos':
        return MaterialPageRoute(builder: (context) => Invitados(idEvento: args,));
      case '/addInvitados':
        return MaterialPageRoute(builder: (context) => FullScreenDialogAdd(id: args,));
      case '/addContactos':
        return MaterialPageRoute(builder: (context) => FullScreenDialog(id: args,));  
      case '/editInvitado':
        return MaterialPageRoute(builder: (context) => FullScreenDialogEdit(idInvitado: args,));
      case '/reporteEvento':
        return MaterialPageRoute(builder: (context) => FullScreenDialogReporte(reporte: args,));  
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


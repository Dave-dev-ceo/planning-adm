import 'package:flutter/material.dart';
//import 'package:weddingplanner/src/models/item_model_parametros.dart';
//import 'package:weddingplanner/src/models/item_model_preferences.dart';
import 'package:weddingplanner/src/ui/Resumen/resumen_evento.dart';
import 'package:weddingplanner/src/ui/construccion/construccion.dart';
import 'package:weddingplanner/src/ui/contratos/contrato.dart';
//import 'package:weddingplanner/src/ui/widgets/invitados/agregar_invitado.dart';
import 'package:weddingplanner/src/ui/widgets/invitados/lista_invitados.dart';
import 'package:weddingplanner/src/ui/widgets/tab/tab_item.dart';
import 'package:weddingplanner/src/ui/asistencia/asistencia.dart';

class Invitados extends StatefulWidget {
  //static const routeName = '/eventos';
  final Map<dynamic, dynamic> detalleEvento;
  const Invitados({Key key, this.detalleEvento}) : super(key: key);

  @override
  _InvitadosState createState() => _InvitadosState(detalleEvento);
}

class _InvitadosState extends State<Invitados> {
  //SharedPreferencesT _sharedPreferences = new SharedPreferencesT();
  final Map<dynamic, dynamic> detalleEvento;
  int _pageIndex = 0;

  _InvitadosState(this.detalleEvento);
  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  /*@override
  void initState() async{
      super.initState();
      idEvento = await _sharedPreferences.getIdEvento();
  }*/

  @override
  Widget build(BuildContext context) {
    //final ScreenArguments param =  ModalRoute.of(context).settings.arguments;
    return DefaultTabController(
        length: 9,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            title: Center(
              child: FittedBox(
                  child: Image.asset(
                'assets/logo.png',
                height: 100.0,
                width: 250.0,
              )),
            ),
            toolbarHeight: 150.0,
            backgroundColor: hexToColor('#880B55'),
            bottom: TabBar(
              onTap: (int index) {
                setState(
                  () {
                    _pageIndex = index;
                  },
                );
              },
              indicatorColor: Colors.white,
              isScrollable: true,
              tabs: [
                TabItem(titulo: 'Resumen', icono: Icons.list),
                TabItem(titulo: 'Invitados', icono: Icons.people),
                TabItem(titulo: 'Timings', icono: Icons.access_time_sharp),
                TabItem(
                    titulo: 'Proveedores', icono: Icons.support_agent_outlined),
                TabItem(
                    titulo: 'Inventario',
                    icono: Icons.featured_play_list_outlined),
                TabItem(titulo: 'Presupuesto', icono: Icons.attach_money_sharp),
                TabItem(titulo: 'Autorizaciones', icono: Icons.lock_open),
                TabItem(titulo: 'Contratos', icono: Icons.description_outlined),
                TabItem(titulo: 'Asistencia', icono: Icons.accessibility),
              ],
            ),
          ),
          body: SafeArea(
            child: IndexedStack(
              index: _pageIndex,
              children: <Widget>[
                ResumenEvento(
                  detalleEvento: detalleEvento,
                ),
                ListaInvitados(
                  idEvento: detalleEvento['idEvento'],
                ),
                Construccion(),
                Construccion(),
                Construccion(),
                Construccion(),
                Construccion(),
                Contratos(),
                Asistencia()
              ],
            ),
          ),
        ));
  }
}

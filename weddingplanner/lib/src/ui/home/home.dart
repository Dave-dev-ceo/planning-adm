import 'package:flutter/material.dart';
import 'package:weddingplanner/src/ui/catalogos_planner/estatus_invitaciones_evento.dart';
import 'package:weddingplanner/src/ui/construccion/construccion.dart';
import 'package:weddingplanner/src/ui/eventos/dashboard_eventos.dart';
import 'package:weddingplanner/src/ui/machotes/machotes.dart';
import 'package:weddingplanner/src/ui/timings/timing.dart';
import 'package:weddingplanner/src/ui/usuarios/usuarios.dart';
import 'package:weddingplanner/src/ui/widgets/tab/tab_item.dart';

class Home extends StatefulWidget {
  //static const routeName = '/eventos';
  //final int idPlanner;
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //SharedPreferencesT _sharedPreferences = new SharedPreferencesT();
  //final int idPlanner;
  int _pageIndex = 0;

  //_HomeState(this.idPlanner);
  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  /*@override
  void initState() async{
      super.initState();
      idEvento = await _sharedPreferences.getIdEvento();
  }*/

  /**
   * Crea tab de menu
   * 
   * @Param titulo el titulo del tab
   * @param icono el icono a mostrar
   * 
   * @Returns widget tab con icono personalizado
   */
  _tabs(String titulo, IconData icono) {
    return Tab(
      icon: Icon(icono, size: 18),
      child: Text(
        titulo,
        style: TextStyle(fontSize: 12),
      ),
    );
  }

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
                TabItem(
                    titulo: 'Eventos', icono: Icons.calendar_today_outlined),
                TabItem(
                    titulo: 'Estatus de invitaciones',
                    icono: Icons.card_membership_rounded),
                TabItem(
                    titulo: 'Timing',
                    icono: Icons.hourglass_bottom_rounded),
                TabItem(
                    titulo: 'Tipos de eventos',
                    icono: Icons.event_note_outlined),
                TabItem(
                    titulo: 'Proveedores', icono: Icons.support_agent_outlined),
                TabItem(
                    titulo: 'Inventario',
                    icono: Icons.featured_play_list_outlined),
                TabItem(titulo: 'Presupuesto', icono: Icons.attach_money_sharp),
                TabItem(titulo: 'Plantillas', icono: Icons.copy),
                TabItem(titulo: 'Usuarios', icono: Icons.people),
              ],
            ),
          ),
          body: SafeArea(
            child: IndexedStack(
              index: _pageIndex,
              children: <Widget>[
                DashboardEventos(),
                ListaEstatusInvitaciones(),
                Timing(),
                Construccion(),
                Construccion(),
                Construccion(),
                Construccion(),
                Machotes(),
                Usuarios()
              ],
            ),
          ),
        ));
  }
}

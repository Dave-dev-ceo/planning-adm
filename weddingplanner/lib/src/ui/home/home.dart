import 'package:flutter/material.dart';
import 'package:weddingplanner/src/ui/catalogos_planner/estatus_invitaciones_evento.dart';
import 'package:weddingplanner/src/ui/eventos/dashboard_eventos.dart';

class Home extends StatefulWidget {
  //static const routeName = '/eventos';
  final int idPlanner;
  const Home({Key key, this.idPlanner}) : super(key: key);

  @override
  _HomeState createState() => _HomeState(idPlanner);
}

class _HomeState extends State<Home> {
    //SharedPreferencesT _sharedPreferences = new SharedPreferencesT();
    final int idPlanner;
    int _pageIndex = 0;

  _HomeState(this.idPlanner);
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
        length: 7,
        child: Scaffold(
      appBar: AppBar(
            automaticallyImplyLeading: true,
            title: Center(child: FittedBox(child: Image.asset('assets/logo.png',height: 100.0,width: 250.0,)),),
            toolbarHeight: 150.0,
            backgroundColor: hexToColor('#880B55'),
            bottom: TabBar(
              onTap: (int index){
                setState(
                  () {
                    _pageIndex = index;
                  },);
                },
              indicatorColor: Colors.white,
              isScrollable: true,
              tabs: [
              Tab(
                icon: Icon(Icons.calendar_today_outlined),
                //text: 'Resumen',
                child: Text('Eventos', style: TextStyle(fontSize: 17),),
              ),
              Tab(
                icon: Icon(Icons.card_membership_rounded),
                //text: 'Home',
                child: Text('Estatus de invitaciones', style: TextStyle(fontSize: 17),),
              ),
              Tab(
                icon: Icon(Icons.event_note_outlined),
                //text: 'Timings',
                child: Text('Tipos de eventos', style: TextStyle(fontSize: 17),),
              ),
                Tab(
                icon: Icon(Icons.support_agent_outlined),
                //text: 'Proveedores',
                child: Text('Proveedores', style: TextStyle(fontSize: 17),),
              ),
              Tab(
                icon: Icon(Icons.featured_play_list_outlined),
                //text: 'Inventario',
                child: Text('Inventario', style: TextStyle(fontSize: 17),),
              ),
              Tab(
                icon: Icon(Icons.attach_money_sharp),
                //text: 'Presupuesto',
                child: Text('Presupuesto', style: TextStyle(fontSize: 17),),
              ),
              Tab(
                icon: Icon(Icons.lock_open),
                //text: 'Autorizaciones',
                child: Text('Autorizaciones', style: TextStyle(fontSize: 17),),
              ),
            ],
            ),
          ),
      body: SafeArea(
        child: IndexedStack(
          index: _pageIndex,
          children: <Widget>[
            DashboardEventos(),
            ListaEstatusInvitaciones(idPlanner: idPlanner,)
          ],
        ),
      ),
    )
  );

  }
}
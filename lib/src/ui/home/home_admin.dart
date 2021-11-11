import 'package:flutter/material.dart';
import 'package:planning/src/ui/administrador/planners.dart';
import 'package:planning/src/ui/construccion/construccion.dart';

class HomeAdmin extends StatefulWidget {
  //static const routeName = '/eventos';
  // final int idPlanner;
  const HomeAdmin({
    Key key,
  }) : super(key: key);

  @override
  _HomeAdminState createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  int _pageIndex = 0;
  //SharedPreferencesT _sharedPreferences = new SharedPreferencesT();

//  _HomeAdminState(this.idPlanner);
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
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            title: Center(
              child: FittedBox(
                  child: Image.asset(
                'assets/new_logo.png',
                height: 100.0,
                width: 250.0,
              )),
            ),
            toolbarHeight: 150.0,
            backgroundColor: hexToColor('#fdf4e5'),
            bottom: TabBar(
              onTap: (int index) {
                setState(
                  () {
                    _pageIndex = index;
                  },
                );
              },
              indicatorColor: Colors.black,
              isScrollable: true,
              tabs: [
                Tab(
                  icon: Icon(Icons.calendar_today_outlined),
                  //text: 'Resumen',
                  child: Text(
                    'Planners',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
                Tab(
                  icon: Icon(Icons.card_membership_rounded),
                  //text: 'HomeAdmin',
                  child: Text(
                    'Planes',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
                Tab(
                  icon: Icon(Icons.event_note_outlined),
                  //text: 'Timings',
                  child: Text(
                    'Proveedores',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
                /*Tab(
                icon: Icon(Icons.support_agent_outlined),
                //text: 'Proveedores',
                child: Text('Tipo de proveedores', style: TextStyle(fontSize: 17),),
              ),
              Tab(
                icon: Icon(Icons.featured_play_list_outlined),
                //text: 'Inventario',
                child: Text('Proveedores', style: TextStyle(fontSize: 17),),
              ),*/
              ],
            ),
          ),
          body: SafeArea(
            child: IndexedStack(
              index: _pageIndex,
              children: <Widget>[
                Planners(),
                Construccion(),
                Construccion()
                //DashboardEventos(),
                //ListaEstatusInvitaciones(idPlanner: idPlanne,)
              ],
            ),
          ),
        ));
  }
}

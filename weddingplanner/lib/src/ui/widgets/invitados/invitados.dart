import 'package:flutter/material.dart';
//import 'package:weddingplanner/src/models/item_model_parametros.dart';
//import 'package:weddingplanner/src/models/item_model_preferences.dart';
import 'package:weddingplanner/src/ui/Resumen/resumen_evento.dart';
import 'package:weddingplanner/src/ui/contratos/contrato.dart';
//import 'package:weddingplanner/src/ui/widgets/invitados/agregar_invitado.dart';
import 'package:weddingplanner/src/ui/widgets/invitados/lista_invitados.dart';

class Invitados extends StatefulWidget {
  //static const routeName = '/eventos';
  final int idEvento;
  const Invitados({Key key, this.idEvento}) : super(key: key);

  @override
  _InvitadosState createState() => _InvitadosState(idEvento);
}

class _InvitadosState extends State<Invitados> {
    //SharedPreferencesT _sharedPreferences = new SharedPreferencesT();
    final int idEvento;
    int _pageIndex = 0;

  _InvitadosState(this.idEvento);
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
        length: 8,
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
                icon: Icon(Icons.list),
                //text: 'Resumen',
                child: Text('Resumen', style: TextStyle(fontSize: 17),),
              ),
              Tab(
                icon: Icon(Icons.people),
                //text: 'Invitados',
                child: Text('Invitados', style: TextStyle(fontSize: 17),),
              ),
              Tab(
                icon: Icon(Icons.access_time_sharp),
                //text: 'Timings',
                child: Text('Timings', style: TextStyle(fontSize: 17),),
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
              Tab(
                icon: Icon(Icons.description_outlined),
                //text: 'Autorizaciones',
                child: Text('Contratos', style: TextStyle(fontSize: 17),),
              ),
            ],
            ),
          ),
      body: SafeArea(
        child: IndexedStack(
          index: _pageIndex,
          children: <Widget>[
            ResumenEvento(idEvento: idEvento,),
            ListaInvitados(idEvento: idEvento,),
            ResumenEvento(idEvento: idEvento,),
            ResumenEvento(idEvento: idEvento,),
            ResumenEvento(idEvento: idEvento,),
            ResumenEvento(idEvento: idEvento,),
            ResumenEvento(idEvento: idEvento,),
            Contratos(),
          ],
        ),
      ),
    )
  );

  }
}
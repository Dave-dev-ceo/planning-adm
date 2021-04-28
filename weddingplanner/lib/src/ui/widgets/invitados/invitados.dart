import 'package:flutter/material.dart';
import 'package:weddingplanner/src/ui/Resumen/resumen_evento.dart';
import 'package:weddingplanner/src/ui/widgets/invitados/agregar_invitado.dart';
import 'package:weddingplanner/src/ui/widgets/invitados/lista_invitados.dart';

class Invitados extends StatefulWidget {
  const Invitados({Key key}) : super(key: key);

  @override
  _InvitadosState createState() => _InvitadosState();
}

class _InvitadosState extends State<Invitados> {
    int _pageIndex = 0;
      
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 7,
        child: Scaffold(
      appBar: AppBar(
            //title: Text('Scrollable Tabs'),
            
            automaticallyImplyLeading: false,
            backgroundColor: Color(0xff5808e5),
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
            ],
            ),
          ),
      body: SafeArea(
        child: IndexedStack(
          index: _pageIndex,
          children: <Widget>[
            ResumenEvento(id: 1,),
            ListaInvitados(id: 1,),
            //AgregarInvitados(),
            //ListaInvitados(),
            //ListaInvitados(),
            //ListaInvitados(),
          ],
        ),
      ),
    )
  );

  }
}
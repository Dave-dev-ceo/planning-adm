import 'package:flutter/material.dart';
import 'package:weddingplanner/src/blocs/eventos_bloc.dart';
import 'package:weddingplanner/src/models/item_model_eventos.dart';
import 'package:weddingplanner/src/models/item_model_parametros.dart';


class DashboardEventos extends StatefulWidget {
  static const routeName = '/';
  @override
  _DashboardEventosState createState() => _DashboardEventosState();
}

class _DashboardEventosState extends State<DashboardEventos> {
  listaEventos(){
    bloc.fetchAllEventos();
    return StreamBuilder(
            stream: bloc.allEventos,
            builder: (context, AsyncSnapshot<ItemModelEventos> snapshot) {
              if (snapshot.hasData) {
                return buildList(snapshot);
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return Center(child: CircularProgressIndicator());
            },
          );
  }
  String titulo="";
  Widget buildList(AsyncSnapshot<ItemModelEventos> snapshot) {
    return GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 400,
                mainAxisExtent: 200,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
            itemCount: snapshot.data.results.length,
            itemBuilder: (BuildContext ctx, index) {
              return miCard(
                snapshot.data.results.elementAt(index).idEvento,
                snapshot.data.results.elementAt(index).tipoEvento,
                snapshot.data.results.elementAt(index).fechaInicio ,
                 snapshot.data.results.elementAt(index).fechaFin,
                 snapshot.data.results.elementAt(index).involucrados);
            });
    /*return ListView.builder(
        itemCount: snapshot.data.results.length,
        padding: const EdgeInsets.only(top: 10),
        itemBuilder: (_,int index){
          titulo = snapshot.data.results.elementAt(index).tipoEvento;
          
          return miCard(titulo,snapshot.data.results.elementAt(index).fechaInicio,snapshot.data.results.elementAt(index).fechaFin);
        }
      );*/
  }
  Widget buildList2() {
    return ListView.builder(
        itemCount: 3,
        //padding: const EdgeInsets.only(top: 10),
        itemBuilder: (_,int index){
          titulo = 'boda';
          return Text('data');
          //miCard(titulo);
        }
      );
  }
  miCard(int idEvento,String titulo,String inicio,String fin, List involucrados) {
    return GestureDetector(
          child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(20),
        elevation: 10,
        child: Column(
          children: <Widget>[
            ListTile(
              contentPadding: EdgeInsets.fromLTRB(15, 10, 25, 0),
              title: Text(titulo),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Fecha Inicio: ' + inicio),
                  Text('Fecha Fin: ' + fin),
                  for (var i = 0; i < involucrados.length; i++) Text(involucrados[i].tipoInvolucrado + ' : ' + involucrados[i].nombre),
                ],
              ),
              leading: Icon(Icons.event),
            ),
            /*Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(onPressed:() => {} , child: Text('Aceptar')),
                FlatButton(onPressed: () => {}, child: Text('Cancelar'))
              ],
            )*/
          ],
        ),
      ),
      onTap: (){Navigator.pushNamed(context, '/eventos',arguments: ScreenArguments(idEvento));},
    );
  }
  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
          appBar: AppBar(backgroundColor: Colors.blue,),
          body:  
            Container(
              child:               
                listaEventos(),
           ),
    );
  }
}
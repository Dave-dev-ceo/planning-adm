import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:weddingplanner/src/blocs/invitados_bloc.dart';
import 'package:weddingplanner/src/models/item_model_reporte_genero.dart';
import 'package:weddingplanner/src/models/item_model_reporte_invitados.dart';

class ResumenEvento extends StatefulWidget {
  final int id;

  const ResumenEvento({Key key, this.id}) : super(key: key);
  @override
  _ResumenEventoState createState() => _ResumenEventoState(id);
}

class _ResumenEventoState extends State<ResumenEvento> {
  final int id;

  _ResumenEventoState(this.id);
  reporteInvitados(){
    bloc.fetchAllReporteInvitados(id);
    return StreamBuilder(
            stream: bloc.reporteInvitados,
            builder: (context, AsyncSnapshot<ItemModelReporteInvitados> snapshot) {
              if (snapshot.hasData) {
                return buildList(snapshot);
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return Center(child: CircularProgressIndicator());
            },
          );
  }

  Widget buildList(AsyncSnapshot<ItemModelReporteInvitados> snapshot) {
    return Container( 
      width: 400,
      height: 150,
      child:  miCardReportesInvitados(snapshot.data.confirmados, snapshot.data.sinConfirmar, snapshot.data.noAsistira)
    );
  }
  miCardReportesInvitados(String confirmados, String sinConfirmar, String noAsistira) {
    return GestureDetector(
          child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(20),
        elevation: 10,
        child: Column(
          children: <Widget>[
            ListTile(
              contentPadding: EdgeInsets.fromLTRB(15, 10, 25, 0),
              title: Text('Asistencia invitados',style: TextStyle(fontSize: 20),),
              subtitle: Wrap(
                spacing: 10,
                runSpacing: 7,
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Confirmados: ' + confirmados, style: TextStyle(fontSize: 15),),
                  Text('Sin confirmar: ' + sinConfirmar, style: TextStyle(fontSize: 15),),
                  Text('No asistiran: ' + noAsistira, style: TextStyle(fontSize: 15),),
                ],
              ),
              leading: Icon(Icons.event),
            ),
          ],
        ),
      ),
      onTap: (){},
    );
  }
  reporteInvitadosGenero(){
  bloc.fetchAllReporteInvitadosGenero(id);
  return StreamBuilder(
          stream: bloc.reporteInvitadosGenero,
          builder: (context, AsyncSnapshot<ItemModelReporteInvitadosGenero> snapshot) {
            if (snapshot.hasData) {
              return buildListGenero(snapshot);
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Center(child: CircularProgressIndicator());
          },
        );
  }
  Widget buildListGenero(AsyncSnapshot<ItemModelReporteInvitadosGenero> snapshot) {
    return Container( 
      width: 400,
      height: 150,
      child:  miCardReportesInvitadosGenero(snapshot.data.masculino, snapshot.data.femenino)
    );
  }
  miCardReportesInvitadosGenero(String hombre, String mujer) {
    return GestureDetector(
          child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(20),
        elevation: 10,
        child: Column(
          children: <Widget>[
            ListTile(
              contentPadding: EdgeInsets.fromLTRB(15, 10, 25, 0),
              title: Text('Reporte de genero',style: TextStyle(fontSize: 20),),
              subtitle: Wrap(
                spacing: 10,
                runSpacing: 7,
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Masculino: ' + hombre, style: TextStyle(fontSize: 15),),
                  Text('Femenino: ' + mujer, style: TextStyle(fontSize: 15),),
                ],
              ),
              leading: Icon(Icons.event),
            ),
          ],
        ),
      ),
      onTap: (){},
    );
  }
  @override
  Widget build(BuildContext context) {
    return 
           SingleChildScrollView(
                        child: Column(
               children: <Widget>[
                 
                 Center(
                    child: Wrap(
                     spacing: 10.0,
                     runSpacing: 20.0,
                     children: [
                       //Expanded(
                         //child: 
                         reporteInvitados(),
                         reporteInvitadosGenero(),
                         reporteInvitados(),
                        //),
                     ],
                     ),
                 )
               ],
             ),
           );
  }
}
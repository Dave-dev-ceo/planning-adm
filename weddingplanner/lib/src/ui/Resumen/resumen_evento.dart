import 'package:flutter/material.dart';

import 'package:weddingplanner/src/blocs/blocs.dart';

import 'package:weddingplanner/src/models/item_model_reporte_genero.dart';
import 'package:weddingplanner/src/models/item_model_reporte_grupos.dart';
import 'package:weddingplanner/src/models/item_model_reporte_invitados.dart';

class ResumenEvento extends StatefulWidget {
  final Map<dynamic, dynamic> detalleEvento;

  const ResumenEvento({Key key, this.detalleEvento}) : super(key: key);
  @override
  _ResumenEventoState createState() => _ResumenEventoState(detalleEvento);
}

class _ResumenEventoState extends State<ResumenEvento> {
  final Map<dynamic, dynamic> detalleEvento;

  @override
  void initState() {
    super.initState();
  }

  _ResumenEventoState(this.detalleEvento);
  reporteGrupos() {
    blocInvitados.fetchAllReporteGrupos(context);
    return StreamBuilder(
      stream: blocInvitados.reporteGrupos,
      builder: (context, AsyncSnapshot<ItemModelReporteGrupos> snapshot) {
        if (snapshot.hasData) {
          return buildListGrupos(snapshot);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget buildListGrupos(AsyncSnapshot<ItemModelReporteGrupos> snapshot) {
    double sizeHeight = 150;
    return Container(
        width: 400,
        //color: Colors.pink,
        height: sizeHeight,
        child: miCardReportesGrupos(snapshot.data));
  }

  miCardReportesGrupos(ItemModelReporteGrupos dataGrupos) {
    return GestureDetector(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(20),
        elevation: 10,
        child: Column(
          children: <Widget>[
            ListTile(
              contentPadding: EdgeInsets.fromLTRB(15, 10, 25, 0),
              title: Text(
                'Relación',
                style: TextStyle(fontSize: 20),
              ),
              subtitle: Container(
                height: 55,
                //color: Colors.purple,
                child: ListView.builder(
                    itemCount: dataGrupos.results.length,
                    itemBuilder: (_, int index) {
                      return Text(dataGrupos.results.elementAt(index).grupo + ': ' + dataGrupos.results.elementAt(index).cantidad.toString());
                    }),
              ),
              leading: Icon(Icons.event),
            ),
          ],
        ),
      ),
      onTap: () {},
    );
  }

  reporteInvitados() {
    blocInvitados.fetchAllReporteInvitados(context);
    return StreamBuilder(
      stream: blocInvitados.reporteInvitados,
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
    double sizeHeight = 150;
    return Container(
        width: 400,
        //color: Colors.pink,
        height: sizeHeight,
        child: miCardReportesInvitados(snapshot.data));
  }

  miCardReportesInvitados(ItemModelReporteInvitados reporte) {
    return GestureDetector(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(20),
        elevation: 10,
        child: Column(
          children: <Widget>[
            ListTile(
              contentPadding: EdgeInsets.fromLTRB(15, 10, 25, 0),
              title: Text(
                'Asistencia',
                style: TextStyle(fontSize: 20),
              ),
              subtitle: Container(
                height: 55,
                //color: Colors.purple,
                child: ListView.builder(
                    itemCount: reporte.results.length,
                    itemBuilder: (_, int index) {
                      return Text(reporte.results.elementAt(index).estatus + ': ' + reporte.results.elementAt(index).cantidad.toString());
                    }),
              ),
              leading: Icon(Icons.event),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context).pushNamed('/reporteEvento', arguments: "asistencia");
      },
    );
  }

  reporteInvitadosGenero() {
    blocInvitados.fetchAllReporteInvitadosGenero(context);
    return StreamBuilder(
      stream: blocInvitados.reporteInvitadosGenero,
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
    return Container(width: 400, height: 150, child: miCardReportesInvitadosGenero(snapshot.data.masculino, snapshot.data.femenino));
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
              title: Text(
                'Genero',
                style: TextStyle(fontSize: 20),
              ),
              subtitle: Wrap(
                spacing: 10,
                runSpacing: 7,
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Masculino: ' + hombre,
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    'Femenino: ' + mujer,
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
              leading: Icon(Icons.event),
            ),
          ],
        ),
      ),
      onTap: () {},
    );
  }

  Widget reporteEvento() {
    return Container(width: 400, height: 150, child: miCardReporteDetallesEvento());
  }

  miCardReporteDetallesEvento() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(20),
      elevation: 10,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 3, vertical: 1),
              title: Text(
                'Detalles del evento',
                style: TextStyle(fontSize: 16),
              ),
              subtitle: Wrap(
                spacing: 5,
                runSpacing: 5,
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Evento: ' + detalleEvento['titulo'],
                    style: TextStyle(fontSize: 13),
                  ),
                  Text(
                    'Fecha inicio: ' + detalleEvento['inicio'],
                    style: TextStyle(fontSize: 11),
                  ),
                  Text(
                    'Fecha fin: ' + detalleEvento['fin'],
                    style: TextStyle(fontSize: 11),
                  ),
                  Text(
                    'Fecha evento: ' + detalleEvento['fevento'],
                    style: TextStyle(fontSize: 11),
                  ),
                  for (var item in detalleEvento['involucrados'])
                    Text(
                      item.tipoInvolucrado + ': ' + item.nombre,
                      style: TextStyle(fontSize: 12),
                    ),
                ],
              ),
              leading: Icon(Icons.event),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Center(
            child: Wrap(
              spacing: 10.0,
              runSpacing: 20.0,
              children: [
                //Expanded(
                //child:
                reporteEvento(),
                reporteInvitados(),
                reporteInvitadosGenero(),
                reporteGrupos(),
                //),
              ],
            ),
          )
        ],
      ),
    );
  }
}

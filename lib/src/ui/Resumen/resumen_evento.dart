import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:planning/src/blocs/blocs.dart';
import 'package:planning/src/blocs/eventos/eventos_bloc.dart' as EvtBloc;
import 'package:planning/src/models/item_model_evento.dart';

import 'package:planning/src/models/item_model_reporte_genero.dart';
import 'package:planning/src/models/item_model_reporte_grupos.dart';
import 'package:planning/src/models/item_model_reporte_invitados.dart';

class ResumenEvento extends StatefulWidget {
  final Map<dynamic, dynamic> detalleEvento;
  final bool WP_EVT_RES_EDT;

  const ResumenEvento({Key key, this.detalleEvento, this.WP_EVT_RES_EDT})
      : super(key: key);
  @override
  _ResumenEventoState createState() =>
      _ResumenEventoState(detalleEvento, WP_EVT_RES_EDT);
}

class _ResumenEventoState extends State<ResumenEvento> {
  final Map<dynamic, dynamic> detalleEvento;
  final bool WP_EVT_RES_EDT;
  EvtBloc.EventosBloc eventosBloc;

  @override
  void initState() {
    eventosBloc = BlocProvider.of<EvtBloc.EventosBloc>(context);
    eventosBloc.add(
        EvtBloc.FetchEventoPorIdEvent(detalleEvento['idEvento'].toString()));
    super.initState();
  }

  _ResumenEventoState(this.detalleEvento, this.WP_EVT_RES_EDT);
  reporteGrupos() {
    blocInvitados.fetchAllReporteGrupos(context);
    return StreamBuilder(
      stream: blocInvitados.reporteGrupos,
      builder: (context, AsyncSnapshot<ItemModelReporteGrupos> snapshot) {
        if (snapshot.hasData) {
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(child: CircularProgressIndicator());
      },
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
    double sizeHeight = 200;
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
                height: 70,
                //color: Colors.purple,
                child: ListView.builder(
                    itemCount: reporte.results.length,
                    itemBuilder: (_, int index) {
                      return Text(reporte.results.elementAt(index).estatus +
                          ': ' +
                          reporte.results.elementAt(index).cantidad.toString());
                    }),
              ),
              leading: Icon(Icons.event),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context)
            .pushNamed('/reporteEvento', arguments: "asistencia");
      },
    );
  }

  ItemModelEvento evento;

  Widget reporteEvento() {
    return BlocBuilder<EvtBloc.EventosBloc, EvtBloc.EventosState>(
      builder: (context, state) {
        //print(state);
        if (state is EvtBloc.LoadingEventoPorIdState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is EvtBloc.MostrarEventoPorIdState) {
          evento = state.evento;
          eventosBloc.add(EvtBloc.FechtEventosEvent());
          return Container(
              width: 400,
              height: 200,
              child: miCardReporteDetallesEvento(evento));
        } else if (state is EvtBloc.ErrorEventoPorIdState) {
          return Center(
            child: Text(state.message),
          );
        } else {
          if (evento != null) {
            return Container(
                width: 400,
                height: 200,
                child: miCardReporteDetallesEvento(evento));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }
      },
    );
  }

  miCardReporteDetallesEvento(ItemModelEvento evtt) {
    return GestureDetector(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(20),
        elevation: 10,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: <Widget>[
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 3, vertical: 1),
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
                        'Evento: ' + evtt.results.elementAt(0).evento,
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Fecha evento: ' +
                            evtt.results.elementAt(0).fechaEvento,
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        'Planeación: Del ' +
                            evtt.results.elementAt(0).fechaInicio +
                            ' al ' +
                            evtt.results.elementAt(0).fechaFin,
                        style: TextStyle(fontSize: 12),
                      ),
                      for (var inv in evtt.results.elementAt(0).involucrados)
                        mostrarInvolucrado(inv),
                    ],
                  ),
                  leading: Icon(Icons.event),
                ),
              ],
            ),
          ),
        ),
      ),
      onTap: WP_EVT_RES_EDT
          ? () async {
              await Navigator.pushNamed(context, '/editarEvento',
                  arguments: {'evento': evtt});
            }
          : null,
    );
  }

  mostrarInvolucrado(dynamic involucrado) {
    if (involucrado.nombre == 'Sin nombre') {
      return Text('Sin involucrados', style: TextStyle(fontSize: 12));
    } else {
      return Text(
        involucrado.tipoInvolucrado + ': ' + involucrado.nombre,
        style: TextStyle(fontSize: 12),
      );
    }
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

                //),
              ],
            ),
          )
        ],
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:planning/src/blocs/blocs.dart';
import 'package:planning/src/blocs/eventos/eventos_bloc.dart' as EvtBloc;
import 'package:planning/src/blocs/planes/planes_bloc.dart';
import 'package:planning/src/logic/eventos_logic.dart';
import 'package:planning/src/logic/planes_logic.dart';
import 'package:planning/src/models/Planes/planes_model.dart';
import 'package:planning/src/models/item_model_evento.dart';

import 'package:planning/src/models/item_model_reporte_genero.dart';
import 'package:planning/src/models/item_model_reporte_grupos.dart';
import 'package:planning/src/models/item_model_reporte_invitados.dart';
import 'package:planning/src/utils/utils.dart';

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
  FetchListaEventosLogic eventoLogic = FetchListaEventosLogic();
  ActividadesEvento _planesLogic = ActividadesEvento();

  Timer _timer;

  @override
  void initState() {
    eventosBloc = BlocProvider.of<EvtBloc.EventosBloc>(context);
    eventosBloc.add(
        EvtBloc.FetchEventoPorIdEvent(detalleEvento['idEvento'].toString()));
    _planesLogic.getAllPlannes();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // _timer.cancel();
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

  ItemModelEvento eventoFecha;

  Widget fechaData() {
    return BlocBuilder<EvtBloc.EventosBloc, EvtBloc.EventosState>(
      builder: (context, state) {
        if (state is EvtBloc.LoadingEventoPorIdState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is EvtBloc.MostrarEventoPorIdState) {
          eventoFecha = state.evento;
          eventosBloc.add(EvtBloc.FechtEventosEvent());
          return Container(
              width: 400, height: 200, child: miCardContadorFecha(eventoFecha));
        } else if (state is EvtBloc.ErrorEventoPorIdState) {
          return Center(
            child: Text(state.message),
          );
        } else {
          if (eventoFecha != null) {
            return Container(
                width: 400,
                height: 200,
                child: miCardContadorFecha(eventoFecha));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }
      },
    );
  }

  miCardContadorFecha(ItemModelEvento evento) {
    String fechaEvento = evento.results.elementAt(0).fechaEvento;

    bool isActive = false;

    Duration fechaEventoTime =
        DateTime.now().difference(DateTime.parse(fechaEvento));

    // if (fechaEventoTime.inSeconds.isNegative) {
    //   isActive = true;
    //   if (mounted) {
    //     _timer = Timer(Duration(seconds: 1), () {
    //       if (mounted) {
    //         setState(() {
    //           fechaEventoTime =
    //               DateTime.parse(fechaEvento).difference(DateTime.now());
    //         });
    //       }
    //     });
    //   } else {
    //     _timer.cancel();
    //   }
    // }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: EdgeInsets.all(20.0),
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          leading: Icon(Icons.access_time_filled_outlined),
          title: Column(
            children: [
              Text(
                'Fecha restante:',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              RichText(
                  text: TextSpan(
                style: TextStyle(fontSize: 18.0, color: Colors.black),
                text: isActive
                    ? '${_printDuration(fechaEventoTime)}'
                    : 'El evento ya finalizo',
              )),
            ],
          ),
        ),
      ),
    );
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitHours = twoDigits(duration.inHours.remainder(24) * -1);
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60) * -1);
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60) * -1);
    return "Dias: ${duration.inDays * -1}, Horas: $twoDigitHours, Minutos: $twoDigitMinutes, Segundos: $twoDigitSeconds";
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

  Widget futureToPlannes() {
    return StreamBuilder(
      stream: _planesLogic.actividadesStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<PlannesModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: 500,
            height: 300,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              margin: EdgeInsets.all(20.0),
              elevation: 10.0,
              child: Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else {
          if (snapshot.hasData) {
            return miCardActividades(snapshot.data);
          } else {
            return Container(
              width: 500,
              height: 300,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                margin: EdgeInsets.all(20.0),
                elevation: 10.0,
                child: SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Center(
                            child: Text('No se encontraron actividades')))),
              ),
            );
          }
        }
      },
    );
  }

  Widget miCardActividades(List<PlannesModel> planes) {
    List<Widget> actividadeCompletas = [];
    List<Widget> actividadesAtrasadas = [];
    List<Widget> actividadesPedientes = [];

    int completadas = 0;
    int total = 0;

    for (var plan in planes) {
      Widget planWidget = ListTile(
        title: Text(
          '${plan.nombreActividad}',
          style: TextStyle(fontSize: 15.0),
        ),
        subtitle: Text(
          '${plan.descripcionActividad}',
          style: TextStyle(fontSize: 12.0),
        ),
      );

      if (plan.estatus == 'Completada') {
        total++;

        if (plan.estatusProgreso) {
          completadas++;
        }
        actividadeCompletas.add(planWidget);
      } else if (plan.estatus == 'Pendiente') {
        actividadesPedientes.add(planWidget);
      } else {
        actividadesAtrasadas.add(planWidget);
      }
    }

    return Container(
      width: 500,
      height: 300,
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        margin: EdgeInsets.all(20.0),
        elevation: 10.0,
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: [
              ExpansionTile(
                textColor: Colors.black,
                subtitle: Text('Progreso: $completadas/$total'),
                title: Text('Actividades completadas'),
                children: actividadeCompletas,
              ),
              ExpansionTile(
                textColor: Colors.black,
                title: Text('Actividades pedientes'),
                children: actividadesPedientes,
              ),
              ExpansionTile(
                textColor: Colors.black,
                title: Text('Actividades atrasadas'),
                children: actividadesAtrasadas,
              ),
            ],
          ),
        )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        color: Colors.blue,
        onRefresh: () async {
          await eventosBloc.add(EvtBloc.FetchEventoPorIdEvent(
              detalleEvento['idEvento'].toString()));
          await _planesLogic.getAllPlannes();
          await blocInvitados.fetchAllReporteGrupos(context);
          await blocInvitados.fetchAllReporteInvitados(context);
        },
        child: SingleChildScrollView(
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
                    futureToPlannes(),
                    fechaData(),
                    //),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.download),
        onPressed: () async {
          final data = await eventoLogic.donwloadPDFEvento();

          if (data != null) {
            downloadFile(data, 'Resumen_Evento');
          }
        },
        tooltip: 'Descargar PDF',
      ),
    );
  }
}

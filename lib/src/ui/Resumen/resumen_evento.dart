// ignore_for_file: non_constant_identifier_names, no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'package:planning/src/blocs/blocs.dart';
import 'package:planning/src/blocs/eventos/eventos_bloc.dart' as evt_bloc;
import 'package:planning/src/logic/add_contratos_logic.dart';
import 'package:planning/src/logic/eventos_logic.dart';
import 'package:planning/src/logic/pagos_logic.dart';
import 'package:planning/src/logic/planes_logic.dart';
import 'package:planning/src/models/Planes/planes_model.dart';
import 'package:planning/src/models/item_model_evento.dart';
import 'package:planning/src/models/item_model_preferences.dart';

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
  evt_bloc.EventosBloc eventosBloc;
  FetchListaEventosLogic eventoLogic = FetchListaEventosLogic();
  final ActividadesEvento _planesLogic = ActividadesEvento();

  bool isInvolucrado = false;
  ConsultasAddContratosLogic documentosLogic = ConsultasAddContratosLogic();
  ConsultasAddContratosLogic contratosLogic = ConsultasAddContratosLogic();
  ConsultasPagosLogic pagosLogic = ConsultasPagosLogic();
  NumberFormat f = NumberFormat("#,##0", "en_US");

  @override
  void initState() {
    eventosBloc = BlocProvider.of<evt_bloc.EventosBloc>(context);
    eventosBloc.add(
        evt_bloc.FetchEventoPorIdEvent(detalleEvento['idEvento'].toString()));
    _checkIsInvolucrado();

    super.initState();
  }

  _checkIsInvolucrado() async {
    int idInvolucrado = await SharedPreferencesT().getIdInvolucrado();

    if (idInvolucrado != null) {
      setState(() {
        isInvolucrado = true;
      });
    }
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
        return const Center(child: LoadingCustom());
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
        return const Center(child: LoadingCustom());
      },
    );
  }

  Widget resumenMinuta() {
    return SizedBox(
      width: 350,
      height: 150,
      child: Card(
        color: const Color(0xFFfdf4e5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10),
        elevation: 6,
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: FutureBuilder(
              future: documentosLogic.obtenerUltimoDocumento(),
              builder: (BuildContext context,
                  AsyncSnapshot<Map<String, dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: LoadingCustom());
                } else if (snapshot.hasData) {
                  if (snapshot.data != null) {
                    Map<String, dynamic> documento = snapshot.data;
                    return ListTile(
                      trailing: const FaIcon(FontAwesomeIcons.book),
                      onTap: null,
                      title: const Text(
                        'Documento',
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                documento['descripcion'],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(.0),
                            child: GestureDetector(
                              onTap: () async {
                                if (documento['tipodoc'] == 'html') {
                                  String file = await contratosLogic
                                      .fetchContratosPdf({
                                    'id_contrato':
                                        documento['iddocumento'].toString()
                                  });
                                  Navigator.pushNamed(context, '/viewContrato',
                                      arguments: {
                                        'htmlPdf': file,
                                        'tipo_mime': documento['tipomime']
                                      });
                                } else if (documento['tipodoc'] == 'file') {
                                  String archivo = await contratosLogic
                                      .obtenerContratoSubidoById({
                                    'id_contrato': documento['iddocumento']
                                  });
                                  Navigator.pushNamed(context, '/viewContrato',
                                      arguments: {
                                        'htmlPdf': archivo,
                                        'tipo_mime': documento['tipomime']
                                      });
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const [
                                  Icon(Icons.remove_red_eye_outlined),
                                  SizedBox(width: 2.0),
                                  Text(
                                    'Ver documento',
                                  )
                                ],
                              ),
                            ),
                          ),
                          if (documento['archivo'])
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: GestureDetector(
                                onTap: () async {
                                  String file = await contratosLogic
                                      .obtenerContratoById({
                                    'id_contrato':
                                        documento['iddocumento'].toString()
                                  });
                                  Navigator.pushNamed(
                                      context, '/viewContrato', arguments: {
                                    'htmlPdf': file,
                                    'tipo_mime': documento['tipomimeoriginal']
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: const [
                                    Icon(Icons.remove_red_eye_outlined),
                                    SizedBox(width: 2.0),
                                    Text('Ver documento firmado')
                                  ],
                                ),
                              ),
                            )
                        ],
                      ),
                    );
                  } else {
                    return const ListTile(
                      title: Text('Sin actividades'),
                      trailing: FaIcon(
                        FontAwesomeIcons.book,
                      ),
                    );
                  }
                }
                return const ListTile(
                  title: Text('Sin documentos'),
                  trailing: FaIcon(
                    FontAwesomeIcons.book,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildList(AsyncSnapshot<ItemModelReporteInvitados> snapshot) {
    return SizedBox(
        width: 350,
        //color: Colors.pink,
        height: 150,
        child: miCardReportesInvitados(snapshot.data));
  }

  miCardReportesInvitados(ItemModelReporteInvitados reporte) {
    return GestureDetector(
      child: Card(
        color: const Color(0xFFfdf4e5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10),
        elevation: 10,
        child: Column(
          children: <Widget>[
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(15, 10, 25, 0),
              title: const Text(
                'Asistencia',
                style: TextStyle(fontSize: 15),
              ),
              subtitle: SizedBox(
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
              trailing: const FaIcon(FontAwesomeIcons.tasks),
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
    return BlocBuilder<evt_bloc.EventosBloc, evt_bloc.EventosState>(
      builder: (context, state) {
        if (state is evt_bloc.LoadingEventoPorIdState) {
          return const Center(child: LoadingCustom());
        } else if (state is evt_bloc.MostrarEventoPorIdState) {
          evento = state.evento;
          eventosBloc.add(evt_bloc.FechtEventosEvent('A'));
          return SizedBox(
              width: 350,
              height: 150,
              child: miCardReporteDetallesEvento(evento));
        } else if (state is evt_bloc.ErrorEventoPorIdState) {
          return Center(
            child: Text(state.message),
          );
        } else {
          if (evento != null) {
            return SizedBox(
                width: 350,
                height: 150,
                child: miCardReporteDetallesEvento(evento));
          } else {
            return const Center(child: LoadingCustom());
          }
        }
      },
    );
  }

  ItemModelEvento eventoFecha;

  miCardReporteDetallesEvento(ItemModelEvento evtt) {
    return GestureDetector(
      child: Card(
        color: const Color(0xFFfdf4e5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10),
        elevation: 6,
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: Column(
              children: <Widget>[
                ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                  title: const Text(
                    'Detalles del evento',
                    style: TextStyle(fontSize: 15),
                  ),
                  subtitle: Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Evento: ' + evtt.results.elementAt(0).evento,
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Fecha evento: ' +
                            evtt.results.elementAt(0).fechaEvento,
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        'Planeación: del ' +
                            evtt.results.elementAt(0).fechaInicio +
                            ' al ' +
                            evtt.results.elementAt(0).fechaFin,
                        style: const TextStyle(fontSize: 12),
                      ),
                      for (var inv in evtt.results.elementAt(0).involucrados)
                        mostrarInvolucrado(inv),
                    ],
                  ),
                  trailing: const Icon(Icons.event),
                ),
              ],
            ),
          ),
        ),
      ),
      onTap: WP_EVT_RES_EDT
          ? () async {
              if (!isInvolucrado) {
                await Navigator.pushNamed(context, '/editarEvento',
                    arguments: {'evento': evtt});
              }
            }
          : null,
    );
  }

  mostrarInvolucrado(dynamic involucrado) {
    if (involucrado.nombre == 'Sin nombre') {
      return const Text('Sin involucrados', style: TextStyle(fontSize: 12));
    } else {
      return Text(
        involucrado.tipoInvolucrado + ': ' + involucrado.nombre,
        style: const TextStyle(fontSize: 12),
      );
    }
  }

  Widget contadorActividadesWidget(Size size) {
    _planesLogic.getContadorValues(isInvolucrado);

    return Card(
      color: const Color(0xFFfdf4e5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      margin: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 15.0),
      elevation: 10.0,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: StreamBuilder(
          stream: _planesLogic.contadorActividadStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.total > 0) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Center(
                        child: Text(
                      'Actividades',
                      style: TextStyle(fontSize: 15.0),
                    )),
                    if (size.width > 400)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Spacer(),
                          Theme(
                            data: ThemeData(disabledColor: Colors.green),
                            child: const Checkbox(
                              value: true,
                              onChanged: null,
                              hoverColor: Colors.transparent,
                            ),
                          ),
                          Text(
                              '${snapshot.data.completadas.toString()} Completadas'),
                          const Spacer(),
                          Theme(
                            data: ThemeData(disabledColor: Colors.yellow[800]),
                            child: const Checkbox(
                              value: false,
                              onChanged: null,
                            ),
                          ),
                          Text(
                              '${snapshot.data.pendientes.toString()} En Curso'),
                          const Spacer(),
                          Theme(
                            data: ThemeData(disabledColor: Colors.red),
                            child: const Checkbox(
                              value: false,
                              onChanged: null,
                            ),
                          ),
                          Text(
                              '${snapshot.data.atrasadas.toString()} Atrasadas'),
                          const Spacer(),
                        ],
                      )
                    else
                      Column(mainAxisSize: MainAxisSize.min, children: [
                        Theme(
                          data: ThemeData(disabledColor: Colors.green),
                          child: const Checkbox(
                            value: true,
                            onChanged: null,
                            hoverColor: Colors.transparent,
                          ),
                        ),
                        Text(
                            '${snapshot.data.completadas.toString()} Completadas'),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Theme(
                          data: ThemeData(disabledColor: Colors.yellow[800]),
                          child: const Checkbox(
                            value: false,
                            onChanged: null,
                          ),
                        ),
                        Text('${snapshot.data.pendientes.toString()} En Curso'),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Theme(
                          data: ThemeData(disabledColor: Colors.red),
                          child: const Checkbox(
                            value: false,
                            onChanged: null,
                          ),
                        ),
                        Text('${snapshot.data.atrasadas.toString()} Atrasadas'),
                      ]),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Text(
                        'Progreso ${((snapshot.data.completadas / snapshot.data.total) * 100).toStringAsFixed(0)}%'),
                    const SizedBox(
                      height: 10,
                    ),
                    Theme(
                      data: ThemeData(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: size.width > 400 ? 400 : 200,
                        ),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          child: LinearProgressIndicator(
                            minHeight: 5.0,
                            value:
                                snapshot.data.completadas / snapshot.data.total,
                            semanticsLabel: 'Linear progress indicator',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text('Total: ${snapshot.data.total}')
                  ],
                );
              }
            }

            return const SizedBox(
              width: 310,
              height: 115,
              child: ListTile(
                title: Text('Sin actividades'),
                trailing: FaIcon(
                  FontAwesomeIcons.calendarMinus,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget resumenPresupuesto() {
    return SizedBox(
      width: 350,
      height: 150,
      child: Card(
        color: const Color(0xFFfdf4e5),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        margin: const EdgeInsets.all(10.0),
        elevation: 10.0,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: FutureBuilder(
            future: pagosLogic.obtenerResumenPagos(),
            builder: (BuildContext context,
                AsyncSnapshot<Map<String, dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: LoadingCustom(),
                );
              } else if (snapshot.hasData) {
                Map<String, dynamic> datos = snapshot.data;

                if (datos != null) {
                  String sueldo;
                  String pagos;
                  String total;

                  double pagosTemp = double.parse(datos['pagos']);

                  double totalTemp = double.parse(datos['total']);
                  double sueldotemp = totalTemp - pagosTemp;

                  if (pagosTemp == 0) {
                    pagos = '0.00\$';
                  } else if (pagosTemp < 0) {
                    pagos = '-' + f.format((pagosTemp * -1)) + '\$';
                  } else {
                    pagos = f.format(pagosTemp) + '\$';
                  }
                  if (totalTemp == 0) {
                    total = '0.00\$';
                  } else if (totalTemp < 0) {
                    total = '-' + f.format((totalTemp * -1)) + '\$';
                  } else {
                    total = f.format(totalTemp) + '\$';
                  }

                  if (sueldotemp == 0) {
                    sueldo = '0.00\$';
                  } else if (sueldotemp < 0) {
                    sueldo = '-' + f.format((sueldotemp * -1)) + '\$';
                  } else {
                    sueldo = f.format(sueldotemp) + '\$';
                  }

                  return ListTile(
                    trailing: const FaIcon(FontAwesomeIcons.moneyCheck),
                    title: const Text('Pagos'),
                    subtitle: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(2),
                          child: Row(
                            children: [
                              const Text('Total: '),
                              const Spacer(),
                              Text(
                                total,
                                textAlign: TextAlign.right,
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2),
                          child: Row(
                            children: [
                              const Text('Pagos: '),
                              const Spacer(),
                              Text(
                                pagos,
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2),
                          child: Row(
                            children: [
                              const Text('Saldo: '),
                              const Spacer(),
                              Text(
                                sueldo,
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Center(
                    child: Text('Sin datos'),
                  );
                }
              }
              return const Center(
                child: Text('Sin datos'),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget futureToPlannes() {
    _planesLogic.getAllPlannes();

    return Card(
      child: StreamBuilder(
        stream: _planesLogic.actividadesStream,
        builder:
            (BuildContext context, AsyncSnapshot<List<PlannesModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              decoration: const BoxDecoration(
                color: Color(0xFFfdf4e5),
              ),
              width: 500,
              height: 300,
              child: const Align(
                alignment: Alignment.center,
                child: LoadingCustom(),
              ),
            );
          } else {
            if (snapshot.hasData) {
              return miCardActividades(snapshot.data);
            } else {
              return Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFfdf4e5),
                ),
                width: 500,
                height: 300,
                child: Card(
                  color: const Color(0xFFfdf4e5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  margin: const EdgeInsets.all(20.0),
                  elevation: 10.0,
                  child: const SingleChildScrollView(
                      child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Center(
                              child: Text('No se encontraron actividades')))),
                ),
              );
            }
          }
        },
      ),
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
          plan.nombreActividad,
          style: const TextStyle(fontSize: 15.0),
        ),
        subtitle: Text(
          plan.descripcionActividad,
          style: const TextStyle(fontSize: 12.0),
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

    return SizedBox(
      width: 500,
      height: 300,
      child: Card(
        color: const Color(0xFFfdf4e5),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        margin: const EdgeInsets.all(20.0),
        elevation: 10.0,
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: [
              ExpansionTile(
                textColor: Colors.black,
                subtitle: Text('Progreso: $completadas/$total'),
                title: const Text('Actividades completadas'),
                children: actividadeCompletas,
              ),
              ExpansionTile(
                textColor: Colors.black,
                title: const Text('Actividades pedientes'),
                children: actividadesPedientes,
              ),
              ExpansionTile(
                textColor: Colors.black,
                title: const Text('Actividades atrasadas'),
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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: (isInvolucrado)
          ? AppBar(
              centerTitle: true,
              title: const Text(
                'Resumen del evento',
              ),
            )
          : null,
      body: RefreshIndicator(
        color: Colors.blue,
        onRefresh: () async {
          eventosBloc.add(evt_bloc.FetchEventoPorIdEvent(
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
                    resumenMinuta(),
                    resumenPresupuesto(),
                    contadorActividadesWidget(size),

                    //),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: UniqueKey(),
        child: const Icon(Icons.download),
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

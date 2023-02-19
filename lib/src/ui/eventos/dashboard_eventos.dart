// ignore_for_file: non_constant_identifier_names, unnecessary_this, no_logic_in_create_state

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/logic/eventos_offline_logic.dart';
import 'package:planning/src/resources/config_conection.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:planning/src/blocs/eventos/eventos_bloc.dart';
import 'package:planning/src/logic/permisos_logic.dart';
import 'package:planning/src/models/item_model_eventos.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/utils/utils.dart' as utils;

class DashboardEventos extends StatefulWidget {
  final bool? WP_EVT_CRT;
  final Map? data;

  const DashboardEventos({Key? key, this.WP_EVT_CRT, this.data})
      : super(key: key);

  @override
  State<DashboardEventos> createState() =>
      _DashboardEventosState(this.WP_EVT_CRT);
}

class _DashboardEventosState extends State<DashboardEventos> {
  final SharedPreferencesT _sharedPreferences = SharedPreferencesT();
  late EventosBloc eventosBloc;
  ItemModelEventos? eventos;
  PerfiladoLogic? perfilado;
  final bool? WP_EVT_CRT;
  late Size size;
  bool _lights = false;
  String? valEstatus;
  bool desconectado = false;
  _DashboardEventosState(this.WP_EVT_CRT);

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  void initState() {
    valEstatus = _lights ? 'I' : 'A';
    eventosBloc = BlocProvider.of<EventosBloc>(context);
    eventosBloc.add(FechtEventosEvent(valEstatus));
    _checkIsDesconectado();
    super.initState();
  }

  _checkIsDesconectado() async {
    desconectado = await SharedPreferencesT().getModoConexion();
    setState(() {});
  }

  String titulo = "";
  Widget buildList(ItemModelEventos snapshot) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: size.width <= 540 ? 550 : 400,
            mainAxisExtent: 150,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 2),
        itemCount: snapshot.results.length,
        itemBuilder: (BuildContext ctx, index) {
          return miCard(
            snapshot.results.elementAt(index).idEvento,
            snapshot.results.elementAt(index).tipoEvento!,
            snapshot.results.elementAt(index).fechaInicio,
            snapshot.results.elementAt(index).fechaFin,
            snapshot.results.elementAt(index).fechaEvento,
            snapshot.results.elementAt(index).involucrados,
          );
        });
  }

  miCard(int? idEvento, String titulo, String? inicio, String? fin,
      String? fevento, List involucrados) {
    return GestureDetector(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(8.0),
        elevation: 10,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFFfdf4e5),
          ),
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  children: <Widget>[
                    ListTile(
                      contentPadding: const EdgeInsets.fromLTRB(15, 10, 25, 0),
                      title: Text(titulo),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Fecha evento: $fevento'),
                          Text('Planeación de evento del: $inicio al $fin'),
                          for (var i = 0; i < involucrados.length; i++)
                            involucrados[0].tipoInvolucrado != 'Sin involucrado'
                                ? Text(involucrados[i].tipoInvolucrado +
                                    ' : ' +
                                    involucrados[i].nombre)
                                : const Text('Sin involucrados'),
                          const Align(
                            alignment: Alignment.centerRight,
                          )
                        ],
                      ),
                      // trailing: FaIcon(
                      //   FontAwesomeIcons.glassCheers,
                      //   size: 18.0,
                      // ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: FutureBuilder(
                      future: FetchListaEventosOfflineLogic()
                          .eventoDescargado(idEvento),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final data = snapshot.data as List;
                          if (data[0] == false) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(right: 7.0, top: 7.0),
                              child: PopupMenuButton(
                                onSelected: (dynamic i) {
                                  if (i == 1) {
                                    showDialogDescargarEvento(
                                        context, idEvento);
                                  }
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 1,
                                    height: 20.0,
                                    child: const Text(
                                      'Descargar evento',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                                child: Icon(
                                  data[1] == true
                                      ? Icons.download_done
                                      : Icons.more_vert,
                                ),
                              ),
                            );
                          }
                        }
                        return Padding(
                          padding: const EdgeInsets.only(right: 7.0, top: 7.0),
                        );
                      }),
                )
              ],
            ),
          ),
        ),
      ),
      onTap: () async {
        await _sharedPreferences.setIdEvento(idEvento!);
        if (mounted) {
          Navigator.pushNamed(context, '/eventos', arguments: {
            'idEvento': idEvento,
            'nEvento': titulo,
            'nombre': widget.data!['name'],
            'boton': true,
            'imag': widget.data!['imag']
          });
        }
      },
    );
  }

  void showDialogDescargarEvento(BuildContext currentContext, int? idEvento) {
    showDialog(
      context: currentContext,
      builder: (currentContext) {
        return AlertDialog(
          title: const Text(
            'Confirmar descarga',
            textAlign: TextAlign.center,
          ),
          content: SizedBox(
            width: 350.0,
            child: const Text(
              'Se guardará en el dispositivo la siguiente información del evento:'
              '\n - Resumen'
              '\n - Documentos'
              '\n - Lista de invitados con sus asistencias, acompañantes y mesas asignadas'
              '\n - Layout del evento'
              '\n\n¿Desea continuar?',
              textAlign: TextAlign.justify,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () async {
                await FetchListaEventosOfflineLogic()
                    .fetchEventosOffline(idEvento, context);
                Navigator.pop(context);
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  _showDialogMsg(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        //barrierDismissible: false,
        builder: (BuildContext context) {
          //_ingresando = context;
          return AlertDialog(
            title: const Text(
              "Sesión",
              textAlign: TextAlign.center,
            ),
            content: const Text(
                'Lo sentimos, la sesión ha caducado. Por favor inicie sesión de nuevo.'),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            actions: <Widget>[
              TextButton(
                child: const Text('Cerrar'),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/', (route) => false);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: RefreshIndicator(
        color: Colors.blue,
        onRefresh: () async {
          eventosBloc.add(FechtEventosEvent(valEstatus));
        },
        child: BlocListener<EventosBloc, EventosState>(
          // ignore: void_checks
          listener: (context, state) {
            if (state is ErrorTokenEventosState) {
              return _showDialogMsg(context);
            }
          },
          child: BlocBuilder<EventosBloc, EventosState>(
            builder: (context, state) {
              if (state is EventosInitial) {
                return const Center(child: LoadingCustom());
              }
              if (state is LoadingEventosState) {
                return const Center(child: LoadingCustom());
              } else if (state is MostrarEventosState) {
                eventos = state.eventos;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: SwitchListTile(
                            title: Text(
                              _lights
                                  ? 'Todos los eventos.'
                                  : 'Eventos activos',
                            ),
                            value: _lights,
                            onChanged: (bool value) {
                              setState(() {
                                _lights = value;
                                if (_lights) {
                                  valEstatus = 'I';
                                } else {
                                  valEstatus = 'A';
                                }
                                eventosBloc.add(FechtEventosEvent(valEstatus));
                              });
                            })),
                    Expanded(
                        child: Row(
                      children: [Expanded(child: buildList(eventos!))],
                    ))
                  ],
                );
              } else if (state is ErrorListaEventosState) {
                return Center(
                  child: Text(state.message),
                );
              } else {
                if (eventos != null) {
                  return Container(
                    child: buildList(eventos!),
                  );
                } else {
                  return const Center(child: LoadingCustom());
                }
              }
            },
          ),
        ),
      ),
      floatingActionButton: WP_EVT_CRT! && !desconectado
          ? expadibleFab()
          : const SizedBox.shrink(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget expadibleFab() {
    return SpeedDial(
      tooltip: 'Opciones',
      children: [
        SpeedDialChild(
            child: const Icon(Icons.event_available),
            onTap: () {
              Navigator.of(context).pushNamed('/addEvento');
            }),
        SpeedDialChild(
            child: const Icon(Icons.download),
            onTap: () async {
              _buildEventosPDF();
            })
      ],
      child: const Icon(Icons.more_vert),
    );
  }

  void _buildEventosPDF() async {
    String token = await _sharedPreferences.getToken();
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idEvento = await _sharedPreferences.getIdEvento();
    const endpoint = '/wedding/EVENTOS/descargarPDFEventos';

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token
    };

    final data = {
      'idPlanner': idPlanner,
      'idEvento': idEvento,
      'eventos': eventos!.results.map((e) => e.toJson()).toList(),
    };
    Client client = Client();
    ConfigConection confiC = ConfigConection();
    final resp = await client.post(
      Uri.parse(confiC.url! + confiC.puerto! + endpoint),
      body: json.encode(data),
      headers: headers,
    );

    if (resp.statusCode == 200) {
      final pdf = json.decode(resp.body)['pdf'];
      String titulotemp = 'Eventos';
      final titulo = titulotemp.replaceAll(" ", "_");
      utils.downloadFile(pdf, titulo);
    }
  }
}

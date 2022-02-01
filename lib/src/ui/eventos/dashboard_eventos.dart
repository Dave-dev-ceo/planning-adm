import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/resources/config_conection.dart';
import 'package:universal_html/html.dart' as html hide Text;

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:planning/src/blocs/eventos/eventos_bloc.dart';
import 'package:planning/src/logic/permisos_logic.dart';
import 'package:planning/src/models/item_model_eventos.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/utils/utils.dart' as utils;

class DashboardEventos extends StatefulWidget {
  final bool WP_EVT_CRT;
  final Map data;

  const DashboardEventos({Key key, this.WP_EVT_CRT, this.data})
      : super(key: key);

  @override
  _DashboardEventosState createState() =>
      _DashboardEventosState(this.WP_EVT_CRT);
}

class _DashboardEventosState extends State<DashboardEventos> {
  SharedPreferencesT _sharedPreferences = new SharedPreferencesT();
  EventosBloc eventosBloc;
  ItemModelEventos eventos;
  PerfiladoLogic perfilado;
  final bool WP_EVT_CRT;
  bool _lights = false;
  _DashboardEventosState(this.WP_EVT_CRT);

  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  void initState() {
    var valEstatus = _lights ? 'I' : 'A';
    eventosBloc = BlocProvider.of<EventosBloc>(context);
    eventosBloc.add(FechtEventosEvent(valEstatus));
    super.initState();
  }

  listaEventos(ItemModelEventos eventos) {
    /*bloc.fetchAllEventos(context);
    return StreamBuilder(
      stream: bloc.allEventos,
      builder: (context, AsyncSnapshot<ItemModelEventos> snapshot) {
        if (snapshot.hasData) {
          return buildList(snapshot);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(child: LoadingCustom());
      },
    );*/
  }

  String titulo = "";
  Widget buildList(ItemModelEventos snapshot) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 400,
            mainAxisExtent: 150,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 0),
        itemCount: snapshot.results.length,
        itemBuilder: (BuildContext ctx, index) {
          return miCard(
            snapshot.results.elementAt(index).idEvento,
            snapshot.results.elementAt(index).tipoEvento,
            snapshot.results.elementAt(index).fechaInicio,
            snapshot.results.elementAt(index).fechaFin,
            snapshot.results.elementAt(index).fechaEvento,
            snapshot.results.elementAt(index).involucrados,
          );
        });
  }

  miCard(int idEvento, String titulo, String inicio, String fin, String fevento,
      List involucrados) {
    return GestureDetector(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(8.0),
        elevation: 10,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFFF0D6),
                Color(0xfffef9f9),
                Color(0xFFFFF0D6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.fromLTRB(15, 10, 25, 0),
                  title: Text(titulo),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Fecha evento: ' + fevento),
                      Text(
                          'Planeación de evento del: ' + inicio + ' al ' + fin),
                      for (var i = 0; i < involucrados.length; i++)
                        involucrados[0].tipoInvolucrado != 'Sin involucrado'
                            ? Text(involucrados[i].tipoInvolucrado +
                                ' : ' +
                                involucrados[i].nombre)
                            : Text('Sin involucrados'),
                    ],
                  ),
                  trailing: FaIcon(
                    FontAwesomeIcons.glassCheers,
                    size: 18.0,
                  ),
                ),
                SizedBox(
                  height: 8.0,
                )
              ],
            ),
          ),
        ),
      ),
      onTap: () async {
        await _sharedPreferences.setIdEvento(idEvento);
        Navigator.pushNamed(context, '/eventos', arguments: {
          'idEvento': idEvento,
          'nEvento': titulo,
          'nombre': widget.data['name'],
          'boton': true,
          'imag': widget.data['imag']
        });
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
            title: Text(
              "Sesión",
              textAlign: TextAlign.center,
            ),
            content: Text(
                'Lo sentimos la sesión a caducado, por favor inicie sesión de nuevo.'),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            actions: <Widget>[
              TextButton(
                child: Text('Cerrar'),
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
    var valEstatus = _lights ? 'I' : 'A';
    return Scaffold(
      body: RefreshIndicator(
        color: Colors.blue,
        onRefresh: () async {
          await eventosBloc.add(FechtEventosEvent(valEstatus));
        },
        child: BlocListener<EventosBloc, EventosState>(
          listener: (context, state) {
            if (state is ErrorTokenEventosState) {
              return _showDialogMsg(context);
            }
          },
          child: BlocBuilder<EventosBloc, EventosState>(
            builder: (context, state) {
              if (state is EventosInitial) {
                return Center(child: LoadingCustom());
              }
              if (state is LoadingEventosState) {
                return Center(child: LoadingCustom());
              } else if (state is MostrarEventosState) {
                eventos = state.eventos;
                return Container(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: SwitchListTile(
                                title: const Text('Ver todos los eventos.'),
                                value: _lights,
                                onChanged: (bool value) {
                                  setState(() {
                                    _lights = value;
                                    eventosBloc
                                        .add(FechtEventosEvent(valEstatus));
                                  });
                                })),
                        Expanded(
                            child: Row(
                          children: [Expanded(child: buildList(eventos))],
                        ))
                      ],
                    ),
                  ),
                  // child: buildList(eventos),
                );
              } else if (state is ErrorListaEventosState) {
                return Center(
                  child: Text(state.message),
                );
              } else {
                if (eventos != null) {
                  return Container(
                    child: buildList(eventos),
                  );
                } else {
                  return Center(child: LoadingCustom());
                }
              }
            },
          ),
        ),
      ),
      floatingActionButton: WP_EVT_CRT
          ? expadibleFab()
          // FloatingActionButton(
          // child: Icon(Icons.event_available),
          // backgroundColor: hexToColor('#fdf4e5'),
          // onPressed: () {
          // Navigator.of(context).pushNamed('/addEvento');
          // })
          : SizedBox.shrink(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget expadibleFab() {
    return SpeedDial(
      tooltip: 'Opciones',
      child: Icon(Icons.more_vert),
      children: [
        SpeedDialChild(
            child: Icon(Icons.event_available),
            onTap: () {
              Navigator.of(context).pushNamed('/addEvento');
            }),
        SpeedDialChild(
            child: Icon(Icons.download),
            onTap: () async {
              await _buildEventosPDF();
            })
      ],
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
      'eventos': eventos.results.map((e) => e.toJson()).toList(),
    };
    Client client = Client();
    ConfigConection confiC = new ConfigConection();
    final resp = await client.post(
      Uri.parse(confiC.url + confiC.puerto + endpoint),
      body: json.encode(data),
      headers: headers,
    );

    if (resp.statusCode == 200) {
      final pdf = json.decode(resp.body)['pdf'];
      String titulotemp = 'Eventos';
      final titulo = titulotemp.replaceAll(" ", "_");
      final date = DateTime.now();
      utils.downloadFile(pdf, '$titulo');
    }

    // final pdf = pw.Document();

    // List<pw.Widget> listaGrid = [];
    // // List<pw.Widget> listaView = [];

    // for (var evento in eventos.results) {
    //   // pw.Widget listaViewChild = pw.Column(children: [
    //   //   pw.Text('Fecha evento: ${evento.fechaEvento}'),
    //   //   pw.Text(
    //   //       'Planeación de evento del: ${evento.fechaInicio} al ${evento.fechaFin}'),
    //   //   for (var i = 0; i < evento.involucrados.length; i++)
    //   //     evento.involucrados[0].tipoInvolucrado != 'Sin involucrado'
    //   //         ? pw.Text(evento.involucrados[i].tipoInvolucrado +
    //   //             ' : ' +
    //   //             evento.involucrados[i].nombre)
    //   //         : pw.Text('Sin involucrados'),
    //   // ]);
    //   // listaView.add(listaViewChild);

    //   pw.Widget gridChild = pw.Container(
    //     margin: const pw.EdgeInsets.only(bottom: 6.0),
    //     decoration: pw.BoxDecoration(
    //       boxShadow: [
    //         pw.BoxShadow(
    //           color: PdfColors.grey,
    //           offset: PdfPoint(0.0, 0.1),
    //           spreadRadius: 5.0,
    //           blurRadius: 6.0,
    //         ),
    //       ],
    //       border: pw.Border.all(),
    //     ),
    //     padding: pw.EdgeInsets.all(8.0),
    //     child: pw.Column(children: [
    //       pw.Center(
    //         child: pw.Text(evento.tipoEvento),
    //       ),
    //       pw.SizedBox(
    //         height: 10.0,
    //       ),
    //       pw.Text('Fecha evento: ${evento.fechaEvento}'),
    //       pw.Text(
    //           'Planeación de evento del: ${evento.fechaInicio} al ${evento.fechaFin}'),
    //       for (var i = 0; i < evento.involucrados.length; i++)
    //         evento.involucrados[0].tipoInvolucrado != 'Sin involucrado'
    //             ? pw.Text(evento.involucrados[i].tipoInvolucrado +
    //                 ' : ' +
    //                 evento.involucrados[i].nombre)
    //             : pw.Text('Sin involucrados'),
    //     ]),
    //   );
    //   listaGrid.add(gridChild);
    // }
    // pdf.addPage(
    //   pw.MultiPage(
    //     build: (pw.Context context) => [
    //       pw.Center(
    //         child: pw.Text('Eventos:', style: pw.Theme.of(context).header4),
    //       ),
    //       pw.SizedBox(height: 15.0),
    //       pw.GridView(
    //         crossAxisCount: 3,
    //         childAspectRatio: 1.0,
    //         crossAxisSpacing: 8.0,
    //         mainAxisSpacing: 8.0,
    //         direction: pw.Axis.vertical,
    //         children: listaGrid,
    //       )
    //     ],
    //   ),
    // );
    // String titulotemp = 'Eventos';

    // final titulo = titulotemp.replaceAll(" ", "_");

    // final date = DateTime.now();

    // final bytes = await pdf.save();
    // final blob = html.Blob([bytes]);
    // final url = html.Url.createObjectUrlFromBlob(blob);

    // final anchor = html.document.createElement('a') as html.AnchorElement
    //   ..href = url
    //   ..style.display = 'none'
    //   ..download = '$titulo-$date.pdf';
    // html.document.body.children.add(anchor);
    // anchor.click();
    // html.document.body.children.remove(anchor);
    // html.Url.revokeObjectUrl(url);
  }
}

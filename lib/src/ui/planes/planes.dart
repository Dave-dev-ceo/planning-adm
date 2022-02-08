// import flutter/dart
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/logic/planes_logic.dart';
import 'package:planning/src/models/Planes/planes_model.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/ui/widgets/snackbar_widget/snackbar_widget.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// blocs
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/blocs/planes/planes_bloc.dart';

// model

// utils
import 'package:planning/src/utils/utils.dart' as utils;

// our
import 'package:planning/src/ui/widgets/text_form_filed/text_form_filed.dart';

// crear listas
class TareaPlanner {
  int idTareaPlanner;
  String nombreTareaPlanner;
  DateTime fechaInicioEvento;
  DateTime fechaFinalEvento;
  int idTareaOld;
  bool checkTarePlanner;
  bool expandedTarePlanner;
  int progreso;
  bool botonAdd;
  List<ActividadPlanner> actividadTareaPlanner;

  TareaPlanner({
    this.idTareaPlanner,
    this.nombreTareaPlanner,
    this.fechaInicioEvento,
    this.fechaFinalEvento,
    this.idTareaOld,
    this.checkTarePlanner,
    this.expandedTarePlanner,
    this.progreso,
    this.botonAdd,
    this.actividadTareaPlanner,
  });
}

class ActividadPlanner {
  int idActividadPlanner;
  String nombreActividadPlanner;
  String nombreResponsable;
  String descripcionActividadPlanner;
  bool visibleInvolucradosActividadPlanner;
  int diasActividadPlanner;
  int predecesorActividadPlanner;
  DateTime fechaInicioActividad;
  DateTime fechaInicioEvento;
  DateTime fechaFinalEvento;
  int idOldActividad;
  bool calendarActividad;
  bool checkActividadPlanner;
  bool nombreValida;
  bool descriValida;

  ActividadPlanner({
    this.idActividadPlanner,
    this.nombreActividadPlanner,
    this.nombreResponsable,
    this.descripcionActividadPlanner,
    this.visibleInvolucradosActividadPlanner,
    this.diasActividadPlanner,
    this.predecesorActividadPlanner,
    this.fechaInicioActividad,
    this.fechaInicioEvento,
    this.fechaFinalEvento,
    this.idOldActividad,
    this.calendarActividad,
    this.checkActividadPlanner,
    this.nombreValida,
    this.descriValida,
  });

  Map<String, dynamic> toJson() => {
        'idActividadPlanner': idActividadPlanner,
        'nombreActividadPlanner': nombreActividadPlanner,
        'nombreResponsable': nombreResponsable,
        'descripcionActividadPlanner': descripcionActividadPlanner,
        'visibleInvolucradosActividadPlanner':
            visibleInvolucradosActividadPlanner,
        'diasActividadPlanner': diasActividadPlanner,
        'predecesorActividadPlanner': predecesorActividadPlanner,
        'fechaInicioActividad': fechaInicioActividad,
        'fechaInicioEvento': fechaInicioEvento,
        'fechaFinalEvento': fechaFinalEvento,
        'idOldActividad': idOldActividad,
        'calendarActividad': calendarActividad,
        'checkActividadPlanner': checkActividadPlanner,
        'nombreValida': nombreValida,
        'descriValida': descriValida,
      };
}

class PlanesPage extends StatefulWidget {
  const PlanesPage({Key key}) : super(key: key);

  @override
  _PlanesPageState createState() => _PlanesPageState();
}

class _PlanesPageState extends State<PlanesPage> with TickerProviderStateMixin {
  PlanesBloc _planesBloc;
  ConsultasPlanesLogic planesLogic = ConsultasPlanesLogic();
  final ActividadesEvento _planesLogic = ActividadesEvento();

  List<TimingModel> listaTimings = [];

  int index = 0;
  Size size;
  bool isEnableButton = false;
  bool isInvolucrado = false;

  @override
  void initState() {
    _planesBloc = BlocProvider.of<PlanesBloc>(context);
    _planesBloc.add(GetTimingsAndActivitiesEvent());
    getIdInvolucrado();

    super.initState();
  }

  Future<void> getIdInvolucrado() async {
    final idInvolucrado = await SharedPreferencesT().getIdInvolucrado();

    if (idInvolucrado != null) {
      setState(() {
        isInvolucrado = true;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: (isInvolucrado)
          ? AppBar(
              title: const Text('Actividades'),
              centerTitle: true,
            )
          : null,
      body: RefreshIndicator(
        onRefresh: () async {
          _planesBloc.add(GetTimingsAndActivitiesEvent());
        },
        color: Colors.blue,
        child: SingleChildScrollView(
          controller: ScrollController(),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Card(
            child: Column(
              children: [
                const SizedBox(
                  height: 10.0,
                ),
                if (!isInvolucrado)
                  Text(
                    'Actividades',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                const SizedBox(
                  height: 10.0,
                ),
                contadorActividadesWidget(size),
                const SizedBox(
                  height: 10.0,
                ),
                if (!isInvolucrado)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        onPressed: isEnableButton
                            ? () async {
                                _updateYselect();
                              }
                            : null,
                        icon: const Icon(Icons.save),
                        label: const Text('Guardar'),
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      ElevatedButton.icon(
                        onPressed: _goAddingPlanes,
                        icon: const Icon(Icons.add),
                        label: const Text('Añadir'),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 10.0,
                ),
                BlocBuilder<PlanesBloc, PlanesState>(
                  builder: (context, state) {
                    if (state is InitiaPlaneslState) {
                      return const Center(child: LoadingCustom());
                    } else if (state is LodingPlanesState) {
                      return const Center(child: LoadingCustom());
                    } else if (state is ShowAllPlannesState) {
                      if (state.listTimings != null) {
                        listaTimings = state.listTimings;
                      }
                      return buildActividadesEvento();
                    } else {
                      return const Center(child: LoadingCustom());
                    }
                  },
                ),
                const SizedBox(
                  height: 30.0,
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _botonFlotante(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  StreamBuilder<ContadorActividadesModel> contadorActividadesWidget(Size size) {
    _planesLogic.getContadorValues(isInvolucrado);

    return StreamBuilder(
      stream: _planesLogic.contadorActividadStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.total > 0) {
            return Column(
              children: [
                if (size.width > 400)
                  Row(
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
                      Text('${snapshot.data.pendientes.toString()} Pendientes'),
                      const Spacer(),
                      Theme(
                        data: ThemeData(disabledColor: Colors.red),
                        child: const Checkbox(
                          value: false,
                          onChanged: null,
                        ),
                      ),
                      Text('${snapshot.data.atrasadas.toString()} Atrasadas'),
                      const Spacer(),
                    ],
                  )
                else
                  Column(children: [
                    Theme(
                      data: ThemeData(disabledColor: Colors.green),
                      child: const Checkbox(
                        value: true,
                        onChanged: null,
                        hoverColor: Colors.transparent,
                      ),
                    ),
                    Text('${snapshot.data.completadas.toString()} Completadas'),
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
                    Text('${snapshot.data.pendientes.toString()} Pendientes'),
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
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: LinearProgressIndicator(
                        minHeight: 5.0,
                        value: snapshot.data.completadas / snapshot.data.total,
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
        if (size.width > 400) {
          return Row(
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
              const Text('Completadas'),
              const Spacer(),
              Theme(
                data: ThemeData(disabledColor: Colors.yellow[800]),
                child: const Checkbox(
                  value: false,
                  onChanged: null,
                ),
              ),
              const Text('Pendientes'),
              const Spacer(),
              Theme(
                data: ThemeData(disabledColor: Colors.red),
                child: const Checkbox(
                  value: false,
                  onChanged: null,
                ),
              ),
              const Text('Atrasadas'),
              const Spacer(),
            ],
          );
        } else {
          return Column(
            children: [
              Theme(
                data: ThemeData(disabledColor: Colors.green),
                child: const Checkbox(
                  value: true,
                  onChanged: null,
                  hoverColor: Colors.transparent,
                ),
              ),
              const Text('Completadas'),
              Theme(
                data: ThemeData(disabledColor: Colors.yellow[800]),
                child: const Checkbox(
                  value: false,
                  onChanged: null,
                ),
              ),
              const Text('Pendientes'),
              Theme(
                data: ThemeData(disabledColor: Colors.red),
                child: const Checkbox(
                  value: false,
                  onChanged: null,
                ),
              ),
              const Text('Atrasadas'),
            ],
          );
        }
      },
    );
  }

  Widget buildActividadesEvento() {
    List<Widget> listPlanesWidget = [];
    // List<FocusNode> focusNode = [];
    index = 0;

    if (listaTimings.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(15.0),
        child: Center(
          child: Text('No se encontraron planes'),
        ),
      );
    } else {
      for (var timing in listaTimings) {
        List<Widget> tempActividadesTiming = [];

        for (var actividad in timing.actividades) {
          // FocusNode tempFocus = FocusNode();
          // focusNode.add(tempFocus);

          actividad.fechaFinActividad ??=
              actividad.fechaInicioActividad.add(const Duration(days: 1));
          if (!isInvolucrado) {
            Widget actividadWidget = ListTile(
              leading: Theme(
                data: ThemeData(
                    primarySwatch: Colors.green,
                    unselectedWidgetColor: actividad.estatus == 'Pendiente'
                        ? Colors.yellow[800]
                        : Colors.red),
                child: Checkbox(
                  value: actividad.estatusProgreso,
                  onChanged: (value) {
                    setState(
                      () {
                        isEnableButton = true;
                        actividad.estatusProgreso = value;
                        if (actividad.estatusProgreso) {
                          actividad.estatus = 'Completada';
                        }
                      },
                    );
                  },
                ),
              ),
              title: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AddNuevaActividad(
                            actividadModel: actividad,
                            idPlanner: timing.idPlanner,
                            plan: timing,
                          ),
                        ).then((_) async {
                          await _planesLogic.getAllPlannes();
                          await _planesLogic.getContadorValues(isInvolucrado);
                          setState(() {});
                        });
                      },
                      child: AutoSizeText(
                        actividad.nombreActividad,
                        maxLines: 2,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: FaIcon(
                      actividad.visibleInvolucrado
                          ? FontAwesomeIcons.eye
                          : FontAwesomeIcons.eyeSlash,
                      size: 15.0,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Tooltip(
                      showDuration: const Duration(
                        milliseconds: 3,
                      ),
                      message: 'Click para editar',
                      child: TextFormField(
                        onTap: () => setState(() {
                          actividad.enable = true;
                          isEnableButton = true;
                        }),
                        // focusNode: focusNode[index],
                        readOnly: !actividad.enable,
                        decoration: InputDecoration(
                          hintText: 'Responsable',
                          constraints: BoxConstraints(
                            maxWidth: size.width * 0.06,
                          ),
                        ),
                        initialValue: actividad.responsable,
                        onChanged: (value) {
                          actividad.responsable = value;
                        },
                        onFieldSubmitted: (_) {},
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: AutoSizeText(
                          '${actividad.fechaInicioActividad.day}/${actividad.fechaInicioActividad.month}/${actividad.fechaInicioActividad.year}',
                          maxLines: 1,
                          wrapWords: false,
                        ),
                      ),
                      onTap: () async {
                        final data = await _giveFecha(
                          actividad.fechaInicioActividad,
                          actividad.fechaInicioEvento,
                          actividad.fechaFinEvento,
                          actividad.diasActividad,
                          actividad.idActividad,
                        );

                        setState(() {
                          if (data != null) {
                            isEnableButton = true;
                            DateTime fecha = DateTime(
                              data.year,
                              data.month,
                              data.day,
                              DateTime.now().toLocal().hour,
                              DateTime.now().toLocal().minute,
                            );

                            if (fecha.isAfter(DateTime.now())) {
                              actividad.estatus = 'Pendiente';
                            } else if (fecha.isBefore(DateTime.now())) {
                              actividad.estatus = 'Atrasada';
                            } else {
                              actividad.estatus = 'Pendiente';
                            }
                            if (fecha.isAfter(actividad.fechaFinActividad)) {
                              actividad.fechaFinActividad =
                                  fecha.add(const Duration(hours: 1));
                            }
                            actividad.fechaInicioActividad = fecha;
                            actividad.estadoCalendarioActividad = true;
                          }
                        });
                      },
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: AutoSizeText(
                          '${actividad.fechaFinActividad.day}/${actividad.fechaFinActividad.month}/${actividad.fechaFinActividad.year}',
                          maxLines: 1,
                          wrapWords: false,
                        ),
                      ),
                      onTap: () async {
                        final data = await _giveFecha(
                          actividad.fechaInicioActividad,
                          actividad.fechaInicioEvento,
                          actividad.fechaFinEvento,
                          actividad.diasActividad,
                          actividad.idActividad,
                        );

                        setState(() {
                          if (data != null) {
                            isEnableButton = true;

                            DateTime fecha = DateTime(
                              data.year,
                              data.month,
                              data.day,
                              DateTime.now().toLocal().hour,
                              DateTime.now().toLocal().minute,
                            );
                            if (fecha.isAfter(DateTime.now())) {
                              actividad.estatus = 'Pendiente';
                            } else if (fecha.isBefore(DateTime.now())) {
                              actividad.estatus = 'Atrasada';
                            } else {
                              actividad.estatus = 'Pendiente';
                            }
                            if (fecha
                                .isBefore(actividad.fechaInicioActividad)) {
                              actividad.fechaInicioActividad =
                                  fecha.subtract(const Duration(hours: 1));
                            }
                            actividad.fechaFinActividad = fecha;
                            actividad.estadoCalendarioActividad = true;
                          }
                        });
                      },
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: (!isInvolucrado)
                        ? GestureDetector(
                            child: const Tooltip(
                              message: 'Eliminar Actividad',
                              child: Icon(Icons.delete),
                            ),
                            onTap: () async {
                              await _alertaBorrar(actividad.idActividad,
                                  actividad.nombreActividad);
                              _planesLogic.getAllPlannes();
                              _planesLogic.getContadorValues(isInvolucrado);
                              setState(() {});
                            },
                          )
                        : Container(),
                    flex: 1,
                  )
                ],
              ),
              subtitle: Text(actividad.descripcionActividad),
            );
            tempActividadesTiming.add(actividadWidget);
            index++;
          } else {
            if (actividad.visibleInvolucrado) {
              Widget actividadWidget = ListTile(
                leading: Theme(
                  data: ThemeData(
                      primarySwatch: Colors.green,
                      unselectedWidgetColor: actividad.estatus == 'Pendiente'
                          ? Colors.yellow[800]
                          : Colors.red),
                  child: Checkbox(
                    value: actividad.estatusProgreso,
                    onChanged: (_) => {},
                    hoverColor: Colors.transparent,
                  ),
                ),
                title: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: AutoSizeText(
                        actividad.nombreActividad,
                        maxLines: 2,
                      ),
                    ),
                    Expanded(
                        flex: 2,
                        child: Text(
                          actividad.responsable ?? 'Sin responsable',
                        )),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: AutoSizeText(
                          '${actividad.fechaInicioActividad.day}/${actividad.fechaInicioActividad.month}/${actividad.fechaInicioActividad.year}',
                          maxLines: 1,
                          wrapWords: false,
                        ),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: AutoSizeText(
                          '${actividad.fechaFinActividad.day}/${actividad.fechaFinActividad.month}/${actividad.fechaFinActividad.year}',
                          maxLines: 1,
                          wrapWords: false,
                        ),
                      ),
                      flex: 1,
                    )
                  ],
                ),
                subtitle: Text(actividad.descripcionActividad),
              );
              tempActividadesTiming.add(actividadWidget);
              index++;
            }
          }
        }

        if (!isInvolucrado) {
          if (listaTimings.first.actividades.first.fechaFinEvento
              .isAfter(DateTime.now())) {
            tempActividadesTiming.add(
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AddNuevaActividad(
                        actividadModel: EventoActividadModel(),
                        idPlanner: timing.idPlanner,
                        plan: timing,
                      ),
                    ).then((_) async {
                      await _planesLogic.getAllPlannes();
                      await _planesLogic.getContadorValues(isInvolucrado);
                      setState(() {});
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar actividad'),
                ),
              ),
            );
          }
        }

        if (tempActividadesTiming.isNotEmpty) {
          Widget timingWidget = ExpansionTile(
            iconColor: Colors.black,
            title: Text(
              timing.nombrePlaner,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
            children: tempActividadesTiming,
          );

          listPlanesWidget.add(timingWidget);
        }
      }
      if (listPlanesWidget.isNotEmpty) {
        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          margin: const EdgeInsets.all(20.0),
          elevation: 10.0,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 10.0,
                ),
                ListView(
                  shrinkWrap: true,
                  children: listPlanesWidget,
                )
              ],
            ),
          ),
        );
      } else {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text('No se encontraron actividades'),
          ),
        );
      }
    }
  }

  Future<DateTime> _giveFecha(DateTime fechaActividad, DateTime fechaInicio,
      DateTime fechaFinal, int dias, int id) async {
    fechaActividad = await showDatePicker(
      context: context,
      initialDate: fechaActividad,
      errorFormatText: 'Error en el formato',
      errorInvalidText: 'Error en la fecha',
      fieldHintText: 'día/mes/año',
      fieldLabelText: 'Fecha de inicio de actividad',
      firstDate: fechaInicio,
      lastDate: fechaFinal,
    );
    return fechaActividad;
  }

  Widget _botonFlotante() {
    return SpeedDial(
      tooltip: 'Opciones',
      icon: Icons.more_vert,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.calendar_today),
          onTap: () => _saveActividades(),
          label: 'Ver calendario',
        ),
        SpeedDialChild(
          child: const Icon(Icons.download),
          onTap: () async {
            final data = await planesLogic.donwloadPDFPlanesEvento();

            if (data != null) {
              utils.downloadFile(data, 'Actividades_Evento');
            }
          },
          label: 'Descargar PDF',
        )
      ],
    );
  }

  void _goAddingPlanes() async {
    Navigator.of(context)
        .pushNamed('/agregarPlan', arguments: listaTimings)
        .then((_) async {
      _planesBloc.add(GetTimingsAndActivitiesEvent());
      await _planesLogic.getAllPlannes();
      await _planesLogic.getContadorValues(isInvolucrado);
      setState(() {});
    });
  }

  Future<void> _alertaBorrar(int idActividad, String nombre) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Estás por borrar una actividad.'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(child: Text('La actividad: $nombre')),
                const SizedBox(
                  height: 15.0,
                ),
                const Center(child: Text('¿Deseas confirmar?')),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Confirmar'),
              onPressed: () async {
                Navigator.of(context).pop();
                _planesBloc.add(BorrarActividadPlanEvent(idActividad));
                await _planesLogic.getAllPlannes();
                await _planesLogic.getContadorValues(isInvolucrado);
                setState(() {});
                MostrarAlerta(
                    mensaje: 'Actividad borrada',
                    tipoMensaje: TipoMensaje.correcto);
              },
            ),
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _saveActividades() {
    List<ActividadPlanner> send = [];

    // bool sinFechas = false;

    // listaTimings.forEach((tarea) {
    //   tarea.actividades.forEach((actividad) {
    //     if (actividad.estadoCalendarioActividad) sinFechas = true;
    //   });
    // });

    // if (sinFechas) {
    for (var tarea in listaTimings) {
      for (var actividad in tarea.actividades) {
        // if (actividad.estadoCalendarioActividad == true)
        send.add(ActividadPlanner(
            fechaInicioActividad: actividad.fechaInicioActividad,
            idActividadPlanner: actividad.idActividad,
            nombreActividadPlanner: actividad.nombreActividad,
            nombreResponsable: actividad.responsable,
            descripcionActividadPlanner: actividad.descripcionActividad,
            visibleInvolucradosActividadPlanner: actividad.visibleInvolucrado,
            diasActividadPlanner: actividad.diasActividad,
            predecesorActividadPlanner: actividad.predecesorActividad,
            fechaInicioEvento: actividad.fechaInicioEvento,
            fechaFinalEvento: actividad.fechaFinEvento,
            idOldActividad: actividad.idActividadOld,
            calendarActividad: actividad.estadoCalendarioActividad,
            checkActividadPlanner: actividad.estatusProgreso,
            nombreValida: true,
            descriValida: true));
      }
    }

    // agregamos a la base de datos
    Navigator.of(context).pushNamed('/calendarPlan', arguments: send);
    // } else {
    //   if (!sinFechas)
    //     _mensaje('No hay fechas');
    //   else
    //     _mensaje('Tienes cambios pendientes por guardar');
    // }
  }

  void _updateYselect() async {
    List<EventoActividadModel> send = [];

    for (var tarea in listaTimings) {
      send += [...tarea.actividades];
    }
    // fin ciclosi

    // filtro para enviar
    if (send.isNotEmpty) {
      setState(() {
        isEnableButton = false;
      }); // reset
      _planesBloc.add(UpdateActividadesEventoEvent(send));
      await _planesLogic.getAllPlannes();
      await _planesLogic.getContadorValues(isInvolucrado);

      // cambiamos x updateevent
    }
  }
}

class AddNuevaActividad extends StatefulWidget {
  final int idPlanner;
  final TimingModel plan;
  final int idActividad;
  final EventoActividadModel actividadModel;

  const AddNuevaActividad(
      {Key key,
      @required this.idPlanner,
      this.plan,
      this.idActividad,
      @required this.actividadModel})
      : super(key: key);

  @override
  _AddNuevaActividadState createState() => _AddNuevaActividadState();
}

class _AddNuevaActividadState extends State<AddNuevaActividad> {
  final keyForm = GlobalKey<FormState>();
  EventoActividadModel actividad;

  TextEditingController fechaInicioController = TextEditingController();
  TextEditingController fechaFinController = TextEditingController();
  List<EventoActividadModel> predecesores = [];

  @override
  void initState() {
    if (widget.actividadModel.idActividad != null) {
      actividad = widget.actividadModel;
      fechaInicioController.text = DateFormat.yMd()
          .add_jm()
          .format(widget.actividadModel.fechaInicioActividad);
      fechaFinController.text = DateFormat.yMd()
          .add_jm()
          .format(widget.actividadModel.fechaFinActividad);
    } else {
      actividad = EventoActividadModel(
        diasActividad: 1,
        visibleInvolucrado: false,
        estadoCalendarioActividad: false,
      );
      actividad.fechaInicioActividad =
          widget.plan.actividades.first.fechaInicioEvento;
      actividad.fechaFinActividad =
          widget.plan.actividades.first.fechaFinEvento;
      fechaInicioController.text = '';
      fechaFinController.text = '';
    }
    EventoActividadModel primeraOpcion = EventoActividadModel(
        nombreActividad: 'Seleccione un predecesor', idActividad: -1);
    predecesores = [primeraOpcion, ...widget.plan.actividades];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir actividad'),
      ),
      body: SingleChildScrollView(
        child: BlocListener<PlanesBloc, PlanesState>(
          listener: (context, state) {
            if (state is AddedActividadState) {
              if (state.isAdded) {
                MostrarAlerta(
                    mensaje: 'Se ha agregado la actividad',
                    tipoMensaje: TipoMensaje.correcto);
                Navigator.of(context).pop();
              } else {
                MostrarAlerta(
                    mensaje: 'Ocurrio un error',
                    tipoMensaje: TipoMensaje.correcto);
              }
            }
          },
          child: Form(
            key: keyForm,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: <Widget>[
                    TextFormFields(
                      icon: Icons.local_activity,
                      large: 500.0,
                      ancho: 80.0,
                      item: Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: TextFormField(
                          initialValue: actividad.nombreActividad,
                          validator: (value) {
                            if (value != null && value != '') {
                              return null;
                            } else {
                              return 'El campo es requerido';
                            }
                          },
                          decoration: const InputDecoration(
                            labelText: 'Nombre:',
                          ),
                          onChanged: (valor) {
                            actividad.nombreActividad = valor;
                          },
                        ),
                      ),
                    ),
                    TextFormFields(
                      icon: Icons.person_rounded,
                      large: 500.0,
                      ancho: 80.0,
                      item: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Responsable:',
                        ),
                        initialValue: actividad.responsable,
                        onChanged: (valor) {
                          actividad.responsable = valor;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: <Widget>[
                    TextFormFields(
                      icon: Icons.drive_file_rename_outline,
                      large: 500.0,
                      ancho: 80.0,
                      item: Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value != null && value != '') {
                              return null;
                            } else {
                              return 'El campo es requerido';
                            }
                          },
                          readOnly: true,
                          controller: fechaInicioController,
                          decoration: InputDecoration(
                              focusColor: Colors.black,
                              labelText: 'Fecha de Inicio',
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      final fecha = await showDatePicker(
                                        initialDate:
                                            (actividad.fechaInicioActividad !=
                                                    null)
                                                ? actividad.fechaInicioActividad
                                                : widget.plan.actividades.first
                                                    .fechaInicioEvento,
                                        context: context,
                                        firstDate: widget.plan.actividades.first
                                            .fechaInicioEvento,
                                        lastDate: widget.plan.actividades.first
                                            .fechaFinEvento,
                                        errorFormatText: 'Error en el formato',
                                        errorInvalidText: 'Error en la fecha',
                                        fieldHintText: 'día/mes/año',
                                        fieldLabelText:
                                            'Fecha de inicio de actividad',
                                      );
                                      if (fecha != null) {
                                        actividad.fechaInicioActividad =
                                            DateTime(
                                                fecha.year,
                                                fecha.month,
                                                fecha.day,
                                                actividad
                                                    .fechaInicioActividad.hour,
                                                actividad.fechaInicioActividad
                                                    .minute);
                                        fechaInicioController.text =
                                            DateFormat.yMd().add_jm().format(
                                                actividad.fechaInicioActividad);
                                        if (fechaFinController.text == '') {
                                          actividad.fechaFinActividad =
                                              DateTime(
                                                  actividad.fechaInicioActividad
                                                      .year,
                                                  actividad.fechaInicioActividad
                                                      .month,
                                                  actividad
                                                      .fechaInicioActividad.day,
                                                  actividad.fechaInicioActividad
                                                          .hour +
                                                      1,
                                                  actividad.fechaInicioActividad
                                                      .minute);
                                          fechaFinController.text =
                                              DateFormat.yMd().add_jm().format(
                                                  actividad.fechaFinActividad);
                                        } else {
                                          if (actividad.fechaInicioActividad
                                              .isAfter(actividad
                                                  .fechaFinActividad)) {
                                            actividad.fechaFinActividad =
                                                DateTime(
                                                    actividad
                                                        .fechaInicioActividad
                                                        .year,
                                                    actividad
                                                        .fechaInicioActividad
                                                        .month,
                                                    actividad
                                                        .fechaInicioActividad
                                                        .day,
                                                    actividad
                                                            .fechaInicioActividad
                                                            .hour +
                                                        1,
                                                    actividad
                                                        .fechaInicioActividad
                                                        .minute);
                                            fechaFinController.text =
                                                DateFormat.yMd()
                                                    .add_jm()
                                                    .format(actividad
                                                        .fechaFinActividad);
                                          }
                                        }
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.date_range,
                                      color: Colors.black,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      final time = await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay(
                                              hour: actividad
                                                  .fechaInicioActividad.hour,
                                              minute: actividad
                                                  .fechaInicioActividad
                                                  .microsecond));

                                      if (time != null) {
                                        actividad.fechaInicioActividad =
                                            DateTime(
                                                actividad
                                                    .fechaInicioActividad.year,
                                                actividad
                                                    .fechaInicioActividad.month,
                                                actividad
                                                    .fechaInicioActividad.day,
                                                time.hour,
                                                time.minute);

                                        if (actividad.fechaInicioActividad
                                            .isAfter(
                                                actividad.fechaFinActividad)) {
                                          actividad.fechaFinActividad =
                                              actividad
                                                  .fechaInicioActividad
                                                  .add(
                                                      const Duration(hours: 1));
                                          fechaFinController.text =
                                              DateFormat.yMd().add_jm().format(
                                                  actividad.fechaFinActividad);
                                        }

                                        fechaInicioController.text =
                                            DateFormat.yMd().add_jm().format(
                                                actividad.fechaInicioActividad);
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.more_time,
                                      color: Colors.black,
                                    ),
                                  )
                                ],
                              )),
                        ),
                      ),
                    ),
                    TextFormFields(
                      icon: Icons.drive_file_rename_outline,
                      large: 500.0,
                      ancho: 80.0,
                      item: Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value != null && value != '') {
                              return null;
                            } else {
                              return 'El campo es requerido';
                            }
                          },
                          readOnly: true,
                          controller: fechaFinController,
                          decoration: InputDecoration(
                              focusColor: Colors.black,
                              labelText: 'Fecha final',
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      final fecha = await showDatePicker(
                                        initialDate:
                                            (actividad.fechaInicioActividad !=
                                                    null)
                                                ? actividad.fechaInicioActividad
                                                : widget.plan.actividades.first
                                                    .fechaInicioEvento,
                                        context: context,
                                        firstDate: widget.plan.actividades.first
                                            .fechaInicioEvento,
                                        lastDate: widget.plan.actividades.first
                                            .fechaFinEvento,
                                        errorFormatText: 'Error en el formato',
                                        errorInvalidText: 'Error en la fecha',
                                        fieldHintText: 'día/mes/año',
                                        fieldLabelText:
                                            'Fecha fin de actividad',
                                      );
                                      if (fecha != null) {
                                        actividad.fechaFinActividad = DateTime(
                                            fecha.year,
                                            fecha.month,
                                            fecha.day,
                                            fecha.hour,
                                            fecha.minute);
                                        if (fechaFinController.text == '') {
                                          actividad.fechaInicioActividad =
                                              DateTime(
                                                  actividad
                                                      .fechaFinActividad.year,
                                                  actividad
                                                      .fechaFinActividad.month,
                                                  actividad
                                                      .fechaFinActividad.day,
                                                  actividad.fechaFinActividad
                                                          .hour -
                                                      1,
                                                  actividad.fechaFinActividad
                                                      .minute);

                                          fechaInicioController.text =
                                              DateFormat.yMd().add_jm().format(
                                                  actividad
                                                      .fechaInicioActividad);
                                        } else {
                                          if (actividad.fechaFinActividad
                                              .isBefore(actividad
                                                  .fechaInicioActividad)) {
                                            actividad.fechaInicioActividad =
                                                DateTime(
                                                    actividad
                                                        .fechaFinActividad.year,
                                                    actividad.fechaFinActividad
                                                        .month,
                                                    actividad
                                                        .fechaFinActividad.day,
                                                    actividad.fechaFinActividad
                                                            .hour -
                                                        1,
                                                    actividad.fechaFinActividad
                                                        .minute);
                                            fechaInicioController.text =
                                                DateFormat.yMd()
                                                    .add_jm()
                                                    .format(actividad
                                                        .fechaInicioActividad);
                                          }
                                        }
                                        fechaFinController.text =
                                            DateFormat.yMd().add_jm().format(
                                                actividad.fechaFinActividad);
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.date_range,
                                      color: Colors.black,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      final time = await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay(
                                              hour: actividad
                                                  .fechaFinActividad.hour,
                                              minute: actividad
                                                  .fechaFinActividad.minute));

                                      if (time != null) {
                                        actividad.fechaFinActividad = DateTime(
                                            actividad.fechaFinActividad.year,
                                            actividad.fechaFinActividad.month,
                                            actividad.fechaFinActividad.day,
                                            time.hour,
                                            time.minute);

                                        if (fechaInicioController.text == '') {
                                          actividad.fechaInicioActividad =
                                              DateTime(
                                                  actividad
                                                      .fechaFinActividad.year,
                                                  actividad
                                                      .fechaFinActividad.month,
                                                  actividad
                                                      .fechaFinActividad.day,
                                                  actividad.fechaFinActividad
                                                          .hour -
                                                      1,
                                                  actividad.fechaFinActividad
                                                      .minute);

                                          fechaInicioController.text =
                                              DateFormat.yMd().add_jm().format(
                                                  actividad
                                                      .fechaInicioActividad);
                                        } else {
                                          if (actividad.fechaFinActividad
                                              .isBefore(actividad
                                                  .fechaInicioActividad)) {
                                            actividad.fechaInicioActividad =
                                                DateTime(
                                                    actividad
                                                        .fechaFinActividad.year,
                                                    actividad.fechaFinActividad
                                                        .month,
                                                    actividad
                                                        .fechaFinActividad.day,
                                                    actividad.fechaFinActividad
                                                            .hour -
                                                        1,
                                                    actividad.fechaFinActividad
                                                        .minute);

                                            fechaInicioController.text =
                                                DateFormat.yMd()
                                                    .add_jm()
                                                    .format(actividad
                                                        .fechaInicioActividad);
                                          }
                                        }

                                        fechaFinController.text =
                                            DateFormat.yMd().add_jm().format(
                                                actividad.fechaFinActividad);
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.more_time,
                                      color: Colors.black,
                                    ),
                                  )
                                ],
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    TextFormFields(
                      icon: Icons.remove_red_eye,
                      large: 500.0,
                      ancho: 80,
                      item: CheckboxListTile(
                        title: const Text('Visible para novios:'),
                        controlAffinity: ListTileControlAffinity.platform,
                        value: actividad.visibleInvolucrado,
                        onChanged: (valor) {
                          setState(
                            () {
                              actividad.visibleInvolucrado = valor;
                            },
                          );
                        },
                      ),
                    ),
                    TextFormFields(
                      icon: Icons.linear_scale_outlined,
                      large: 500,
                      ancho: 80,
                      item: DropdownButton(
                        isExpanded: true,
                        value: actividad.predecesorActividad ?? -1,
                        icon: const Icon(Icons.arrow_drop_down_outlined),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: Color(0xFF000000)),
                        underline: Container(
                          height: 2,
                          color: const Color(0xFF000000),
                        ),
                        onChanged: (valor) {
                          setState(() {
                            if (valor != -1) {
                              actividad.predecesorActividad = valor;
                            } else {
                              actividad.predecesorActividad = null;
                            }
                          });
                        },
                        items: predecesores.map(
                          (item) {
                            return DropdownMenuItem(
                              value: item.idActividad,
                              child: Text(
                                item.nombreActividad,
                                style: const TextStyle(fontSize: 18),
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ],
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    TextFormFields(
                      icon: Icons.drive_file_rename_outline,
                      large: 500.0,
                      ancho: 80.0,
                      item: TextFormField(
                        initialValue: actividad.descripcionActividad,
                        decoration: const InputDecoration(
                          labelText: 'Descripción:',
                        ),
                        onChanged: (valor) {
                          actividad.descripcionActividad = valor;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: PointerInterceptor(
                      child: ElevatedButton(
                        child: const Tooltip(
                          child: Icon(Icons.save_sharp),
                          message: "Agregar actividad.",
                        ),
                        onPressed: () async {
                          if (keyForm.currentState.validate()) {
                            if (widget.actividadModel.idActividad != null) {
                              BlocProvider.of<PlanesBloc>(context)
                                  .add(EditActividadEvent(actividad));
                            } else {
                              BlocProvider.of<PlanesBloc>(context).add(
                                AddNewActividadEvent(
                                    actividad, widget.plan.idPlanner),
                              );
                            }
                          } else {
                            MostrarAlerta(
                                mensaje:
                                    'Inserte datos en los campos requeridos',
                                tipoMensaje: TipoMensaje.advertencia);
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

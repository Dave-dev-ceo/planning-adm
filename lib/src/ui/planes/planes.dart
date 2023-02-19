// import flutter/dart
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/logic/actividades_logic/archivo_actividad_logic.dart';
import 'package:planning/src/logic/planes_logic.dart';
import 'package:planning/src/models/Planes/planes_model.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/ui/planes/ver_archivo_dialog.dart';
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
  int? idTareaPlanner;
  String? nombreTareaPlanner;
  DateTime? fechaInicioEvento;
  DateTime? fechaFinalEvento;
  int? idTareaOld;
  bool? checkTarePlanner;
  bool? expandedTarePlanner;
  int? progreso;
  bool? botonAdd;
  List<ActividadPlanner>? actividadTareaPlanner;

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
  int? idActividadPlanner;
  String? nombreActividadPlanner;
  String? nombreResponsable;
  String? descripcionActividadPlanner;
  bool? visibleInvolucradosActividadPlanner;
  int? diasActividadPlanner;
  int? predecesorActividadPlanner;
  DateTime? fechaInicioActividad;
  DateTime? fechaInicioEvento;
  DateTime? fechaFinalEvento;
  int? idOldActividad;
  bool? calendarActividad;
  bool? checkActividadPlanner;
  bool? nombreValida;
  bool? descriValida;

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
  const PlanesPage({Key? key}) : super(key: key);

  @override
  _PlanesPageState createState() => _PlanesPageState();
}

class _PlanesPageState extends State<PlanesPage> with TickerProviderStateMixin {
  late PlanesBloc _planesBloc;
  ConsultasPlanesLogic planesLogic = ConsultasPlanesLogic();
  final ActividadesEvento _planesLogic = ActividadesEvento();
  final ArchivoActividadLogic archivoLogic = ArchivoActividadLogic();

  List<TimingModel>? listaTimings = [];

  int index = 0;
  Size? size;
  bool isEnableButton = false;
  String? claveRol;

  @override
  void initState() {
    _planesBloc = BlocProvider.of<PlanesBloc>(context);
    _planesBloc.add(GetTimingsAndActivitiesEvent());
    getIdInvolucrado();

    super.initState();
  }

  Future<void> getIdInvolucrado() async {
    final data = await SharedPreferencesT().getClaveRol();

    setState(() {
      claveRol = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: (claveRol == 'INVO')
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
                  height: 15.0,
                ),
                contadorActividadesWidget(size),
                const SizedBox(
                  height: 10.0,
                ),
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
                    if (claveRol != 'INVO')
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
                      return buildListActividades();
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

  StreamBuilder<ContadorActividadesModel> contadorActividadesWidget(Size? size) {
    _planesLogic.getContadorValues(claveRol == 'INVO' ? true : false);

    return StreamBuilder(
      stream: _planesLogic.contadorActividadStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.total! > 0) {
            return Column(
              children: [
                if (size!.width > 400)
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
                          '${snapshot.data!.completadas.toString()} Completadas'),
                      const Spacer(),
                      Theme(
                        data: ThemeData(disabledColor: Colors.yellow[800]),
                        child: const Checkbox(
                          value: false,
                          onChanged: null,
                        ),
                      ),
                      Text('${snapshot.data!.pendientes.toString()} En curso'),
                      const Spacer(),
                      Theme(
                        data: ThemeData(disabledColor: Colors.red),
                        child: const Checkbox(
                          value: false,
                          onChanged: null,
                        ),
                      ),
                      Text('${snapshot.data!.atrasadas.toString()} Atrasadas'),
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
                    Text('${snapshot.data!.completadas.toString()} Completadas'),
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
                    Text('${snapshot.data!.pendientes.toString()} En Curso'),
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
                    Text('${snapshot.data!.atrasadas.toString()} Atrasadas'),
                  ]),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                    'Progreso ${((snapshot.data!.completadas! / snapshot.data!.total!) * 100).toStringAsFixed(0)}%'),
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
                        value: snapshot.data!.completadas! / snapshot.data!.total!,
                        semanticsLabel: 'Linear progress indicator',
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Text('Total: ${snapshot.data!.total}')
              ],
            );
          }
        }
        if (size!.width > 400) {
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
              const Text('En Curso'),
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
              const Text('En curso'),
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

  Widget buildListActividades() {
    List<Widget> listActividadesWidget = [];

    Widget card;
    List<EventoActividadModel> actividades = [];

    if (listaTimings!.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(15.0),
        child: Center(
          child: Text('No se encontraron actividades'),
        ),
      );
    } else {
      DateTime? fechaInicio =
          listaTimings!.first.actividades!.first.fechaInicioEvento;
      DateTime? fechaFin = listaTimings!.first.actividades!.first.fechaFinEvento;
      int? idTiming = listaTimings!.last.idPlanner;

      for (TimingModel timing in listaTimings!) {
        actividades += [...timing.actividades!];
      }

      actividades.sort((a, b) => b.fechaInicioActividad!
          .compareTo(a.fechaInicioActividad!.add(const Duration(hours: 1))));

      Widget header = ListTile(
        leading: const Text('Estatus'),
        title: Row(
          children: [
            const Expanded(
              flex: 4,
              child: Text(
                'Actividad',
              ),
            ),
            if (claveRol != 'INVO')
              const Expanded(
                  flex: 1,
                  child: Text(
                    'Visible ',
                  )),
            const Expanded(
              flex: 2,
              child: Text('Responsable'),
            ),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  'Inicio',
                ),
              ),
              flex: 1,
            ),
            const Expanded(
              child: Text('Acción'),
              flex: 1,
            )
          ],
        ),
      );
      if (size!.width > 720) {
        listActividadesWidget.add(header);
      }

      for (EventoActividadModel actividad in actividades) {
        if (claveRol == 'INVO') {
          if (actividad.visibleInvolucrado!) {
            listActividadesWidget.add(size!.width > 720
                ? listileActividad(actividad)
                : buildActividaWidgetdMovil(actividad));
          }
        } else {
          listActividadesWidget.add(size!.width > 720
              ? listileActividad(actividad)
              : buildActividaWidgetdMovil(actividad));
        }
      }

      card = Card(
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
              if (claveRol != 'INVO')
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AddNuevaActividad(
                            idTiming: idTiming,
                            fechaFinEvento: fechaFin,
                            fechaInicioEvento: fechaInicio,
                            actividadModel: EventoActividadModel(),
                          ),
                        ).then((_) async {
                          await _planesLogic.getAllPlannes();
                          await _planesLogic
                              .getContadorValues(claveRol == 'INVO');
                          setState(() {});
                        });
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Agregar actividad'),
                    ),
                  ),
                ),
              const SizedBox(
                height: 10.0,
              ),
              for (Widget child in listActividadesWidget) child
            ],
          ),
        ),
      );

      if (listActividadesWidget.isNotEmpty) {
        return card;
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

  Widget buildActividaWidgetdMovil(EventoActividadModel actividad) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      elevation: 10,
      child: ExpansionTile(
        textColor: Colors.black,
        leading: Theme(
          data: ThemeData(
              primarySwatch: Colors.green,
              unselectedWidgetColor: actividad.estatus == 'En Curso'
                  ? Colors.yellow[800]
                  : Colors.red),
          child: Checkbox(
            value: actividad.estatusProgreso,
            onChanged: (value) {
              setState(
                () {
                  isEnableButton = true;
                  actividad.estatusProgreso = value;
                  if (actividad.estatusProgreso!) {
                    actividad.estatus = 'Completada';
                  }
                },
              );
            },
          ),
        ),
        subtitle: Text(actividad.descripcionActividad!),
        title: GestureDetector(
          onTap: claveRol == 'INVO'
              ? null
              : () {
                  showDialog(
                    context: context,
                    builder: (context) => AddNuevaActividad(
                      fechaFinEvento: actividad.fechaFinEvento,
                      fechaInicioEvento: actividad.fechaInicioEvento,
                      actividadModel: actividad,
                    ),
                  ).then((_) async {
                    await _planesLogic.getAllPlannes();
                    await _planesLogic.getContadorValues(claveRol == 'INVO');
                    setState(() {});
                  });
                },
          child: AutoSizeText(
            actividad.nombreActividad!,
            maxLines: 2,
          ),
        ),
        children: [
          if (claveRol != 'INVO')
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Text('Visible:'),
                  const SizedBox(
                    width: 10.0,
                  ),
                  FaIcon(
                    actividad.visibleInvolucrado!
                        ? FontAwesomeIcons.eye
                        : FontAwesomeIcons.eyeSlash,
                    size: 15.0,
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('Responsable: ' +
                    (actividad.responsable ?? 'Sin responsable')),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Text('Inicio:'),
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: AutoSizeText(
                      '${actividad.fechaInicioActividad!.day}/${actividad.fechaInicioActividad!.month}/${actividad.fechaInicioActividad!.year}',
                      maxLines: 1,
                      wrapWords: false,
                    ),
                  ),
                  onTap: claveRol != 'INVO'
                      ? () async {
                          final data = await _giveFecha(
                            actividad.fechaInicioActividad!,
                            actividad.fechaInicioEvento!,
                            actividad.fechaFinEvento!,
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

                              if (fecha.isAfter(DateTime.now()) ||
                                  fecha.isAtSameMomentAs(DateTime.now())) {
                                actividad.estatus = 'En Curso';
                              } else if (fecha.isBefore(DateTime.now())) {
                                actividad.estatus = 'Atrasada';
                              } else {
                                actividad.estatus = 'En Curso';
                              }

                              actividad.fechaInicioActividad = fecha;
                              actividad.estadoCalendarioActividad = true;
                            }
                          });
                        }
                      : null,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                const Text('Acción:'),
                if (actividad.haveArchivo!)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      child: const Tooltip(
                        message: 'Ver archivo',
                        child: Icon(Icons.file_present_rounded),
                      ),
                      onTap: () async {
                        showDialog(
                            context: context,
                            builder: (context) => DialogArchivoActividad(
                                  nombreActividad: actividad.nombreActividad,
                                  idActividad: actividad.idActividad,
                                ));
                      },
                    ),
                  ),
                if (claveRol != 'INVO')
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      child: const Tooltip(
                        message: 'Eliminar actividad',
                        child: Icon(Icons.delete),
                      ),
                      onTap: () async {
                        await _alertaBorrar(
                            actividad.idActividad, actividad.nombreActividad);
                        _planesLogic.getAllPlannes();
                        _planesLogic.getContadorValues(claveRol == 'INVO');
                        setState(() {});
                      },
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }

  ListTile listileActividad(EventoActividadModel actividad) {
    return ListTile(
      leading: Theme(
        data: ThemeData(
            primarySwatch: Colors.green,
            unselectedWidgetColor: actividad.estatus == 'En Curso'
                ? Colors.yellow[800]
                : Colors.red),
        child: Checkbox(
          value: actividad.estatusProgreso,
          onChanged: (value) {
            setState(
              () {
                isEnableButton = true;
                actividad.estatusProgreso = value;
                if (actividad.estatusProgreso!) {
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
              onTap: claveRol == 'INVO'
                  ? null
                  : () {
                      showDialog(
                        context: context,
                        builder: (context) => AddNuevaActividad(
                          fechaFinEvento: actividad.fechaFinEvento,
                          fechaInicioEvento: actividad.fechaInicioEvento,
                          actividadModel: actividad,
                        ),
                      ).then((_) async {
                        await _planesLogic.getAllPlannes();
                        await _planesLogic
                            .getContadorValues(claveRol == 'INVO');
                        setState(() {});
                      });
                    },
              child: AutoSizeText(
                actividad.nombreActividad!,
                maxLines: 2,
              ),
            ),
          ),
          if (claveRol != 'INVO')
            Expanded(
              flex: 1,
              child: FaIcon(
                actividad.visibleInvolucrado!
                    ? FontAwesomeIcons.eye
                    : FontAwesomeIcons.eyeSlash,
                size: 15.0,
              ),
            ),
          Expanded(
            flex: 2,
            child: Text(actividad.responsable ?? 'Sin responsable'),
          ),
          Expanded(
            child: GestureDetector(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: AutoSizeText(
                  '${actividad.fechaInicioActividad!.day}/${actividad.fechaInicioActividad!.month}/${actividad.fechaInicioActividad!.year}',
                  maxLines: 1,
                  wrapWords: false,
                ),
              ),
              onTap: claveRol != 'INVO'
                  ? () async {
                      final data = await _giveFecha(
                        actividad.fechaInicioActividad!,
                        actividad.fechaInicioEvento!,
                        actividad.fechaFinEvento!,
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
                            actividad.estatus = 'En Curso';
                          } else if (fecha.isBefore(DateTime.now())) {
                            actividad.estatus = 'Atrasada';
                          } else {
                            actividad.estatus = 'En Curso';
                          }

                          actividad.fechaInicioActividad = fecha;
                          actividad.estadoCalendarioActividad = true;
                        }
                      });
                    }
                  : null,
            ),
            flex: 1,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: claveRol == 'INVO'
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (actividad.haveArchivo!)
                  GestureDetector(
                    child: const Tooltip(
                      message: 'Ver archivo',
                      child: Icon(Icons.file_present_rounded),
                    ),
                    onTap: () async {
                      showDialog(
                          context: context,
                          builder: (context) => DialogArchivoActividad(
                                nombreActividad: actividad.nombreActividad,
                                idActividad: actividad.idActividad,
                              ));
                    },
                  ),
                if (claveRol != 'INVO')
                  GestureDetector(
                    child: const Tooltip(
                      message: 'Eliminar actividad',
                      child: Icon(Icons.delete),
                    ),
                    onTap: () async {
                      await _alertaBorrar(
                          actividad.idActividad, actividad.nombreActividad);
                      _planesLogic.getAllPlannes();
                      _planesLogic.getContadorValues(claveRol == 'INVO');
                      setState(() {});
                    },
                  ),
                const SizedBox(
                  width: 8.0,
                ),
              ],
            ),
            flex: 1,
          )
        ],
      ),
      subtitle: Text(actividad.descripcionActividad ?? ''),
    );
  }

  Future<DateTime?> _giveFecha(DateTime fechaActividad, DateTime fechaInicio,
      DateTime fechaFinal, int? id) async {
    fechaActividad = (await showDatePicker(
      context: context,
      initialDate: fechaActividad,
      errorFormatText: 'Error en el formato',
      errorInvalidText: 'Error en la fecha',
      fieldHintText: 'día/mes/año',
      fieldLabelText: 'Fecha de inicio de actividad',
      firstDate: fechaInicio,
      lastDate: fechaFinal,
    ))!;
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
      await _planesLogic.getContadorValues(claveRol == 'INVO');
      setState(() {});
    });
  }

  Future<void> _alertaBorrar(int? idActividad, String? nombre) {
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
                MostrarAlerta(
                    mensaje: 'Actividad borrada',
                    tipoMensaje: TipoMensaje.correcto);
                Navigator.of(context, rootNavigator: true).pop();
                _planesBloc.add(BorrarActividadPlanEvent(idActividad));
                await _planesLogic.getAllPlannes();
                await _planesLogic.getContadorValues(claveRol == 'INVO');
                setState(() {});
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
    for (var tarea in listaTimings!) {
      for (var actividad in tarea.actividades!) {
        // if (actividad.estadoCalendarioActividad == true)
        send.add(ActividadPlanner(
            fechaInicioActividad: actividad.fechaInicioActividad,
            idActividadPlanner: actividad.idActividad,
            nombreActividadPlanner: actividad.nombreActividad,
            nombreResponsable: actividad.responsable,
            descripcionActividadPlanner: actividad.descripcionActividad,
            visibleInvolucradosActividadPlanner: actividad.visibleInvolucrado,
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

    for (var tarea in listaTimings!) {
      send += [...tarea.actividades!];
    }
    // fin ciclosi

    // filtro para enviar
    if (send.isNotEmpty) {
      setState(() {
        isEnableButton = false;
      }); // reset
      _planesBloc.add(UpdateActividadesEventoEvent(send));
      await _planesLogic.getAllPlannes();
      await _planesLogic.getContadorValues(claveRol == 'INVO');

      // cambiamos x updateevent
    }
  }
}

class AddNuevaActividad extends StatefulWidget {
  final DateTime? fechaInicioEvento;
  final DateTime? fechaFinEvento;
  final EventoActividadModel actividadModel;
  final int? idTiming;

  const AddNuevaActividad(
      {Key? key,
      required this.actividadModel,
      required this.fechaInicioEvento,
      required this.fechaFinEvento,
      this.idTiming})
      : super(key: key);

  @override
  _AddNuevaActividadState createState() => _AddNuevaActividadState();
}

class _AddNuevaActividadState extends State<AddNuevaActividad> {
  final keyForm = GlobalKey<FormState>();
  EventoActividadModel? actividad;

  final ArchivoActividadLogic archivoLogic = ArchivoActividadLogic();

  TextEditingController fechaInicioController = TextEditingController();
  List<EventoActividadModel> predecesores = [];
  String? archivo;
  String? tipoMime;

  @override
  void initState() {
    if (widget.actividadModel.idActividad != null) {
      if (widget.actividadModel.haveArchivo!) {
        getArchivo();
      }

      actividad = widget.actividadModel;
      fechaInicioController.text = DateFormat.yMd()
          .add_jm()
          .format(widget.actividadModel.fechaInicioActividad!);
    } else {
      actividad = EventoActividadModel(
        visibleInvolucrado: false,
        estadoCalendarioActividad: false,
      );
      actividad!.fechaInicioActividad = widget.fechaInicioEvento;
      fechaInicioController.text = '';
    }
    super.initState();
  }

  void getArchivo() async {
    archivoLogic
        .obtenerArchivoActividad(widget.actividadModel.idActividad, false)
        .then((value) {
      if (value != null) {
        archivo = value['archivo'];
        tipoMime = value['tipo_mime'];
      }
    });
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
                Navigator.of(context, rootNavigator: true).pop();
                MostrarAlerta(
                    mensaje: widget.actividadModel.idActividad == null
                        ? 'Se ha agregado la actividad'
                        : 'Se ha editado la actividad',
                    tipoMensaje: TipoMensaje.correcto);
              } else {
                MostrarAlerta(
                    mensaje: 'Ocurrió un error',
                    tipoMensaje: TipoMensaje.error);
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
                          initialValue: actividad!.nombreActividad,
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
                            actividad!.nombreActividad = valor;
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
                        initialValue: actividad!.responsable,
                        onChanged: (valor) {
                          actividad!.responsable = valor;
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
                              labelText: 'Fecha de inicio',
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      final fecha = await showDatePicker(
                                        initialDate:
                                            (actividad!.fechaInicioActividad !=
                                                    null)
                                                ? actividad!.fechaInicioActividad!
                                                : widget.fechaInicioEvento!,
                                        context: context,
                                        firstDate: widget.fechaInicioEvento!,
                                        lastDate: widget.fechaFinEvento!,
                                        errorFormatText: 'Error en el formato',
                                        errorInvalidText: 'Error en la fecha',
                                        fieldHintText: 'día/mes/año',
                                        fieldLabelText:
                                            'Fecha de inicio de actividad',
                                      );
                                      if (fecha != null) {
                                        actividad!.fechaInicioActividad =
                                            DateTime(
                                                fecha.year,
                                                fecha.month,
                                                fecha.day,
                                                actividad!
                                                    .fechaInicioActividad!.hour,
                                                actividad!.fechaInicioActividad!
                                                    .minute);
                                        fechaInicioController.text =
                                            DateFormat.yMd().add_jm().format(
                                                actividad!.fechaInicioActividad!);
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
                                              hour: actividad!
                                                  .fechaInicioActividad!.hour,
                                              minute: actividad!
                                                  .fechaInicioActividad!
                                                  .microsecond));

                                      if (time != null) {
                                        actividad!.fechaInicioActividad =
                                            DateTime(
                                                actividad!
                                                    .fechaInicioActividad!.year,
                                                actividad!
                                                    .fechaInicioActividad!.month,
                                                actividad!
                                                    .fechaInicioActividad!.day,
                                                time.hour,
                                                time.minute);

                                        fechaInicioController.text =
                                            DateFormat.yMd().add_jm().format(
                                                actividad!.fechaInicioActividad!);
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
                        title: const Text('Visible para involucrados:'),
                        controlAffinity: ListTileControlAffinity.platform,
                        value: actividad!.visibleInvolucrado,
                        onChanged: (valor) {
                          setState(
                            () {
                              actividad!.visibleInvolucrado = valor;
                            },
                          );
                        },
                      ),
                    ),
                    TextFormFields(
                      icon: Icons.drive_file_rename_outline,
                      large: 500.0,
                      ancho: 80.0,
                      item: TextFormField(
                        initialValue: actividad!.descripcionActividad,
                        decoration: const InputDecoration(
                          labelText: 'Comentarios:',
                        ),
                        onChanged: (valor) {
                          actividad!.descripcionActividad = valor;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15.0,
                ),
                ElevatedButton(
                  onPressed: () async {
                    const extensiones = ['jpg', 'png', 'jpeg', 'pdf'];
                    FilePickerResult? pickedFile =
                        await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      withData: true,
                      allowedExtensions: extensiones,
                      allowMultiple: false,
                    );

                    if (pickedFile != null) {
                      archivo = base64Encode(pickedFile.files.single.bytes!);
                      tipoMime = pickedFile.files.single.extension;

                      MostrarAlerta(
                        mensaje:
                            'Archivo seleccionado: ${pickedFile.files.single.name}',
                        tipoMensaje: TipoMensaje.correcto,
                      );
                    }
                  },
                  child: const Text('Subir archivo'),
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
                          if (keyForm.currentState!.validate()) {
                            if (widget.actividadModel.idActividad != null) {
                              BlocProvider.of<PlanesBloc>(context).add(
                                EditActividadEvent(
                                  actividad,
                                  archivo,
                                  tipoMime,
                                ),
                              );
                            } else {
                              BlocProvider.of<PlanesBloc>(context).add(
                                AddNewActividadEvent(actividad, widget.idTiming,
                                    archivo, tipoMime),
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

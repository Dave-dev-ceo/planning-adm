// imports dart/flutter
// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/models/Planes/planes_model.dart';
import 'package:planning/src/ui/widgets/snackbar_widget/snackbar_widget.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

// blocs
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/blocs/planes/planes_bloc.dart';

//model
import 'package:planning/src/models/item_model_planes.dart';

class AgregarPlanes extends StatefulWidget {
  final List<TimingModel>? lista;
  const AgregarPlanes({Key? key, required this.lista}) : super(key: key);

  @override
  _AgregarPlanesState createState() => _AgregarPlanesState();
}

class _AgregarPlanesState extends State<AgregarPlanes> {
  // variables bloc
  late PlanesBloc _planesBloc;

  // variable model
  ItemModelPlanes? _itemModel;
  DateTime? fechaEvento;
  DateTime? fechaInicio;

  // variables class
  late List<TareaPlanner> _listTare;
  final String _condicionQuery = 'AND ea.estatus_calendar = true';

  @override
  void initState() {
    super.initState();
    // cargamos el bloc
    _planesBloc = BlocProvider.of<PlanesBloc>(context);
    _planesBloc.add(SelectPlanesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return _crearScaffold();
  }

  // creo el scaffold muestra la vista - v1
  Widget _crearScaffold() {
    return WillPopScope(
      onWillPop: () async {
        _planesBloc.add(GetTimingsAndActivitiesEvent());
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lista de planes'),
        ),
        body: _buildBloc(),
      ),
    );
  }

  // bloc principal
  Widget _buildBloc() {
    return BlocBuilder<PlanesBloc, PlanesState>(builder: (context, state) {
      // state ini
      if (state is InitiaPlaneslState) {
        return const Center(child: LoadingCustom());
      } else if (state is LodingPlanesState) {
        return const Center(child: LoadingCustom());
      } else if (state is SelectPlanesState) {
        // evita que se reescriba la lista
        if (state.planes != null) {
          if (_itemModel != state.planes) {
            _itemModel = state.planes;
            if (_itemModel != null) {
              fechaEvento = state.fechaEvento;
              fechaInicio = state.fechaInicio;
              if (widget.lista!.isNotEmpty) {
                _listTare = _crearListaEditableConDatos(_itemModel!);
              } else {
                _listTare = _crearListaEditableSinDatos(_itemModel!);
              }
            }
          }
        } else {
          _planesBloc.add(SelectPlanesEvent());
          return const Center(child: LoadingCustom());
        }
        if (_itemModel != null) {
          return _crearStickyHeader(_itemModel!);
        } else {
          return const Center(child: Text('Sin datos'));
        }
      }
      // state create
      else if (state is CreatePlanesState) {
        _planesBloc.add(GetTimingsAndActivitiesEvent());
        return _crearStickyHeader(_itemModel!);
      }
      // no state
      else {
        return const Center(child: LoadingCustom());
      }
    });
  }

  // creo el StickyHeader
  Widget _crearStickyHeader(ItemModelPlanes model) {
    return Container(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          child: ListView(
            children: [
              StickyHeader(
                header: _header(),
                content: _content(model),
              ),
            ],
          ),
        ));
  }

  // header
  Container _header() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      width: double.infinity,
      color: Colors.white,
      child: const Text(
        'Selecciona los planes para tu evento',
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }

  // contetnt
  Container _content(ItemModelPlanes model) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _crearViewExpanded(model),
          const SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
            child: const Text('Agregar'),
            onPressed:
                widget.lista!.isNotEmpty ? _eventoAgregarData : _eventoAgregar,
          ),
        ],
      ),
    );
  }

  // pasamos el model a una lista sino hay datos en la anterior vista
  List<TareaPlanner> _crearListaEditableSinDatos(ItemModelPlanes model) {
    List<TareaPlanner> tempTarea = []; // variable temporal 1° ciclo

    // ciclo para separar tareas
    for (int i = 0; i < model.planes.length; i++) {
      List<ActividadAgregarPlanner> tempActividad =
          []; // cariable temporal 2° ciclo

      // ciclo para separar actividades
      for (int j = 0; j < model.planes.length; j++) {
        // junta las actividades de cada tarea en una lista
        if (model.planes[i].idPlan == model.planes[j].idPlan) {
          tempActividad.add(ActividadAgregarPlanner(
            idActividadPlanner: model.planes[j].idActividad,
            nombreActividadPlanner: model.planes[j].nombreActividad,
            descripcionActividadPlanner: model.planes[j].descripcionActividad,
            visibleInvolucradosActividadPlanner:
                model.planes[j].visibleInvolucradosActividad,
            diasActividadPlanner: model.planes[j].duracionActividad,
            predecesorActividadPlanner: model.planes[j].predecesorActividad,
            isEvento: false,
            checkActividadPlanner: false,
            tiempoAntes: model.planes[j].tiempoAntes,
          ));
        }
      }

      // juntando las tareas con sus actividades
      if (i == 0) {
        tempTarea.add(TareaPlanner(
            idTareaPlanner: model.planes[i].idPlan,
            nombreTareaPlanner: model.planes[i].nombrePlan,
            isEvento: false,
            checkTarePlanner: false,
            expandedTarePlanner: false,
            actividadTareaPlanner: tempActividad));
      } else {
        if (model.planes[i].idPlan != model.planes[(i - 1)].idPlan) {
          tempTarea.add(TareaPlanner(
              idTareaPlanner: model.planes[i].idPlan,
              nombreTareaPlanner: model.planes[i].nombrePlan,
              isEvento: false,
              checkTarePlanner: false,
              expandedTarePlanner: false,
              actividadTareaPlanner: tempActividad));
        }
      }
    }

    return tempTarea; // enviamos la lista
  }

  // pasamos el model a una lista con los datos de la anterior vista || revisar en el metodo anterior se puede hacer esto
  List<TareaPlanner> _crearListaEditableConDatos(ItemModelPlanes model) {
    List<TareaPlanner> tempTarea = []; // variable temporal 1° ciclo

    // ciclo para separar tareas
    for (int i = 0; i < model.planes.length; i++) {
      List<ActividadAgregarPlanner> tempActividad =
          []; // cariable temporal 2° ciclo

      // ciclo para separar actividades
      for (int j = 0; j < model.planes.length; j++) {
        // junta las actividades de cada tarea en una lista
        if (model.planes[i].idPlan == model.planes[j].idPlan) {
          tempActividad.add(ActividadAgregarPlanner(
            idActividadPlanner: model.planes[j].idActividad,
            nombreActividadPlanner: model.planes[j].nombreActividad,
            descripcionActividadPlanner: model.planes[j].descripcionActividad,
            visibleInvolucradosActividadPlanner:
                model.planes[j].visibleInvolucradosActividad,
            predecesorActividadPlanner: model.planes[j].predecesorActividad,
            isEvento: false,
            checkActividadPlanner: false,
            tiempoAntes: model.planes[j].tiempoAntes,
          ));
        }
      }

      // juntando las tareas con sus actividades
      if (i == 0) {
        tempTarea.add(TareaPlanner(
          idTareaPlanner: model.planes[i].idPlan,
          nombreTareaPlanner: model.planes[i].nombrePlan,
          checkTarePlanner: false,
          expandedTarePlanner: false,
          isEvento: false,
          actividadTareaPlanner: tempActividad,
        ));
      } else {
        if (model.planes[i].idPlan != model.planes[(i - 1)].idPlan) {
          tempTarea.add(TareaPlanner(
            idTareaPlanner: model.planes[i].idPlan,
            nombreTareaPlanner: model.planes[i].nombrePlan,
            checkTarePlanner: false,
            expandedTarePlanner: false,
            isEvento: false,
            actividadTareaPlanner: tempActividad,
          ));
        }
      }
    }

    for (var tareaHere in tempTarea) {
      for (var tareaThere in widget.lista!) {
        if (tareaThere.idPlanerOld == tareaHere.idTareaPlanner) {
          tareaHere.idTareaPlanner = tareaThere.idPlanner;
          tareaHere.checkTarePlanner = true;
          tareaHere.isEvento = true;

          for (var actividadHere in tareaHere.actividadTareaPlanner!) {
            for (var actividadThere in tareaThere.actividades!) {
              if (actividadHere.idActividadPlanner ==
                  actividadThere.idActividadOld) {
                actividadHere.idActividadPlanner =
                    actividadThere.idActividadOld;
                actividadHere.checkActividadPlanner = true;
                actividadHere.isEvento = true;
                actividadHere.tiempoAntes = actividadThere.tiempoAntes;
              }
            }
          }
        }
      }
    }

    return tempTarea; // enviamos la lista
  }

  // creamos una promesa de una lista
  Future<List<TareaPlanner>> _promiseList(ItemModelPlanes model) async {
    if (widget.lista!.isNotEmpty) {
      return _crearListaEditableSinDatos(model);
    } else {
      return _crearListaEditableConDatos(model);
    }
  }

  // creamos los expandeds
  List<ExpansionPanel> _buildListExpanded(List<TareaPlanner>? list) {
    List<ExpansionPanel> listExpanded = []; // variable con la lista de expanded

    // ciclo para generar mis widgets padres
    for (TareaPlanner tarea in _listTare) {
      List<Widget> listWidget = []; // variable con los hijos del expanded

      // ciclo para generar los hijos
      for (ActividadAgregarPlanner actividad in tarea.actividadTareaPlanner!) {
        // agregamos items a la lista widget
        listWidget.add(ListTile(
          leading: Checkbox(
            value: actividad.checkActividadPlanner,
            onChanged: (valor) {
              DateTime fechaTemp = DateTime(
                fechaEvento!.year,
                fechaEvento!.month - actividad.tiempoAntes!,
                fechaEvento!.day,
                10,
              );

              if (fechaTemp.isBefore(fechaInicio!)) {
                MostrarAlerta(
                    mensaje:
                        'La actividad no puede ser antes de la fecha de planeación del evento',
                    tipoMensaje: TipoMensaje.advertencia);
              } else {
                actividad.fechaInicio = fechaTemp;
                actividad.checkActividadPlanner = valor;
                setState(() {});
              }
            },
          ),
          title: Text(actividad.nombreActividadPlanner!),
          subtitle: Text(actividad.descripcionActividadPlanner!),
        ));
      }

      // agregamos items a la lista expanded
      listExpanded.add(
        ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return ListTile(
              leading: Checkbox(
                value: tarea.checkTarePlanner ?? false,
                onChanged: (valor) {
                  setState(() {
                    tarea.checkTarePlanner = valor;

                    // forEach para seleccionar a todas las actividades de la tarea
                    for (var actividad in tarea.actividadTareaPlanner!) {
                      DateTime fechaTemp = DateTime(
                        fechaEvento!.year,
                        fechaEvento!.month - actividad.tiempoAntes!,
                        fechaEvento!.day,
                        10,
                      );

                      if (fechaTemp.isBefore(fechaInicio!)) {
                        if (tarea.checkTarePlanner ?? false) {
                          MostrarAlerta(
                              mensaje:
                                  'La actividad no puede ser antes de la fecha de planeación del evento',
                              tipoMensaje: TipoMensaje.advertencia);
                        }
                      } else {
                        actividad.fechaInicio = fechaTemp;
                        setState(() {
                          actividad.checkActividadPlanner = valor;
                        });
                      }
                    }
                  });
                },
              ),
              title: Text(tarea.nombreTareaPlanner!),
              onTap: () {
                // evento clic en el cuerpo de la listTile cabre el expanded
                setState(() {
                  tarea.expandedTarePlanner = !tarea.expandedTarePlanner!;
                });
              },
            );
          },
          isExpanded: tarea.expandedTarePlanner ?? false,
          body: Container(
            padding: const EdgeInsets.only(left: 20.0),
            child: Column(
              children: listWidget,
            ),
          ),
        ),
      );
    }

    return listExpanded; // enviamos la lista
  }

  // creamos la vista de expanded
  Widget _crearViewExpanded(ItemModelPlanes model) {
    if (model.planes.isNotEmpty) {
      return FutureBuilder<List<TareaPlanner>>(
          future: _promiseList(model),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: ExpansionPanelList(
                  animationDuration: const Duration(milliseconds: 500),
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      _listTare[index].expandedTarePlanner = !isExpanded;
                    });
                  },
                  children: _buildListExpanded(snapshot.data),
                ),
              );
            } else {
              return const Center(
                child: LoadingCustom(),
              );
            }
          });
    } else {
      return const Center(
        child: Text('Sin datos'),
      );
    }
  }

  /* seccion de evento */

  // creamos lista con las tareas & actividades que van al evento
  void _eventoAgregar() {
    List<TareaPlanner> tareaPlaner = []; // lista ciclo 1

    // ciclo 1 manejar tareas
    for (var tarea in _listTare) {
      List<ActividadAgregarPlanner> actividadPlaner = []; // lista ciclo 2
      bool bandera = false; // bandera para agregar lo que esta marcado

      // ciclo 2 manejar actividades
      for (var actividad in tarea.actividadTareaPlanner!) {
        // agregar actividades marcadas
        if (actividad.checkActividadPlanner!) {
          actividadPlaner.add(ActividadAgregarPlanner(
            idActividadPlanner: actividad.idActividadPlanner,
            nombreActividadPlanner: actividad.nombreActividadPlanner,
            descripcionActividadPlanner: actividad.descripcionActividadPlanner,
            visibleInvolucradosActividadPlanner:
                actividad.visibleInvolucradosActividadPlanner,
            diasActividadPlanner: actividad.diasActividadPlanner,
            predecesorActividadPlanner: actividad.predecesorActividadPlanner,
            isEvento: false,
            tiempoAntes: actividad.tiempoAntes,
            fechaInicio: actividad.fechaInicio,
          ));
          bandera = true;
        }
      }

      // agregar tareas & actividades
      if (bandera) {
        tareaPlaner.add(TareaPlanner(
            idTareaPlanner: tarea.idTareaPlanner,
            nombreTareaPlanner: tarea.nombreTareaPlanner,
            actividadTareaPlanner: actividadPlaner,
            isEvento: false));
      }
    }

    // enviamos al evento
    if (tareaPlaner.isNotEmpty) {
      // regresamos

      _planesBloc.add(CreatePlanesEvent(tareaPlaner));
      _planesBloc.add(GetTimingsAndActivitiesEvent());
      Navigator.pop(context);
      MostrarAlerta(
          mensaje: 'Planes agregados.', tipoMensaje: TipoMensaje.correcto);
    } else {
      MostrarAlerta(
          mensaje: 'Agrege un plan por favor...',
          tipoMensaje: TipoMensaje.advertencia);
    }
  }

  //  creamos lista con las tareas & actividades que van al evento sin repetir || revisar en el metodo anterior se puede hacer esto
  void _eventoAgregarData() {
    List<TareaPlanner> tareaPlaner = []; // lista ciclo 1

    // ciclo 1 manejar tareas
    for (var tarea in _listTare) {
      List<ActividadAgregarPlanner> actividadPlaner = []; // lista ciclo 2
      bool bandera = false; // bandera para agregar lo que esta marcado

      // ciclo 2 manejar actividades
      for (var actividad in tarea.actividadTareaPlanner!) {
        // agregar actividades marcadas
        if (actividad.checkActividadPlanner!) {
          actividadPlaner.add(ActividadAgregarPlanner(
            idActividadPlanner: actividad.idActividadPlanner,
            nombreActividadPlanner: actividad.nombreActividadPlanner,
            descripcionActividadPlanner: actividad.descripcionActividadPlanner,
            visibleInvolucradosActividadPlanner:
                actividad.visibleInvolucradosActividadPlanner,
            diasActividadPlanner: actividad.diasActividadPlanner,
            predecesorActividadPlanner: actividad.predecesorActividadPlanner,
            isEvento: actividad.isEvento,
            tiempoAntes: actividad.tiempoAntes,
            fechaInicio: actividad.fechaInicio,
          ));
          bandera = true;
        }
      }

      // agregar tareas & actividades
      if (bandera) {
        tareaPlaner.add(TareaPlanner(
          idTareaPlanner: tarea.idTareaPlanner,
          nombreTareaPlanner: tarea.nombreTareaPlanner,
          actividadTareaPlanner: actividadPlaner,
          isEvento: tarea.isEvento,
        ));
      }
    }

    // enviamos al evento
    if (tareaPlaner.isNotEmpty) {
      // regresamos
      _planesBloc.add(CreatePlanesEvent(tareaPlaner));
      _planesBloc.add(GetTimingsAndActivitiesEvent());
      MostrarAlerta(
          mensaje: 'Planes agregados.', tipoMensaje: TipoMensaje.correcto);
      Navigator.of(context, rootNavigator: true).pop();
    } else {
      MostrarAlerta(
          mensaje: 'Agrege un plan por favor...',
          tipoMensaje: TipoMensaje.advertencia);
    }
  }
}

// crear listas
class TareaPlanner {
  int? idTareaPlanner;
  String? nombreTareaPlanner;
  bool? checkTarePlanner;
  bool? expandedTarePlanner;
  bool? isEvento;
  List<ActividadAgregarPlanner>? actividadTareaPlanner;

  TareaPlanner({
    this.idTareaPlanner,
    this.nombreTareaPlanner,
    this.checkTarePlanner,
    this.expandedTarePlanner,
    this.isEvento,
    this.actividadTareaPlanner,
  });
}

class ActividadAgregarPlanner {
  int? idActividadPlanner;
  String? nombreActividadPlanner;
  String? descripcionActividadPlanner;
  bool? visibleInvolucradosActividadPlanner;
  int? diasActividadPlanner;
  int? predecesorActividadPlanner;
  bool? isEvento;
  DateTime? fechaInicio;
  bool? checkActividadPlanner;
  int? tiempoAntes;

  ActividadAgregarPlanner({
    this.idActividadPlanner,
    this.nombreActividadPlanner,
    this.descripcionActividadPlanner,
    this.visibleInvolucradosActividadPlanner,
    this.diasActividadPlanner,
    this.predecesorActividadPlanner,
    this.isEvento,
    this.checkActividadPlanner,
    this.tiempoAntes,
    this.fechaInicio,
  });
}

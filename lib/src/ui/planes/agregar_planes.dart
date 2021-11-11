// imports dart/flutter
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

// blocs
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/blocs/planes/planes_bloc.dart';

//model
import 'package:planning/src/models/item_model_planes.dart';

class AgregarPlanes extends StatefulWidget {
  final List<dynamic> lista;
  AgregarPlanes({Key key, @required this.lista}) : super(key: key);

  @override
  _AgregarPlanesState createState() => _AgregarPlanesState();
}

class _AgregarPlanesState extends State<AgregarPlanes> {
  // variables bloc
  PlanesBloc _planesBloc;

  // variable model
  ItemModelPlanes _itemModel;

  // variables class
  List<TareaPlanner> _listTare;
  String _condicionQuery = 'AND ea.estatus_calendar = true';

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
    return new WillPopScope(
      onWillPop: () async {
        _planesBloc.add(SelectPlanesEventoEvent(_condicionQuery));
        return true;
      },
      child: new Scaffold(
        appBar: new AppBar(
          title: Text('Lista De Planes'),
        ),
        body: _buildBloc(),
      ),
    );
  }

  // bloc principal
  Widget _buildBloc() {
    return BlocBuilder<PlanesBloc, PlanesState>(builder: (context, state) {
      // state ini
      if (state is InitiaPlaneslState)
        return Center(child: CircularProgressIndicator());
      // state log
      else if (state is LodingPlanesState)
        return Center(child: CircularProgressIndicator());
      // state select
      else if (state is SelectPlanesState) {
        // evita que se reescriba la lista
        if (state.planes != null) {
          if (_itemModel != state.planes) {
            _itemModel = state.planes;
            if (_itemModel != null) {
              if (widget.lista.length > 0)
                _listTare = _crearListaEditableConDatos(_itemModel);
              else
                _listTare = _crearListaEditableSinDatos(_itemModel);
            }
          }
        } else {
          _planesBloc.add(SelectPlanesEvent());
          return Center(child: CircularProgressIndicator());
        }
        if (_itemModel != null) {
          return _crearStickyHeader(_itemModel);
        } else {
          return Center(child: Text('Sin datos'));
        }
      }
      // state create
      else if (state is CreatePlanesState) {
        _planesBloc.add(SelectPlanesEventoEvent(_condicionQuery));
        return _crearStickyHeader(_itemModel);
      }
      // no state
      else {
        return Center(child: CircularProgressIndicator());
      }
    });
  }

  // creo el StickyHeader
  Widget _crearStickyHeader(ItemModelPlanes model) {
    return Container(
        padding: EdgeInsets.all(20.0),
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
      padding: EdgeInsets.all(20.0),
      width: double.infinity,
      color: Colors.white,
      child: Text(
        'Selecciona los planes para tu evento',
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }

  // contetnt
  Container _content(ItemModelPlanes model) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _crearViewExpanded(model),
          SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
            child: Text('Agregar'),
            onPressed:
                widget.lista.length > 0 ? _eventoAgregarData : _eventoAgregar,
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
      List<ActividadPlanner> tempActividad = []; // cariable temporal 2° ciclo

      // ciclo para separar actividades
      for (int j = 0; j < model.planes.length; j++) {
        // junta las actividades de cada tarea en una lista
        if (model.planes[i].idPlan == model.planes[j].idPlan) {
          tempActividad.add(ActividadPlanner(
            idActividadPlanner: model.planes[j].idActividad,
            nombreActividadPlanner: model.planes[j].nombreActividad,
            descripcionActividadPlanner: model.planes[j].descripcionActividad,
            visibleInvolucradosActividadPlanner:
                model.planes[j].visibleInvolucradosActividad,
            diasActividadPlanner: model.planes[j].duracionActividad,
            predecesorActividadPlanner: model.planes[j].predecesorActividad,
            isEvento: false,
            checkActividadPlanner: false,
          ));
        }
      }

      // juntando las tareas con sus actividades
      if (i == 0)
        tempTarea.add(TareaPlanner(
            idTareaPlanner: model.planes[i].idPlan,
            nombreTareaPlanner: model.planes[i].nombrePlan,
            isEvento: false,
            checkTarePlanner: false,
            expandedTarePlanner: false,
            actividadTareaPlanner: tempActividad));
      else {
        if (model.planes[i].idPlan != model.planes[(i - 1)].idPlan)
          tempTarea.add(TareaPlanner(
              idTareaPlanner: model.planes[i].idPlan,
              nombreTareaPlanner: model.planes[i].nombrePlan,
              isEvento: false,
              checkTarePlanner: false,
              expandedTarePlanner: false,
              actividadTareaPlanner: tempActividad));
      }
    }

    return tempTarea; // enviamos la lista
  }

  // pasamos el model a una lista con los datos de la anterior vista || revisar en el metodo anterior se puede hacer esto
  List<TareaPlanner> _crearListaEditableConDatos(ItemModelPlanes model) {
    List<TareaPlanner> tempTarea = []; // variable temporal 1° ciclo

    // ciclo para separar tareas
    for (int i = 0; i < model.planes.length; i++) {
      List<ActividadPlanner> tempActividad = []; // cariable temporal 2° ciclo

      // ciclo para separar actividades
      for (int j = 0; j < model.planes.length; j++) {
        // junta las actividades de cada tarea en una lista
        if (model.planes[i].idPlan == model.planes[j].idPlan) {
          tempActividad.add(ActividadPlanner(
            idActividadPlanner: model.planes[j].idActividad,
            nombreActividadPlanner: model.planes[j].nombreActividad,
            descripcionActividadPlanner: model.planes[j].descripcionActividad,
            visibleInvolucradosActividadPlanner:
                model.planes[j].visibleInvolucradosActividad,
            diasActividadPlanner: model.planes[j].duracionActividad,
            predecesorActividadPlanner: model.planes[j].predecesorActividad,
            isEvento: false,
            checkActividadPlanner: false,
          ));
        }
      }

      // juntando las tareas con sus actividades
      if (i == 0)
        tempTarea.add(TareaPlanner(
            idTareaPlanner: model.planes[i].idPlan,
            nombreTareaPlanner: model.planes[i].nombrePlan,
            checkTarePlanner: false,
            expandedTarePlanner: false,
            isEvento: false,
            actividadTareaPlanner: tempActividad));
      else {
        if (model.planes[i].idPlan != model.planes[(i - 1)].idPlan)
          tempTarea.add(TareaPlanner(
              idTareaPlanner: model.planes[i].idPlan,
              nombreTareaPlanner: model.planes[i].nombrePlan,
              checkTarePlanner: false,
              expandedTarePlanner: false,
              isEvento: false,
              actividadTareaPlanner: tempActividad));
      }
    }

    tempTarea.forEach((tareaHere) {
      widget.lista.forEach((tareaThere) {
        if (tareaThere.idTareaOld == tareaHere.idTareaPlanner) {
          tareaHere.idTareaPlanner = tareaThere.idTareaPlanner;
          tareaHere.checkTarePlanner = true;
          tareaHere.isEvento = true;

          tareaHere.actividadTareaPlanner.forEach((actividadHere) {
            tareaThere.actividadTareaPlanner.forEach((actividadThere) {
              if (actividadHere.idActividadPlanner ==
                  actividadThere.idOldActividad) {
                actividadHere.idActividadPlanner =
                    actividadThere.idOldActividad;
                actividadHere.checkActividadPlanner = true;
                actividadHere.isEvento = true;
              }
            });
          });
        }
      });
    });

    return tempTarea; // enviamos la lista
  }

  // creamos una promesa de una lista
  Future<List<TareaPlanner>> _promiseList(ItemModelPlanes model) async {
    if (widget.lista.length > 0)
      return _crearListaEditableSinDatos(model);
    else
      return _crearListaEditableConDatos(model);
  }

  // creamos los expandeds
  List<ExpansionPanel> _buildListExpanded(List<TareaPlanner> list) {
    List<ExpansionPanel> listExpanded = []; // variable con la lista de expanded

    // ciclo para generar mis widgets padres
    for (int i = 0; i < list.length; i++) {
      List<Widget> listWidget = []; // variable con los hijos del expanded

      // ciclo para generar los hijos
      for (int j = 0; j < list[i].actividadTareaPlanner.length; j++) {
        // agregamos items a la lista widget
        listWidget.add(ListTile(
          leading: Checkbox(
            value: _listTare[i].actividadTareaPlanner[j].checkActividadPlanner,
            onChanged: (valor) {
              setState(() {
                _listTare[i].actividadTareaPlanner[j].checkActividadPlanner =
                    valor;
              });
            },
          ),
          title: Text(list[i].actividadTareaPlanner[j].nombreActividadPlanner),
          subtitle: Text(
              list[i].actividadTareaPlanner[j].descripcionActividadPlanner),
        ));
      }

      // agregamos items a la lista expanded
      listExpanded.add(
        ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return ListTile(
              leading: Checkbox(
                value: _listTare[i].checkTarePlanner ?? false,
                onChanged: (valor) {
                  setState(() {
                    _listTare[i].checkTarePlanner = valor;

                    // forEach para seleccionar a todas las actividades de la tarea
                    _listTare[i].actividadTareaPlanner.forEach((actividad) {
                      actividad.checkActividadPlanner = valor;
                    });
                  });
                },
              ),
              title: Text(list[i].nombreTareaPlanner),
              onTap: () {
                // evento clic en el cuerpo de la listTile cabre el expanded
                setState(() {
                  _listTare[i].expandedTarePlanner =
                      !_listTare[i].expandedTarePlanner;
                });
              },
            );
          },
          isExpanded: _listTare[i].expandedTarePlanner ?? false,
          body: Container(
            padding: EdgeInsets.only(left: 20.0),
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
    if (model.planes.length > 0) {
      return FutureBuilder<List<TareaPlanner>>(
          future: _promiseList(model),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: ExpansionPanelList(
                  animationDuration: Duration(milliseconds: 500),
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      _listTare[index].expandedTarePlanner = !isExpanded;
                    });
                  },
                  children: _buildListExpanded(snapshot.data),
                ),
              );
            } else
              return Center(
                child: CircularProgressIndicator(),
              );
          });
    } else
      return Center(
        child: Text('Sin datos'),
      );
  }

  // mensaje
  Future<void> _mensaje(String txt) async {
    return await ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(txt),
    ));
  }

  /* seccion de evento */

  // creamos lista con las tareas & actividades que van al evento
  void _eventoAgregar() {
    List<TareaPlanner> tareaPlaner = []; // lista ciclo 1

    // ciclo 1 manejar tareas
    _listTare.forEach((tarea) {
      List<ActividadPlanner> actividadPlaner = []; // lista ciclo 2
      bool bandera = false; // bandera para agregar lo que esta marcado

      // ciclo 2 manejar actividades
      tarea.actividadTareaPlanner.forEach((actividad) {
        // agregar actividades marcadas
        if (actividad.checkActividadPlanner) {
          actividadPlaner.add(ActividadPlanner(
              idActividadPlanner: actividad.idActividadPlanner,
              nombreActividadPlanner: actividad.nombreActividadPlanner,
              descripcionActividadPlanner:
                  actividad.descripcionActividadPlanner,
              visibleInvolucradosActividadPlanner:
                  actividad.visibleInvolucradosActividadPlanner,
              diasActividadPlanner: actividad.diasActividadPlanner,
              predecesorActividadPlanner: actividad.predecesorActividadPlanner,
              isEvento: false));
          bandera = true;
        }
      });

      // agregar tareas & actividades
      if (bandera)
        tareaPlaner.add(TareaPlanner(
            idTareaPlanner: tarea.idTareaPlanner,
            nombreTareaPlanner: tarea.nombreTareaPlanner,
            actividadTareaPlanner: actividadPlaner,
            isEvento: false));
    });

    // enviamos al evento
    if (tareaPlaner.length > 0) {
      // regresamos
      _planesBloc.add(CreatePlanesEvent(tareaPlaner));
      Navigator.pop(context);
      _mensaje('Planes agregados.');
    } else
      _mensaje('Agrege un plan por favor...');
  }

  //  creamos lista con las tareas & actividades que van al evento sin repetir || revisar en el metodo anterior se puede hacer esto
  void _eventoAgregarData() {
    List<TareaPlanner> tareaPlaner = []; // lista ciclo 1

    // ciclo 1 manejar tareas
    _listTare.forEach((tarea) {
      List<ActividadPlanner> actividadPlaner = []; // lista ciclo 2
      bool bandera = false; // bandera para agregar lo que esta marcado

      // ciclo 2 manejar actividades
      tarea.actividadTareaPlanner.forEach((actividad) {
        // agregar actividades marcadas
        if (actividad.checkActividadPlanner) {
          actividadPlaner.add(ActividadPlanner(
              idActividadPlanner: actividad.idActividadPlanner,
              nombreActividadPlanner: actividad.nombreActividadPlanner,
              descripcionActividadPlanner:
                  actividad.descripcionActividadPlanner,
              visibleInvolucradosActividadPlanner:
                  actividad.visibleInvolucradosActividadPlanner,
              diasActividadPlanner: actividad.diasActividadPlanner,
              predecesorActividadPlanner: actividad.predecesorActividadPlanner,
              isEvento: actividad.isEvento));
          bandera = true;
        }
      });

      // agregar tareas & actividades
      if (bandera)
        tareaPlaner.add(TareaPlanner(
            idTareaPlanner: tarea.idTareaPlanner,
            nombreTareaPlanner: tarea.nombreTareaPlanner,
            actividadTareaPlanner: actividadPlaner,
            isEvento: tarea.isEvento));
    });

    // enviamos al evento
    if (tareaPlaner.length > 0) {
      // regresamos
      _planesBloc.add(CreatePlanesEvent(tareaPlaner));
      Navigator.pop(context);
      _mensaje('Planes agregados.');
    } else
      _mensaje('Agrege un plan por favor...');
  }
}

// crear listas
class TareaPlanner {
  int idTareaPlanner;
  String nombreTareaPlanner;
  bool checkTarePlanner;
  bool expandedTarePlanner;
  bool isEvento;
  List<ActividadPlanner> actividadTareaPlanner;

  TareaPlanner({
    this.idTareaPlanner,
    this.nombreTareaPlanner,
    this.checkTarePlanner,
    this.expandedTarePlanner,
    this.isEvento,
    this.actividadTareaPlanner,
  });
}

class ActividadPlanner {
  int idActividadPlanner;
  String nombreActividadPlanner;
  String descripcionActividadPlanner;
  bool visibleInvolucradosActividadPlanner;
  int diasActividadPlanner;
  int predecesorActividadPlanner;
  bool isEvento;
  bool checkActividadPlanner;

  ActividadPlanner({
    this.idActividadPlanner,
    this.nombreActividadPlanner,
    this.descripcionActividadPlanner,
    this.visibleInvolucradosActividadPlanner,
    this.diasActividadPlanner,
    this.predecesorActividadPlanner,
    this.isEvento,
    this.checkActividadPlanner,
  });
}

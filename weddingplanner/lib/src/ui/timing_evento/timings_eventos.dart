// imports dart/flutter
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

// blocs
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingplanner/src/blocs/actividadesTiming/actividadestiming_bloc.dart';

// model
import 'package:weddingplanner/src/models/item_model_actividades_timings.dart';
import 'package:weddingplanner/src/ui/timing_evento/table_calendar.dart';

class TimingsEventos extends StatefulWidget {
  const TimingsEventos({Key key}) : super(key: key);

  @override
  _TimingsEventosState createState() => _TimingsEventosState();
}

class _TimingsEventosState extends State<TimingsEventos> {
  // variables bloc
  ActividadestimingBloc eventoTimingBloc;

  // variables model
  ItemModelActividadesTimings itemModel;
  ItemModelActividadesTimings copyItemModel;

  // variables clase
  bool _allCheck = false;
  List<Tarea> _listFull = [];

  // ini
  @override
  void initState() {
    super.initState();
    eventoTimingBloc = BlocProvider.of<ActividadestimingBloc>(context);
    eventoTimingBloc.add(FetchActividadesTimingsPorIdPlannerEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActividadestimingBloc, ActividadestimingState>(
      builder: (context, state) {
        if (state is ActividadestimingInitial) {
          return Center(child: CircularProgressIndicator());
        } else if (state is LoadingActividadesTimingsState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is MostrarActividadesTimingsEventosState) {
            // buscador en header
            if (state.actividadesTimings != null) {
              if(itemModel != state.actividadesTimings){
                itemModel = state.actividadesTimings;
                if (itemModel != null) {
                  copyItemModel = itemModel.copy();
                  _listFull = _crearListaEditable(copyItemModel);
                }
              }
            } else {
              eventoTimingBloc.add(FetchActividadesTimingsPorIdPlannerEvent());
              return Center(child: CircularProgressIndicator());
            }
            if(copyItemModel != null) {
              return _crearVista(copyItemModel);
            }else {
              return Center(child: Text('Sin datos'));
            }
        } else if (state is ErrorMostrarActividadesTimingsState) {
          return Center(child: Text(state.message),);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  // cremos vista
  Widget _crearVista(copyItemModel) {
    return Scaffold(
      body: ListView(
        children: [
          StickyHeader(
            header: _agregarHeader(),
            content: _agregarActividades(copyItemModel),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _myBotonSave(copyItemModel),
    );
  }

  // creamos header
  Widget _agregarHeader() {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Card(
        child: _crearHeader()
      ),
    );
  }

  Widget _crearHeader() {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          _tituloHeader(),
          // SizedBox(height: 10.0,),
          // _buscadorHeader(),
          SizedBox(height: 15.0,),
          _checkActividadesHeader(),
        ],
      ),
    );
  }

  Widget _tituloHeader() {
    return Text('Actividades', style: TextStyle(fontSize: 20.0),);
  }

  Widget _buscadorHeader() {
    return TextField(
      decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
          ),
          hintText: 'Buscar...'),
      onChanged: (valor) {_buscadorActividades(valor);},
    );
  }

  Widget _checkActividadesHeader() {
    return Row(
      children: [
        Checkbox(
          value: _allCheck, 
          onChanged: (valor){
            setState((){
              _allCheck = !_allCheck;
              _listFull.forEach((tarea) {
                tarea.check_tarea = _allCheck;
                tarea.expanded_tarea = _allCheck;
                tarea.actividad.forEach((actividad) {
                  actividad.agregar_actividad = _allCheck;
                });
              });
            });
          },
        ),
        Text('Seleccionar todo.'),
      ],
    );
  }

  Widget _agregarActividades(copyItemModel) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: listaToda(copyItemModel)
    );
  }

  // Cargar las actividades - eventos/todo
  Future<List<Tarea>> loadData(ItemModelActividadesTimings itemInMethod) async {
    // acomodar el modelo para que carge las actividades dentro de una sola tarea
    return _crearListaEditable(itemInMethod);
  }

  Widget listaToda(ItemModelActividadesTimings itemModel) {
    if(itemModel.results.length > 0) {
      return FutureBuilder<List<Tarea>>(
        future: loadData(itemModel),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: ExpansionPanelList(
                  animationDuration: Duration(milliseconds: 500),
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      if(_listFull[index].check_tarea == true)
                        _listFull[index].expanded_tarea = !isExpanded;
                    });
                  },
                  children: buildPanelList(snapshot.data)),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      );
    }
    else {
      return Center(child: Text('Sin datos'));
    }
  }

  List<ExpansionPanel> buildPanelList(List<Tarea> data) {
    List<ExpansionPanel> children = [];
    for (int i = 0; i < data.length; i++) {
      List<ListTile> listTiles = [];
      for(int j = 0; j < data[i].actividad.length; j++){
        listTiles.add(
          ListTile(
            leading: Checkbox(
              value: _listFull[i].actividad[j].agregar_actividad,
              onChanged: (valor){
                setState(() {
                  _listFull[i].actividad[j].agregar_actividad = valor;
                });
              },
            ),
            title: Text('${data[i].actividad[j].nombre_actividad}'),
            subtitle: Text('${data[i].actividad[j].describe_actividad}'),
            trailing: _listFull[i].actividad[j].agregar_actividad == true ? _calendaryIcon(_listFull[i].actividad[j].fecha_inicio_actividad,_listFull[i].actividad[j].id_actividad,_listFull[i].actividad[j].fecha_inicio_evento,_listFull[i].actividad[j].fecha_final_evento,_listFull[i].actividad[j].dias) : null,
            // onTap: _listFull[i].actividad[j].agregar_actividad == true ? (){} : null,
          )
        );
      }
      children.add(ExpansionPanel(
        headerBuilder: (context, isExpanded) {
          return ListTile(
            leading: Checkbox(
              value: _listFull[i].check_tarea ?? false,
              onChanged: (valor){
                setState((){
                  if(_listFull[i].expanded_tarea == false)
                    _listFull[i].check_tarea = valor;
                });
              },
            ),
            title: Text("${data[i].nombre_tarea}"),
          );
        },
        isExpanded: _listFull[i].expanded_tarea ?? false,
        body: Column(
          children: listTiles,
        ),
      ));
    }
    return children;
  }

  List<Tarea> _crearListaEditable(ItemModelActividadesTimings itemInMethod) {
    //
    List<Tarea> tempTarea = [];
    //
    for(int i = 0; i < itemInMethod.results.length; i++) {
      //
      List<Actividad> tempActividad = [];
      //
      for(int j = 1; j < itemInMethod.results.length; j++) {
        if(itemInMethod.results[i].idEventoTiming == itemInMethod.results[j].idEventoTiming)
          tempActividad.add(Actividad(
            id_actividad: itemInMethod.results[j].idEventoActividad,
            nombre_actividad: itemInMethod.results[j].nombreEventoActividad,
            describe_actividad: itemInMethod.results[j].descripcion,
            dias: itemInMethod.results[j].dia,
            fecha_inicio_actividad: itemInMethod.results[j].fechaInicioActividad,
            fecha_inicio_evento: itemInMethod.results[j].fechaInicioEvento,
            fecha_final_evento: itemInMethod.results[j].fechaFinalEvento,
            agregar_actividad: itemInMethod.results[j].addActividad,
          ));
      }
      //
      if(i == 0)
        tempTarea.add(Tarea(
          id_tarea: itemInMethod.results[i].idEventoTiming,
          nombre_tarea: itemInMethod.results[i].nombreEventoTarea,
          check_tarea: itemInMethod.results[i].isCheck,
          expanded_tarea: itemInMethod.results[i].isExpanded,
          actividad: tempActividad,
        ));
      else {
        if(itemInMethod.results[(i-1)].idEventoTiming != itemInMethod.results[i].idEventoTiming)
          tempTarea.add(Tarea(
            id_tarea: itemInMethod.results[i].idEventoTiming,
            nombre_tarea: itemInMethod.results[i].nombreEventoTarea,
            check_tarea: itemInMethod.results[i].isCheck,
            expanded_tarea: itemInMethod.results[i].isExpanded,
            actividad: tempActividad,
          ));
      }
    }
    return tempTarea;
  }

  _buscadorActividades(String valor) {
    if(valor.length > 2) {
      List<dynamic> buscador = itemModel.results.where((element) =>
        element.nombreEventoTarea.toLowerCase().contains(valor.toLowerCase())
      ).toList();
      setState((){
        copyItemModel.results.clear();
        if(buscador.length > 0) {
          buscador.forEach((element) {
            copyItemModel.results.add(element);
            // rescribir cheks
            // copyItemModel.results.forEach((element) {
            //   if(_keepStatus[element.idActividad] != null)
            //     element.addActividad = _keepStatus[element.idActividad].isCheck;
            // });
          });
        }
        else {}
      });
    } else {
      setState((){
        if (itemModel != null) {
          copyItemModel = itemModel.copy();
          // rescribir cheks
          // copyItemModel.results.forEach((element) {
          //   if(_keepStatus[element.idActividad] != null)
          //     element.addActividad = _keepStatus[element.idActividad].isCheck;
          // });
        }
      });
    }
  }
  // fin Cargar las actividades - eventos/todo
  
  Widget _myBotonSave(itemModel) {
    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close_rounded,
      visible: true,
      tooltip: 'Opciones',
      heroTag: 'Opciones',
      backgroundColor: Colors.pink[900],
      foregroundColor: Colors.white,
      gradientBoxShape: BoxShape.circle,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      children: _armarBotonesAcciones(itemModel),
    );
  }

  List<SpeedDialChild> _armarBotonesAcciones(itemModel) {
    List<SpeedDialChild> temp = [];
    temp.add(_agregarNuevaActividad());
    temp.add(_agregarActividadCalendario(itemModel));
    return temp;
  }

  SpeedDialChild _agregarNuevaActividad() {
    return SpeedDialChild(
      backgroundColor: Colors.pink[900],
      foregroundColor: Colors.white,
      child: Tooltip(
        child: Icon(Icons.access_time_sharp),
        message: "Agregar tareas.",
      ),
      onTap: () async {},
    );
  }

  SpeedDialChild _agregarActividadCalendario(itemModel) {
    return SpeedDialChild(
      backgroundColor: Colors.pink[900],
      foregroundColor: Colors.white,
      child: Tooltip(
        child: Icon(Icons.calendar_today_outlined),
        message: "Agregar a calendario.",
      ),
      onTap: () async { await _saveActividades(itemModel);},
    );
  }

  void _saveActividades(itemModel) {
    // crear metodo para actualizar estado
    // Navigator.pushNamed(
    //   context,
    //   '/eventoCalendario',
    //   arguments: TableEventsExample(itemModel: itemModel)
    // );
    Navigator.of(context).pushNamed('/eventoCalendario', arguments: itemModel);
  }

  // parte del calendary put
  Widget _calendaryIcon(DateTime fechaInicio,int idActividad, DateTime fechaInicioEvento, DateTime fechaFinalEvento, int dias) {
    return GestureDetector(
      child: Icon(Icons.calendar_today),
      onTap: () async {
        FocusScope.of(context).requestFocus(new FocusNode());

        fechaInicio = await showDatePicker(
                      context: context, 
                      initialDate: fechaInicio,
                      errorFormatText: 'Error en el formato',
                      errorInvalidText: 'Error en la fecha',
                      fieldHintText: 'día/mes/año',
                      fieldLabelText: 'Fecha de inicio de actividad',
                      firstDate: fechaInicioEvento,
                      lastDate: fechaFinalEvento,
        );
        
        // // agregamos la nueva fecha
        _listFull.forEach((tareas) {
          tareas.actividad.forEach((actividades) {
            if(actividades.id_actividad == idActividad){
              if(fechaInicio != null) {
                if(fechaInicio.add(Duration(days: actividades.dias)).isAfter(actividades.fecha_final_evento))
                  _alertaFechas(actividades.nombre_actividad,actividades.fecha_inicio_evento,fechaInicio,actividades.fecha_final_evento,actividades.dias);
                else
                  actividades.fecha_inicio_actividad = fechaInicio;
              }
              else {
              }
            }
          });
        });
      },
    );
  }

  // mensajes
  Future<void> _alertaFechas(String actividad, DateTime fechaInicialEvento, DateTime fechaActividad, DateTime fechaFinalEvento, int duracion) {
    String txtDuracion;

    if(duracion > 1)
      txtDuracion = 'tiene la duración de $duracion dias';
    else
      txtDuracion = 'tiene la duración de $duracion dia';

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error en la fecha'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('La actividad: $actividad'),
                Text('$txtDuracion'),
                SizedBox(height: 15.0,),
                Text('No puedes exceder el día final del evento,'),
                SizedBox(height: 15.0,),
                Text('fecha final: ${DateFormat("yyyy-MM-dd").format(fechaFinalEvento)}')
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  // fin calendary put
  
}
// clases para manejar el modelo
// tarea
class Tarea {
  int id_tarea;
  String nombre_tarea;
  bool check_tarea;
  bool expanded_tarea;
  List<Actividad> actividad;

  Tarea({
    this.id_tarea,
    this.nombre_tarea,
    this.check_tarea,
    this.expanded_tarea,
    this.actividad,
  });
}
// actividad
class Actividad {
  int id_actividad;
  String nombre_actividad;
  String describe_actividad;
  int dias;
  DateTime fecha_inicio_actividad;
  DateTime fecha_inicio_evento;
  DateTime fecha_final_evento;
  bool agregar_actividad;

  Actividad({
    this.id_actividad,
    this.nombre_actividad,
    this.describe_actividad,
    this.dias,
    this.fecha_inicio_actividad,
    this.fecha_inicio_evento,
    this.fecha_final_evento,
    this.agregar_actividad,
  });
}

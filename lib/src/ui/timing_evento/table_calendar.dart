// imports from flutter/dart
import 'dart:collection';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:table_calendar/table_calendar.dart';

// imports from wedding
import 'package:planning/src/blocs/comentariosActividades/comentariosactividades_bloc.dart';
import 'package:planning/src/models/item_model_comentarios_actividades.dart';

class TableEventsExample extends StatefulWidget {
  final List<dynamic> actividadesLista;
  const TableEventsExample({Key key, @required this.actividadesLista})
      : super(key: key);

  @override
  _TableEventsExampleState createState() => _TableEventsExampleState();
}

class _TableEventsExampleState extends State<TableEventsExample> {
  ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;
  DateTime _rangeStart;
  DateTime _rangeEnd;

  // blocs
  ComentariosactividadesBloc eventoComentario;

  // model
  ItemModelComentarios itemModel, copyItemModel;

  // mi lista
  List<Actividad> _listFull = [];
  int _idComentario;

  @override
  void initState() {
    super.initState();

    eventoComentario = BlocProvider.of<ComentariosactividadesBloc>(context);
    eventoComentario.add(SelectComentarioPorIdEvent());

    // _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendario de actividades'),
      ),
      body: _mostrarActividades(widget.actividadesLista),
    );
  }

  // v1
  Widget _mostrarActividades(actividades) {
    if (actividades.length > 0) {
      return BlocBuilder<ComentariosactividadesBloc,
          ComentariosactividadesState>(builder: (context, state) {
        if (state is ComentarioInitialState) {
          return Center(child: LoadingCustom());
        } else if (state is LodingComentarioState) {
          return Center(child: LoadingCustom());
        } else if (state is SelectComentarioState) {
          // buscador en header
          if (state.comentario != null) {
            if (itemModel != state.comentario) {
              itemModel = state.comentario;
              if (itemModel != null) {
                copyItemModel = itemModel;
                _listFull = _crearLista(copyItemModel, actividades);
              }
            }
          } else {
            eventoComentario.add(SelectComentarioPorIdEvent());
            return Center(child: LoadingCustom());
          }
          if (copyItemModel != null) {
            return _consulta(copyItemModel, actividades);
          } else {
            return Center(child: Text('Sin datos'));
          }
        } else if (state is CreateComentariosState) {
          _idComentario = state.idComentario;
          return _consulta(copyItemModel, actividades);
        } else if (state is UpdateComentariosState) {
          return _consulta(copyItemModel, actividades);
        } else {
          return Center(
            child: Text('Error En Data'),
          );
        }
      });
    } else {
      return Center(
        child: Text('Sin actividades'),
      );
    }
  }

  // v2
  Widget _consulta(comentario, actividades) {
    return Container(
      padding: EdgeInsets.all(30.0),
      child: Card(
        color: Colors.white,
        child: Column(
          children: [
            TableCalendar<Event>(
              locale: 'es_ES',
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              firstDay: DateTime.utc(
                  actividades[0].fecha_inicio_evento.year,
                  actividades[0].fecha_inicio_evento.month,
                  actividades[0].fecha_inicio_evento.day),
              lastDay: DateTime.utc(
                  actividades[0].fecha_final_evento.year,
                  actividades[0].fecha_final_evento.month,
                  actividades[0].fecha_final_evento.day),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              calendarFormat: _calendarFormat,
              rangeSelectionMode: _rangeSelectionMode,
              eventLoader: _getEventsForDay,
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: CalendarStyle(
                // Use `CalendarStyle` to customize the UI
                outsideDaysVisible: false,
              ),
              onDaySelected: _onDaySelected,
              onRangeSelected: _onRangeSelected,
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
            const SizedBox(height: 8.0),
            Expanded(child: _crearVistaActividades(comentario, actividades)),
          ],
        ),
      ),
    );
  }

  // v3
  Widget _crearVistaActividades(ItemModelComentarios modelo, actividades) {
    return ValueListenableBuilder<List<Event>>(
      valueListenable: _selectedEvents,
      builder: (context, value, _) {
        return ListView.builder(
          itemCount: value.length,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.all(15.0),
              child: ExpansionPanelList(
                animationDuration: Duration(milliseconds: 500),
                expansionCallback: (int i, bool isExpanded) {
                  setState(() {
                    value[index].actividad.isExpanded = !isExpanded;
                  });
                },
                children: [
                  ExpansionPanel(
                    headerBuilder: (context, isExpanded) {
                      return ListTile(
                        leading: Checkbox(
                          value: value[index]
                              .actividad
                              .comentario
                              .estadoComentario,
                          onChanged: (valor) {
                            setState(() {
                              value[index]
                                  .actividad
                                  .comentario
                                  .estadoComentario = valor;
                              _caomentariosEvents(value[index].actividad);
                            });
                          },
                        ),
                        title:
                            Text("${value[index].actividad.nombreActividad}"),
                        subtitle: Text(
                            "${value[index].actividad.descripcionActividad} \n La actividad finaliza el: ${DateFormat('yyyy-MM-dd').format(value[index].actividad.fechaActividad.add(Duration(days: value[index].actividad.duracion)))}"),
                      );
                    },
                    isExpanded: value[index].actividad.isExpanded,
                    body: Column(
                      children: [
                        ListTile(
                          title: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Agrega un comentario',
                            ),
                            maxLines: 6,
                            controller: TextEditingController(
                                text:
                                    '${value[index].actividad.comentario.comentarioTxt}'),
                            onChanged: (valor) {
                              value[index].actividad.comentario.comentarioTxt =
                                  valor;
                            },
                          ),
                          trailing: GestureDetector(
                            child: Icon(
                              Icons.save_sharp,
                              color: Colors.black,
                            ),
                            onTap: () {
                              setState(() {
                                // mensaje eliminar/borrar
                                _mensajeComentario(value[index].actividad);
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  // cremos eventos v4
  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    List<dynamic> itemRecived = widget.actividadesLista;

    // crea
    final _kEventSourceModel = Map<DateTime, List<Event>>.fromIterable(
        itemRecived,
        key: (item) => DateTime.utc(item.fecha_inicio_actividad.year,
            item.fecha_inicio_actividad.month, item.fecha_inicio_actividad.day),
        value: ((item) {
          List<Event> temp = [];

          // hay un bug no muestra 1 actividad agregada pasa solo si es agregada en las primeras 2 fechas
          // si es la primera o la 3 no pasa nada es una actividad con el nombre igual a otra
          _listFull.forEach((actividad) {
            if (actividad.fechaActividad == item.fecha_inicio_actividad)
              temp.add(Event(('${actividad.nombreActividad}'), actividad));
          });

          return temp;
        }));

    // muestra
    final kEventsModel = LinkedHashMap<DateTime, List<Event>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(_kEventSourceModel);

    // _getEventsForDay
    return kEventsModel[day] ?? [];
  }

  // v5
  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  // v6
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  // v7
  void _onRangeSelected(DateTime start, DateTime end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  // v8
  List<Actividad> _crearLista(ItemModelComentarios modelo, actividades) {
    List<Actividad> tempActividad = [];

    actividades.forEach((actividad) {
      Comentario tempComentario;

      modelo.comentarios.forEach((comentarios) {
        if (actividad.id_actividad == comentarios.idEventoActividad) {
          tempComentario = Comentario(
            idComentario: comentarios.idComentario,
            comentarioTxt: comentarios.comentarioActividad,
            estadoComentario: comentarios.estadoComentario,
          );
        }
      });

      if (tempComentario == null) {
        tempComentario = Comentario(
          idComentario: 0,
          comentarioTxt: '',
          estadoComentario: false,
        );
      }

      tempActividad.add(Actividad(
        idActividad: actividad.id_actividad,
        nombreActividad: actividad.nombre_actividad,
        descripcionActividad: actividad.describe_actividad,
        fechaActividad: actividad.fecha_inicio_actividad,
        duracion: actividad.dias,
        isExpanded: false,
        comentario: tempComentario,
      ));
    });

    return tempActividad;
  }

  // v9
  Future<void> _mensajeComentario(Actividad actividad) async {
    _caomentariosEvents(actividad);
    return await ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Comentario guardado..."),
    ));
  }

  // crear&actualizar
  _caomentariosEvents(actividad) async {
    if (actividad.comentario.idComentario == null)
      actividad.comentario.idComentario = await _idComentario;
    else
      _idComentario = null;
    // guardamos en BD cambios
    if (actividad.comentario.idComentario == 0) {
      eventoComentario.add(CreateComentarioEvent(
          actividad.idActividad,
          actividad.comentario.estadoComentario,
          actividad.comentario.comentarioTxt));

      actividad.comentario.idComentario = null;

      if (_idComentario != null)
        actividad.comentario.idComentario = await _idComentario;
    } else {
      // update
      eventoComentario.add(UpdateComentarioEvent(
          actividad.comentario.idComentario,
          actividad.comentario.estadoComentario,
          actividad.comentario.comentarioTxt));
    }
  }
}

// fuera del widgetFull
int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

// Example event class.
class Event {
  final String title;
  final Actividad actividad;

  const Event(this.title, this.actividad);

  @override
  String toString() => title;
}

// clases
class Actividad {
  int idActividad;
  String nombreActividad;
  String descripcionActividad;
  DateTime fechaActividad;
  int duracion;
  bool isExpanded;
  Comentario comentario;

  Actividad({
    this.idActividad,
    this.nombreActividad,
    this.descripcionActividad,
    this.fechaActividad,
    this.duracion,
    this.isExpanded,
    this.comentario,
  });
}

//
class Comentario {
  int idComentario;
  String comentarioTxt;
  bool estadoComentario;

  Comentario({
    this.idComentario,
    this.comentarioTxt,
    this.estadoComentario,
  });
}

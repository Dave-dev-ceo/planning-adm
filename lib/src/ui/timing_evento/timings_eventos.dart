// imports dart/flutter
// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:flutter/services.dart';

// blocs
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/blocs/actividadesTiming/actividadestiming_bloc.dart';

// model
import 'package:planning/src/models/item_model_actividades_timings.dart';
import 'package:planning/src/ui/widgets/text_form_filed/text_form_filed.dart';

class TimingsEventos extends StatefulWidget {
  const TimingsEventos({Key? key}) : super(key: key);

  @override
  _TimingsEventosState createState() => _TimingsEventosState();
}

class _TimingsEventosState extends State<TimingsEventos> {
  // variables bloc
  late ActividadestimingBloc eventoTimingBloc;

  // variables model
  ItemModelActividadesTimings? itemModel;
  ItemModelActividadesTimings? copyItemModel;

  // variables clase
  bool _allCheck = false;
  List<Tarea> _listFull = [];

  // varables valida
  bool nombreValidador = false;
  bool descripcionValidador = false;
  bool diaValidador = false;

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
          return const Center(child: LoadingCustom());
        } else if (state is LoadingActividadesTimingsState) {
          return const Center(child: LoadingCustom());
        } else if (state is MostrarActividadesTimingsEventosState) {
          // buscador en header
          if (state.actividadesTimings != null) {
            if (itemModel != state.actividadesTimings) {
              itemModel = state.actividadesTimings;
              if (itemModel != null) {
                copyItemModel = itemModel!.copy();
                _listFull = _crearListaEditable(copyItemModel!);
              }
            }
          } else {
            eventoTimingBloc.add(FetchActividadesTimingsPorIdPlannerEvent());
            return const Center(child: LoadingCustom());
          }
          if (copyItemModel != null) {
            return _crearVista(copyItemModel);
          } else {
            return const Center(child: Text('Sin datos'));
          }
        } else if (state is AddActividadesState) {
          // eventoTimingBloc.add(FetchActividadesTimingsPorIdPlannerEvent());
          // return Center(child: LoadingCustom());
          for (var tarea in _listFull) {
            for (var actividad in tarea.actividad!) {
              if (tarea.idTarea == state.idTarea &&
                  actividad.idActividad == 0 &&
                  tarea.nuevaActividad == true) {
                actividad.idActividad = state.idActividad;
              }
            }
          }
          return _crearVista(copyItemModel);
        } else if (state is ErrorMostrarActividadesTimingsState) {
          return Center(
            child: Text(state.message),
          );
        } else {
          return const Center(child: LoadingCustom());
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
          const SizedBox(
            height: 60.0,
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _agregarActividadCalendario(),
    );
  }

  // creamos header
  Widget _agregarHeader() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Card(child: _crearHeader()),
    );
  }

  Widget _crearHeader() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          _tituloHeader(),
          // SizedBox(height: 10.0,),
          // _buscadorHeader(),
          const SizedBox(
            height: 15.0,
          ),
          _checkActividadesHeader(),
        ],
      ),
    );
  }

  Widget _tituloHeader() {
    return const Text(
      'Actividades',
      style: TextStyle(fontSize: 20.0),
    );
  }

  Widget _buscadorHeader() {
    return TextField(
      decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.search,
          ),
          hintText: 'Buscar...'),
      onChanged: (valor) {
        _buscadorActividades(valor);
      },
    );
  }

  Widget _checkActividadesHeader() {
    return Row(
      children: [
        Checkbox(
          value: _allCheck,
          onChanged: (valor) {
            setState(() {
              _allCheck = !_allCheck;
              for (var tarea in _listFull) {
                tarea.checkTarea = _allCheck;
                tarea.expandedTarea = _allCheck;
                for (var actividad in tarea.actividad!) {
                  actividad.agregarActividad = _allCheck;
                }
              }
            });
          },
        ),
        const Text('Seleccionar todo'),
      ],
    );
  }

  Widget _agregarActividades(copyItemModel) {
    return Container(
        padding: const EdgeInsets.all(20.0), child: listaToda(copyItemModel));
  }

  // Cargar las actividades - eventos/todo
  Future<List<Tarea>> loadData(ItemModelActividadesTimings itemInMethod) async {
    // acomodar el modelo para que carge las actividades dentro de una sola tarea
    return _crearListaEditable(itemInMethod);
  }

  Widget listaToda(ItemModelActividadesTimings itemModel) {
    if (itemModel.results.isNotEmpty) {
      return FutureBuilder<List<Tarea>>(
          future: loadData(itemModel),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: ExpansionPanelList(
                    animationDuration: const Duration(milliseconds: 500),
                    expansionCallback: (int index, bool isExpanded) {
                      setState(() {
                        if (_listFull[index].checkTarea == true) {
                          _listFull[index].expandedTarea = !isExpanded;
                        }
                      });
                    },
                    children: buildPanelList(snapshot.data!)),
              );
            } else {
              return const Center(
                child: LoadingCustom(),
              );
            }
          });
    } else {
      return const Center(child: Text('Sin datos'));
    }
  }

  List<ExpansionPanel> buildPanelList(List<Tarea> data) {
    List<ExpansionPanel> children = [];
    for (int i = 0; i < data.length; i++) {
      List<Widget> listTiles = [];
      for (int j = 0; j < _listFull[i].actividad!.length; j++) {
        if (_listFull[i].actividad![j].idActividad != 0) {
          listTiles.add(ListTile(
            leading: Checkbox(
              value: _listFull[i].actividad![j].agregarActividad,
              onChanged: (valor) {
                setState(() {
                  _listFull[i].actividad![j].agregarActividad = valor;
                });
              },
            ),
            title: Text(_listFull[i].actividad![j].nombreActividad!),
            subtitle: Text(_listFull[i].actividad![j].describeActividad!),
            trailing: _listFull[i].actividad![j].agregarActividad == true
                ? _calendaryIcon(
                    _listFull[i].actividad![j].fechaInicioActividad,
                    _listFull[i].actividad![j].idActividad,
                    _listFull[i].actividad![j].fechaInicioEvento,
                    _listFull[i].actividad![j].fechaFinalEvento,
                    _listFull[i].actividad![j].dias)
                : null,
            // onTap: _listFull[i].actividad[j].agregar_actividad == true ? (){} : null,
          ));
        } else {
          listTiles.add(
              // _formAddActividad(
              //   _listFull[i].id_tarea,
              //   _listFull[i].actividad[j].id_actividad,
              //   _listFull[i].actividad
              // )
              Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 15.0,
              ),
              Wrap(
                alignment: WrapAlignment.center,
                children: <Widget>[
                  TextFormFields(
                    icon: Icons.local_activity,
                    large: 500.0,
                    ancho: 80.0,
                    item: TextFormField(
                      controller: TextEditingController(
                          text: _listFull[i].actividad![j].nombreActividad),
                      decoration: InputDecoration(
                          labelText: 'Nombre:',
                          errorText:
                              nombreValidador ? 'Campo obligatorio' : null),
                      onChanged: (valor) {
                        _listFull[i].actividad![j].nombreActividad = valor;
                      },
                    ),
                  ),
                  TextFormFields(
                    icon: Icons.drive_file_rename_outline,
                    large: 500.0,
                    ancho: 80.0,
                    item: TextFormField(
                      controller: TextEditingController(
                          text: _listFull[i].actividad![j].describeActividad),
                      decoration: InputDecoration(
                          labelText: 'Descripción:',
                          errorText: descripcionValidador
                              ? 'Campo obligatorio'
                              : null),
                      onChanged: (valor) {
                        _listFull[i].actividad![j].describeActividad = valor;
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
                    icon: Icons.date_range_outlined,
                    large: 500.0,
                    ancho: 80.0,
                    item: Row(
                      children: [
                        const Expanded(child: Text("Duración en días:")),
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: _listFull[i].actividad![j].dias! > 0
                              ? () {
                                  setState(() {
                                    if (_listFull[i].actividad![j].dias !=
                                        null) {
                                      _listFull[i].actividad![j].dias =
                                          _listFull[i].actividad![j].dias! - 1;
                                    }
                                  });
                                }
                              : null,
                        ),
                        SizedBox(
                          width: 45,
                          height: 45,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: TextFormField(
                              controller: TextEditingController(
                                  text: '${_listFull[i].actividad![j].dias}'),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  errorText: diaValidador ? 'Error' : null),
                            ),
                          ),
                        ),
                        IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                if (_listFull[i].actividad![j].dias != null) {
                                  _listFull[i].actividad![j].dias =
                                      _listFull[i].actividad![j].dias! + 1;
                                }
                              });
                            })
                      ],
                    ),
                  ),
                  TextFormFields(
                    icon: Icons.remove_red_eye,
                    large: 500.0,
                    ancho: 80,
                    item: CheckboxListTile(
                      title: const Text('Visible para involucrados:'),
                      controlAffinity: ListTileControlAffinity.platform,
                      value: _listFull[i].actividad![j].visibleActividad,
                      onChanged: (valor) {
                        setState(() => _listFull[i]
                            .actividad![j]
                            .visibleActividad = valor);
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
                children: [
                  TextFormFields(
                      icon: Icons.linear_scale_outlined,
                      large: 500,
                      ancho: 80,
                      // item: _crearSelect(listActividad, idTarea, idActividad),
                      item: DropdownButton(
                        isExpanded: true,
                        value: _listFull[i].actividad![j].predecesorActividad,
                        icon: const Icon(Icons.arrow_drop_down_outlined),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: Color(0xFF000000)),
                        underline: Container(
                          height: 2,
                          color: const Color(0xFF000000),
                        ),
                        onChanged: (dynamic valor) {
                          setState(() {
                            _listFull[i].actividad![j].predecesorActividad =
                                valor;
                          });
                        },
                        items: _listFull[i].actividad!.map((item) {
                          return DropdownMenuItem(
                            value: item.idActividad,
                            child: Text(
                              item.idActividad != 0
                                  ? item.nombreActividad!
                                  : 'Selecciona un predecesor',
                              style: const TextStyle(fontSize: 18),
                            ),
                          );
                        }).toList(),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ElevatedButton(
                      child: const Tooltip(
                        child: Icon(Icons.save_sharp),
                        message: "Agregar actividad",
                      ),
                      onPressed: () {
                        // validamos data
                        if (_listFull[i].actividad![j].nombreActividad == '') {
                          setState(() => nombreValidador = true);
                        } else if (_listFull[i]
                                .actividad![j]
                                .describeActividad ==
                            '') {
                          setState(() => descripcionValidador = true);
                        } else if (_listFull[i].actividad![j].dias! <= 0) {
                          setState(() => diaValidador = true);
                        } else {
                          // validaciones
                          // setState(() =>nombreValidador = false);
                          // setState(() =>descripcionValidador = false);
                          // setState(() =>diaValidador = false);
                          // preparamos Actividad
                          Map<String, dynamic> actividadTemporal = {
                            'id_actividad': _listFull[i]
                                .actividad![j]
                                .idActividad
                                .toString(),
                            'nombre_actividad': _listFull[i]
                                .actividad![j]
                                .nombreActividad
                                .toString(),
                            'describe_actividad': _listFull[i]
                                .actividad![j]
                                .describeActividad
                                .toString(),
                            'dias': _listFull[i].actividad![j].dias.toString(),
                            'fecha_inicio_actividad': DateTime.now().toString(),
                            'agregar_actividad': false.toString(),
                            'visible_actividad': _listFull[i]
                                .actividad![j]
                                .visibleActividad
                                .toString(),
                            'predecesor_actividad': _listFull[i]
                                        .actividad![j]
                                        .predecesorActividad ==
                                    0
                                ? '0'
                                : _listFull[i]
                                    .actividad![j]
                                    .predecesorActividad
                                    .toString(),
                          };
                          _addActividad(
                              _listFull[i].idTarea, actividadTemporal);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30.0,
              ),
            ],
          ));
        }
      }

      // add new activities
      listTiles.add(Container(
          padding: const EdgeInsets.only(right: 15.0, bottom: 15.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              child: Tooltip(
                child: _listFull[i].nuevaActividad == true
                    ? const Icon(Icons.add)
                    : const Icon(Icons.remove),
                message: "Agregar actividades",
              ),
              onPressed: () {
                setState(() {
                  if (_listFull[i].nuevaActividad == true) {
                    _listFull[i].actividad!.add(Actividad(
                          idActividad: 0,
                          nombreActividad: '',
                          describeActividad: '',
                          dias: 1,
                          fechaInicioActividad: DateTime.now(),
                          agregarActividad: false,
                          visibleActividad: false,
                          predecesorActividad: 0,
                          fechaInicioEvento: _listFull[i].fechaInicioEvento,
                          fechaFinalEvento: _listFull[i].fechaFinalEvento,
                        ));
                    _listFull[i].nuevaActividad = false;
                  } else {
                    _listFull[i].actividad!.removeLast();
                    _listFull[i].nuevaActividad = true;
                  }
                });
              },
            ),
          )));
      // end add new activities

      children.add(ExpansionPanel(
        headerBuilder: (context, isExpanded) {
          return ListTile(
            leading: Checkbox(
              value: _listFull[i].checkTarea ?? false,
              onChanged: (valor) {
                setState(() {
                  if (_listFull[i].expandedTarea == false) {
                    _listFull[i].checkTarea = valor;
                  }
                });
              },
            ),
            title: Text(data[i].nombreTarea!),
          );
        },
        isExpanded: _listFull[i].expandedTarea ?? false,
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
    for (int i = 0; i < itemInMethod.results.length; i++) {
      //
      List<Actividad> tempActividad = [];
      //
      bool isOpen = false;
      //
      for (int j = 0; j < itemInMethod.results.length; j++) {
        if (itemInMethod.results[i].idEventoTiming ==
            itemInMethod.results[j].idEventoTiming) {
          tempActividad.add(Actividad(
            idActividad: itemInMethod.results[j].idEventoActividad,
            nombreActividad: itemInMethod.results[j].nombreEventoActividad,
            describeActividad: itemInMethod.results[j].descripcion,
            dias: itemInMethod.results[j].dia,
            fechaInicioActividad: itemInMethod.results[j].fechaInicioActividad,
            fechaInicioEvento: itemInMethod.results[j].fechaInicioEvento,
            fechaFinalEvento: itemInMethod.results[j].fechaFinalEvento,
            agregarActividad: itemInMethod.results[j].addActividad,
          ));

          if (itemInMethod.results[j].addActividad == true) isOpen = true;
        }
      }
      //
      if (i == 0) {
        tempTarea.add(Tarea(
          idTarea: itemInMethod.results[i].idEventoTiming,
          nombreTarea: itemInMethod.results[i].nombreEventoTarea,
          checkTarea: isOpen,
          expandedTarea: isOpen,
          nuevaActividad: true,
          fechaInicioEvento: itemInMethod.results[i].fechaInicioEvento,
          fechaFinalEvento: itemInMethod.results[i].fechaFinalEvento,
          actividad: tempActividad,
        ));
      } else {
        if (itemInMethod.results[(i - 1)].idEventoTiming !=
            itemInMethod.results[i].idEventoTiming) {
          tempTarea.add(Tarea(
            idTarea: itemInMethod.results[i].idEventoTiming,
            nombreTarea: itemInMethod.results[i].nombreEventoTarea,
            checkTarea: isOpen,
            expandedTarea: isOpen,
            nuevaActividad: true,
            fechaInicioEvento: itemInMethod.results[i].fechaInicioEvento,
            fechaFinalEvento: itemInMethod.results[i].fechaFinalEvento,
            actividad: tempActividad,
          ));
        }
      }
    }

    return tempTarea;
  }

  _buscadorActividades(String valor) {
    if (valor.length > 2) {
      List<dynamic> buscador = itemModel!.results
          .where((element) => element.nombreEventoTarea!
              .toLowerCase()
              .contains(valor.toLowerCase()))
          .toList();
      setState(() {
        copyItemModel!.results.clear();
        if (buscador.isNotEmpty) {
          for (var element in buscador) {
            copyItemModel!.results.add(element);
            // rescribir cheks
            // copyItemModel.results.forEach((element) {
            //   if(_keepStatus[element.idActividad] != null)
            //     element.addActividad = _keepStatus[element.idActividad].isCheck;
            // });
          }
        } else {}
      });
    } else {
      setState(() {
        if (itemModel != null) {
          copyItemModel = itemModel!.copy();
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

  // colores
  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  FloatingActionButton _agregarActividadCalendario() {
    return FloatingActionButton(
      heroTag: UniqueKey(),
      backgroundColor: hexToColor('#fdf4e5'),
      foregroundColor: Colors.white,
      child: const Tooltip(
        child: Icon(Icons.calendar_today_outlined),
        message: "Agregar al calendario",
      ),
      onPressed: () async {
        _saveActividades();
      },
    );
  }

  void _saveActividades() {
    List<Actividad> send = [];

    for (var full in _listFull) {
      for (var actividad in full.actividad!) {
        if (actividad.agregarActividad == true) send.add(actividad);
        eventoTimingBloc.add(ActulizarTimingsEvent(actividad.idActividad,
            actividad.agregarActividad, actividad.fechaInicioActividad));
      }
    }

    // agregamos a la base de datos
    Navigator.of(context).pushNamed('/eventoCalendario', arguments: send);
  }

  // parte del calendary put
  Widget _calendaryIcon(DateTime? fechaInicio, int? idActividad,
      DateTime? fechaInicioEvento, DateTime? fechaFinalEvento, int? dias) {
    return GestureDetector(
      child: const Icon(
        Icons.calendar_today,
        color: Colors.black,
      ),
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());

        fechaInicio = await showDatePicker(
          context: context,
          initialDate: fechaInicio!,
          errorFormatText: 'Error en el formato',
          errorInvalidText: 'Error en la fecha',
          fieldHintText: 'día/mes/año',
          fieldLabelText: 'Fecha de inicio de la actividad',
          firstDate: fechaInicioEvento!,
          lastDate: fechaFinalEvento!,
        );

        // // agregamos la nueva fecha
        for (var tareas in _listFull) {
          for (var actividades in tareas.actividad!) {
            if (actividades.idActividad == idActividad) {
              if (fechaInicio != null) {
                if (fechaInicio!
                    .add(Duration(days: actividades.dias!))
                    .isAfter(actividades.fechaFinalEvento!)) {
                  _alertaFechas(
                      actividades.nombreActividad,
                      actividades.fechaInicioEvento,
                      fechaInicio,
                      actividades.fechaFinalEvento,
                      actividades.dias!);
                } else {
                  actividades.fechaInicioActividad = fechaInicio;
                }
              } else {}
            }
          }
        }
      },
    );
  }

  // mensajes
  Future<void> _alertaFechas(String? actividad, DateTime? fechaInicialEvento,
      DateTime? fechaActividad, DateTime? fechaFinalEvento, int duracion) {
    String txtDuracion;

    if (duracion > 1) {
      txtDuracion = 'tiene la duración de $duracion dias';
    } else {
      txtDuracion = 'tiene la duración de $duracion dia';
    }

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
                Text(txtDuracion),
                const SizedBox(
                  height: 15.0,
                ),
                const Text('No puedes exceder el día final del evento,'),
                const SizedBox(
                  height: 15.0,
                ),
                Text(
                    'fecha final: ${DateFormat("yyyy-MM-dd").format(fechaFinalEvento!)}')
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
  void _addActividad(int? idTarea, Map<String, dynamic> actividad) {
    for (var tarea in _listFull) {
      if (tarea.idTarea == idTarea) tarea.nuevaActividad = true;
    }
    eventoTimingBloc.add(AddActividadesEvent(actividad, idTarea));
  }

  // tiene un bug
  Widget? _formAddActividad(
      int idTarea, int idActividad, List<Actividad> listActividad) {
    Column? temp;

    for (var tarea in _listFull) {
      for (var actividad in tarea.actividad!) {
        if (actividad.idActividad == idActividad) {
          temp = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 15.0,
              ),
              Wrap(
                alignment: WrapAlignment.center,
                children: <Widget>[
                  TextFormFields(
                    icon: Icons.local_activity,
                    large: 500.0,
                    ancho: 80.0,
                    item: TextFormField(
                      controller: null,
                      decoration: const InputDecoration(
                        labelText: 'Nombre:',
                      ),
                    ),
                  ),
                  TextFormFields(
                    icon: Icons.drive_file_rename_outline,
                    large: 500.0,
                    ancho: 80.0,
                    item: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Descripción:',
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
                children: <Widget>[
                  TextFormFields(
                    icon: Icons.date_range_outlined,
                    large: 500.0,
                    ancho: 80.0,
                    item: Row(
                      children: [
                        const Expanded(child: Text("Duración en días:")),
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {},
                        ),
                        SizedBox(
                          width: 45,
                          height: 45,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: TextFormField(
                              // controller: et ? numCtrl : numEditCtrl,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        IconButton(
                            icon: const Icon(Icons.add), onPressed: () {})
                      ],
                    ),
                  ),
                  TextFormFields(
                    icon: Icons.remove_red_eye,
                    large: 500.0,
                    ancho: 80,
                    item: CheckboxListTile(
                      title: const Text('Visible para involucrados:'),
                      controlAffinity: ListTileControlAffinity.platform,
                      value: false,
                      onChanged: (valor) {},
                      activeColor: Colors.green,
                      checkColor: Colors.black,
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
                    icon: Icons.linear_scale_outlined,
                    large: 500,
                    ancho: 80,
                    item: _crearSelect(listActividad, idTarea, idActividad),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ElevatedButton(
                      child: const Tooltip(
                        child: Icon(Icons.save_sharp),
                        message: "Agregar actividad",
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30.0,
              ),
            ],
          );
        }
      }
    }

    return temp;
  }

  // tiene un bug
  Widget? _crearSelect(
      List<Actividad> listActividades, int idTarea, int idActividad) {
    Widget? temp;

    for (var tareas in _listFull) {
      for (var actividades in tareas.actividad!) {
        if (actividades.idActividad == idActividad) {
          temp = DropdownButton(
            isExpanded: true,
            value: actividades.predecesorActividad,
            icon: const Icon(Icons.arrow_drop_down_outlined),
            iconSize: 24,
            elevation: 16,
            style: const TextStyle(color: Color(0xFF000000)),
            underline: Container(
              height: 2,
              color: const Color(0xFF000000),
            ),
            onChanged: (dynamic valor) {
              setState(() {
                actividades.predecesorActividad = valor;
              });
            },
            items: tareas.actividad!.map((item) {
              return DropdownMenuItem(
                value: item.idActividad,
                child: Text(
                  item.idActividad != 0
                      ? item.nombreActividad!
                      : 'Selecciona un predecesor',
                  style: const TextStyle(fontSize: 18),
                ),
              );
            }).toList(),
          );
        }
      }
    }

    return listActividades.length > 1
        ? temp
        : const Center(child: Text('Sin predecesores'));
  }
}

// clases para manejar el modelo
// tarea
class Tarea {
  int? idTarea;
  String? nombreTarea;
  bool? checkTarea;
  bool? expandedTarea;
  bool? nuevaActividad;
  DateTime? fechaInicioEvento;
  DateTime? fechaFinalEvento;
  List<Actividad>? actividad;

  Tarea({
    this.idTarea,
    this.nombreTarea,
    this.checkTarea,
    this.expandedTarea,
    this.nuevaActividad,
    this.fechaInicioEvento,
    this.fechaFinalEvento,
    this.actividad,
  });
}

// actividad
class Actividad {
  int? idActividad;
  String? nombreActividad;
  String? describeActividad;
  int? dias;
  DateTime? fechaInicioActividad;
  DateTime? fechaInicioEvento;
  DateTime? fechaFinalEvento;
  bool? agregarActividad;
  bool? visibleActividad;
  int? predecesorActividad;

  Actividad({
    this.idActividad,
    this.nombreActividad,
    this.describeActividad,
    this.dias,
    this.fechaInicioActividad,
    this.fechaInicioEvento,
    this.fechaFinalEvento,
    this.agregarActividad,
    this.visibleActividad,
    this.predecesorActividad,
  });
}

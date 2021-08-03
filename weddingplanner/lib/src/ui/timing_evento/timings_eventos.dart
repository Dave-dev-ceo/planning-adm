// imports dart/flutter
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:flutter/services.dart';

// blocs
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingplanner/src/blocs/actividadesTiming/actividadestiming_bloc.dart';

// model
import 'package:weddingplanner/src/models/item_model_actividades_timings.dart';
import 'package:weddingplanner/src/ui/widgets/text_form_filed/text_form_filed.dart';

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
        } else if (state is AddActividadesState) {
            // eventoTimingBloc.add(FetchActividadesTimingsPorIdPlannerEvent());
            // return Center(child: CircularProgressIndicator());
            _listFull.forEach((tarea) {
              tarea.actividad.forEach((actividad) {
                if(tarea.id_tarea == state.idTarea && actividad.id_actividad == 0 && tarea.nueva_actividad == true)
                  actividad.id_actividad = state.idActividad;
              });
            });
            return _crearVista(copyItemModel);
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
          SizedBox(height: 60.0,)
        ],
      ),
      floatingActionButton: _agregarActividadCalendario(),
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
      List<Widget> listTiles = [];
      for(int j = 0; j < _listFull[i].actividad.length; j++){
        if(_listFull[i].actividad[j].id_actividad != 0) {
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
              title: Text('${_listFull[i].actividad[j].nombre_actividad}'),
              subtitle: Text('${_listFull[i].actividad[j].describe_actividad}'),
              trailing: _listFull[i].actividad[j].agregar_actividad == true ? _calendaryIcon(_listFull[i].actividad[j].fecha_inicio_actividad,_listFull[i].actividad[j].id_actividad,_listFull[i].actividad[j].fecha_inicio_evento,_listFull[i].actividad[j].fecha_final_evento,_listFull[i].actividad[j].dias) : null,
              // onTap: _listFull[i].actividad[j].agregar_actividad == true ? (){} : null,
            )
          );
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
              SizedBox(height: 15.0,),
              Wrap(
                alignment: WrapAlignment.center,
                children: <Widget>[
                  TextFormFields(
                      icon: Icons.local_activity,
                      large: 500.0,
                      ancho: 80.0,
                      item: TextFormField(
                        controller: TextEditingController(text: '${_listFull[i].actividad[j].nombre_actividad}'),
                        decoration: new InputDecoration(
                          labelText: 'Nombre:',
                          errorText: nombreValidador ? 'Campo obligatorio.':null
                        ),
                        onChanged: (valor) {
                          _listFull[i].actividad[j].nombre_actividad = valor;
                        },
                      ),
                  ),
                  TextFormFields(
                    icon: Icons.drive_file_rename_outline,
                    large: 500.0,
                    ancho: 80.0,
                    item: TextFormField(
                      controller: TextEditingController(text: '${_listFull[i].actividad[j].describe_actividad}'),
                      decoration: new InputDecoration(
                        labelText: 'Descripción:',
                        errorText: descripcionValidador ? 'Campo obligatorio.':null
                      ),
                      onChanged: (valor) {
                        _listFull[i].actividad[j].describe_actividad = valor;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.0,),
              Wrap(
                alignment: WrapAlignment.center,
                children: <Widget>[
                  TextFormFields(
                    icon: Icons.date_range_outlined,
                    large: 500.0,
                    ancho: 80.0,
                    item: Row(
                      children: [
                        Expanded(child: Text("Duración en días:")),
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: _listFull[i].actividad[j].dias > 0 ? () {
                            setState(() => _listFull[i].actividad[j].dias--);
                          }:null,
                        ),
                        Container(
                          width: 45,
                          height: 45,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 3),
                            child: TextFormField(
                              controller: TextEditingController(text: '${_listFull[i].actividad[j].dias}'),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                              ],
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                errorText: diaValidador ? 'Error':null
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            setState(() => _listFull[i].actividad[j].dias++);
                          }
                        )
                      ],
                    ),
                  ),
                  TextFormFields(
                    icon: Icons.remove_red_eye,
                    large: 500.0,
                    ancho: 80,
                    item: CheckboxListTile(
                      title: Text('Visible para novios:'),
                      controlAffinity: ListTileControlAffinity.platform,
                      value: _listFull[i].actividad[j].visible_actividad,
                      onChanged: (valor) { setState(() =>  _listFull[i].actividad[j].visible_actividad = valor); },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.0,),
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
                      value: _listFull[i].actividad[j].predecesor_actividad,
                      icon: const Icon(Icons.arrow_drop_down_outlined),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Color(0xFF000000)),
                      underline: Container(
                        height: 2,
                        color: Color(0xFF000000),
                      ),
                      onChanged: (valor) {
                        setState(() {
                          _listFull[i].actividad[j].predecesor_actividad = valor;
                        });
                      },
                      items: _listFull[i].actividad.map((item) {
                        return DropdownMenuItem(
                          value: item.id_actividad,
                          child: Text(
                            item.id_actividad != 0 ? item.nombre_actividad:'Selecciona un predecesor',
                            style: TextStyle(fontSize: 18),
                          ),
                        );
                      }).toList(),
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: ElevatedButton(
                      child: Tooltip(
                        child: Icon(Icons.save_sharp),
                        message: "Agregar actividad.",
                      ),
                      onPressed: () {
                        // validamos data
                        if(_listFull[i].actividad[j].nombre_actividad == '') {
                          setState(() =>nombreValidador = true);
                        }
                        else if(_listFull[i].actividad[j].describe_actividad == '') {
                          setState(() =>descripcionValidador = true);
                        }
                        else if(_listFull[i].actividad[j].dias <= 0) {
                          setState(() =>diaValidador = true);
                        }
                        else {
                          // validaciones
                          // setState(() =>nombreValidador = false);
                          // setState(() =>descripcionValidador = false);
                          // setState(() =>diaValidador = false);
                          // preparamos Actividad
                          Map<String, dynamic>  actividadTemporal = {
                            'id_actividad': _listFull[i].actividad[j].id_actividad.toString(),
                            'nombre_actividad': _listFull[i].actividad[j].nombre_actividad.toString(),
                            'describe_actividad': _listFull[i].actividad[j].describe_actividad.toString(),
                            'dias': _listFull[i].actividad[j].dias.toString(),
                            'fecha_inicio_actividad': DateTime.now().toString(),
                            'agregar_actividad': false.toString(),
                            'visible_actividad': _listFull[i].actividad[j].visible_actividad.toString(),
                            'predecesor_actividad': _listFull[i].actividad[j].predecesor_actividad == 0 ? '0':_listFull[i].actividad[j].predecesor_actividad.toString(),
                          };
                          _addActividad(_listFull[i].id_tarea, actividadTemporal);
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.0,),
            ],
          )

          );
        }
      }

      // add new activities
      listTiles.add(
        Container(
          padding: EdgeInsets.only(right: 15.0,bottom: 15.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              child: Tooltip(
                child: _listFull[i].nueva_actividad == true ? Icon(Icons.add):Icon(Icons.remove),
                message: "Agregar actividades.",
              ),
              onPressed: () {
                setState(() {
                  if(_listFull[i].nueva_actividad == true) {
                    _listFull[i].actividad.add(
                      Actividad(
                        id_actividad: 0,
                        nombre_actividad: '',
                        describe_actividad: '',
                        dias: 1,
                        fecha_inicio_actividad: DateTime.now(),
                        agregar_actividad: false,
                        visible_actividad: false,
                        predecesor_actividad: 0,
                        fecha_inicio_evento: _listFull[i].fecha_inicio_evento,
                        fecha_final_evento: _listFull[i].fecha_final_evento,
                      )
                    );
                    _listFull[i].nueva_actividad = false;
                  } else {
                    _listFull[i].actividad..removeLast();
                    _listFull[i].nueva_actividad = true;
                  }
                });
              },
            ),
          )
        )
      );
      // end add new activities

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
      bool isOpen = false;
      //
      for(int j = 0; j < itemInMethod.results.length; j++) {
        if(itemInMethod.results[i].idEventoTiming == itemInMethod.results[j].idEventoTiming) {
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

          if(itemInMethod.results[j].addActividad == true)
            isOpen = true;
        }
      }
      //
      if(i == 0)
        tempTarea.add(Tarea(
          id_tarea: itemInMethod.results[i].idEventoTiming,
          nombre_tarea: itemInMethod.results[i].nombreEventoTarea,
          check_tarea: isOpen,
          expanded_tarea: isOpen,
          nueva_actividad: true,
          fecha_inicio_evento: itemInMethod.results[i].fechaInicioEvento,
          fecha_final_evento: itemInMethod.results[i].fechaFinalEvento,
          actividad: tempActividad,
        ));
      else {
        if(itemInMethod.results[(i-1)].idEventoTiming != itemInMethod.results[i].idEventoTiming)
          tempTarea.add(Tarea(
            id_tarea: itemInMethod.results[i].idEventoTiming,
            nombre_tarea: itemInMethod.results[i].nombreEventoTarea,
            check_tarea: isOpen,
            expanded_tarea: isOpen,
            nueva_actividad: true,
            fecha_inicio_evento: itemInMethod.results[i].fechaInicioEvento,
            fecha_final_evento: itemInMethod.results[i].fechaFinalEvento,
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

  // colores
  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  FloatingActionButton _agregarActividadCalendario() {
    return FloatingActionButton(
      backgroundColor: hexToColor('#000000'),
      foregroundColor: Colors.white,
      child: Tooltip(
        child: Icon(Icons.calendar_today_outlined),
        message: "Agregar a calendario.",
      ),
      onPressed: () async { await _saveActividades();},
    );
  }

  void _saveActividades() {
    List<Actividad> send = [];

    _listFull.forEach((full) {
      full.actividad.forEach((actividad) {
        if(actividad.agregar_actividad == true)
          send.add(actividad);
        eventoTimingBloc.add(ActulizarTimingsEvent(actividad.id_actividad,actividad.agregar_actividad,actividad.fecha_inicio_actividad));
      });
    });

    // agregamos a la base de datos
    Navigator.of(context).pushNamed('/eventoCalendario', arguments: send);
  }

  // parte del calendary put
  Widget _calendaryIcon(DateTime fechaInicio,int idActividad, DateTime fechaInicioEvento, DateTime fechaFinalEvento, int dias) {
    return GestureDetector(
      child: Icon(Icons.calendar_today, color: Colors.black,),
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
  void _addActividad(int id_tarea, Map<String, dynamic> actividad) {
    _listFull.forEach((tarea) {
      if(tarea.id_tarea == id_tarea)
        tarea.nueva_actividad = true;
    });
    eventoTimingBloc.add(AddActividadesEvent(actividad,id_tarea));
  }

  // tiene un bug
  Widget _formAddActividad(int idTarea, int idActividad, List<Actividad> listActividad) {
    Column temp;

    _listFull.forEach((tarea) {
      tarea.actividad.forEach((actividad) {
        if(actividad.id_actividad == idActividad) {
          temp =  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 15.0,),
              Wrap(
                alignment: WrapAlignment.center,
                children: <Widget>[
                  TextFormFields(
                      icon: Icons.local_activity,
                      large: 500.0,
                      ancho: 80.0,
                      item: TextFormField(
                        controller: null,
                        decoration: new InputDecoration(
                          labelText: 'Nombre:',
                        ),
                      ),
                  ),
                  TextFormFields(
                    icon: Icons.drive_file_rename_outline,
                    large: 500.0,
                    ancho: 80.0,
                    item: TextFormField(
                      decoration: new InputDecoration(
                        labelText: 'Descripción:',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.0,),
              Wrap(
                alignment: WrapAlignment.center,
                children: <Widget>[
                  TextFormFields(
                    icon: Icons.date_range_outlined,
                    large: 500.0,
                    ancho: 80.0,
                    item: Row(
                      children: [
                        Expanded(child: Text("Duración en días:")),
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {},
                        ),
                        Container(
                          width: 45,
                          height: 45,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 3),
                            child: TextFormField(
                              // controller: et ? numCtrl : numEditCtrl,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {}
                        )
                      ],
                    ),
                  ),
                  TextFormFields(
                    icon: Icons.remove_red_eye,
                    large: 500.0,
                    ancho: 80,
                    item: CheckboxListTile(
                      title: Text('Visible para novios:'),
                      controlAffinity: ListTileControlAffinity.platform,
                      value: false,
                      onChanged: (valor) {},
                      activeColor: Colors.green,
                      checkColor: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.0,),
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
                    padding: EdgeInsets.all(15.0),
                    child: ElevatedButton(
                      child: Tooltip(
                        child: Icon(Icons.save_sharp),
                        message: "Agregar actividad.",
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.0,),
            ],
          );
        }
      });
    });

    return temp;
  }

  // tiene un bug
  Widget _crearSelect(List<Actividad> listActividades, int idTarea, int idActividad) {
    Widget temp;

    _listFull.forEach((tareas) {
      tareas.actividad.forEach((actividades) {
        if(actividades.id_actividad == idActividad) {
          temp = DropdownButton(
            isExpanded: true,
            value: actividades.predecesor_actividad,
            icon: const Icon(Icons.arrow_drop_down_outlined),
            iconSize: 24,
            elevation: 16,
            style: const TextStyle(color: Color(0xFF000000)),
            underline: Container(
              height: 2,
              color: Color(0xFF000000),
            ),
            onChanged: (valor) {
              setState(() {
                actividades.predecesor_actividad = valor;
              });
            },
            items: tareas.actividad.map((item) {
              return DropdownMenuItem(
                value: item.id_actividad,
                child: Text(
                  item.id_actividad != 0 ? item.nombre_actividad:'Selecciona un predecesor',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }).toList(),
          );
        }
      });
    });

    return listActividades.length > 1 ? temp:Container(child: Center(child: Text('Sin predecesores')));
  }

}
// clases para manejar el modelo
// tarea
class Tarea {
  int id_tarea;
  String nombre_tarea;
  bool check_tarea;
  bool expanded_tarea;
  bool nueva_actividad;
  DateTime fecha_inicio_evento;
  DateTime fecha_final_evento;
  List<Actividad> actividad;

  Tarea({
    this.id_tarea,
    this.nombre_tarea,
    this.check_tarea,
    this.expanded_tarea,
    this.nueva_actividad,
    this.fecha_inicio_evento,
    this.fecha_final_evento,
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
  bool visible_actividad;
  int predecesor_actividad;

  Actividad({
    this.id_actividad,
    this.nombre_actividad,
    this.describe_actividad,
    this.dias,
    this.fecha_inicio_actividad,
    this.fecha_inicio_evento,
    this.fecha_final_evento,
    this.agregar_actividad,
    this.visible_actividad,
    this.predecesor_actividad,
  });
}

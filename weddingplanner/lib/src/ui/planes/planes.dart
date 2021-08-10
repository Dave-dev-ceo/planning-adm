// import flutter/dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:flutter/services.dart';

// blocs
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingplanner/src/blocs/planes/planes_bloc.dart';

// model
import 'package:weddingplanner/src/models/item_model_planes.dart';

// our
import 'package:weddingplanner/src/ui/widgets/text_form_filed/text_form_filed.dart';

class Planes extends StatefulWidget {
  Planes({Key key}) : super(key: key);

  @override
  _PlanesState createState() => _PlanesState();
}

class _PlanesState extends State<Planes> {
  // variables bloc
  PlanesBloc _planesBloc;

  // variable model
  ItemModelPlanes _itemModel;

  // variables class
  List<TareaPlanner> _listTare;
  List<TareaPlanner> _listFull;
  int _tabShow = 0;
  int botonIs = 0;
  String _condicionQuery = 'AND ea.estatus_progreso = true';
  bool _botonSave = false;

  @override
  void initState() {
    super.initState();
    // cargamos el bloc
    _planesBloc = BlocProvider.of<PlanesBloc>(context);
    _planesBloc.add(SelectPlanesEventoEvent(_condicionQuery));
  }

  @override
  Widget build(BuildContext context) {
    return _crearScaffold();
  }

  // creo el scaffold muestra la vista - v1
  Scaffold _crearScaffold() {
    return Scaffold(
      body: _buildBloc(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _botonFlotante(),
    );
  }

  // creo bloc principal
  Widget _buildBloc() {
    return BlocBuilder<PlanesBloc, PlanesState>(
      builder: (context, state) {
        // state ini
        if(state is InitiaPlaneslState)
          return Center(child: CircularProgressIndicator());
        // state log
        else if(state is LodingPlanesState)
          return Center(child: CircularProgressIndicator());
        // state select
        else if(state is SelectEventoState) {
          // evita que se reescriba la lista
          if (state.planes != null) {
            if(_itemModel != state.planes){
              _itemModel = state.planes;
              if (_itemModel != null) {
                _listTare = _crearListaEditable(_itemModel);
                _listFull = _crearListaEditable(state.full);
              }
            }
          } else {
            _planesBloc.add(SelectPlanesEventoEvent(_condicionQuery));
            return Center(child: CircularProgressIndicator());
          }
          if(_itemModel != null) {
            return _crearStickyHeader(_itemModel);
          }else {
            return Center(child: Text('Sin datos'));
          }
        }
        // state create
        else if(state is CreatePlanesState) {
          _planesBloc.add(SelectPlanesEventoEvent(_condicionQuery));
          return _crearStickyHeader(_itemModel);
        }
        // no state
        else
          return Center(child: CircularProgressIndicator());
      }
    );
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
      ),
    );
  }

  // crear header
  Container _header() {
    return Container(
      padding: EdgeInsets.all(20.0),
      width: double.infinity,
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Actividades', style: TextStyle(fontSize: 20.0),),
          SizedBox(height: 15.0,),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _botonSave ? _mostrarBoton():SizedBox(width: 0),
              SizedBox(width: 10.0,),
              ElevatedButton(
                child: Icon(Icons.add),
                onPressed: _goAddingPlanes,
              ),
            ],
          ),
          SizedBox(height: 15.0,),
          _tabsActividades(),
        ],
      ),
    );
  }

  // crear content
  Container _content(ItemModelPlanes model) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 15.0,),
          _crearViewExpanded(model),
        ],
      ),
    );
  }

  // tabs
  Widget _tabsActividades() {
    return DefaultTabController(
      length: 3,
      initialIndex: _tabShow,
      child: TabBar(
        labelColor: Colors.black,
        tabs: [
          Tab(text: 'Realizado'),
          Tab(text: 'Pendiente'),
          Tab(text: 'Atrasado'),
        ],
        onTap: (index) {
          setState(() {
            _tabShow = index;
            if(index == 0)
              _updateYselect(_listTare,'AND ea.estatus_progreso = true',true);
            else if(index == 1)
              _updateYselect(_listTare,
                'AND ea.estatus_progreso = false ' +
                'AND ea.fecha_inicio_actividad >= NOW() ',
                true
              );
            else
              _updateYselect(_listTare,
                'AND ea.estatus_progreso = false ' +
                'AND ea.fecha_inicio_actividad <= NOW() ',
                true
              );
          });
        },
      ),
    );
  }

  // pasamos el model a una lista
  List<TareaPlanner> _crearListaEditable(ItemModelPlanes model) {
    List<TareaPlanner> tempTarea = []; // variable temporal 1° ciclo

    // ciclo para separar tareas
    for(int i = 0; i < model.planes.length; i++) {
      List<ActividadPlanner> tempActividad = []; // cariable temporal 2° ciclo
      bool tempCheck = true;
      int progreso = 0;
      // ciclo para separar actividades
      for(int j = 0; j < model.planes.length; j++) {
        // junta las actividades de cada tarea en una lista
        if(model.planes[i].idPlan == model.planes[j].idPlan) {
          if(!model.planes[j].statusProgreso)
            tempCheck = false;
          else
            progreso++;
          tempActividad.add(ActividadPlanner(
            idActividadPlanner: model.planes[j].idActividad,
            nombreActividadPlanner: model.planes[j].nombreActividad,
            descripcionActividadPlanner: model.planes[j].descripcionActividad,
            visibleInvolucradosActividadPlanner: model.planes[j].visibleInvolucradosActividad,
            diasActividadPlanner: model.planes[j].duracionActividad,
            predecesorActividadPlanner: model.planes[j].predecesorActividad,
            fechaInicioActividad: model.planes[j].fechaInicioActividad,
            fechaInicioEvento:model.planes[i].fechaInicioEvento,
            fechaFinalEvento: model.planes[i].fechaFinalEvento,
            idOldActividad: model.planes[j].idOldActividad,
            calendarActividad: model.planes[j].statusCalendar,
            checkActividadPlanner: model.planes[j].statusProgreso,
            nombreValida: true,
            descriValida: true,
          ));
        }
      }

      // juntando las tareas con sus actividades
      if(i == 0) 
        tempTarea.add(TareaPlanner(
          idTareaPlanner: model.planes[i].idPlan,
          nombreTareaPlanner: model.planes[i].nombrePlan,
          fechaInicioEvento: model.planes[i].fechaInicioEvento,
          fechaFinalEvento: model.planes[i].fechaFinalEvento,
          idTareaOld: model.planes[i].idOldPlan,
          checkTarePlanner: tempCheck,
          expandedTarePlanner: false,
          progreso: progreso,
          botonAdd: true,
          actividadTareaPlanner: tempActividad,
        ));
      else {
        if(model.planes[i].idPlan != model.planes[(i-1)].idPlan) 
          tempTarea.add(TareaPlanner(
            idTareaPlanner: model.planes[i].idPlan,
            nombreTareaPlanner: model.planes[i].nombrePlan,
            fechaInicioEvento: model.planes[i].fechaInicioEvento,
            fechaFinalEvento: model.planes[i].fechaFinalEvento,
            idTareaOld: model.planes[i].idOldPlan,
            checkTarePlanner: tempCheck,
            expandedTarePlanner: false,
            progreso: progreso,
            botonAdd: true,
            actividadTareaPlanner: tempActividad
          ));
      }
    }

    return tempTarea; // enviamos la lista
  }

  // creamos una promesa de una lista
  Future<List<TareaPlanner>> _promiseList(ItemModelPlanes model) async {
    return _crearListaEditable(model);
  }

  // creamos los expandeds
  List<ExpansionPanel> _buildListExpanded(List<TareaPlanner> list) {
    List<ExpansionPanel> listExpanded = []; // variable con la lista de expanded
    
    // ciclo para generar mis widgets padres
    for(int i = 0; i < _listTare.length; i++) {
      List<Widget> listWidget = []; // variable con los hijos del expanded

      // ciclo para generar los hijos
      for(int j = 0; j < _listTare[i].actividadTareaPlanner.length; j++) {
        // agregamos items a la lista widget
        if(_listTare[i].actividadTareaPlanner[j].idActividadPlanner != 0) {
          bool canChange = _listTare[i].actividadTareaPlanner[j].calendarActividad  ; // variable q indica si puede cambiar
          listWidget.add(
            ListTile(
              leading: Checkbox(
                value: _listTare[i].actividadTareaPlanner[j].checkActividadPlanner,
                onChanged: (valor){
                  if(canChange) {
                    setState(() {
                      _listTare[i].actividadTareaPlanner[j].checkActividadPlanner = valor;
                      if(valor) {
                        _listTare[i].progreso++;

                        _listFull.forEach((tarea) {
                          if(_listTare[i].idTareaPlanner == tarea.idTareaPlanner) {
                            tarea.progreso++;
                          }
                        });

                      }
                      else {
                        _listTare[i].progreso--;

                        _listFull.forEach((tarea) {
                          if(_listTare[i].idTareaPlanner == tarea.idTareaPlanner) {
                            tarea.progreso--;
                          }
                        });

                      }

                      // done
                      bool tempBool = true;
                      _listTare[i].actividadTareaPlanner.forEach((actividad) {
                        if(!actividad.checkActividadPlanner)
                          tempBool = false;
                      });

                      _listTare[i].checkTarePlanner = tempBool;
                      
                      _botonSave = true; // cambio boton

                    });
                  } else {
                    _mensaje('Debes poner fecha, antes de finalizar actividades');
                  }
                },
              ),
              title: Row(
                children: [
                  Expanded(child: Text(list[i].actividadTareaPlanner[j].nombreActividadPlanner),flex: 5,),
                  // Expanded(child: Icon(Icons.calendar_today_outlined),flex: 1,),
                  // Expanded(child: Icon(Icons.delete),flex: 1,),
                  Expanded(
                    flex: 1,
                    child: _giveFecha(_listTare[i].actividadTareaPlanner[j].fechaInicioActividad,_listTare[i].fechaInicioEvento, _listTare[i].fechaFinalEvento, _listTare[i].actividadTareaPlanner[j].diasActividadPlanner,_listTare[i].actividadTareaPlanner[j].idActividadPlanner),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      child: Icon(Icons.delete),
                      onTap: () async {
                        _alertaBorrar(_listTare[i].actividadTareaPlanner[j].idActividadPlanner, _listTare[i].actividadTareaPlanner[j].nombreActividadPlanner,_condicionQuery);
                      },
                    ),
                  ),
                ],
              ),
              subtitle: Text(list[i].actividadTareaPlanner[j].descripcionActividadPlanner),
            )
          );
        } else {
          listWidget.add(
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                          controller: TextEditingController(text: '${_listTare[i].actividadTareaPlanner[j].nombreActividadPlanner}'),
                          decoration: new InputDecoration(
                            labelText: 'Nombre:',
                            errorText: _listTare[i].actividadTareaPlanner[j].nombreValida ? null:'Campo obligatorio.'
                          ),
                          onChanged: (valor) {
                            _listTare[i].actividadTareaPlanner[j].nombreActividadPlanner = valor;
                          },
                        ),
                    ),
                    TextFormFields(
                      icon: Icons.drive_file_rename_outline,
                      large: 500.0,
                      ancho: 80.0,
                      item: TextFormField(
                        controller: TextEditingController(text: '${_listTare[i].actividadTareaPlanner[j].descripcionActividadPlanner}'),
                        decoration: new InputDecoration(
                          labelText: 'Descripción:',
                          errorText: _listTare[i].actividadTareaPlanner[j].descriValida ? null:'Campo obligatorio.'
                        ),
                        onChanged: (valor) {
                          _listTare[i].actividadTareaPlanner[j].descripcionActividadPlanner = valor;
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
                            onPressed: _listTare[i].actividadTareaPlanner[j].diasActividadPlanner > 1 ? () {
                              setState(() => _listTare[i].actividadTareaPlanner[j].diasActividadPlanner--);
                            }:null,
                          ),
                          Container(
                            width: 45,
                            height: 45,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 3),
                              child: TextFormField(
                                controller: TextEditingController(text: '${_listTare[i].actividadTareaPlanner[j].diasActividadPlanner}'),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                ],
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              setState(() => _listTare[i].actividadTareaPlanner[j].diasActividadPlanner++);
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
                        value: _listTare[i].actividadTareaPlanner[j].visibleInvolucradosActividadPlanner,
                        onChanged: (valor) { setState(() =>  _listTare[i].actividadTareaPlanner[j].visibleInvolucradosActividadPlanner = valor); },
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
                      item: DropdownButton(
                        isExpanded: true,
                        value: _listTare[i].actividadTareaPlanner[j].predecesorActividadPlanner,
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
                            _listTare[i].actividadTareaPlanner[j].predecesorActividadPlanner = valor;
                          });
                        },
                        items: _listTare[i].actividadTareaPlanner.map((item) {
                          return DropdownMenuItem(
                            value: item.idActividadPlanner,
                            child: Text(
                              item.idActividadPlanner != 0 ? item.nombreActividadPlanner:'Selecciona un predecesor',
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
                          setState(() {
                            // re
                            _listTare[i].actividadTareaPlanner[j].nombreValida = true;
                            _listTare[i].actividadTareaPlanner[j].descriValida = true;
                            // validamos data
                            if(_listTare[i].actividadTareaPlanner[j].nombreActividadPlanner == '') {
                              _listTare[i].actividadTareaPlanner[j].nombreValida = false;
                            }
                            else if(_listTare[i].actividadTareaPlanner[j].descripcionActividadPlanner == '') {
                              _listTare[i].actividadTareaPlanner[j].descriValida = false;
                            }
                            else {
                              Map<String, dynamic>  actividadTemporal = {
                                'id_actividad_timing': null.toString(),
                                'nombre': _listTare[i].actividadTareaPlanner[j].nombreActividadPlanner.toString(),
                                'descripcion': _listTare[i].actividadTareaPlanner[j].descripcionActividadPlanner.toString(),
                                'dias': _listTare[i].actividadTareaPlanner[j].diasActividadPlanner.toString(),
                                'visible_involucrados': _listTare[i].actividadTareaPlanner[j].visibleInvolucradosActividadPlanner.toString(),
                                'predecesor': _listTare[i].actividadTareaPlanner[j].predecesorActividadPlanner == 0 ? null.toString():_listFull[i].actividadTareaPlanner[j].predecesorActividadPlanner.toString(),
                              };
                              _planesBloc.add(CreateUnaPlanesEvent(actividadTemporal, _listTare[i].idTareaPlanner, _condicionQuery));
                              _mensaje('Actividad agregada');
                            }
                          });
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

      // agregamos boton de mas x tarea
      listWidget.add(
        Padding(
          padding: EdgeInsets.all(15.0),
          child: ElevatedButton(
            child: _listTare[i].botonAdd ? Icon(Icons.add):Icon(Icons.remove),
            onPressed: () => _addActividad(_listTare[i].idTareaPlanner),
          ),
        )
      );

      // lista full encontrar tamaño y progreso || tiene fallas no actualiza en TR
      // manejar la lista general y ahi acer los cambios
      int totalTareas = 0;
      int totalHechas = 0;

      _listFull.forEach((tarea) {
        if(_listTare[i].idTareaPlanner == tarea.idTareaPlanner) {
          totalTareas = tarea.actividadTareaPlanner.length;
          totalHechas = tarea.progreso;
        }
      });

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
                      if(actividad.checkActividadPlanner != valor) {
                        if(valor) {
                          _listTare[i].progreso++;

                          _listFull.forEach((tarea) {
                            if(_listTare[i].idTareaPlanner == tarea.idTareaPlanner) {
                              tarea.progreso++;
                            }
                          });

                        }
                        else {
                          _listTare[i].progreso--;

                          _listFull.forEach((tarea) {
                            if(_listTare[i].idTareaPlanner == tarea.idTareaPlanner) {
                              tarea.progreso--;
                            }
                          });

                        }
                      }
                      actividad.checkActividadPlanner = valor;
                    });

                    _botonSave = true; // cambio boton

                  });
                },
              ),
              title: Text(list[i].nombreTareaPlanner),
              subtitle: Text('Progreso: ${totalHechas}/${totalTareas}'),
              onTap: () {
                // evento clic en el cuerpo de la listTile cabre el expanded
                setState(() {
                  _listTare[i].expandedTarePlanner = !_listTare[i].expandedTarePlanner;
                });
              },
            );
          },
          isExpanded: _listTare[i].expandedTarePlanner ?? false,
          body: Container(
            padding: EdgeInsets.only(left: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
    if(model.planes.length > 0) {
      return FutureBuilder<List<TareaPlanner>>(
        future: _promiseList(model),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
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
          }
          else return Center(child: CircularProgressIndicator(),);
        }
      );
    }
    else return Center(child: Text('Sin datos'),);
  }

  // mostra boton al realizar cambios
  ElevatedButton _mostrarBoton() {
    return ElevatedButton(
      child: Icon(Icons.save),
      onPressed: () => _updateYselect(_listTare, _condicionQuery,false),
    );
  }

  // boton flotante
  FloatingActionButton _botonFlotante() {
    return FloatingActionButton(
      child: Icon(Icons.calendar_today),
      onPressed: () => _saveActividades(),
    );
  }

  /* Eventos */

  // vamos a ver los planes para agregar
  void _goAddingPlanes() {
    _tabShow = 2;
    Navigator.of(context).pushNamed('/agregarPlan', arguments: _listFull);
  }

  // evento de tabs tiene errores pero funciona
  void _updateYselect(List<TareaPlanner> listTare, String txt, bool who) {
    _condicionQuery = txt; // paradoja del abuelo
    // variable temp
    List<ActividadPlanner> tempActividad = [];
    // comparamos la lista full y si hay cambios enviamos update
    _listFull.forEach((tareas) {
      // ciclo revisa actividades
      tareas.actividadTareaPlanner.forEach((actividades) {
        // tarea
        listTare.forEach((tarea) {
          // actividad
          tarea.actividadTareaPlanner.forEach((actividad) {
            // filtro
            if(actividades.idActividadPlanner == actividad.idActividadPlanner) {
              // 1
              if(actividades.fechaInicioActividad != actividad.fechaInicioActividad || actividades.checkActividadPlanner != actividad.checkActividadPlanner)
                tempActividad.add(
                  ActividadPlanner(
                    idActividadPlanner: actividad.idActividadPlanner,
                    fechaInicioActividad: actividad.fechaInicioActividad,
                    checkActividadPlanner: actividad.checkActividadPlanner,
                    calendarActividad: actividad.calendarActividad,
                  )
                );
            }
          });

        });

      });

    });
    // fin ciclos

    // filtro para enviar
    if(tempActividad.length > 0 && _tabShow != botonIs) {
      _botonSave = false; // reset
      _planesBloc.add(UpdatePlanesEventoEvent(tempActividad,_condicionQuery)); // cambiamos x updateevent
    }

    if(!who) {
      _botonSave = false; // reset
      _planesBloc.add(UpdatePlanesEventoEvent(tempActividad,_condicionQuery)); // cambiamos x updateevent
      _planesBloc.add(SelectPlanesEventoEvent(_condicionQuery));
      _mensaje('Cambios guardados.');
    }

    if(_tabShow != botonIs) {
      _planesBloc.add(SelectPlanesEventoEvent(_condicionQuery));
      botonIs = _tabShow;
    }
  }

  // add form to add actividades
  _addActividad(int idTareaPlanner) {
    setState(() {
      _listTare.forEach((tarea) {
        if(tarea.idTareaPlanner == idTareaPlanner) {
          if(tarea.botonAdd == true) {
            tarea.actividadTareaPlanner.add(
              ActividadPlanner(
                idActividadPlanner: 0,
                nombreActividadPlanner: '',
                descripcionActividadPlanner: '',
                diasActividadPlanner: 1,
                visibleInvolucradosActividadPlanner: false,
                predecesorActividadPlanner: 0,
                nombreValida: true,
                descriValida: true,
              )
            );
            tarea.botonAdd = false;
          } else {
            tarea.botonAdd = true;
            tarea.actividadTareaPlanner.removeLast();
          }
        }
      });
    });
  }

  // dialogo
  Future<void> _alertaBorrar(int idActividad, String Nombre, String txt) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Estás por borrar una actividad.'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(child: Text('La actividad: $Nombre')),
                SizedBox(height: 15.0,),
                Center(child: Text('¿Deseas confirmar?')),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Confirmar'),
              onPressed: () {
                Navigator.of(context).pop();
                _planesBloc.add(DeleteAnActividadEvent(idActividad, txt));
                _mensaje('Actividad borra');
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

  // mensaje 
  Future<void> _mensaje(String txt) async {
    return await ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(txt),
      )
    );
  }

  Widget _giveFecha(DateTime fechaActividad,DateTime fechaInicio, DateTime fechaFinal, int dias, int id) {
    return GestureDetector(
      child: Icon(Icons.calendar_today),
      onTap: () async {
        FocusScope.of(context).requestFocus(new FocusNode());

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

        // // agregamos la nueva fecha
        _listTare.forEach((tareas) {
          tareas.actividadTareaPlanner.forEach((actividades) {
            if(actividades.idActividadPlanner == id){
              if(fechaActividad != null) {
                if(fechaActividad.add(Duration(days: actividades.diasActividadPlanner)).isAfter(tareas.fechaFinalEvento))
                  _alertaFechas(actividades.nombreActividadPlanner,tareas.fechaInicioEvento,fechaInicio,tareas.fechaFinalEvento,actividades.diasActividadPlanner);
                else {
                  actividades.fechaInicioActividad = fechaActividad;
                  actividades.calendarActividad = true;
                  _botonSave = true;
                }
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
  
  // goCalendario
  void _saveActividades() {
    List<ActividadPlanner> send = [];

    bool sinFechas = false;

    _listFull.forEach((tarea) {
      tarea.actividadTareaPlanner.forEach((actividad) {
        if(actividad.calendarActividad)
          sinFechas = true;
      });
    });

    if(!_botonSave && sinFechas) {
      _listFull.forEach((tarea) {
        tarea.actividadTareaPlanner.forEach((actividad) {
          if(actividad.calendarActividad == true)
            send.add(actividad);
        });
      });

      // agregamos a la base de datos
      Navigator.of(context).pushNamed('/calendarPlan', arguments: send);
    } else {
      if(!sinFechas)
        _mensaje('No hay fechas');
      else
        _mensaje('Tienes cambios pendientes por guardar');
    }

  }
}

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
}
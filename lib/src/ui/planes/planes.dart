// import flutter/dart
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:planning/src/logic/planes_logic.dart';
import 'package:planning/src/models/Planes/planes_model.dart';
import 'package:planning/src/models/item_model_preferences.dart';
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

// class Planes extends StatefulWidget {
//   Planes({Key key}) : super(key: key);

//   @override
//   _PlanesState createState() => _PlanesState();
// }

// class _PlanesState extends State<Planes> {
//   // variables bloc
//   PlanesBloc _planesBloc;

//   // variable model
//   ItemModelPlanes _itemModel;

//   //logic
//   ConsultasPlanesLogic planesLogic = ConsultasPlanesLogic();

//   // variables class
//   List<TareaPlanner> _listTare;
//   List<TareaPlanner> _listFull;
//   int _tabShow = 0;
//   int botonIs = 0;
//   String _condicionQuery = 'AND ea.estatus_progreso = true';
//   int _botonSave;
//   List<List<bool>> onTapsResponsable = [];

//   @override
//   void initState() {
//     super.initState();
//     // cargamos el bloc
//     _planesBloc = BlocProvider.of<PlanesBloc>(context);
//     _planesBloc.add(SelectPlanesEventoEvent(_condicionQuery));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _crearScaffold();
//   }

//   // creo el scaffold muestra la vista - v1
//   Scaffold _crearScaffold() {
//     return Scaffold(
//       body: RefreshIndicator(
//           color: Colors.blue,
//           onRefresh: () async {
//             await _planesBloc.add(SelectPlanesEventoEvent(_condicionQuery));
//           },
//           child: _buildBloc()),
//       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//       floatingActionButton: _botonFlotante(),
//     );
//   }

//   // creo bloc principal
//   Widget _buildBloc() {
//     return BlocBuilder<PlanesBloc, PlanesState>(builder: (context, state) {
//       // state ini
//       if (state is InitiaPlaneslState)
//         return Center(child: CircularProgressIndicator());
//       // state log
//       else if (state is LodingPlanesState)
//         return Center(child: CircularProgressIndicator());
//       // state select
//       else if (state is SelectEventoState) {
//         // evita que se reescriba la lista
//         if (state.planes != null) {
//           if (_itemModel != state.planes) {
//             _itemModel = state.planes;
//             if (_itemModel != null) {
//               _listTare = _crearListaEditable(_itemModel);
//               _listFull = _crearListaEditable(state.full);
//             }
//           }
//         } else {
//           _planesBloc.add(SelectPlanesEventoEvent(_condicionQuery));
//           return Center(child: CircularProgressIndicator());
//         }
//         if (_itemModel != null) {
//           return _crearStickyHeader(_itemModel);
//         } else {
//           return Center(child: Text('Sin datos'));
//         }
//       }
//       // state create
//       else if (state is CreatePlanesState) {
//         _planesBloc.add(SelectPlanesEventoEvent(_condicionQuery));
//         return _crearStickyHeader(_itemModel);
//       }
//       // no state
//       else
//         return Center(child: CircularProgressIndicator());
//     });
//   }

//   // creo el StickyHeader
//   Widget _crearStickyHeader(ItemModelPlanes model) {
//     return Container(
//       padding: EdgeInsets.all(20.0),
//       child: Card(
//         child: ListView(
//           children: [
//             StickyHeader(
//               header: _header(),
//               content: _content(model),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // crear header
//   Container _header() {
//     return Container(
//       padding: EdgeInsets.all(20.0),
//       width: double.infinity,
//       color: Colors.white,
//       child: Column(
//         mainAxisSize: MainAxisSize.max,
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Actividades',
//             style: TextStyle(fontSize: 20.0),
//           ),
//           SizedBox(
//             height: 15.0,
//           ),
//           Row(
//             mainAxisSize: MainAxisSize.max,
//             mainAxisAlignment: MainAxisAlignment.end,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _botonSave != null ? _mostrarBoton() : SizedBox(width: 0),
//               SizedBox(
//                 width: 10.0,
//               ),
//               ElevatedButton(
//                 child: Icon(Icons.add),
//                 onPressed: _goAddingPlanes,
//               ),
//             ],
//           ),
//           SizedBox(
//             height: 15.0,
//           ),
//           _tabsActividades(),
//         ],
//       ),
//     );
//   }

//   // crear content
//   Container _content(ItemModelPlanes model) {
//     return Container(
//       padding: EdgeInsets.all(20.0),
//       child: Column(
//         mainAxisSize: MainAxisSize.max,
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SizedBox(
//             height: 15.0,
//           ),
//           _crearViewExpanded(model),
//         ],
//       ),
//     );
//   }

//   // tabs
//   Widget _tabsActividades() {
//     return DefaultTabController(
//       length: 3,
//       initialIndex: _tabShow,
//       child: TabBar(
//         labelColor: Colors.black,
//         tabs: [
//           Tab(text: 'Realizado'),
//           Tab(text: 'Pendiente'),
//           Tab(text: 'Atrasado'),
//         ],
//         onTap: (index) {
//           setState(() {
//             _tabShow = index;
//             if (index == 0)
//               _updateYselect(_listTare, 'AND ea.estatus_progreso = true', true);
//             else if (index == 1)
//               _updateYselect(
//                   _listTare,
//                   'AND ea.estatus_progreso = false ' +
//                       'AND ea.fecha_inicio_actividad >= NOW() ',
//                   true);
//             else
//               _updateYselect(
//                   _listTare,
//                   'AND ea.estatus_progreso = false ' +
//                       'AND ea.fecha_inicio_actividad <= NOW() ',
//                   true);
//           });
//         },
//       ),
//     );
//   }

//   // pasamos el model a una lista
//   List<TareaPlanner> _crearListaEditable(ItemModelPlanes model) {
//     List<TareaPlanner> tempTarea = []; // variable temporal 1° ciclo

//     // ciclo para separar tareas
//     for (int i = 0; i < model.planes.length; i++) {
//       List<ActividadPlanner> tempActividad = []; // cariable temporal 2° ciclo
//       bool tempCheck = true;
//       int progreso = 0;
//       // ciclo para separar actividades
//       for (int j = 0; j < model.planes.length; j++) {
//         // junta las actividades de cada tarea en una lista
//         if (model.planes[i].idPlan == model.planes[j].idPlan) {
//           if (model.planes[j].statusProgreso != null) {
//             if (!model.planes[j].statusProgreso)
//               tempCheck = false;
//             else
//               progreso++;
//           }
//           tempActividad.add(ActividadPlanner(
//             idActividadPlanner: model.planes[j].idActividad,
//             nombreActividadPlanner: model.planes[j].nombreActividad,
//             nombreResponsable: model.planes[j].nombreResponsable,
//             descripcionActividadPlanner: model.planes[j].descripcionActividad,
//             visibleInvolucradosActividadPlanner:
//                 model.planes[j].visibleInvolucradosActividad,
//             diasActividadPlanner: model.planes[j].duracionActividad,
//             predecesorActividadPlanner: model.planes[j].predecesorActividad,
//             fechaInicioActividad: model.planes[j].fechaInicioActividad,
//             fechaInicioEvento: model.planes[i].fechaInicioEvento,
//             fechaFinalEvento: model.planes[i].fechaFinalEvento,
//             idOldActividad: model.planes[j].idOldActividad,
//             calendarActividad: model.planes[j].statusCalendar,
//             checkActividadPlanner: model.planes[j].statusProgreso,
//             nombreValida: true,
//             descriValida: true,
//           ));
//         }
//       }

//       // juntando las tareas con sus actividades
//       if (i == 0)
//         tempTarea.add(TareaPlanner(
//           idTareaPlanner: model.planes[i].idPlan,
//           nombreTareaPlanner: model.planes[i].nombrePlan,
//           fechaInicioEvento: model.planes[i].fechaInicioEvento,
//           fechaFinalEvento: model.planes[i].fechaFinalEvento,
//           idTareaOld: model.planes[i].idOldPlan,
//           checkTarePlanner: tempCheck,
//           expandedTarePlanner: false,
//           progreso: progreso,
//           botonAdd: true,
//           actividadTareaPlanner: tempActividad,
//         ));
//       else {
//         if (model.planes[i].idPlan != model.planes[(i - 1)].idPlan)
//           tempTarea.add(TareaPlanner(
//               idTareaPlanner: model.planes[i].idPlan,
//               nombreTareaPlanner: model.planes[i].nombrePlan,
//               fechaInicioEvento: model.planes[i].fechaInicioEvento,
//               fechaFinalEvento: model.planes[i].fechaFinalEvento,
//               idTareaOld: model.planes[i].idOldPlan,
//               checkTarePlanner: tempCheck,
//               expandedTarePlanner: false,
//               progreso: progreso,
//               botonAdd: true,
//               actividadTareaPlanner: tempActividad));
//       }
//     }

//     return tempTarea; // enviamos la lista
//   }

//   // creamos una promesa de una lista
//   Future<List<TareaPlanner>> _promiseList(ItemModelPlanes model) async {
//     return _crearListaEditable(model);
//   }

//   // creamos los expandeds
//   List<ExpansionPanel> _buildListExpanded(List<TareaPlanner> list) {
//     List<ExpansionPanel> listExpanded = []; // variable con la lista de expanded

//     // ciclo para generar mis widgets padres
//     for (int i = 0; i < _listTare.length; i++) {
//       List<Widget> listWidget = []; // variable con los hijos del expanded
//       // ciclo para generar los hijos
//       for (int j = 0; j < _listTare[i].actividadTareaPlanner.length; j++) {
//         // agregamos items a la lista widget
//         if (_listTare[i].actividadTareaPlanner[j].idActividadPlanner != 0) {
//           bool canChange = _listTare[i]
//               .actividadTareaPlanner[j]
//               .calendarActividad; // variable q indica si puede cambiar
//           listWidget.add(ListTile(
//             leading: Checkbox(
//               value:
//                   _listTare[i].actividadTareaPlanner[j].checkActividadPlanner,
//               onChanged: (valor) {
//                 if (canChange) {
//                   setState(() {
//                     _listTare[i]
//                         .actividadTareaPlanner[j]
//                         .checkActividadPlanner = valor;
//                     if (valor) {
//                       _listTare[i].progreso++;

//                       _listFull.forEach((tarea) {
//                         if (_listTare[i].idTareaPlanner ==
//                             tarea.idTareaPlanner) {
//                           tarea.progreso++;
//                         }
//                       });
//                     } else {
//                       _listTare[i].progreso--;

//                       _listFull.forEach((tarea) {
//                         if (_listTare[i].idTareaPlanner ==
//                             tarea.idTareaPlanner) {
//                           tarea.progreso--;
//                         }
//                       });
//                     }

//                     // done
//                     bool tempBool = true;
//                     _listTare[i].actividadTareaPlanner.forEach((actividad) {
//                       if (!actividad.checkActividadPlanner) tempBool = false;
//                     });

//                     _listTare[i].checkTarePlanner = tempBool;

//                     _botonSave = -1; // cambio boton
//                   });
//                 } else {
//                   _mensaje('Debes poner fecha, antes de finalizar actividades');
//                 }
//               },
//             ),
//             title: Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                       list[i].actividadTareaPlanner[j].nombreActividadPlanner),
//                   flex: 5,
//                 ),
//                 // Expanded(child: Icon(Icons.calendar_today_outlined),flex: 1,),
//                 // Expanded(child: Icon(Icons.delete),flex: 1,),
//                 Expanded(
//                   flex: 2,
//                   child: _botonSave == j
//                       ? TextFormField(
//                           initialValue: list[i]
//                               .actividadTareaPlanner[j]
//                               .nombreResponsable,
//                           onChanged: (value) {
//                             _listTare[i]
//                                 .actividadTareaPlanner[j]
//                                 .nombreResponsable = value;
//                           },
//                         )
//                       : Text(list[i]
//                                   .actividadTareaPlanner[j]
//                                   .nombreResponsable !=
//                               null
//                           ? list[i].actividadTareaPlanner[j].nombreResponsable
//                           : 'Sin responsable'),
//                 ),
//                 Expanded(
//                   flex: 1,
//                   child: _giveFecha(
//                       _listTare[i]
//                           .actividadTareaPlanner[j]
//                           .fechaInicioActividad,
//                       _listTare[i].fechaInicioEvento,
//                       _listTare[i].fechaFinalEvento,
//                       _listTare[i]
//                           .actividadTareaPlanner[j]
//                           .diasActividadPlanner,
//                       _listTare[i].actividadTareaPlanner[j].idActividadPlanner,
//                       j),
//                 ),
//                 Expanded(
//                   flex: 1,
//                   child: GestureDetector(
//                     child: Icon(Icons.delete),
//                     onTap: () async {
//                       _alertaBorrar(
//                           _listTare[i]
//                               .actividadTareaPlanner[j]
//                               .idActividadPlanner,
//                           _listTare[i]
//                               .actividadTareaPlanner[j]
//                               .nombreActividadPlanner,
//                           _condicionQuery);
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             subtitle: Text(
//                 list[i].actividadTareaPlanner[j].descripcionActividadPlanner),
//           ));
//         } else {
//           listWidget.add(Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(
//                 height: 15.0,
//               ),
//               Wrap(
//                 alignment: WrapAlignment.center,
//                 children: <Widget>[
//                   TextFormFields(
//                     icon: Icons.local_activity,
//                     large: 500.0,
//                     ancho: 80.0,
//                     item: TextFormField(
//                       controller: TextEditingController(
//                           text:
//                               '${_listTare[i].actividadTareaPlanner[j].nombreActividadPlanner}'),
//                       decoration: new InputDecoration(
//                           labelText: 'Nombre:',
//                           errorText:
//                               _listTare[i].actividadTareaPlanner[j].nombreValida
//                                   ? null
//                                   : 'Campo obligatorio.'),
//                       onChanged: (valor) {
//                         _listTare[i]
//                             .actividadTareaPlanner[j]
//                             .nombreActividadPlanner = valor;
//                       },
//                     ),
//                   ),
//                   TextFormFields(
//                     icon: Icons.drive_file_rename_outline,
//                     large: 500.0,
//                     ancho: 80.0,
//                     item: TextFormField(
//                       controller: TextEditingController(
//                           text:
//                               '${_listTare[i].actividadTareaPlanner[j].descripcionActividadPlanner}'),
//                       decoration: new InputDecoration(
//                           labelText: 'Descripción:',
//                           errorText:
//                               _listTare[i].actividadTareaPlanner[j].descriValida
//                                   ? null
//                                   : 'Campo obligatorio.'),
//                       onChanged: (valor) {
//                         _listTare[i]
//                             .actividadTareaPlanner[j]
//                             .descripcionActividadPlanner = valor;
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 15.0,
//               ),
//               Wrap(
//                 alignment: WrapAlignment.center,
//                 children: <Widget>[
//                   TextFormFields(
//                     icon: Icons.date_range_outlined,
//                     large: 500.0,
//                     ancho: 80.0,
//                     item: Row(
//                       children: [
//                         Expanded(child: Text("Duración en días:")),
//                         IconButton(
//                           icon: Icon(Icons.remove),
//                           onPressed: _listTare[i]
//                                       .actividadTareaPlanner[j]
//                                       .diasActividadPlanner >
//                                   1
//                               ? () {
//                                   setState(() => _listTare[i]
//                                       .actividadTareaPlanner[j]
//                                       .diasActividadPlanner--);
//                                 }
//                               : null,
//                         ),
//                         Container(
//                           width: 45,
//                           height: 45,
//                           child: Padding(
//                             padding: EdgeInsets.symmetric(vertical: 3),
//                             child: TextFormField(
//                               controller: TextEditingController(
//                                   text:
//                                       '${_listTare[i].actividadTareaPlanner[j].diasActividadPlanner}'),
//                               keyboardType: TextInputType.number,
//                               inputFormatters: <TextInputFormatter>[
//                                 FilteringTextInputFormatter.digitsOnly
//                               ],
//                               textAlign: TextAlign.center,
//                             ),
//                           ),
//                         ),
//                         IconButton(
//                             icon: Icon(Icons.add),
//                             onPressed: () {
//                               setState(() => _listTare[i]
//                                   .actividadTareaPlanner[j]
//                                   .diasActividadPlanner++);
//                             })
//                       ],
//                     ),
//                   ),
//                   TextFormFields(
//                     icon: Icons.remove_red_eye,
//                     large: 500.0,
//                     ancho: 80,
//                     item: CheckboxListTile(
//                       title: Text('Visible para novios:'),
//                       controlAffinity: ListTileControlAffinity.platform,
//                       value: _listTare[i]
//                           .actividadTareaPlanner[j]
//                           .visibleInvolucradosActividadPlanner,
//                       onChanged: (valor) {
//                         setState(() => _listTare[i]
//                             .actividadTareaPlanner[j]
//                             .visibleInvolucradosActividadPlanner = valor);
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 15.0,
//               ),
//               Wrap(
//                 alignment: WrapAlignment.center,
//                 children: [
//                   TextFormFields(
//                       icon: Icons.linear_scale_outlined,
//                       large: 500,
//                       ancho: 80,
//                       item: DropdownButton(
//                         isExpanded: true,
//                         value: _listTare[i]
//                             .actividadTareaPlanner[j]
//                             .predecesorActividadPlanner,
//                         icon: const Icon(Icons.arrow_drop_down_outlined),
//                         iconSize: 24,
//                         elevation: 16,
//                         style: const TextStyle(color: Color(0xFF000000)),
//                         underline: Container(
//                           height: 2,
//                           color: Color(0xFF000000),
//                         ),
//                         onChanged: (valor) {
//                           setState(() {
//                             _listTare[i]
//                                 .actividadTareaPlanner[j]
//                                 .predecesorActividadPlanner = valor;
//                           });
//                         },
//                         items: _listTare[i].actividadTareaPlanner.map((item) {
//                           return DropdownMenuItem(
//                             value: item.idActividadPlanner,
//                             child: Text(
//                               item.idActividadPlanner != 0
//                                   ? item.nombreActividadPlanner
//                                   : 'Selecciona un predecesor',
//                               style: TextStyle(fontSize: 18),
//                             ),
//                           );
//                         }).toList(),
//                       )),
//                   Padding(
//                     padding: EdgeInsets.all(15.0),
//                     child: ElevatedButton(
//                       child: Tooltip(
//                         child: Icon(Icons.save_sharp),
//                         message: "Agregar actividad.",
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           // re
//                           _listTare[i].actividadTareaPlanner[j].nombreValida =
//                               true;
//                           _listTare[i].actividadTareaPlanner[j].descriValida =
//                               true;
//                           // validamos data
//                           if (_listTare[i]
//                                   .actividadTareaPlanner[j]
//                                   .nombreActividadPlanner ==
//                               '') {
//                             _listTare[i].actividadTareaPlanner[j].nombreValida =
//                                 false;
//                           } else if (_listTare[i]
//                                   .actividadTareaPlanner[j]
//                                   .descripcionActividadPlanner ==
//                               '') {
//                             _listTare[i].actividadTareaPlanner[j].descriValida =
//                                 false;
//                           } else {
//                             Map<String, dynamic> actividadTemporal = {
//                               'id_actividad_timing': null.toString(),
//                               'nombre': _listTare[i]
//                                   .actividadTareaPlanner[j]
//                                   .nombreActividadPlanner
//                                   .toString(),
//                               'descripcion': _listTare[i]
//                                   .actividadTareaPlanner[j]
//                                   .descripcionActividadPlanner
//                                   .toString(),
//                               'dias': _listTare[i]
//                                   .actividadTareaPlanner[j]
//                                   .diasActividadPlanner
//                                   .toString(),
//                               'visible_involucrados': _listTare[i]
//                                   .actividadTareaPlanner[j]
//                                   .visibleInvolucradosActividadPlanner
//                                   .toString(),
//                               'predecesor': _listTare[i]
//                                           .actividadTareaPlanner[j]
//                                           .predecesorActividadPlanner ==
//                                       0
//                                   ? null.toString()
//                                   : _listFull[i]
//                                       .actividadTareaPlanner[j]
//                                       .predecesorActividadPlanner
//                                       .toString(),
//                             };
//                             _planesBloc.add(CreateUnaPlanesEvent(
//                                 actividadTemporal,
//                                 _listTare[i].idTareaPlanner,
//                                 _condicionQuery));
//                             _mensaje('Actividad agregada');
//                           }
//                         });
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 30.0,
//               ),
//             ],
//           ));
//         }
//       }

//       // agregamos boton de mas x tarea
//       listWidget.add(Padding(
//         padding: EdgeInsets.all(15.0),
//         child: ElevatedButton(
//           child: _listTare[i].botonAdd ? Icon(Icons.add) : Icon(Icons.remove),
//           onPressed: () => _addActividad(_listTare[i].idTareaPlanner),
//         ),
//       ));

//       // lista full encontrar tamaño y progreso || tiene fallas no actualiza en TR
//       // manejar la lista general y ahi acer los cambios
//       int totalTareas = 0;
//       int totalHechas = 0;

//       _listFull.forEach((tarea) {
//         if (_listTare[i].idTareaPlanner == tarea.idTareaPlanner) {
//           totalTareas = tarea.actividadTareaPlanner.length;
//           totalHechas = tarea.progreso;
//         }
//       });

//       // agregamos items a la lista expanded
//       listExpanded.add(
//         ExpansionPanel(
//           headerBuilder: (context, isExpanded) {
//             return ListTile(
//               leading: Checkbox(
//                 value: _listTare[i].checkTarePlanner ?? false,
//                 onChanged: (valor) {
//                   setState(() {
//                     _listTare[i].checkTarePlanner = valor;

//                     // forEach para seleccionar a todas las actividades de la tarea
//                     _listTare[i].actividadTareaPlanner.forEach((actividad) {
//                       if (actividad.checkActividadPlanner != valor) {
//                         if (valor) {
//                           _listTare[i].progreso++;

//                           _listFull.forEach((tarea) {
//                             if (_listTare[i].idTareaPlanner ==
//                                 tarea.idTareaPlanner) {
//                               tarea.progreso++;
//                             }
//                           });
//                         } else {
//                           _listTare[i].progreso--;

//                           _listFull.forEach((tarea) {
//                             if (_listTare[i].idTareaPlanner ==
//                                 tarea.idTareaPlanner) {
//                               tarea.progreso--;
//                             }
//                           });
//                         }
//                       }
//                       actividad.checkActividadPlanner = valor;
//                     });

//                     _botonSave = -1; // cambio boton
//                   });
//                 },
//               ),
//               title: Text(list[i].nombreTareaPlanner),
//               subtitle: Text('Progreso: ${totalHechas}/${totalTareas}'),
//               onTap: () {
//                 // evento clic en el cuerpo de la listTile cabre el expanded
//                 setState(() {
//                   _listTare[i].expandedTarePlanner =
//                       !_listTare[i].expandedTarePlanner;
//                 });
//               },
//             );
//           },
//           isExpanded: _listTare[i].expandedTarePlanner ?? false,
//           body: Container(
//             padding: EdgeInsets.only(left: 20.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: listWidget,
//             ),
//           ),
//         ),
//       );
//     }

//     return listExpanded; // enviamos la lista
//   }

//   // creamos la vista de expanded
//   Widget _crearViewExpanded(ItemModelPlanes model) {
//     if (model.planes.length > 0) {
//       return FutureBuilder<List<TareaPlanner>>(
//           future: _promiseList(model),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               return SingleChildScrollView(
//                 child: ExpansionPanelList(
//                   animationDuration: Duration(milliseconds: 500),
//                   expansionCallback: (int index, bool isExpanded) {
//                     setState(() {
//                       _listTare[index].expandedTarePlanner = !isExpanded;
//                     });
//                   },
//                   children: _buildListExpanded(snapshot.data),
//                 ),
//               );
//             } else
//               return Center(
//                 child: CircularProgressIndicator(),
//               );
//           });
//     } else
//       return Center(
//         child: Text('Sin datos'),
//       );
//   }

//   // mostra boton al realizar cambios
//   ElevatedButton _mostrarBoton() {
//     return ElevatedButton(
//       child: Icon(Icons.save),
//       onPressed: () => _updateYselect(_listTare, _condicionQuery, false),
//     );
//   }

//   // boton flotante
//   Widget _botonFlotante() {
//     return SpeedDial(
//       icon: Icons.more_vert,
//       children: [
//         SpeedDialChild(
//           child: Icon(Icons.calendar_today),
//           onTap: () => _saveActividades(),
//           label: 'Ver calendario',
//         ),
//         SpeedDialChild(
//           child: Icon(Icons.download),
//           onTap: () async {
//             final data = await planesLogic.donwloadPDFPlanesEvento();

//             if (data != null) {
//               utils.downloadFile(data, 'Actividades_Evento');
//             }
//           },
//           label: 'Descargar PDF',
//         )
//       ],
//     );
//   }

//   /* Eventos */

//   // vamos a ver los planes para agregar
//   void _goAddingPlanes() {
//     Navigator.of(context).pushNamed('/agregarPlan', arguments: _listFull);
//   }

//   // evento de tabs tiene errores pero funciona
//   void _updateYselect(List<TareaPlanner> listTare, String txt, bool who) {
//     _condicionQuery = txt; // paradoja del abuelo
//     // variable temp
//     List<ActividadPlanner> tempActividad = [];
//     // comparamos la lista full y si hay cambios enviamos update
//     _listFull.forEach((tareas) {
//       // ciclo revisa actividades
//       tareas.actividadTareaPlanner.forEach((actividades) {
//         // tarea
//         listTare.forEach((tarea) {
//           // actividad
//           tarea.actividadTareaPlanner.forEach((actividad) {
//             // filtro
//             if (actividades.idActividadPlanner ==
//                 actividad.idActividadPlanner) {
//               // 1
//               if (actividades.fechaInicioActividad !=
//                       actividad.fechaInicioActividad ||
//                   actividades.checkActividadPlanner !=
//                       actividad.checkActividadPlanner)
//                 tempActividad.add(ActividadPlanner(
//                   idActividadPlanner: actividad.idActividadPlanner,
//                   nombreResponsable: actividad.nombreResponsable,
//                   fechaInicioActividad: actividad.fechaInicioActividad,
//                   checkActividadPlanner: actividad.checkActividadPlanner,
//                   calendarActividad: actividad.calendarActividad,
//                 ));
//             }
//           });
//         });
//       });
//     });
//     // fin ciclos

//     // filtro para enviar
//     if (tempActividad.length > 0 && _tabShow != botonIs) {
//       _botonSave = null; // reset
//       _planesBloc.add(UpdatePlanesEventoEvent(
//           tempActividad, _condicionQuery)); // cambiamos x updateevent
//     }

//     if (!who) {
//       _botonSave = null; // reset
//       _planesBloc.add(UpdatePlanesEventoEvent(
//           tempActividad, _condicionQuery)); // cambiamos x updateevent
//       _planesBloc.add(SelectPlanesEventoEvent(_condicionQuery));
//       _mensaje('Cambios guardados.');
//     }

//     if (_tabShow != botonIs) {
//       _planesBloc.add(SelectPlanesEventoEvent(_condicionQuery));
//       botonIs = _tabShow;
//     }
//   }

//   // add form to add actividades
//   _addActividad(int idTareaPlanner) {
//     setState(() {
//       _listTare.forEach((tarea) {
//         if (tarea.idTareaPlanner == idTareaPlanner) {
//           if (tarea.botonAdd == true) {
//             tarea.actividadTareaPlanner.add(ActividadPlanner(
//               idActividadPlanner: 0,
//               nombreActividadPlanner: '',
//               descripcionActividadPlanner: '',
//               diasActividadPlanner: 1,
//               visibleInvolucradosActividadPlanner: false,
//               predecesorActividadPlanner: 0,
//               nombreValida: true,
//               descriValida: true,
//             ));
//             tarea.botonAdd = false;
//           } else {
//             tarea.botonAdd = true;
//             tarea.actividadTareaPlanner.removeLast();
//           }
//         }
//       });
//     });
//   }

//   // dialogo
//   Future<void> _alertaBorrar(int idActividad, String Nombre, String txt) {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false, // user must tap button!
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Estás por borrar una actividad.'),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 Center(child: Text('La actividad: $Nombre')),
//                 SizedBox(
//                   height: 15.0,
//                 ),
//                 Center(child: Text('¿Deseas confirmar?')),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Confirmar'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _planesBloc.add(DeleteAnActividadEvent(idActividad, txt));
//                 _mensaje('Actividad borra');
//               },
//             ),
//             TextButton(
//               child: const Text('Cancelar'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // mensaje
//   Future<void> _mensaje(String txt) async {
//     return await ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text(txt),
//     ));
//   }

//   Widget _giveFecha(DateTime fechaActividad, DateTime fechaInicio,
//       DateTime fechaFinal, int dias, int id, int index) {
//     return GestureDetector(
//       child: Icon(Icons.calendar_today),
//       onTap: () async {
//         FocusScope.of(context).requestFocus(new FocusNode());

//         fechaActividad = await showDatePicker(
//           context: context,
//           initialDate: fechaActividad,
//           errorFormatText: 'Error en el formato',
//           errorInvalidText: 'Error en la fecha',
//           fieldHintText: 'día/mes/año',
//           fieldLabelText: 'Fecha de inicio de actividad',
//           firstDate: fechaInicio,
//           lastDate: fechaFinal,
//         );

//         // // agregamos la nueva fecha
//         _listTare.forEach((tareas) {
//           tareas.actividadTareaPlanner.forEach((actividades) {
//             if (actividades.idActividadPlanner == id) {
//               if (fechaActividad != null) {
//                 if (fechaActividad
//                     .add(Duration(days: actividades.diasActividadPlanner))
//                     .isAfter(tareas.fechaFinalEvento))
//                   _alertaFechas(
//                       actividades.nombreActividadPlanner,
//                       tareas.fechaInicioEvento,
//                       fechaInicio,
//                       tareas.fechaFinalEvento,
//                       actividades.diasActividadPlanner);
//                 else {
//                   actividades.fechaInicioActividad = fechaActividad;
//                   actividades.calendarActividad = true;
//                   _botonSave = index;
//                 }
//               } else {}
//             }
//           });
//         });
//       },
//     );
//   }

//   // mensajes
//   Future<void> _alertaFechas(String actividad, DateTime fechaInicialEvento,
//       DateTime fechaActividad, DateTime fechaFinalEvento, int duracion) {
//     String txtDuracion;

//     if (duracion > 1)
//       txtDuracion = 'tiene la duración de $duracion dias';
//     else
//       txtDuracion = 'tiene la duración de $duracion dia';

//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false, // user must tap button!
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Error en la fecha'),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 Text('La actividad: $actividad'),
//                 Text('$txtDuracion'),
//                 SizedBox(
//                   height: 15.0,
//                 ),
//                 Text('No puedes exceder el día final del evento,'),
//                 SizedBox(
//                   height: 15.0,
//                 ),
//                 Text(
//                     'fecha final: ${DateFormat("yyyy-MM-dd").format(fechaFinalEvento)}')
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Ok'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // goCalendario
//   void _saveActividades() {
//     List<ActividadPlanner> send = [];

//     bool sinFechas = false;

//     _listFull.forEach((tarea) {
//       tarea.actividadTareaPlanner.forEach((actividad) {
//         if (actividad.calendarActividad) sinFechas = true;
//       });
//     });

//     if (_botonSave == null && sinFechas) {
//       _listFull.forEach((tarea) {
//         tarea.actividadTareaPlanner.forEach((actividad) {
//           if (actividad.calendarActividad == true) send.add(actividad);
//         });
//       });

//       // agregamos a la base de datos
//       Navigator.of(context).pushNamed('/calendarPlan', arguments: send);
//     } else {
//       if (!sinFechas)
//         _mensaje('No hay fechas');
//       else
//         _mensaje('Tienes cambios pendientes por guardar');
//     }
//   }
// }

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
  @override
  _PlanesPageState createState() => _PlanesPageState();
}

class _PlanesPageState extends State<PlanesPage> with TickerProviderStateMixin {
  PlanesBloc _planesBloc;
  ConsultasPlanesLogic planesLogic = ConsultasPlanesLogic();
  ActividadesEvento _planesLogic = ActividadesEvento();

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
              title: Text('Actividades'),
              centerTitle: true,
            )
          : null,
      body: RefreshIndicator(
        onRefresh: () async {
          await _planesBloc.add(GetTimingsAndActivitiesEvent());
        },
        color: Colors.blue,
        child: SingleChildScrollView(
          controller: ScrollController(),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Card(
            child: Column(
              children: [
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Actividades',
                  style: Theme.of(context).textTheme.headline5,
                ),
                SizedBox(
                  height: 10.0,
                ),
                contadorActividadesWidget(),
                SizedBox(
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
                        icon: Icon(Icons.save),
                        label: Text('Guardar'),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      ElevatedButton.icon(
                        onPressed: _goAddingPlanes,
                        icon: Icon(Icons.add),
                        label: Text('Añadir'),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                    ],
                  ),
                SizedBox(
                  height: 10.0,
                ),
                BlocBuilder<PlanesBloc, PlanesState>(
                  builder: (context, state) {
                    if (state is InitiaPlaneslState)
                      return Center(child: CircularProgressIndicator());
                    // state log
                    else if (state is LodingPlanesState)
                      return Center(child: CircularProgressIndicator());
                    else if (state is ShowAllPlannesState) {
                      if (state.listTimings != null) {
                        listaTimings = state.listTimings;
                      }
                      return buildActividadesEvento();
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
                SizedBox(
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

  StreamBuilder<ContadorActividadesModel> contadorActividadesWidget() {
    _planesLogic.getContadorValues(isInvolucrado);

    return StreamBuilder(
      stream: _planesLogic.contadorActividadStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.total > 0) {
            return Column(
              children: [
                Row(
                  children: [
                    Spacer(),
                    Theme(
                      data: ThemeData(disabledColor: Colors.green),
                      child: Checkbox(
                        value: true,
                        onChanged: null,
                        hoverColor: Colors.transparent,
                      ),
                    ),
                    Text('${snapshot.data.completadas.toString()} Completadas'),
                    Spacer(),
                    Theme(
                      data: ThemeData(disabledColor: Colors.yellow[800]),
                      child: Checkbox(
                        value: false,
                        onChanged: null,
                      ),
                    ),
                    Text('${snapshot.data.pendientes.toString()} Pendientes'),
                    Spacer(),
                    Theme(
                      data: ThemeData(disabledColor: Colors.red),
                      child: Checkbox(
                        value: false,
                        onChanged: null,
                      ),
                    ),
                    Text('${snapshot.data.atrasadas.toString()} Atrasadas'),
                    Spacer(),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                    'Progreso ${((snapshot.data.completadas / snapshot.data.total) * 100).toStringAsFixed(0)}%'),
                SizedBox(
                  height: 10,
                ),
                Theme(
                  data: ThemeData(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 400,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: LinearProgressIndicator(
                        minHeight: 5.0,
                        value: snapshot.data.completadas / snapshot.data.total,
                        semanticsLabel: 'Linear progress indicator',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text('Total: ${snapshot.data.total}')
              ],
            );
          }
        }
        return Row(
          children: [
            Spacer(),
            Theme(
              data: ThemeData(disabledColor: Colors.green),
              child: Checkbox(
                value: true,
                onChanged: null,
                hoverColor: Colors.transparent,
              ),
            ),
            Text('Completadas'),
            Spacer(),
            Theme(
              data: ThemeData(disabledColor: Colors.yellow[800]),
              child: Checkbox(
                value: false,
                onChanged: null,
              ),
            ),
            Text('Pendientes'),
            Spacer(),
            Theme(
              data: ThemeData(disabledColor: Colors.red),
              child: Checkbox(
                value: false,
                onChanged: null,
              ),
            ),
            Text('Atrasadas'),
            Spacer(),
          ],
        );
      },
    );
  }

  Widget buildActividadesEvento() {
    List<Widget> listPlanesWidget = [];
    // List<FocusNode> focusNode = [];
    index = 0;

    if (listaTimings.length <= 0) {
      return Padding(
        padding: const EdgeInsets.all(15.0),
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

          if (actividad.fechaFinActividad == null) {
            actividad.fechaFinActividad =
                actividad.fechaInicioActividad.add(Duration(days: 1));
          }
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
                      showDuration: Duration(
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
                        initialValue: actividad.responsable != null
                            ? actividad.responsable
                            : null,
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
                                  fecha.add(Duration(hours: 1));
                              print(fecha);
                              print(actividad.fechaFinActividad);
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
                                  fecha.subtract(Duration(hours: 1));
                              print(fecha);

                              print(actividad.fechaInicioActividad);
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
                            child: Tooltip(
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
                          actividad.responsable != null
                              ? actividad.responsable
                              : 'Sin responsable',
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
                  icon: Icon(Icons.add),
                  label: Text('Agregar actividad'),
                ),
              ),
            );
          }
        }

        if (tempActividadesTiming.length > 0) {
          Widget timingWidget = ExpansionTile(
            iconColor: Colors.black,
            title: Text(
              timing.nombrePlaner,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            children: tempActividadesTiming,
          );

          listPlanesWidget.add(timingWidget);
        }
      }
      if (listPlanesWidget.length > 0) {
        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          margin: EdgeInsets.all(20.0),
          elevation: 10.0,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
                SizedBox(
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
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
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
      icon: Icons.more_vert,
      children: [
        SpeedDialChild(
          child: Icon(Icons.calendar_today),
          onTap: () => _saveActividades(),
          label: 'Ver calendario',
        ),
        SpeedDialChild(
          child: Icon(Icons.download),
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
                SizedBox(
                  height: 15.0,
                ),
                Center(child: Text('¿Deseas confirmar?')),
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
                _mensaje('Actividad borrada');
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

  Future<void> _mensaje(String txt) async {
    return await ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(txt),
    ));
  }

  void _saveActividades() {
    List<ActividadPlanner> send = [];

    bool sinFechas = false;

    listaTimings.forEach((tarea) {
      tarea.actividades.forEach((actividad) {
        if (actividad.estadoCalendarioActividad) sinFechas = true;
      });
    });

    // if (sinFechas) {
    listaTimings.forEach((tarea) {
      tarea.actividades.forEach((actividad) {
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
      });
    });

    // agregamos a la base de datos
    Navigator.of(context).pushNamed('/calendarPlan', arguments: send);
    // } else {
    //   if (!sinFechas)
    //     _mensaje('No hay fechas');
    //   else
    //     _mensaje('Tienes cambios pendientes por guardar');
    // }
  }

  void _updateYselect() {
    List<EventoActividadModel> send = [];

    listaTimings.forEach((tarea) {
      send += [...tarea.actividades];
    });
    // fin ciclosi

    // filtro para enviar
    if (send.length > 0) {
      setState(() {
        isEnableButton = false;
      }); // reset
      _planesBloc.add(UpdateActividadesEventoEvent(send));
      _planesLogic.getAllPlannes();
      _planesLogic.getContadorValues(isInvolucrado);

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
        title: Text('Añadir actividad'),
      ),
      body: SingleChildScrollView(
        child: BlocListener<PlanesBloc, PlanesState>(
          listener: (context, state) {
            if (state is AddedActividadState) {
              if (state.isAdded) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Se ha agregado la actividad'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Ocurrio un error'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
          child: Form(
            key: keyForm,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
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
                          decoration: new InputDecoration(
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
                        decoration: new InputDecoration(
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
                SizedBox(
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
                          decoration: new InputDecoration(
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
                                    icon: Icon(
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
                                              actividad.fechaInicioActividad
                                                  .add(Duration(hours: 1));
                                          fechaFinController.text =
                                              DateFormat.yMd().add_jm().format(
                                                  actividad.fechaFinActividad);
                                        }

                                        fechaInicioController.text =
                                            DateFormat.yMd().add_jm().format(
                                                actividad.fechaInicioActividad);
                                      }
                                    },
                                    icon: Icon(
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
                          decoration: new InputDecoration(
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
                                    icon: Icon(
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
                                    icon: Icon(
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
                SizedBox(
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
                        title: Text('Visible para novios:'),
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
                        value: actividad.predecesorActividad == null
                            ? -1
                            : actividad.predecesorActividad,
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
                                style: TextStyle(fontSize: 18),
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
                        decoration: new InputDecoration(
                          labelText: 'Descripción:',
                        ),
                        onChanged: (valor) {
                          actividad.descripcionActividad = valor;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30.0,
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: PointerInterceptor(
                      child: ElevatedButton(
                        child: Tooltip(
                          child: Icon(Icons.save_sharp),
                          message: "Agregar actividad.",
                        ),
                        onPressed: () async {
                          if (keyForm.currentState.validate()) {
                            if (widget.actividadModel.idActividad != null) {
                              await BlocProvider.of<PlanesBloc>(context)
                                  .add(EditActividadEvent(actividad));
                            } else {
                              await BlocProvider.of<PlanesBloc>(context).add(
                                AddNewActividadEvent(
                                    actividad, widget.plan.idPlanner),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'Inserte datos en los campos requeridos'),
                              backgroundColor: Colors.red,
                            ));
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

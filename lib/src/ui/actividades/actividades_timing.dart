// ignore_for_file: no_logic_in_create_state

import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/blocs/actividadesTiming/actividadestiming_bloc.dart';
import 'package:planning/src/models/Planes/planes_model.dart';
import 'package:planning/src/models/item_model_actividades_timings.dart';
import 'package:planning/src/ui/planes/ver_archivo_dialog.dart';
import 'package:planning/src/ui/widgets/snackbar_widget/snackbar_widget.dart';
import 'package:planning/src/ui/widgets/text_form_filed/text_form_filed.dart';

class AgregarActividades extends StatefulWidget {
  final int idTiming;
  const AgregarActividades({Key key, this.idTiming}) : super(key: key);

  @override
  State<AgregarActividades> createState() => _AgregarActividadesState(idTiming);
}

class _AgregarActividadesState extends State<AgregarActividades> {
  final int idTiming;
  _AgregarActividadesState(this.idTiming);

  TextEditingController actividadCtrl;
  TextEditingController actividadEditCtrl;
  TextEditingController descripcionCtrl;
  TextEditingController descripcionEditCtrl;
  TextEditingController numCtrl;
  TextEditingController numEditCtrl;
  ActividadestimingBloc actividadestimingBloc;
  ItemModelActividadesTimings itemModelActividadesTimings;
  GlobalKey<FormState> keyForm = GlobalKey();
  int _itemCount = 0;
  bool _actVisible = false;
  bool _actVisibleEdit = false;

  TextEditingController nombreArchivoCtrl = TextEditingController();

  String archivo;
  PlatformFile file;

  int _seleccion;

  List<Map<String, dynamic>> opcionesMeses = [
    {'descripcion': 'A un mes', 'value': 1},
    {'descripcion': 'A dos meses', 'value': 2},
    {'descripcion': 'A tres meses', 'value': 3},
    {'descripcion': 'A cuatro meses', 'value': 4},
    {'descripcion': 'A cinco meses', 'value': 5},
    {'descripcion': 'A seis meses', 'value': 6},
    {'descripcion': 'A siete meses', 'value': 7},
    {'descripcion': 'A ocho meses', 'value': 8},
    {'descripcion': 'A nueve meses', 'value': 9},
    {'descripcion': 'A diez meses', 'value': 10},
    {'descripcion': 'A once meses', 'value': 11},
    {'descripcion': 'A doce meses', 'value': 12},
  ];

  @override
  void initState() {
    actividadestimingBloc = BlocProvider.of<ActividadestimingBloc>(context);
    actividadestimingBloc.add(FetchActividadesTimingsPorPlannerEvent(idTiming));
    _initControlers();
    super.initState();
  }

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  _clearData() {
    _itemCount = 0;
    numCtrl.text = _itemCount.toString();
    _actVisible = false;
    actividadCtrl.clear();
    descripcionCtrl.clear();
    file = null;
    nombreArchivoCtrl.clear();
    _seleccion = null;
  }

  _initControlersEdit(ItemModelActividadesTimings actividad, int i) {
    actividadEditCtrl = TextEditingController(
        text: actividad.results.elementAt(i).nombreActividad);
    _actVisibleEdit = actividad.results.elementAt(i).visibleInvolucrados;
    descripcionEditCtrl =
        TextEditingController(text: actividad.results.elementAt(i).descripcion);
    //_mySelectionAT = actividad.results.elementAt(i).idTipoTimig.toString();
  }

  _initControlers() {
    actividadCtrl = TextEditingController();
    numCtrl = TextEditingController(text: 0.toString());
    descripcionCtrl = TextEditingController();
  }

  String validateActividad(String value) {
    if (value.isEmpty) {
      return "Falta actividad";
    } else {
      return null;
    }
  }

  String validateDescripcion(String value) {
    if (value.isEmpty) {
      return "Falta descripción";
    } else {
      return null;
    }
  }

  String validateActividadEdit(String value) {
    if (value.isEmpty) {
      return "Falta actividad";
    } else {
      return null;
    }
  }

  String validateDescripcionEdit(String value) {
    if (value.isEmpty) {
      return "Falta descripción";
    } else {
      return null;
    }
  }

  _save() {
    if (keyForm.currentState.validate()) {
      Map<String, dynamic> jsonActividad = {
        "nombre_actividad": actividadCtrl.text,
        "descripcion": descripcionCtrl.text,
        "visible_involucrados": _actVisible.toString(),
        'tiempoAntes': _seleccion.toString(),
      };

      if (file != null) {
        final tipoMime = file.extension;

        jsonActividad['archivo'] = base64Encode(file.bytes);
        jsonActividad['descripcionFile'] = file.name;

        jsonActividad['tipoMime'] = tipoMime;
      }

      actividadestimingBloc
          .add(CreateActividadesTimingsEvent(jsonActividad, idTiming));
    }
  }

  _formIu(bool et) {
    return SizedBox(
      width: 1200,
      //height: 600,
      child: Card(
        color: Colors.white,
        elevation: 12,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: <Widget>[
            Wrap(
              alignment: WrapAlignment.center,
              children: <Widget>[
                TextFormFields(
                    icon: Icons.local_activity,
                    item: TextFormField(
                      controller: et ? actividadCtrl : actividadEditCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Nombre',
                      ),
                      validator: et ? validateActividad : validateActividadEdit,
                    ),
                    large: 500.0,
                    ancho: 85.0),
                TextFormFields(
                    icon: Icons.drive_file_rename_outline,
                    item: TextFormField(
                      controller: et ? descripcionCtrl : descripcionEditCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Descripción',
                      ),
                      validator:
                          et ? validateDescripcion : validateActividadEdit,
                    ),
                    large: 500.0,
                    ancho: 85.0),
              ],
            ),
            Wrap(
              alignment: WrapAlignment.center,
              children: <Widget>[
                et
                    ? TextFormFields(
                        icon: FontAwesomeIcons.circleCheck,
                        item: CheckboxListTile(
                          title: const Text('Visible para involucrados'),
                          //secondary: Icon(Icons.be),
                          controlAffinity: ListTileControlAffinity.platform,
                          value: _actVisible,
                          onChanged: (bool value) {
                            setState(() {
                              _actVisible = value;
                            });
                          },
                          activeColor: Colors.green,
                          checkColor: Colors.black,
                        ),
                        ancho: 85,
                        large: 400.0,
                      )
                    : TextFormFields(
                        icon: FontAwesomeIcons.circleCheck,
                        item: CheckboxListTile(
                          title: const Text('Visible para involucrados'),
                          //secondary: Icon(Icons.be),
                          controlAffinity: ListTileControlAffinity.platform,
                          value: _actVisibleEdit,
                          onChanged: (bool value) {
                            setState(() {
                              _actVisibleEdit = value;
                            });
                          },
                          activeColor: Colors.green,
                          checkColor: Colors.black,
                        ),
                        ancho: 85.toDouble(),
                        large: 400.0.toDouble(),
                      ),
                TextFormFields(
                  icon: FontAwesomeIcons.calendarDay,
                  item: DropdownButtonFormField(
                    validator: (value) {
                      if (value != null) {
                        return null;
                      }
                      return 'El campo es requerido';
                    },
                    isExpanded: true,
                    onChanged: (value) => setState(() {
                      _seleccion = value;
                    }),
                    items: opcionesMeses.map((e) {
                      return DropdownMenuItem(
                        value: e['value'],
                        child: Text(e['descripcion']),
                      );
                    }).toList(),
                    value: _seleccion,
                    hint: const Text(
                        'Seleccione a cuánto tiempo antes del evento'),
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color: Colors.black,
                    ),
                  ),
                  ancho: 85.toDouble(),
                  large: 400.0.toDouble(),
                ),
              ],
            ),
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Tooltip(
                    message: 'Subir archivo',
                    child: ElevatedButton(
                      onPressed: () async {
                        const extensiones = ['jpg', 'png', 'jpeg', 'pdf'];
                        FilePickerResult pickedFile =
                            await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          withData: true,
                          allowedExtensions: extensiones,
                          allowMultiple: false,
                        );

                        if (pickedFile != null) {
                          file = pickedFile.files.single;
                          nombreArchivoCtrl.text = file.name;
                          setState(() {});
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: FaIcon(FontAwesomeIcons.fileArrowUp),
                      ),
                    ),
                  ),
                ),
                if (file != null)
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextFormFields(
                        icon: FontAwesomeIcons.fileZipper,
                        item: TextFormField(
                          controller: nombreArchivoCtrl,
                          readOnly: true,
                          decoration: const InputDecoration(
                              hintText: 'Nombre del archivo',
                              labelText: 'Nombre del archivo'),
                        ),
                        large: 500.toDouble(),
                        ancho: 85.toDouble()),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: ElevatedButton(
                onPressed: () {
                  _save();
                },
                style: ElevatedButton.styleFrom(
                  primary: hexToColor('#fdf4e5'), // background
                  onPrimary: Colors.white, // foreground
                  padding:
                      const EdgeInsets.symmetric(horizontal: 68, vertical: 25),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  elevation: 8.0,
                ),
                child: const Text('Guardar',
                    style: TextStyle(fontSize: 18, color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _actividadesTiming() {
    return SizedBox(
      width: 1200,
      height: 400,
      child: Card(
        //color: Colors.white,
        elevation: 12,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: BlocBuilder<ActividadestimingBloc, ActividadestimingState>(
          builder: (context, state) {
            if (state is ActividadestimingInitial) {
              return const Center(
                child: LoadingCustom(),
              );
            } else if (state is LoadingActividadesTimingsState) {
              return const Center(
                child: LoadingCustom(),
              );
            } else if (state is MostrarActividadesTimingsState) {
              return _constructorListView(state.actividadesTimings);
            } else if (state is ErrorMostrarActividadesTimingsState) {
              return Center(
                child: Text(state.message),
              );
              //_showError(context, state.message);
            } else {
              return const Center(
                child: LoadingCustom(),
              );
            }
          },
        ),
      ),
    );
  }

  _constructorListView(ItemModelActividadesTimings item) {
    return item.results.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: item.results.length - 1,
            itemBuilder: (BuildContext context, int i) {
              //final item = items[i];
              i++;
              final row = item.results.elementAt(i);
              return Dismissible(
                key: Key(row.idActividad.toString()),
                secondaryBackground: Container(
                  color: Colors.green[400],
                  alignment: Alignment.topRight,
                  child: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                ),
                confirmDismiss: (DismissDirection direccion) async {
                  if (direccion == DismissDirection.endToStart) {
                    _initControlersEdit(item, i);
                    return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          EventoActividadModel actividadModel =
                              EventoActividadModel(
                            idActividad: item.results.elementAt(i).idActividad,
                            nombreActividad:
                                item.results.elementAt(i).nombreActividad,
                            descripcionActividad:
                                item.results.elementAt(i).descripcion,
                            visibleInvolucrado:
                                item.results.elementAt(i).visibleInvolucrados,
                            haveArchivo: item.results.elementAt(i).haveFile,
                            tiempoAntes: item.results.elementAt(i).tiempoAntes,
                          );

                          List<EventoActividadModel> listaActividades = [];

                          for (var actividad in item.results) {
                            {
                              if (item.results.elementAt(i).idActividad !=
                                      actividad.idActividad &&
                                  actividad.idActividad != 0) {
                                listaActividades.add(
                                  (EventoActividadModel(
                                    idActividad: actividad.idActividad,
                                    nombreActividad: actividad.nombreActividad,
                                    descripcionActividad: actividad.descripcion,
                                    visibleInvolucrado:
                                        actividad.visibleInvolucrados,
                                    haveArchivo: actividad.haveFile,
                                    tiempoAntes: actividad.tiempoAntes,
                                  )),
                                );
                              }
                            }
                          }

                          return EditActividadDialog(
                            actividad: actividadModel,
                            idTiming: idTiming,
                            actividades: listaActividades,
                          );
                        });
                  } else {
                    return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SizedBox(
                              width: double.infinity,
                              child: AlertDialog(
                                title: const Text('¿Eliminar actividad?'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        setState(() {
                                          actividadestimingBloc.add(
                                              DeleteActividadesTimingsEvent(
                                                  idTiming,
                                                  item.results
                                                      .elementAt(i)
                                                      .idActividad));
                                          item.results.removeAt(i);
                                        });
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                      },
                                      child: const Text('Sí')),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('No')),
                                ],
                              ));
                        });
                  }
                },
                background: Container(
                  color: Colors.red[400],
                  alignment: Alignment.topLeft,
                  child: const Icon(
                    Icons.cancel,
                    color: Colors.white,
                  ),
                ),
                child: Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black12)),
                  child: ListTile(
                    trailing: item.results.elementAt(i).haveFile
                        ? GestureDetector(
                            child: const FaIcon(FontAwesomeIcons.paperclip),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => DialogArchivoActividad(
                                        nombreActividad: item.results
                                            .elementAt(i)
                                            .nombreActividad,
                                        idActividad: item.results
                                            .elementAt(i)
                                            .idActividad,
                                        isPlanner: true,
                                      ));
                            },
                          )
                        : null,
                    title:
                        Text(item.results.elementAt(i).nombreActividad ?? ''),
                    subtitle: ListBody(
                      children: [
                        Text(item.results.elementAt(i).descripcion ?? ''),
                        Text(item.results.elementAt(i).visibleInvolucrados
                            ? 'Visible para involucrados'
                            : 'No visible para involucrados')
                      ],
                    ),
                  ),
                ),
              );
            })
        : const Center(child: Text('Sin actividades'));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ActividadestimingBloc, ActividadestimingState>(
      listener: (context, state) {
        if (state is CreateActividadesTimingsOkState) {
          _clearData();
          setState(() {});
        }
      },
      child: SingleChildScrollView(
        child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Form(key: keyForm, child: _formIu(true)),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Actividades',
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(
                  height: 20,
                ),
                _actividadesTiming(),
              ],
            )),
      ),
    );
  }
}

class EditActividadDialog extends StatefulWidget {
  final EventoActividadModel actividad;
  final List<EventoActividadModel> actividades;
  final int idTiming;

  const EditActividadDialog(
      {Key key,
      @required this.actividad,
      @required this.idTiming,
      this.actividades})
      : super(key: key);

  @override
  State<EditActividadDialog> createState() =>
      _EditActividadDialogState(idTiming);
}

class _EditActividadDialogState extends State<EditActividadDialog> {
  int idTiming;
  _EditActividadDialogState(this.idTiming);

  ActividadestimingBloc actividadestimingBloc;
  TextEditingController nombreArchivoCtrl = TextEditingController();

  String archivo;
  PlatformFile file;

  final _keyForm = GlobalKey<FormState>();

  List<Map<String, dynamic>> opcionesMeses = [
    {'descripcion': 'A un mes', 'value': 1},
    {'descripcion': 'A dos meses', 'value': 2},
    {'descripcion': 'A tres meses', 'value': 3},
    {'descripcion': 'A cuatro meses', 'value': 4},
    {'descripcion': 'A cinco meses', 'value': 5},
    {'descripcion': 'A seis meses', 'value': 6},
    {'descripcion': 'A siete meses', 'value': 7},
    {'descripcion': 'A ocho meses', 'value': 8},
    {'descripcion': 'A nueve meses', 'value': 9},
    {'descripcion': 'A diez meses', 'value': 10},
    {'descripcion': 'A once meses', 'value': 11},
    {'descripcion': 'A doce meses', 'value': 12},
  ];

  @override
  void initState() {
    actividadestimingBloc = BlocProvider.of<ActividadestimingBloc>(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: AlertDialog(
          title: const Text('Editar actividad'),
          content: SingleChildScrollView(
              child:
                  BlocListener<ActividadestimingBloc, ActividadestimingState>(
            listener: (context, state) {
              if (state is EditedActividadEvent) {
                if (state.isOk) {
                  Navigator.of(context, rootNavigator: true).pop();
                  MostrarAlerta(
                      mensaje: 'Se ha editado correctamente la actividad',
                      tipoMensaje: TipoMensaje.correcto);
                }
              }
            },
            child: Form(
              key: _keyForm,
              child: ListBody(
                children: [
                  SizedBox(
                    width: 1200,
                    //height: 600,
                    child: Card(
                      color: Colors.white,
                      elevation: 12,
                      shadowColor: Colors.black12,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: <Widget>[
                          TextFormFields(
                              icon: Icons.local_activity,
                              item: TextFormField(
                                initialValue: widget.actividad.nombreActividad,
                                decoration: const InputDecoration(
                                  labelText: 'Nombre',
                                ),
                                onChanged: (value) {
                                  widget.actividad.nombreActividad = value;
                                },
                                validator: (value) {
                                  if (value != '' && value != null) {
                                    return null;
                                  }
                                  return 'El nombre es requerido';
                                },
                              ),
                              large: 500.0,
                              ancho: 85.0),
                          TextFormFields(
                              icon: Icons.drive_file_rename_outline,
                              item: TextFormField(
                                initialValue:
                                    widget.actividad.descripcionActividad,
                                decoration: const InputDecoration(
                                  labelText: 'Descripción',
                                ),
                                onChanged: (value) {
                                  widget.actividad.descripcionActividad = value;
                                },
                              ),
                              large: 500.0,
                              ancho: 85.0),
                          TextFormFields(
                            icon: FontAwesomeIcons.circleCheck,
                            item: CheckboxListTile(
                              title: const Text('Visible para involucrados'),
                              //secondary: Icon(Icons.be),
                              controlAffinity: ListTileControlAffinity.platform,
                              value: widget.actividad.visibleInvolucrado,
                              onChanged: (bool value) {
                                setState(() {
                                  widget.actividad.visibleInvolucrado = value;
                                });
                              },
                              activeColor: Colors.green,
                              checkColor: Colors.black,
                            ),
                            ancho: 85,
                            large: 500.0,
                          ),
                          TextFormFields(
                            icon: FontAwesomeIcons.calendarDay,
                            item: DropdownButtonFormField(
                              validator: (value) {
                                if (value != null) {
                                  return null;
                                }
                                return 'El tiempo es requerido';
                              },
                              isExpanded: true,
                              onChanged: (value) => setState(() {
                                widget.actividad.tiempoAntes = value;
                              }),
                              items: opcionesMeses.map((e) {
                                return DropdownMenuItem(
                                  value: e['value'],
                                  child: Text(e['descripcion']),
                                );
                              }).toList(),
                              value: widget.actividad.tiempoAntes,
                              hint: Text(widget.actividad.tiempoAntes != null
                                  ? widget.actividad.tiempoAntes.toString()
                                  : 'Seleccione a cuánto tiempo antes del evento'),
                              style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: Colors.black,
                              ),
                            ),
                            ancho: 85.toDouble(),
                            large: 500.0.toDouble(),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: ElevatedButton(
                              onPressed: () async {
                                const extensiones = [
                                  'jpg',
                                  'png',
                                  'jpeg',
                                  'pdf'
                                ];
                                FilePickerResult pickedFile =
                                    await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  withData: true,
                                  allowedExtensions: extensiones,
                                  allowMultiple: false,
                                );

                                if (pickedFile != null) {
                                  file = pickedFile.files.single;
                                  nombreArchivoCtrl.text = file.name;
                                  setState(() {});
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: FaIcon(FontAwesomeIcons.fileArrowUp),
                              ),
                            ),
                          ),
                          if (file != null)
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: TextFormFields(
                                  icon: FontAwesomeIcons.fileZipper,
                                  item: TextFormField(
                                    controller: nombreArchivoCtrl,
                                    readOnly: true,
                                    decoration: const InputDecoration(
                                        hintText: 'Nombre del archivo',
                                        labelText: 'Nombre del archivo'),
                                  ),
                                  large: 500.toDouble(),
                                  ancho: 85.toDouble()),
                            ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar')),
            TextButton(
                onPressed: () async {
                  if (file != null) {
                    widget.actividad.archivo = base64Encode(file.bytes);
                    widget.actividad.tipoMime = file.extension;
                    widget.actividad.haveArchivo = false;
                  }

                  if (_keyForm.currentState.validate()) {
                    actividadestimingBloc
                        .add(UpdateActividadEvent(widget.actividad, idTiming));
                  }
                },
                child: const Text('Aceptar')),
          ],
        ));
  }
}

// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/blocs/actividadesTiming/actividadestiming_bloc.dart';
import 'package:planning/src/models/Planes/planes_model.dart';
import 'package:planning/src/models/item_model_actividades_timings.dart';
import 'package:planning/src/ui/widgets/snackbar_widget/snackbar_widget.dart';
import 'package:planning/src/ui/widgets/text_form_filed/text_form_filed.dart';

class AgregarActividades extends StatefulWidget {
  final int idTiming;
  const AgregarActividades({Key key, this.idTiming}) : super(key: key);

  @override
  _AgregarActividadesState createState() => _AgregarActividadesState(idTiming);
}

class _AgregarActividadesState extends State<AgregarActividades> {
  final int idTiming;
  TextEditingController actividadCtrl;
  TextEditingController actividadEditCtrl;
  TextEditingController descripcionCtrl;
  TextEditingController descripcionEditCtrl;
  TextEditingController numCtrl;
  TextEditingController numEditCtrl;
  ActividadestimingBloc actividadestimingBloc;
  ItemModelActividadesTimings itemModelActividadesTimings;
  GlobalKey<FormState> keyForm = GlobalKey();
  String _mySelectionAT = '0';
  int _itemCount = 0;
  bool _actVisible = false;
  int _itemCountEdit = 0;
  bool _actVisibleEdit = false;

  _AgregarActividadesState(this.idTiming);
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
    _mySelectionAT = '0';
    _itemCount = 0;
    numCtrl.text = _itemCount.toString();
    _actVisible = false;
    actividadCtrl.clear();
    descripcionCtrl.clear();
  }

  _initControlersEdit(ItemModelActividadesTimings actividad, int i) {
    actividadEditCtrl = TextEditingController(
        text: actividad.results.elementAt(i).nombreActividad);
    _itemCountEdit = int.parse(actividad.results.elementAt(i).dias);
    numEditCtrl = TextEditingController(text: _itemCountEdit.toString());
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
      return "Falta descripcion";
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
      return "Falta descripcion";
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
        "dias": numCtrl.text,
        "predecesor": _mySelectionAT,
      };
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
                    ancho: 80.0),
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
                    ancho: 80.0),
              ],
            ),
            Wrap(
              alignment: WrapAlignment.center,
              children: <Widget>[
                TextFormFields(
                  icon: Icons.date_range_outlined,
                  ancho: 80.0,
                  large: 363.0,
                  item: Row(
                    children: [
                      const Expanded(child: Text("Duración en días:")),
                      et
                          ? IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: _itemCount == 0
                                  ? null
                                  : () => setState(() {
                                        _itemCount--;
                                        numCtrl.text = _itemCount.toString();
                                      }),
                            )
                          : IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: _itemCountEdit == 0
                                  ? null
                                  : () => setState(() {
                                        _itemCountEdit--;
                                        numEditCtrl.text =
                                            _itemCountEdit.toString();
                                      }),
                            ),
                      SizedBox(
                        width: 45,
                        height: 45,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: TextFormField(
                            controller: et ? numCtrl : numEditCtrl,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      et
                          ? IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => setState(() {
                                    _itemCount++;
                                    numCtrl.text = _itemCount.toString();
                                  }))
                          : IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => setState(() {
                                    _itemCountEdit++;
                                    numEditCtrl.text =
                                        _itemCountEdit.toString();
                                  })),
                    ],
                  ),
                ),
                et
                    ? TextFormFields(
                        icon: null,
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
                        ancho: 80,
                        large: 363.0,
                      )
                    : TextFormFields(
                        icon: null,
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
                        ancho: 80,
                        large: 363.0,
                      ),
                TextFormFields(
                  icon: Icons.linear_scale_outlined,
                  item: _constructorDropDownAT(),
                  ancho: 80,
                  large: 500,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: ElevatedButton(
                    onPressed: () {
                      _save();
                    },
                    child: const Text('Guardar',
                        style: TextStyle(fontSize: 18, color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      primary: hexToColor('#fdf4e5'), // background
                      onPrimary: Colors.white, // foreground
                      padding: const EdgeInsets.symmetric(
                          horizontal: 68, vertical: 25),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      elevation: 8.0,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _dropDownActividades(ItemModelActividadesTimings items) {
    return items.results.isNotEmpty
        ? DropdownButton(
            isExpanded: true,
            value: _mySelectionAT,
            icon: const Icon(Icons.arrow_drop_down_outlined),
            iconSize: 24,
            elevation: 16,
            style: const TextStyle(
                color: Color(0xFF000000), overflow: TextOverflow.ellipsis),
            underline: Container(
              height: 2,
              color: const Color(0xFF000000),
            ),
            onChanged: (newValue) {
              setState(() {
                _mySelectionAT = newValue;
              });
            },
            items: items.results.map((item) {
              return DropdownMenuItem(
                value: item.idActividad.toString(),
                child: Text(
                  item.nombreActividad,
                  style: const TextStyle(fontSize: 18),
                ),
              );
            }).toList(),
          )
        : const Center(child: Text('Sin predecesores'));
  }

  _constructorDropDownAT() {
    return BlocBuilder<ActividadestimingBloc, ActividadestimingState>(
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
          return _dropDownActividades(state.actividadesTimings);
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
                  child: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  alignment: Alignment.topRight,
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
                            diasActividad: item.results.elementAt(i).dia,
                            visibleInvolucrado:
                                item.results.elementAt(i).visibleInvolucrados,
                            predecesorActividad:
                                item.results.elementAt(i).predecesor,
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
                                    diasActividad: actividad.dia,
                                    visibleInvolucrado:
                                        actividad.visibleInvolucrados,
                                    predecesorActividad: actividad.predecesor,
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
                                        Navigator.of(context).pop();
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
                  child: const Icon(
                    Icons.cancel,
                    color: Colors.white,
                  ),
                  alignment: Alignment.topLeft,
                ),
                child: Container(
                  child: ListTile(
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
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black12)),
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
  _EditActividadDialogState createState() =>
      _EditActividadDialogState(actividad, idTiming);
}

class _EditActividadDialogState extends State<EditActividadDialog> {
  EventoActividadModel actividad;
  int idTiming;
  _EditActividadDialogState(this.actividad, this.idTiming);

  ActividadestimingBloc actividadestimingBloc;
  TextEditingController diasController;
  List<EventoActividadModel> predecesores = [];

  @override
  void initState() {
    actividadestimingBloc = BlocProvider.of<ActividadestimingBloc>(context);
    EventoActividadModel primeraOpcion = EventoActividadModel(
        nombreActividad: 'Seleccione un predecesor', idActividad: -1);
    predecesores = [primeraOpcion, ...widget.actividades];

    diasController = TextEditingController(text: '${actividad.diasActividad}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                  MostrarAlerta(
                      mensaje: 'Se ha editado correctamente la actividad',
                      tipoMensaje: TipoMensaje.correcto);
                  Navigator.of(context).pop();
                }
              }
            },
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
                        Wrap(
                          alignment: WrapAlignment.center,
                          children: <Widget>[
                            TextFormFields(
                                icon: Icons.local_activity,
                                item: TextFormField(
                                  initialValue: actividad.nombreActividad,
                                  decoration: const InputDecoration(
                                    labelText: 'Nombre',
                                  ),
                                  onChanged: (value) {
                                    actividad.nombreActividad = value;
                                  },
                                ),
                                large: 500.0,
                                ancho: 80.0),
                            TextFormFields(
                                icon: Icons.drive_file_rename_outline,
                                item: TextFormField(
                                  initialValue: actividad.descripcionActividad,
                                  decoration: const InputDecoration(
                                    labelText: 'Descripción',
                                  ),
                                  onChanged: (value) {
                                    actividad.descripcionActividad = value;
                                  },
                                ),
                                large: 500.0,
                                ancho: 80.0),
                          ],
                        ),
                        Wrap(
                          alignment: WrapAlignment.center,
                          children: <Widget>[
                            TextFormFields(
                              icon: Icons.date_range_outlined,
                              ancho: 80.0,
                              large: 363.0,
                              item: (size.width > 400)
                                  ? Row(
                                      children: durationDaysChildren(false),
                                    )
                                  : Column(
                                      children: durationDaysChildren(true),
                                    ),
                            ),
                            TextFormFields(
                              icon: null,
                              item: CheckboxListTile(
                                title: const Text('Visible para involucrados'),
                                //secondary: Icon(Icons.be),
                                controlAffinity:
                                    ListTileControlAffinity.platform,
                                value: actividad.visibleInvolucrado,
                                onChanged: (bool value) {
                                  setState(() {
                                    actividad.visibleInvolucrado = value;
                                  });
                                },
                                activeColor: Colors.green,
                                checkColor: Colors.black,
                              ),
                              ancho: 80,
                              large: 363.0,
                            ),
                            if (widget.actividades.isNotEmpty)
                              TextFormFields(
                                icon: Icons.linear_scale_outlined,
                                item: DropdownButtonFormField(
                                    decoration: const InputDecoration(
                                        constraints: BoxConstraints(
                                      maxWidth: 450,
                                    )),
                                    hint:
                                        const Text('Seleccione el predecesor'),
                                    menuMaxHeight: 450,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      overflow: TextOverflow.ellipsis,
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
                                    iconSize: 10.0,
                                    isExpanded: true,
                                    value: actividad.predecesorActividad ?? -1,
                                    items: predecesores
                                        .map((e) => DropdownMenuItem(
                                              child: Text(
                                                e.nombreActividad,
                                              ),
                                              value: e.idActividad,
                                            ))
                                        .toList()),
                                ancho: 80,
                                large: 500,
                              ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
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
                  actividadestimingBloc
                      .add(UpdateActividadEvent(actividad, idTiming));
                },
                child: const Text('Aceptar')),
          ],
        ));
  }

  List<Widget> durationDaysChildren(bool isMovil) {
    return [
      const Text("Duración en días:"),
      Row(
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: actividad.diasActividad == 0
                ? null
                : () => setState(() {
                      actividad.diasActividad--;
                      diasController.text = actividad.diasActividad.toString();
                    }),
          ),
          SizedBox(
            width: 45,
            height: 45,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: TextFormField(
                controller: diasController,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => setState(() {
                    actividad.diasActividad++;
                    diasController.text = actividad.diasActividad.toString();
                  })),
        ],
      )
    ];
  }
}

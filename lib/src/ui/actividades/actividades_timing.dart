import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/blocs/actividadesTiming/actividadestiming_bloc.dart';
import 'package:planning/src/models/item_model_actividades_timings.dart';
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
  GlobalKey<FormState> keyForm = new GlobalKey();
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
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
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
    actividadEditCtrl = new TextEditingController(
        text: actividad.results.elementAt(i).nombreActividad);
    _itemCountEdit = int.parse(actividad.results.elementAt(i).dias);
    numEditCtrl = new TextEditingController(text: _itemCountEdit.toString());
    _actVisibleEdit = actividad.results.elementAt(i).visibleInvolucrados;
    descripcionEditCtrl = new TextEditingController(
        text: actividad.results.elementAt(i).descripcion);
    //_mySelectionAT = actividad.results.elementAt(i).idTipoTimig.toString();
  }

  _initControlers() {
    actividadCtrl = new TextEditingController();
    numCtrl = new TextEditingController(text: 0.toString());
    descripcionCtrl = new TextEditingController();
  }

  String validateActividad(String value) {
    if (value.length == 0) {
      return "Falta actividad";
    } else {
      return null;
    }
  }

  String validateDescripcion(String value) {
    if (value.length == 0) {
      return "Falta descripcion";
    } else {
      return null;
    }
  }

  String validateActividadEdit(String value) {
    if (value.length == 0) {
      return "Falta actividad";
    } else {
      return null;
    }
  }

  String validateDescripcionEdit(String value) {
    if (value.length == 0) {
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
    return Container(
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
                      decoration: new InputDecoration(
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
                      decoration: new InputDecoration(
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
                      Expanded(child: Text("Duración en días:")),
                      et
                          ? IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: _itemCount == 0
                                  ? null
                                  : () => setState(() {
                                        _itemCount--;
                                        numCtrl.text = _itemCount.toString();
                                      }),
                            )
                          : IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: _itemCountEdit == 0
                                  ? null
                                  : () => setState(() {
                                        _itemCountEdit--;
                                        numEditCtrl.text =
                                            _itemCountEdit.toString();
                                      }),
                            ),
                      Container(
                        width: 45,
                        height: 45,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 3),
                          child: TextFormField(
                            controller: et ? numCtrl : numEditCtrl,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      et
                          ? IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () => setState(() {
                                    _itemCount++;
                                    numCtrl.text = _itemCount.toString();
                                  }))
                          : IconButton(
                              icon: Icon(Icons.add),
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
                          title: Text('Visible para novios'),
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
                          title: Text('Visible para novios'),
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
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: ElevatedButton(
                    onPressed: () {
                      _save();
                    },
                    child: Text('Guardar',
                        style: TextStyle(fontSize: 18, color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      primary: hexToColor('#fdf4e5'), // background
                      onPrimary: Colors.white, // foreground
                      padding:
                          EdgeInsets.symmetric(horizontal: 68, vertical: 25),
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
    return items.results.length != 0
        ? DropdownButton(
            value: _mySelectionAT,
            icon: const Icon(Icons.arrow_drop_down_outlined),
            iconSize: 24,
            elevation: 16,
            style: const TextStyle(color: Color(0xFF000000)),
            underline: Container(
              height: 2,
              color: Color(0xFF000000),
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
                  style: TextStyle(fontSize: 18),
                ),
              );
            }).toList(),
          )
        : Container(child: Center(child: Text('Sin predecesores')));
  }

  _constructorDropDownAT() {
    return BlocBuilder<ActividadestimingBloc, ActividadestimingState>(
      builder: (context, state) {
        if (state is ActividadestimingInitial) {
          return Center(child: CircularProgressIndicator());
        } else if (state is LoadingActividadesTimingsState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is MostrarActividadesTimingsState) {
          return _dropDownActividades(state.actividadesTimings);
        } else if (state is ErrorMostrarActividadesTimingsState) {
          return Center(
            child: Text(state.message),
          );
          //_showError(context, state.message);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  _actividadesTiming() {
    return Container(
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
              return Center(child: CircularProgressIndicator());
            } else if (state is LoadingActividadesTimingsState) {
              return Center(child: CircularProgressIndicator());
            } else if (state is MostrarActividadesTimingsState) {
              return _constructorListView(state.actividadesTimings);
            } else if (state is ErrorMostrarActividadesTimingsState) {
              return Center(
                child: Text(state.message),
              );
              //_showError(context, state.message);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  _constructorListView(ItemModelActividadesTimings item) {
    return item.results.length != 0
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
                  child: Icon(
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
                          return Container(
                              width: double.infinity,
                              child: AlertDialog(
                                title: Text('Editar actividad'),
                                content: SingleChildScrollView(
                                    child: ListBody(
                                  children: [_formIu(false)],
                                )),
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
                                          //item.results.removeAt(i);
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Sí')),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('No')),
                                ],
                              ));
                        });
                  } else {
                    return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                              width: double.infinity,
                              child: AlertDialog(
                                title: Text('¿Eliminar actividad?'),
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
                                      child: Text('Sí')),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('No')),
                                ],
                              ));
                        });
                  }
                },
                background: Container(
                  color: Colors.red[400],
                  child: Icon(
                    Icons.cancel,
                    color: Colors.white,
                  ),
                  alignment: Alignment.topLeft,
                ),
                child: Container(
                  child: ListTile(
                    title: Text(
                        item.results.elementAt(i).nombreActividad != null
                            ? item.results.elementAt(i).nombreActividad
                            : ''),
                    subtitle: ListBody(
                      children: [
                        Text(item.results.elementAt(i).descripcion != null
                            ? item.results.elementAt(i).descripcion
                            : ''),
                        Text(item.results.elementAt(i).visibleInvolucrados
                            ? 'Visible para los novios'
                            : 'No visible para los novios')
                      ],
                    ),
                  ),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black12)),
                ),
              );
            })
        : Container(
            child: Center(child: Text('Sin actividades')),
          );
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
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(child: Form(key: keyForm, child: _formIu(true))),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Actividades',
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(
                  height: 20,
                ),
                _actividadesTiming(),
              ],
            )),
      ),
    );
  }
}

// ignore_for_file: unused_field, no_logic_in_create_state

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/blocs/blocs.dart';
import 'package:planning/src/blocs/invitadosMesa/invitadosmesas_bloc.dart';
import 'package:planning/src/models/item_model_acompanante.dart';
import 'package:planning/src/models/item_model_estatus_invitado.dart';
import 'package:planning/src/models/item_model_grupos.dart';
import 'package:planning/src/models/item_model_invitado.dart';
import 'package:planning/src/resources/api_provider.dart';
import 'package:planning/src/resources/my_flutter_app_icons.dart';
import 'package:planning/src/ui/widgets/call_to_action/call_to_action.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:planning/src/ui/widgets/snackbar_widget/snackbar_widget.dart';

class FullScreenDialogEdit extends StatefulWidget {
  final int idInvitado;

  const FullScreenDialogEdit({Key key, this.idInvitado}) : super(key: key);
  @override
  _FullScreenDialogEditState createState() =>
      _FullScreenDialogEditState(idInvitado);
}

class _FullScreenDialogEditState extends State<FullScreenDialogEdit> {
  final _keyFormAcomp = GlobalKey<FormState>();
  final _keyFormEditAcomp = GlobalKey<FormState>();
  ApiProvider api = ApiProvider();
  final int idInvitado;
  int _numAcomp = 0;
  int contActualiza = 0;
  int contActualizaEdad = 0;
  int contActualizaGenero = 0;
  int contActualizaGrupo = 0;
  int contActualizaData = 0;
  int contActualizaMesa = 0;
  bool isExpaned = true;
  bool isExpanedT = false;
  bool isExpaneA = false;
  GlobalKey<FormState> keyForm = GlobalKey();
  GlobalKey<FormState> keyFormG = GlobalKey();
  final TextEditingController _numberGuestsController = TextEditingController();
  TextEditingController nombreCtrl = TextEditingController();

  TextEditingController emailCtrl = TextEditingController();

  TextEditingController grupo = TextEditingController();

  TextEditingController telefonoCtrl = TextEditingController();

  TextEditingController tipoAlimentacionCtrl = TextEditingController();
  TextEditingController asistenciaEspecialCtrl = TextEditingController();
  TextEditingController alergiasCtrl = TextEditingController();
  TextEditingController alimentAcompContrl = TextEditingController();
  TextEditingController alerAcompContrl = TextEditingController();
  TextEditingController asisEspAcompContrl = TextEditingController();

  String dropdownValue = 'Hombre';
  int _currentSelection;
  int _currentSelectionGenero;
  String _mySelection = '';
  String _mySelectionG = "1";
  String _mySelectionM = "0";
  final bool _lights = false;
  String seleccionEstatus;
  bool isEdtiingEstatus = false;

  String _base64qr;
  // Acompañante
  TextEditingController nombreAcompananteCtrl = TextEditingController();
  int _mySelectionAEdad = 0;
  int _mySelectionAGenero = 0;
  int _mySelectionAEdad2 = 0;
  int _mySelectionAGenero2 = 0;
  int numbAcomFromDB;

  _FullScreenDialogEditState(this.idInvitado);
  final Map<int, Widget> _children = {
    0: const Text(
      'Adulto',
      style: TextStyle(fontSize: 12),
    ),
    1: const Text(
      'Niño',
      style: TextStyle(fontSize: 12),
    ),
  };
  final Map<int, Widget> _childrenGenero = {
    0: const Text(
      'Hombre',
      style: TextStyle(fontSize: 12),
    ),
    1: const Text(
      'Mujer',
      style: TextStyle(fontSize: 12),
    ),
  };

  _datosInvitado() {
    blocInvitado.fetchAllInvitado(idInvitado, context);
    return StreamBuilder(
      stream: blocInvitado.allInvitado,
      builder: (context, AsyncSnapshot<ItemModelInvitado> snapshot) {
        if (snapshot.hasData) {
          //_mySelection = ((snapshot.data.results.length - 1).toString());
          ItemModelAcompanante l;
          return formUI(snapshot.data, l);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return const Center(child: LoadingCustom());
      },
    );
  }

  Widget _listaAcompanantes() {
    blocInvitado.fetchAllAcompanante(idInvitado, context);
    return StreamBuilder(
      stream: blocInvitado.allAcompanante,
      builder: (context, AsyncSnapshot<ItemModelAcompanante> snapshot) {
        if (snapshot.hasData) {
          numbAcomFromDB = snapshot.data.results.length;
          return SizedBox(
            width: 1000,
            child: Column(
              children: <Widget>[
                Wrap(
                  children: _createListItemsAcomp(snapshot.data),
                )
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return const Center(child: LoadingCustom());
      },
    );
  }

  List<Widget> _createListItemsAcomp(ItemModelAcompanante data) {
    // Creación de lista de Widget.
    List<Widget> listaAcompa = [];
    for (var opt in data.results) {
      final tempWidget = ListTile(
          title: Text(opt.nombre),
          trailing: Wrap(spacing: 12, children: <Widget>[
            IconButton(
                onPressed: () => showDialog<void>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: const Text('Eliminar acompañante'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context, 'Cancelar');
                                },
                                child: const Text('Cancelar')),
                            TextButton(
                                onPressed: () async {
                                  _eliminarAcompanante(opt.idAcompanne);
                                  Navigator.pop(context, 'Ok');
                                },
                                child: const Text('Eliminar'))
                          ],
                        )),
                icon: const Icon(Icons.delete)),
            IconButton(
                onPressed: () => showDialog<void>(
                    context: context,
                    builder: (BuildContext context) =>
                        dialogEditAcomp(opt.idAcompanne, data)),
                icon: const Icon(Icons.edit))
          ]));
      listaAcompa.add(tempWidget);
    }
    return listaAcompa;
  }

  Widget dialogEditAcomp(int idAcompanante, ItemModelAcompanante data) {
    String genero;
    final acompanante = data.results
        .firstWhere((element) => element.idAcompanne == idAcompanante);
    return AlertDialog(
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'Cancelar');
          },
          child: const Text(
            'Cancelar',
            textAlign: TextAlign.left,
          ),
        ),
        TextButton(
          onPressed: () async {
            if (_mySelectionAEdad2 == 0) {
              acompanante.edad = 'A';
            } else {
              acompanante.edad = 'N';
            }

            if (_mySelectionAGenero2 == 0) {
              genero = 'H';
            } else {
              genero = 'M';
            }
            if (_keyFormEditAcomp.currentState.validate()) {
              Map<String, String> editAcompanante = {
                'idAcompanante': acompanante.idAcompanne.toString(),
                'nombre': acompanante.nombre,
                'edad': acompanante.edad,
                'genero': genero,
                'alimentacion': acompanante.alimentacion,
                'alergias': acompanante.alergias,
                'asistenciaEspecial': acompanante.asistenciaEspecial
              };
              final data = await api.updateAcompanante(editAcompanante);

              if (data == 'Ok') {
                MostrarAlerta(
                    mensaje: 'El acompañante se actualizó correctamente.',
                    tipoMensaje: TipoMensaje.correcto);
                await blocInvitado.fetchAllAcompanante(idInvitado, context);
                Navigator.pop(context, 'Agregado');
              } else {
                Navigator.pop(context, 'Error');
                MostrarAlerta(
                    mensaje:
                        'Ocurrio un error al intentar actualizar al acompañante.',
                    tipoMensaje: TipoMensaje.error);
              }
            }
          },
          child: const Text(
            'Guardar',
            textAlign: TextAlign.right,
          ),
        )
      ],
      content: SingleChildScrollView(
        child: Form(
          key: _keyFormEditAcomp,
          child: SizedBox(
            width: 600,
            height: 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text(
                    'Editar acompañante',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                formItemsDesign(
                    Icons.person,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: TextFormField(
                        initialValue: acompanante.nombre,
                        onChanged: (value) {
                          acompanante.nombre = value;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Nombre completo',
                        ),
                        //initialValue: invitado.nombre,
                        validator: validateNombre,
                      ),
                    ),
                    400.0,
                    70.0),
                formItemsDesign(
                    Icons.av_timer_rounded,
                    Row(children: <Widget>[
                      const Text('Edad'),
                      //SizedBox(width: 15,),
                      Expanded(
                        child: MaterialSegmentedControl(
                          children: _children,
                          selectionIndex: _mySelectionAEdad2,
                          borderColor: const Color(0xFF000000),
                          selectedColor: const Color(0xFF000000),
                          unselectedColor: Colors.white,
                          borderRadius: 32.0,
                          horizontalPadding: const EdgeInsets.all(4),
                          onSegmentChosen: (index) {
                            setState(() {
                              _mySelectionAEdad2 = index;
                            });
                          },
                        ),
                      ),
                    ]),
                    400.0,
                    70.0),
                formItemsDesign(
                    MyFlutterApp.transgender,
                    Row(children: <Widget>[
                      const Text('Género'),
                      //SizedBox(width: 15,),
                      Expanded(
                        child: MaterialSegmentedControl(
                          children: _childrenGenero,
                          selectionIndex: _mySelectionAGenero2,
                          borderColor: const Color(0xFF000000),
                          selectedColor: const Color(0xFF000000),
                          unselectedColor: Colors.white,
                          borderRadius: 32.0,
                          horizontalPadding:
                              const EdgeInsets.symmetric(horizontal: 5.0),
                          onSegmentChosen: (index) {
                            setState(() {
                              _mySelectionAGenero2 = index;
                            });
                          },
                        ),
                      ),
                    ]),
                    400.0,
                    70.0),
                formItemsDesign(
                    Icons.restaurant_menu_sharp,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: TextFormField(
                        initialValue: acompanante.alimentacion,
                        onChanged: (value) {
                          acompanante.alimentacion = value;
                        },
                        decoration: const InputDecoration(
                            labelText: 'Tipo de alimentación'),
                      ),
                    ),
                    400.0,
                    70.0),
                formItemsDesign(
                    Icons.sick_outlined,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: TextFormField(
                        initialValue: acompanante.alergias,
                        onChanged: (value) {
                          acompanante.alergias = value;
                        },
                        decoration:
                            const InputDecoration(labelText: 'Alergias'),
                      ),
                    ),
                    400,
                    70),
                formItemsDesign(
                    Icons.wheelchair_pickup,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: TextFormField(
                        initialValue: acompanante.asistenciaEspecial,
                        inputFormatters: [
                          FilteringTextInputFormatter.singleLineFormatter
                        ],
                        onChanged: (value) {
                          acompanante.asistenciaEspecial = value;
                        },
                        decoration: const InputDecoration(
                            labelText: 'Asistencia especial'),
                      ),
                    ),
                    400.0,
                    70.0)
              ],
            ),
          ),
        ),
      ),
    );
  }

  _eliminarAcompanante(int idAcompanante) async {
    final data = await api.deleteAcompanante(idAcompanante.toString());
    if (data == 'Ok') {
      MostrarAlerta(
          mensaje: 'El acompañante se ha eliminado.',
          tipoMensaje: TipoMensaje.correcto);
    } else {
      MostrarAlerta(
          mensaje: 'Ocurrio un error: $data.', tipoMensaje: TipoMensaje.error);
    }

    await blocInvitado.fetchAllAcompanante(idInvitado, context);
  }

  _listaGrupos() {
    ///bloc.dispose();
    blocGrupos.fetchAllGrupos(context);
    return StreamBuilder(
      stream: blocGrupos.allGrupos,
      builder: (context, AsyncSnapshot<ItemModelGrupos> snapshot) {
        if (snapshot.hasData) {
          //_mySelection = ((snapshot.data.results.length - 1).toString());
          return _dropDownGrupos(snapshot.data);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return const Center(child: LoadingCustom());
      },
    );
  }

  _dropDownGrupos(ItemModelGrupos grupos) {
    return DropdownButton(
      value: _mySelectionG,
      icon: const Icon(Icons.arrow_drop_down_outlined),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Color(0xFF000000)),
      underline: Container(
        height: 2,
        color: const Color(0xFF000000),
      ),
      onChanged: (newValue) {
        setState(() {
          if (newValue ==
              grupos.results
                  .elementAt(grupos.results.length - 1)
                  .idGrupo
                  .toString()) {
            _showMyDialog();
          } else {
            _mySelectionG = newValue;
          }
        });
      },
      items: grupos.results.map((item) {
        return DropdownMenuItem(
          value: item.idGrupo.toString(),
          child: Text(
            item.nombreGrupo,
            style: const TextStyle(fontSize: 18),
          ),
        );
      }).toList(),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              const Text('Registar nuevo grupo', textAlign: TextAlign.center),
          content: SingleChildScrollView(
            child: Form(
              key: keyFormG,
              child: ListBody(
                children: <Widget>[
                  TextFormField(
                    controller: grupo,
                    decoration: const InputDecoration(
                      labelText: 'Grupo',
                    ),
                    validator: validateGrupo,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      _save(context);
                    },
                    child: const CallToAction('Agregar'),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _save(BuildContext context) async {
    if (keyFormG.currentState.validate()) {
      Map<String, String> json = {"nombre_grupo": grupo.text};
      //json.
      bool response = await api.createGrupo(json, context);
      if (response) {
        //_mySelection = "0";
        Navigator.of(context).pop();
        MostrarAlerta(
            mensaje: 'Grupo agregado.', tipoMensaje: TipoMensaje.correcto);
        _listaGrupos();
      } else {
        if (kDebugMode) {
          print('error');
        }
      }
    }
  }

  _listaEstatus() {
    ///bloc.dispose();
    blocEstatus.fetchAllEstatus(context);
    return StreamBuilder(
      stream: blocEstatus.allEstatus,
      builder: (context, AsyncSnapshot<ItemModelEstatusInvitado> snapshot) {
        if (snapshot.hasData) {
          // _mySelection = ((snapshot.data.results.length - 1).toString());
          return _dropDownEstatusInvitado(snapshot.data);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return const Center(child: LoadingCustom());
      },
    );
  }

  _dropDownEstatusInvitado(ItemModelEstatusInvitado estatus) {
    return DropdownButton(
      // hint: const Text('Seleccionar estatus'),
      value: seleccionEstatus,
      icon: const Icon(Icons.arrow_drop_down_outlined),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Color(0xFF000000)),
      underline: Container(
        height: 2,
        color: const Color(0xFF000000),
      ),
      isDense: true,
      onChanged: (newValue) {
        setState(() {
          isEdtiingEstatus = true;
          seleccionEstatus = newValue;
        });
      },
      items: estatus.results.map((item) {
        return DropdownMenuItem(
          value: item.idEstatusInvitado.toString(),
          child: Text(
            item.descripcion,
            style: const TextStyle(fontSize: 18),
          ),
        );
      }).toList(),
    );
  }

  String gender;
  String edad;
  formItemsDesign(icon, item, double large, double ancho) {
    return SizedBox(
      child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 10,
          child: ListTile(leading: Icon(icon), title: item)),
      width: large,
      height: ancho,
    );
  }

  Widget formUI(ItemModelInvitado invitado, ItemModelAcompanante acompanante) {
    if (invitado.numbAcomp != null) {
      _numAcomp = invitado.numbAcomp;
    }
    if (!isEdtiingEstatus) {
      seleccionEstatus = invitado.asistencia.toString() == 'null'
          ? null
          : invitado.asistencia.toString();
    }

    _base64qr = invitado.codigoQr;
    if (contActualiza <= 0) {
      if (invitado.asistencia != null) {
        _mySelection = invitado.asistencia.toString();
        contActualiza++;
      } else {
        _mySelection = "0";
        contActualiza++;
      }
    }
    if (contActualizaEdad <= 0) {
      if (invitado.edad == "A") {
        _currentSelection = 0;
        contActualizaEdad++;
      } else if (invitado.edad == "N") {
        _currentSelection = 1;
        contActualizaEdad++;
      }
    }

    if (contActualizaGenero <= 0) {
      if (invitado.genero == "H") {
        _currentSelectionGenero = 0;
        contActualizaGenero++;
      } else if (invitado.genero == "M") {
        _currentSelectionGenero = 1;
        contActualizaGenero++;
      }
    }
    if (contActualizaGrupo <= 0) {
      if (invitado.grupo == null) {
        _mySelectionG = "0";
      } else {
        _mySelectionG = invitado.grupo.toString();
      }
      contActualizaGrupo++;
    }
    if (contActualizaMesa <= 0) {
      if (invitado.idMesa == null) {
        _mySelectionM = "0";
      } else {
        _mySelectionM = invitado.idMesa.toString();
      }
      contActualizaMesa++;
    }
    if (contActualizaData <= 0) {
      nombreCtrl.text = invitado.nombre;
      emailCtrl.text = invitado.email;
      telefonoCtrl.text = invitado.telefono;
      alergiasCtrl.text = invitado.alergias;
      tipoAlimentacionCtrl.text = invitado.alimentacion;
      asistenciaEspecialCtrl.text = invitado.asistenciaEspecial;
      contActualizaData++;
      if (invitado.numbAcomp != null) {
        _numberGuestsController.text = invitado.numbAcomp.toString();
      }
    }
    return Column(children: <Widget>[
      const SizedBox(
        width: 60,
      ),
      ExpansionPanelList(
        animationDuration: const Duration(milliseconds: 1000),
        expansionCallback: (int index, bool expaned) {
          setState(() {
            if (index == 0) {
              isExpaned = !isExpaned;
            } else if (index == 1) {
              isExpanedT = !isExpanedT;
            } else if (index == 2) {
              isExpaneA = !isExpaneA;
            }
          });
        },
        children: [
          ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpaned) {
                return const Center(
                    child: Text(
                  'Información general',
                  style: TextStyle(fontSize: 20.0),
                ));
              },
              canTapOnHeader: true,
              isExpanded: isExpaned,
              body: Column(
                children: <Widget>[
                  Wrap(children: <Widget>[
                    formItemsDesign(
                        Icons.person,
                        TextFormField(
                          controller: nombreCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Nombre completo',
                          ),
                          //initialValue: invitado.nombre,
                          validator: validateNombre,
                        ),
                        500.0,
                        80.0),
                    formItemsDesign(
                        //MyFlutterApp.transgender,
                        Icons.assignment,
                        Row(
                          children: <Widget>[
                            const Text('Asistencia'),
                            const SizedBox(
                              width: 15,
                            ),
                            _listaEstatus(),
                            //_dropDownEstatusInvitado(),
                          ],
                        ),
                        500.0,
                        80.0)
                    //Container(width: 300,chilistaAld: TextFormField(initialValue: nombre,decoration: InputDecoration(labelText: 'Nombre'))),
                  ]),
                  Wrap(
                    children: <Widget>[
                      formItemsDesign(
                          Icons.av_timer_rounded,
                          Row(children: <Widget>[
                            const Text('Edad'),
                            //SizedBox(width: 15,),
                            Expanded(
                              child: MaterialSegmentedControl(
                                children: _children,
                                selectionIndex: _currentSelection,
                                borderColor: const Color(0xFF000000),
                                selectedColor: const Color(0xFF000000),
                                unselectedColor: Colors.white,
                                borderRadius: 32.0,
                                horizontalPadding: const EdgeInsets.all(8),
                                onSegmentChosen: (index) {
                                  setState(() {
                                    _currentSelection = index;
                                  });
                                },
                              ),
                            ),
                          ]),
                          500.0,
                          80.0),
                      formItemsDesign(
                          MyFlutterApp.transgender,
                          Row(children: <Widget>[
                            const Text('Género'),
                            //SizedBox(width: 15,),
                            Expanded(
                              child: MaterialSegmentedControl(
                                children: _childrenGenero,
                                selectionIndex: _currentSelectionGenero,
                                borderColor: const Color(0xFF000000),
                                selectedColor: const Color(0xFF000000),
                                unselectedColor: Colors.white,
                                borderRadius: 32.0,
                                horizontalPadding: const EdgeInsets.all(8),
                                onSegmentChosen: (index) {
                                  setState(() {
                                    _currentSelectionGenero = index;
                                  });
                                },
                              ),
                            ),
                          ]),
                          500.0,
                          80.0),
                    ],
                  ),
                  Wrap(
                    children: <Widget>[
                      formItemsDesign(
                          Icons.email,
                          TextFormField(
                            controller: emailCtrl,
                            //initialValue: invitado.email,
                            decoration: const InputDecoration(
                              labelText: 'Correo',
                            ),
                            validator: validateEmail,
                          ),
                          500.0,
                          80.0),
                      formItemsDesign(
                          Icons.people,
                          MergeSemantics(
                            child: ListTile(
                              title: TextFormField(
                                enabled: false,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                // controller: _textController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'Número de invitados'),
                                controller: _numberGuestsController,
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        if (_numAcomp > 0 ||
                                            _numAcomp >= numbAcomFromDB) {
                                          _numAcomp -= 1;

                                          _numberGuestsController.text =
                                              _numAcomp.toString();
                                        }
                                      },
                                      icon: const Icon(
                                          Icons.keyboard_arrow_down)),
                                  IconButton(
                                      onPressed: () {
                                        _numAcomp += 1;
                                        _numberGuestsController.text =
                                            _numAcomp.toString();
                                      },
                                      icon: const Icon(Icons.keyboard_arrow_up))
                                ],
                              ),
                            ),
                          ),
                          500.0,
                          80.0)
                    ],
                  ),
                  Wrap(
                    children: <Widget>[
                      formItemsDesign(
                          Icons.phone,
                          TextFormField(
                            controller: telefonoCtrl,
                            //initialValue: invitado.telefono,
                            decoration: const InputDecoration(
                              labelText: 'Número de teléfono',
                            ),
                            validator: validateTelefono,
                          ),
                          500.0,
                          80.0),
                      formItemsDesign(
                          Icons.group,
                          Row(
                            children: <Widget>[
                              const Text('Grupo'),
                              const SizedBox(
                                width: 15,
                              ),
                              _listaGrupos(),
                            ],
                          ),
                          500.0,
                          80.0)
                    ],
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                ],
              )),
          ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpaned) {
                return const Center(
                    child: Text(
                  'Comentarios',
                  style: TextStyle(fontSize: 20.0),
                ));
              },
              canTapOnHeader: true,
              isExpanded: isExpanedT,
              body: Column(
                children: <Widget>[
                  Wrap(
                    children: <Widget>[
                      formItemsDesign(
                          null,
                          TextFormField(
                            controller: tipoAlimentacionCtrl,
                            keyboardType: TextInputType.multiline,
                            maxLines: 2,
                            //initialValue: invitado.email,
                            decoration: const InputDecoration(
                              labelText: 'Tipo de alimentación',
                            ),
                            //validator: validateEmail,
                          ),
                          500.0,
                          100.0),

                      formItemsDesign(
                          null,
                          TextFormField(
                            controller: alergiasCtrl,
                            keyboardType: TextInputType.multiline,
                            maxLines: 2,
                            //initialValue: invitado.email,
                            decoration: const InputDecoration(
                              labelText: 'Alergias',
                            ),
                            //validator: validateEmail,
                          ),
                          500.0,
                          100.0),
                      //SizedBox(height: 30.0,),
                    ],
                  ),
                  Wrap(
                    children: <Widget>[
                      formItemsDesign(
                          null,
                          TextFormField(
                            controller: asistenciaEspecialCtrl,
                            keyboardType: TextInputType.multiline,
                            maxLines: 2,
                            decoration: const InputDecoration(
                              labelText: 'Asistencia especial',
                            ),
                          ),
                          500.0,
                          100.0),
                    ],
                  ),
                  _base64qr != ''
                      ? formItemsDesign(
                          null,
                          Column(children: [
                            //Expanded(child: Text('Código QR')),
                            Expanded(
                                child: Image.memory(
                              base64Decode(_base64qr
                                  .substring(_base64qr.indexOf(',') + 1)),
                              width: 250.0,
                              height: 250.0,
                            )),
                          ]),
                          400.0,
                          200.0)
                      : const SizedBox.shrink(),
                  const SizedBox(
                    height: 30.0,
                  ),
                ],
              )),
          ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpaned) {
                return const Center(
                    child: Text(
                  'Acompañantes',
                  style: TextStyle(fontSize: 20.0),
                ));
              },
              canTapOnHeader: true,
              isExpanded: isExpaneA,
              body: Column(
                children: <Widget>[
                  Form(
                    key: _keyFormAcomp,
                    child: Wrap(
                      children: <Widget>[
                        formItemsDesign(
                            Icons.person,
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: TextFormField(
                                controller: nombreAcompananteCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Nombre completo',
                                ),
                                //initialValue: invitado.nombre,
                                validator: validateNombre,
                              ),
                            ),
                            500.0,
                            100.0),
                        formItemsDesign(
                            Icons.av_timer_rounded,
                            Row(children: <Widget>[
                              const Text('Edad'),
                              //SizedBox(width: 15,),
                              Expanded(
                                child: MaterialSegmentedControl(
                                  children: _children,
                                  selectionIndex: _mySelectionAEdad,
                                  borderColor: const Color(0xFF000000),
                                  selectedColor: const Color(0xFF000000),
                                  unselectedColor: Colors.white,
                                  borderRadius: 32.0,
                                  horizontalPadding: const EdgeInsets.all(8),
                                  onSegmentChosen: (index) {
                                    setState(() {
                                      _mySelectionAEdad = index;
                                    });
                                  },
                                ),
                              ),
                            ]),
                            500.0,
                            100.0),
                        formItemsDesign(
                            MyFlutterApp.transgender,
                            Row(children: <Widget>[
                              const Text('Género'),
                              //SizedBox(width: 15,),
                              Expanded(
                                child: MaterialSegmentedControl(
                                  children: _childrenGenero,
                                  selectionIndex: _mySelectionAGenero,
                                  borderColor: const Color(0xFF000000),
                                  selectedColor: const Color(0xFF000000),
                                  unselectedColor: Colors.white,
                                  borderRadius: 32.0,
                                  horizontalPadding: const EdgeInsets.all(8),
                                  onSegmentChosen: (index) {
                                    setState(() {
                                      _mySelectionAGenero = index;
                                    });
                                  },
                                ),
                              ),
                            ]),
                            500.0,
                            100.0),
                        formItemsDesign(
                            Icons.restaurant_menu_sharp,
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: TextFormField(
                                controller: alimentAcompContrl,
                                decoration: const InputDecoration(
                                    labelText: 'Tipo de alimentación'),
                              ),
                            ),
                            500.0,
                            100),
                        formItemsDesign(
                            Icons.sick_outlined,
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: TextFormField(
                                controller: alerAcompContrl,
                                decoration: const InputDecoration(
                                    labelText: 'Alergias'),
                              ),
                            ),
                            500.0,
                            100.0),
                        formItemsDesign(
                            Icons.wheelchair_pickup,
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: TextFormField(
                                inputFormatters: [
                                  FilteringTextInputFormatter
                                      .singleLineFormatter
                                ],
                                controller: asisEspAcompContrl,
                                decoration: const InputDecoration(
                                    labelText: 'Asistencia especial'),
                              ),
                            ),
                            500.0,
                            100.0)
                      ],
                    ),
                  ),
                  Ink(
                      padding: const EdgeInsets.all(5),
                      width: 100.0,
                      // height: 100.0,
                      decoration: const ShapeDecoration(
                        color: Colors.black,
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                          icon: const Icon(Icons.add),
                          color: Colors.white,
                          onPressed: () async {
//
//                                  if(_numAcomp > 0 && _numAcomp ){
                            String edad = '';
                            String genero = '';
                            if (_mySelectionAEdad == 0) {
                              edad = 'A';
                            } else {
                              edad = 'N';
                            }
                            if (_mySelectionAGenero == 0) {
                              genero = 'H';
                            } else {
                              genero = 'M';
                            }
//
                            Map<String, String> json = {
                              "id_invitado": idInvitado.toString(),
                              "nombre": nombreAcompananteCtrl.text,
                              "edad": edad,
                              "genero": genero,
                              "alimentacion": alimentAcompContrl.text,
                              "alergias": alerAcompContrl.text,
                              "asistenciaEspecial": asisEspAcompContrl.text
                            };

                            if (_keyFormAcomp.currentState.validate()) {
                              await api
                                  .agregarAcompanante(json, context)
                                  .then((value) => {
                                        alerAcompContrl.text = '',
                                        asisEspAcompContrl.text = '',
                                        alimentAcompContrl.text = '',
                                        nombreAcompananteCtrl.text = ''
                                      });
                              await blocInvitado.fetchAllAcompanante(
                                  idInvitado, context);
                            }
// }
                          })),
                  const SizedBox(
                    height: 30.0,
                  ),
                  _listaAcompanantes(),
                  const SizedBox(
                    height: 30.0,
                  )
                ],
              )),
        ],
      ),
      const SizedBox(
        height: 30.0,
      ),
      GestureDetector(
          onTap: () {
            save();
          },
          child: const CallToAction('Guardar'))
    ]);
  }

  String validateGrupo(String value) {
    String pattern = r"[a-zA-ZñÑáéíóúÁÉÍÓÚ\s]+";
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return "El grupo es necesario";
    } else if (!regExp.hasMatch(value)) {
      return "El grupo debe de ser a-z y A-Z";
    }
    return null;
  }

  String validateNombre(String value) {
    String pattern = r"[a-zA-ZñÑáéíóúÁÉÍÓÚ\s]+";
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return "El nombre es necesario";
    } else if (!regExp.hasMatch(value)) {
      return "El nombre debe de ser a-z y A-Z";
    }
    return null;
  }

  String validateTelefono(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = RegExp(patttern);
    if (value.isEmpty) {
      return "El telefono es necesario";
    } else if (value.length != 10) {
      return "El numero debe tener 10 digitos";
    } else if (!regExp.hasMatch(value)) {
      return "El numero debe ser de 0-9";
    }
    return null;
  }

  String validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return "El correo es necesario";
    } else if (!regExp.hasMatch(value)) {
      return "Correo invalido";
    } else {
      return null;
    }
  }

  save() async {
    //if (keyForm.currentState.validate()) {
    if (_currentSelectionGenero == 0) {
      gender = "H";
    } else if (_currentSelectionGenero == 1) {
      gender = "M";
    } else {
      gender = "";
    }
    if (_currentSelection == 0) {
      edad = "A";
    } else if (_currentSelection == 1) {
      edad = "N";
    } else {
      edad = "";
    }

    Map<String, String> json = {
      "id_invitado": idInvitado.toString(),
      "id_estatus_invitado": seleccionEstatus,
      "nombre": nombreCtrl.text,
      "edad": edad,
      "telefono": telefonoCtrl.text,
      "email": emailCtrl.text,
      "genero": gender,
      "id_grupo": _mySelectionG,
      "id_mesa": _mySelectionM,
      "alimentacion": tipoAlimentacionCtrl.text,
      "alergias": alergiasCtrl.text,
      "asistencia_especial": asistenciaEspecialCtrl.text
    };
    //json.
    bool response = await api.updateInvitado(json, context);

    if (response) {
      BlocProvider.of<InvitadosMesasBloc>(context)
          .add(MostrarInvitadosMesasEvent());
      Navigator.of(context).pop();
      MostrarAlerta(
          mensaje: 'Invitado actualizado.', tipoMensaje: TipoMensaje.correcto);
    } else {
      MostrarAlerta(
          mensaje: 'Error: No se pudo realizar la actualización.',
          tipoMensaje: TipoMensaje.correcto);
    }
  }

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  void initState() {
    _numberGuestsController.text = _numAcomp.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Editar invitado'),
          automaticallyImplyLeading: true,
          backgroundColor: hexToColor('#fdf4e5'),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            alignment: Alignment.center,
            //child: Expanded(
            child: Container(
              width: 1200,
              margin: const EdgeInsets.all(10.0),
              child: Form(
                key: keyForm,
                child: _datosInvitado(),
              ),
            ),
          ),
          //),
        ));
  }
}

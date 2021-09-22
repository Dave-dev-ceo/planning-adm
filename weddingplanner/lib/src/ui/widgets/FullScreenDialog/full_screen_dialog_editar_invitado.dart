import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weddingplanner/src/blocs/blocs.dart';
import 'package:weddingplanner/src/models/item_model-acompanante.dart';
import 'package:weddingplanner/src/models/item_model_estatus_invitado.dart';
import 'package:weddingplanner/src/models/item_model_grupos.dart';
import 'package:weddingplanner/src/models/item_model_invitado.dart';
import 'package:weddingplanner/src/models/item_model_mesas.dart';
import 'package:weddingplanner/src/resources/api_provider.dart';
import 'package:weddingplanner/src/resources/my_flutter_app_icons.dart';
import 'package:weddingplanner/src/ui/widgets/call_to_action/call_to_action.dart';
import 'package:material_segmented_control/material_segmented_control.dart';

class FullScreenDialogEdit extends StatefulWidget {
  final int idInvitado;

  const FullScreenDialogEdit({Key key, this.idInvitado}) : super(key: key);
  @override
  _FullScreenDialogEditState createState() =>
      _FullScreenDialogEditState(idInvitado);
}

class _FullScreenDialogEditState extends State<FullScreenDialogEdit> {
  ApiProvider api = new ApiProvider();
  final int idInvitado;
  int contActualiza = 0;
  int contActualizaEdad = 0;
  int contActualizaGenero = 0;
  int contActualizaGrupo = 0;
  int contActualizaData = 0;
  int contActualizaMesa = 0;
  bool isExpaned = true;
  bool isExpanedT = false;
  bool isExpaneA = false;
  GlobalKey<FormState> keyForm = new GlobalKey();
  GlobalKey<FormState> keyFormG = new GlobalKey();
  TextEditingController nombreCtrl = new TextEditingController();

  TextEditingController emailCtrl = new TextEditingController();

  TextEditingController grupo = new TextEditingController();

  TextEditingController telefonoCtrl = new TextEditingController();

  TextEditingController tipoAlimentacionCtrl = new TextEditingController();
  TextEditingController asistenciaEspecialCtrl = new TextEditingController();
  TextEditingController alergiasCtrl = new TextEditingController();

  String dropdownValue = 'Hombre';
  int _currentSelection;
  int _currentSelectionGenero;
  String _mySelection;
  String _mySelectionG = "1";
  String _mySelectionM = "0";
  bool _lights = false;

  String _base64qr;
  // Acompañante
  TextEditingController nombreAcompananteCtrl = new TextEditingController();
  int _mySelectionAEdad = 0;
  int _mySelectionAGenero = 0;

  _FullScreenDialogEditState(this.idInvitado);
  Map<int, Widget> _children = {
    0: Text(
      'Adulto',
      style: TextStyle(fontSize: 12),
    ),
    1: Text(
      'Niño',
      style: TextStyle(fontSize: 12),
    ),
  };
  Map<int, Widget> _childrenGenero = {
    0: Text(
      'Hombre',
      style: TextStyle(fontSize: 12),
    ),
    1: Text(
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
          //print(snapshot.data);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _listaAcompanantes() {
    blocInvitado.fetchAllAcompanante(idInvitado, context);
    return StreamBuilder(
      stream: blocInvitado.allAcompanante,
      builder: (context, AsyncSnapshot<ItemModelAcompanante> snapshot) {
        if (snapshot.hasData) {
          return Container(
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
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  List<Widget> _createListItemsAcomp(ItemModelAcompanante data) {
    // Creación de lista de Widget.
    List<Widget> listaAcompa = new List<Widget>();
    for (var opt in data.results) {
      final tempWidget = ListTile(
          title: Text(opt.nombre),
          subtitle: Text(opt.edad),
          trailing: Wrap(spacing: 12, children: <Widget>[
            IconButton(
                onPressed: () => showDialog<void>(
                    context: context,
                    builder: (BuildContext context) => _eliminarAcompanante()),
                icon: const Icon(Icons.delete)),
            IconButton(
                onPressed: () => showDialog<void>(
                    context: context,
                    builder: (BuildContext context) => _editarAcompanante()),
                icon: const Icon(Icons.edit))
          ]));
      listaAcompa.add(tempWidget);
    }
    return listaAcompa;
  }

  _eliminarAcompanante() {}
  _editarAcompanante() {}
  _listaGrupos() {
    ///bloc.dispose();
    blocGrupos.fetchAllGrupos(context);
    return StreamBuilder(
      stream: blocGrupos.allGrupos,
      builder: (context, AsyncSnapshot<ItemModelGrupos> snapshot) {
        if (snapshot.hasData) {
          //_mySelection = ((snapshot.data.results.length - 1).toString());
          //print(_mySelection);
          return _dropDownGrupos(snapshot.data);
          //print(snapshot.data);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  _listaMesas() {
    ///bloc.dispose();
    blocMesas.fetchAllMesas(context);
    return StreamBuilder(
      stream: blocMesas.allMesas,
      builder: (context, AsyncSnapshot<ItemModelMesas> snapshot) {
        if (snapshot.hasData) {
          //_mySelection = ((snapshot.data.results.length - 1).toString());
          //print(_mySelection);
          return _dropDownMesas(snapshot.data);
          //print(snapshot.data);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  _dropDownMesas(ItemModelMesas mesas) {
    return DropdownButton(
      value: _mySelectionM,
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
          _mySelectionM = newValue;
        });
      },
      items: mesas.results.map((item) {
        return DropdownMenuItem(
          value: item.idMesa.toString(),
          child: Text(
            item.mesa,
            style: TextStyle(fontSize: 18),
          ),
        );
      }).toList(),
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
        color: Color(0xFF000000),
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
            style: TextStyle(fontSize: 18),
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
          title: Text('Registar nuevo grupo', textAlign: TextAlign.center),
          content: SingleChildScrollView(
            child: Form(
              key: keyFormG,
              child: ListBody(
                children: <Widget>[
                  TextFormField(
                    controller: grupo,
                    decoration: new InputDecoration(
                      labelText: 'Grupo',
                    ),
                    validator: validateGrupo,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      _save(context);
                      //print('guardado');
                    },
                    child: CallToAction('Agregar'),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _msgSnackBar(String error, Color color) {
    final snackBar = SnackBar(
      content: Container(
        height: 30,
        child: Center(
          child: Text(error),
        ),
        //color: Colors.red,
      ),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _save(BuildContext context) async {
    if (keyFormG.currentState.validate()) {
      Map<String, String> json = {"nombre_grupo": grupo.text};
      //json.
      bool response = await api.createGrupo(json, context);
      if (response) {
        //_mySelection = "0";
        Navigator.of(context).pop();
        _msgSnackBar('Grupo agregado', Colors.green);
        _listaGrupos();
      } else {
        print('error');
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
          //_mySelection = ((snapshot.data.results.length - 1).toString());
          //print(_mySelection);
          return _dropDownEstatusInvitado(snapshot.data);
          //print(snapshot.data);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  _dropDownEstatusInvitado(ItemModelEstatusInvitado estatus) {
    return DropdownButton(
      value: _mySelection,
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
          _mySelection = newValue;
        });
      },
      items: estatus.results.map((item) {
        return DropdownMenuItem(
          value: item.idEstatusInvitado.toString(),
          child: Text(
            item.descripcion,
            style: TextStyle(fontSize: 18),
          ),
        );
      }).toList(),
    );
  }

  /*_dropDownGenero(){
    return DropdownButton(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_drop_down_outlined),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.pink),
      underline: Container(
        height: 2,
        color: Colors.pink,
      ),
      onChanged: (newValue) {
        setState(() {
            dropdownValue = newValue;
        });
      },
      items: <String>['Hombre', 'Mujer'].map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item, style: TextStyle(fontSize: 18),),
        );
      }).toList(),
    );
  }*/
  String gender;
  String edad;
  formItemsDesign(icon, item, large, ancho) {
    return Container(
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
    }
    return Column(children: <Widget>[
      SizedBox(
        width: 60,
      ),
      ExpansionPanelList(
        animationDuration: Duration(milliseconds: 1000),
        expansionCallback: (int index, bool expaned) {
          setState(() {
            if (index == 0) {
              isExpaned = !isExpaned;
            } else if (index == 1) {
              isExpanedT = !isExpanedT;
            } else if (index == 2) {
              isExpaneA = !isExpaneA;
            }
            //print(index);
          });
        },
        children: [
          ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpaned) {
                return Center(
                    child: Text(
                  'Información general',
                  style: TextStyle(fontSize: 20.0),
                ));
              },
              canTapOnHeader: true,
              isExpanded: isExpaned,
              body: Container(
                  child: Column(
                children: <Widget>[
                  Wrap(children: <Widget>[
                    formItemsDesign(
                        Icons.person,
                        TextFormField(
                          controller: nombreCtrl,
                          decoration: new InputDecoration(
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
                            Text('Asistencia'),
                            SizedBox(
                              width: 15,
                            ),

                            _listaEstatus(),
                            //_dropDownEstatusInvitado(),
                          ],
                        ),
                        500.0,
                        80.0)
                    //Container(width: 300,child: TextFormField(initialValue: nombre,decoration: InputDecoration(labelText: 'Nombre'))),
                  ]),
                  Wrap(
                    children: <Widget>[
                      formItemsDesign(
                          Icons.av_timer_rounded,
                          Row(children: <Widget>[
                            Text('Edad'),
                            //SizedBox(width: 15,),
                            Expanded(
                              child: MaterialSegmentedControl(
                                children: _children,
                                selectionIndex: _currentSelection,
                                borderColor: Color(0xFF000000),
                                selectedColor: Color(0xFF000000),
                                unselectedColor: Colors.white,
                                borderRadius: 32.0,
                                horizontalPadding: EdgeInsets.all(8),
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
                            Text('Genero'),
                            //SizedBox(width: 15,),
                            Expanded(
                              child: MaterialSegmentedControl(
                                children: _childrenGenero,
                                selectionIndex: _currentSelectionGenero,
                                borderColor: Color(0xFF000000),
                                selectedColor: Color(0xFF000000),
                                unselectedColor: Colors.white,
                                borderRadius: 32.0,
                                horizontalPadding: EdgeInsets.all(8),
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
                            decoration: new InputDecoration(
                              labelText: 'Correo',
                            ),
                            validator: validateEmail,
                          ),
                          500.0,
                          80.0),
                      formItemsDesign(
                          !invitado.estatusInvitacion
                              ? Icons.cancel
                              : Icons.check_box,
                          MergeSemantics(
                            child: ListTile(
                              title: Text(!invitado.estatusInvitacion
                                  ? 'Invitación pendiente'
                                  : 'Invitación enviada'),
                              trailing: CupertinoSwitch(
                                value: _lights, //invitado.estatusInvitacion,
                                onChanged: (bool value) {
                                  setState(() {
                                    _lights = value;
                                  });
                                },
                              ),
                              onTap: () {
                                setState(() {
                                  _lights = !_lights;
                                });
                              },
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
                            decoration: new InputDecoration(
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
                              Text('Grupo'),
                              SizedBox(
                                width: 15,
                              ),
                              _listaGrupos(),
                            ],
                          ),
                          500.0,
                          80.0)
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                ],
              ))),
          ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpaned) {
                return Center(
                    child: Text(
                  'Comentarios',
                  style: TextStyle(fontSize: 20.0),
                ));
              },
              canTapOnHeader: true,
              isExpanded: isExpanedT,
              body: Container(
                child: Column(
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
                              decoration: new InputDecoration(
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
                              decoration: new InputDecoration(
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
                              //initialValue: invitado.email,
                              decoration: new InputDecoration(
                                labelText: 'Asistencia especial',
                              ),
                              //validator: validateEmail,
                            ),
                            500.0,
                            100.0),
                        formItemsDesign(
                            Icons.tablet_rounded,
                            Row(
                              children: <Widget>[
                                Text('Mesa'),
                                SizedBox(
                                  width: 15,
                                ),
                                _listaMesas(),
                              ],
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
                                width: 250,
                                height: 250,
                              )),
                            ]),
                            400.0,
                            200.0)
                        : SizedBox.shrink(),
                    SizedBox(
                      height: 30.0,
                    ),
                  ],
                ),
              )),
          ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpaned) {
                return Center(
                    child: Text(
                  'Acompañantes',
                  style: TextStyle(fontSize: 20.0),
                ));
              },
              canTapOnHeader: true,
              isExpanded: isExpaneA,
              body: Container(
                child: Column(
                  children: <Widget>[
                    Wrap(
                      children: <Widget>[
                        formItemsDesign(
                            Icons.person,
                            TextFormField(
                              controller: nombreAcompananteCtrl,
                              decoration: new InputDecoration(
                                labelText: 'Nombre completo',
                              ),
                              //initialValue: invitado.nombre,
                              validator: validateNombre,
                            ),
                            500.0,
                            80.0),
                        formItemsDesign(
                            Icons.av_timer_rounded,
                            Row(children: <Widget>[
                              Text('Edad'),
                              //SizedBox(width: 15,),
                              Expanded(
                                child: MaterialSegmentedControl(
                                  children: _children,
                                  selectionIndex: _mySelectionAEdad,
                                  borderColor: Color(0xFF000000),
                                  selectedColor: Color(0xFF000000),
                                  unselectedColor: Colors.white,
                                  borderRadius: 32.0,
                                  horizontalPadding: EdgeInsets.all(8),
                                  onSegmentChosen: (index) {
                                    setState(() {
                                      _mySelectionAEdad = index;
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
                              Text('Genero'),
                              //SizedBox(width: 15,),
                              Expanded(
                                child: MaterialSegmentedControl(
                                  children: _childrenGenero,
                                  selectionIndex: _mySelectionAGenero,
                                  borderColor: Color(0xFF000000),
                                  selectedColor: Color(0xFF000000),
                                  unselectedColor: Colors.white,
                                  borderRadius: 32.0,
                                  horizontalPadding: EdgeInsets.all(8),
                                  onSegmentChosen: (index) {
                                    setState(() {
                                      _mySelectionAGenero = index;
                                    });
                                  },
                                ),
                              ),
                            ]),
                            500.0,
                            80.0),
                      ],
                    ),
                    Ink(
                        padding: EdgeInsets.all(5),
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
                              print('Vamos a agregar acom');
                              print(nombreAcompananteCtrl.text);
                              print(_mySelectionAEdad);
                              print(_mySelectionAGenero);
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

                              Map<String, String> json = {
                                "id_invitado": idInvitado.toString(),
                                "nombre": nombreAcompananteCtrl.text,
                                "edad": edad,
                                "genero": genero
                              };
                              await api.agregarAcompanante(json, context);
                              await blocInvitado.fetchAllAcompanante(
                                  idInvitado, context);
                            })),
                    SizedBox(
                      height: 30.0,
                    ),
                    _listaAcompanantes(),
                    SizedBox(
                      height: 30.0,
                    )
                  ],
                ),
              )),
        ],
      ),
      SizedBox(
        height: 30.0,
      ),
      GestureDetector(
          onTap: () {
            save();
          },
          child: CallToAction('Guardar'))
    ]);
  }

  _limpiarAcompanante() {}

  String validateGrupo(String value) {
    String pattern = r"[a-zA-ZñÑáéíóúÁÉÍÓÚ\s]+";
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "El grupo es necesario";
    } else if (!regExp.hasMatch(value)) {
      return "El grupo debe de ser a-z y A-Z";
    }
    return null;
  }

  String validateNombre(String value) {
    String pattern = r"[a-zA-ZñÑáéíóúÁÉÍÓÚ\s]+";
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "El nombre es necesario";
    } else if (!regExp.hasMatch(value)) {
      return "El nombre debe de ser a-z y A-Z";
    }
    return null;
  }

  String validateTelefono(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
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
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
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
      "id_estatus_invitado": _mySelection,
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
      Navigator.of(context).pop();

      final snackBar = SnackBar(
        content: Container(
          height: 30,
          child: Center(
            child: Text('Invitado actualizado'),
          ),
          //color: Colors.red,
        ),
        backgroundColor: Colors.green,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final snackBar = SnackBar(
        content: Container(
          height: 30,
          child: Center(
            child: Text('Error: No se pudo realizar la actualización'),
          ),
          //color: Colors.red,
        ),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    //}
  }

  @override
  void initState() {
    super.initState();
  }

  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Editar Invitado'),
          automaticallyImplyLeading: true,
          backgroundColor: hexToColor('#000000'),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            alignment: Alignment.center,
            //child: Expanded(
            child: new Container(
              width: 1200,
              margin: new EdgeInsets.all(10.0),
              child: new Form(
                key: keyForm,
                child: _datosInvitado(),
              ),
            ),
          ),
          //),
        ));
  }
}

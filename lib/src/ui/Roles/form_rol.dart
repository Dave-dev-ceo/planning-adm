// ignore_for_file: unused_field, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/blocs/roles/formRol/formRol_bloc.dart';
import 'package:planning/src/blocs/roles/rol/rol_bloc.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/models/model_form.dart';
import 'package:planning/src/models/model_roles.dart';

class FormRol extends StatefulWidget {
  final Map<String, dynamic> datos;
  const FormRol({Key key, this.datos}) : super(key: key);
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => FormRol(),
      );
  @override
  _FormRolState createState() => _FormRolState(this.datos);
}

class _FormRolState extends State<FormRol> {
  SharedPreferencesT _sharedPreferences = new SharedPreferencesT();
  final Map<String, dynamic> datos;

  GlobalKey<FormState> formKey = new GlobalKey();

  BuildContext _dialogContext;

  TextEditingController claveCtrl;
  TextEditingController nombreCtrl;

  Map<int, Widget> _estatus = {
    0: Text(
      'Activo',
      style: TextStyle(fontSize: 12),
    ),
    1: Text(
      'Inactivo',
      style: TextStyle(fontSize: 12),
    ),
  };

  int _estatusSeleccionado;

  ItemModelRol itemModelRol;
  RolBloc rolBloc;

  // vARIABLES FORMULARIO ROLES
  FormRolBloc rolFormBloc;

  ItemModelFormRol _formRoles;
  List<Itemr> _data;

  _FormRolState(this.datos);

  @override
  void initState() {
    rolBloc = BlocProvider.of<RolBloc>(context);
    rolFormBloc = BlocProvider.of<FormRolBloc>(context);
    if (datos['accion'] == 0) {
      rolFormBloc.add(GetFormRolEvent());
    } else if (datos['accion'] == 1) {
      rolFormBloc
          .add(GetFormRolEvent(idRol0: datos['data'].result.id_rol.toString()));
    }
    _setInitialController();
    setState(() {});
    super.initState();
    _data = [];
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Scaffold(
      body: SingleChildScrollView(
        child: BlocListener<RolBloc, RolState>(
          listener: (context, state) {
            // Alta de usuario
            if (state is LoadingCrearRolState) {
              _dialogSpinner('');
            } else if (state is RolCreadoState) {
              _formRoles = null;
              Navigator.pop(_dialogContext);
              Navigator.pop(context, state.data);
            } else if (state is ErrorCrearRolState) {
              Navigator.pop(_dialogContext);
              _dialogMSG(
                  'Error al ${datos['accion'] == 0 ? 'crear' : 'editar'} rol: ',
                  state.message,
                  'msg');
            }
            // Edicion de usuario
            else if (state is LoadingEditarRolState) {
              _dialogSpinner('');
            } else if (state is RolEditadoState) {
              Navigator.pop(_dialogContext);
              Navigator.pop(context, state.data);
            } else if (state is ErrorEditarRolState) {
              Navigator.pop(_dialogContext);
              _dialogMSG(
                  'Error al ${datos['accion'] == 0 ? 'crear' : 'editar'} rol: ',
                  state.message,
                  'msg');
            }
            //ERROR DE TOKEN
            else if (state is ErrorTokenRolState) {
              Navigator.pop(_dialogContext);
              return _showDialogMsg(context);
            }
          },
          child: Container(
            width: double.infinity,
            alignment: Alignment.center,
            //child: Expanded(
            child: new Container(
              width: 800,
              margin: new EdgeInsets.all(10.0),
              child: new Form(
                key: formKey,
                child: formUI(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _setInitialController() {
    claveCtrl = new TextEditingController(
        text: datos['accion'] == 1 ? datos['data'].result.clave_rol : '');
    nombreCtrl = new TextEditingController(
        text: datos['accion'] == 1 ? datos['data'].result.nombre_rol : '');

    _estatusSeleccionado = datos['accion'] == 1
        ? datos['data'].result.estatus == 'A'
            ? 0
            : 1
        : _estatusSeleccionado;
  }

  agregarInput(
      IconData icono,
      TextInputType inputType,
      TextEditingController controller,
      String titulo,
      Function validator,
      List<TextInputFormatter> inputF,
      bool isEnabled,
      {bool obscureT: false,
      int maxL: 0}) {
    return formItemsDesign(
        icono,
        TextFormField(
          enabled: isEnabled,
          keyboardType: inputType,
          controller: controller,
          decoration: new InputDecoration(
            labelText: titulo,
          ),
          validator: validator,
          inputFormatters: inputF,
          obscureText: obscureT,
          maxLength: maxL,
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ));
  }

  Widget formUI(BuildContext contextForm) {
    return Column(
      children: <Widget>[
        agregarInput(Icons.tag, TextInputType.name, claveCtrl, 'Clave de rol',
            validateClave, null, datos['accion'] == 0,
            maxL: 15),
        agregarInput(Icons.phone, TextInputType.name, nombreCtrl,
            'Nombre de rol', validateNombre, null, true,
            maxL: 75),
        // datos['accion'] == 1
        //     ? formItemsDesign(
        //         Icons.bar_chart,
        //         Row(
        //           children: [
        //             Expanded(child: Text('Estatus')),
        //             Expanded(
        //               child: MaterialSegmentedControl(
        //                 children: _estatus,
        //                 selectionIndex: _estatusSeleccionado,
        //                 borderColor: Color(0xFF000000),
        //                 selectedColor: Color(0xFF000000),
        //                 unselectedColor: Colors.white,
        //                 borderRadius: 32.0,
        //                 horizontalPadding: EdgeInsets.all(8),
        //                 onSegmentChosen: (index) {
        //                   setState(() {
        //                     _estatusSeleccionado = index;
        //                   });
        //                 },
        //               ),
        //             ),
        //           ],
        //         ))
        //     : SizedBox.shrink(),
        _formPermisos(),
        SizedBox(
          height: 20.0,
        ),
        ElevatedButton(
          onPressed: () {
            _save(contextForm);
          },
          child: Text((datos['accion'] == 0 ? 'Crear' : 'Editar') + ' rol',
              style: TextStyle(fontSize: 18, color: Colors.black)),
          style: ElevatedButton.styleFrom(
            primary: hexToColor('#fdf4e5'), // background
            onPrimary: Colors.white, // foreground
            padding: EdgeInsets.symmetric(horizontal: 68, vertical: 25),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            elevation: 8.0,
          ),
        ),
      ],
    );
  }

  formItemsDesign(icon, item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7),
      child: Card(child: ListTile(leading: Icon(icon), title: item)),
    );
  }

  _save(BuildContext contextSB) {
    try {
      List<SeccionRol> _dataTemp = [];
      _data.forEach((element) {
        List _pantallasSeccion = [];
        if (element.pantallas.length > 0) {
          element.pantallas.forEach((elementPantallas) {
            _pantallasSeccion.add({
              'id_pantalla': elementPantallas.id_pantalla,
              'clave_pantalla': elementPantallas.clave_pantalla,
              'nombre_pantalla': elementPantallas.nombre_pantalla,
              'selected': elementPantallas.seleccion
            });
          });
        }
        Map<String, dynamic> jsonRol = {
          'id_seccion': element.id_seccion,
          'clave_seccion': element.clave_seccion,
          'nombre_seccion': element.nombre_seccion,
          'selected': element.selected,
          'pantallas': _pantallasSeccion
        };
        _dataTemp.add(SeccionRol(jsonRol));
      });
      ItemModelFormRol _formRolesTemp = new ItemModelFormRol(_dataTemp);
      if (formKey.currentState.validate()) {
        if (datos['accion'] == 0) {
          Map<String, dynamic> jsonRol = {
            '"clave_rol"': '"${claveCtrl.text}"',
            '"nombre_rol"': '"${claveCtrl.text}"',
            '"permisos"': _formRolesTemp.toJsonStr()
          };
          rolBloc.add(CrearRolEvent(jsonRol));
        } else {
          Map<String, dynamic> jsonRol = {
            '"id_rol"': datos['data'].result.id_rol,
            '"clave_rol"': '"${claveCtrl.text}"',
            '"nombre_rol"': '"${claveCtrl.text}"',
            '"permisos"': _formRolesTemp.toJsonStr()
          };
          rolBloc.add(EditarRolEvent(jsonRol));
        }
      } else {
        ScaffoldMessenger.of(contextSB).showSnackBar(SnackBar(
            content: Text(
                'Ingrese todos los datos requeridos para ${datos['accion'] == 0 ? 'agregar' : 'editar'} rol')));
      }
    } catch (e) {
      print(e);
    }
  }

  _dialogMSG(String title, String msg, String type) {
    Widget child;
    if (type == "msg") {
      child = Text(msg);
    } else if (type == "loading") {
      child = Center(child: CircularProgressIndicator());
    }
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(
                title,
                textAlign: TextAlign.center,
              ),
              content: child,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              actions: type != "log"
                  ? <Widget>[
                      TextButton(
                        child: Text('Cerrar'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ]
                  : null);
        });
  }

  _dialogSpinner(String title) {
    Widget child = CircularProgressIndicator();
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          _dialogContext = context;
          return AlertDialog(
            title: Text(
              title,
              textAlign: TextAlign.center,
            ),
            content: child,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
          );
        });
  }

  String validateNombre(String value) {
    String pattern = r"[a-zA-ZñÑáéíóúÁÉÍÓÚ\s]+";
    RegExp regExp = new RegExp(pattern);
    if (value.length < 5) {
      return "El nombre debe tener al menos 5 caracteres";
    } else if (!regExp.hasMatch(value)) {
      return "El nombre debe de ser a-z y A-Z";
    }
    return null;
  }

  String validateClave(String value) {
    String pattern = r"[a-zA-ZñÑáéíóúÁÉÍÓÚ\s]+";
    RegExp regExp = new RegExp(pattern);
    if (value.length < 5) {
      return "La clave debe tener al menos 5 caracteres";
    } else if (!regExp.hasMatch(value)) {
      return "La clave debe de ser a-z y A-Z";
    }
    return null;
  }

  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  _formPermisos() {
    List<Widget> dataForm = <Widget>[Text('Permisos del rol:')];
    return BlocBuilder<FormRolBloc, FormRolState>(
      builder: (context, state) {
        if (state is FormRolInitial) {
          return Center(child: CircularProgressIndicator());
        } else if (state is ErrorTokenFormRolState) {
          return _showDialogMsg(context);
        } else if (state is LoadingMostrarFormRol) {
          return Center(child: CircularProgressIndicator());
        } else if (state is MostrarFormRol) {
          _formRoles = null;
          _formRoles = state.form;
          if (state.form != null && _data.length == 0) {
            state.form.form.forEach((element) {});
            _data = _generateItems(state.form);
          }

          //if (_formRoles == null) {
          //_formRoles = state.form;
          // if (_formRoles.form != null) {
          // for (var seccion in _formRoles.form) {
          //   List<Widget> pantallas = <Widget>[];
          //   if (seccion.pantallas != null) {
          //     for (var pantalla in seccion.pantallas) {
          //       pantallas.add(CheckboxListTile(
          //         title: Text(pantalla.nombre_pantalla),
          //         value: pantalla.selected,
          //         onChanged: (bool value) {
          //           setState(() {
          //             pantalla.selected = value;
          //           });
          //         },
          //         secondary: Icon(Icons.preview),
          //       ));
          //     }
          //   }
          //   dataForm.add(
          //     formItemsDesign(
          //       Icons.view_module,
          //       Center(
          //         child: Column(
          //           children: [
          //             CheckboxListTile(
          //                 title: Text(seccion.nombre_seccion),
          //                 value: seccion.selected,
          //                 onChanged: (bool value) {
          //                   setState(() {
          //                     seccion.selected = value;
          //                   });
          //                 }),
          //             Column(
          //                 children: pantallas.length > 0
          //                     ? pantallas
          //                     : [SizedBox.shrink()])
          //           ],
          //         ),
          //       ),
          //     ),
          //   );
          // }
          // return Text('data');
          if (_data.length > 0) {
            return _listaBuild();
          } else {
            return Center(
              child: Text('No hay datos.'),
            );
          }
          //} else {
          //return Text('Error al obtener Form');
          //}
          // } else {
          // if (_formRoles.form != null) {
          //   for (var seccion in _formRoles.form) {
          //     List<Widget> pantallas = <Widget>[];
          //     if (seccion.pantallas != null) {
          //       for (var pantalla in seccion.pantallas) {
          //         pantallas.add(CheckboxListTile(
          //           title: Text(pantalla.nombre_pantalla),
          //           value: pantalla.selected,
          //           onChanged: (bool value) {
          //             setState(() {
          //               pantalla.selected = value;
          //             });
          //           },
          //           secondary: Icon(Icons.preview),
          //         ));
          //       }
          //     }
          //     dataForm.add(
          //       formItemsDesign(
          //         Icons.view_module,
          //         Center(
          //           child: Column(
          //             children: [
          //               CheckboxListTile(
          //                   title: Text(seccion.nombre_seccion),
          //                   value: seccion.selected,
          //                   onChanged: (bool value) {
          //                     setState(() {
          //                       seccion.selected = value;
          //                     });
          //                   }),
          //               Column(
          //                   children: pantallas.length > 0
          //                       ? pantallas
          //                       : [SizedBox.shrink()])
          //             ],
          //           ),
          //         ),
          //       ),
          //     );
          //   }
          //   return SingleChildScrollView(
          //     child:
          //         formItemsDesign(Icons.settings, Column(children: dataForm)),
          //   );
          // } else {
          //   return Text('Error al obtener Form');
          // }
          // return Text('Entro al else');
          // }
        } else if (state is ErrorMostrarFormRol) {
          return Center(
            child: Text(state.message),
          );
        } else {
          return Center(child: Text('Sin permisos'));
        }
      },
    );
  }

  Widget _listaBuild() {
    int position = 0;
    return Container(
        child: ExpansionPanelList(
      animationDuration: Duration(milliseconds: 500),
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = !isExpanded;
          position = index;
        });
      },
      children: _data.map<ExpansionPanel>((Itemr item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              leading: Icon(Icons.view_module),
              title: Text(item.nombre_seccion),
              trailing: Wrap(spacing: 12, children: <Widget>[
                Checkbox(
                    value: item.selected,
                    onChanged: (value) {
                      setState(() {
                        item.selected = value;
                        if (item.selected) {
                          item.pantallas.forEach((element) {
                            element.seleccion = true;
                          });
                        } else {
                          item.pantallas.forEach((element) {
                            element.seleccion = false;
                          });
                        }
                      });
                    })
              ]),
            );
          },
          body: Column(children: _listPantallas(item.pantallas, item.posicion)),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    ));
  }

  List<Widget> _listPantallas(
      List<ItemPantalla> itemPantalla, int positionHeader) {
    List<Widget> lista = [
      Form(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: itemPantalla.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Icon(Icons.preview),
                  trailing: Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Checkbox(
                        value: itemPantalla[index].seleccion,
                        onChanged: (value) {
                          setState(() {
                            itemPantalla[index].seleccion = value;

                            if (itemPantalla[index].seleccion) {
                              _data[positionHeader].selected = true;
                            } else if (!itemPantalla[index].seleccion) {
                              var boolPosition = false;
                              itemPantalla.forEach((element) {
                                if (element.seleccion) {
                                  boolPosition = true;
                                }
                              });
                              _data[positionHeader].selected = boolPosition;
                            }
                          });
                        }),
                  ),
                  title: Text(itemPantalla[index].nombre_pantalla),
                );
              }),
        ),
      )
    ];
    // if (itemPantalla != null) {
    //   for (var opt in itemPantalla) {
    //     final tempWidget = ListTile(
    //       title: Text(opt.nombre_pantalla),
    //       leading: Checkbox(
    //           value: opt.seleccion,
    //           onChanged: (value) {
    //             setState(() {
    //               opt.seleccion = value;
    //             });
    //           }),
    //       trailing: Wrap(spacing: 12, children: <Widget>[
    //         Checkbox(
    //             value: opt.seleccion,
    //             onChanged: (value) {
    //               setState(() {
    //                 opt.seleccion = value;
    //               });
    //             })
    //       ]),
    //     );
    //     lista.add(tempWidget);
    //   }
    // }
    return lista;
  }

  _showDialogMsg(BuildContext contextT) {
    _dialogContext = contextT;
    return AlertDialog(
      title: Text(
        "Sesión",
        textAlign: TextAlign.center,
      ),
      content:
          Text('Lo sentimos; la sesión a caducado. Inicie sesión de nuevo.'),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      actions: <Widget>[
        TextButton(
          child: Text('Cerrar'),
          onPressed: () async {
            await _sharedPreferences.clear();
            Navigator.of(contextT)
                .pushNamedAndRemoveUntil('/', (route) => false);
          },
        ),
      ],
    );
  }

  _generateItems(ItemModelFormRol data) {
    List<Itemr> _dataTemp = [];
    int posicionTemp = 0;
    data.form.forEach((element) {
      List<ItemPantalla> _pantallaTemp = [];
      if (element.pantallas != null) {
        element.pantallas.forEach((elementPant) {
          _pantallaTemp.add(ItemPantalla(
              clave_pantalla: elementPant.clave_pantalla,
              id_pantalla: elementPant.id_pantalla,
              nombre_pantalla: elementPant.nombre_pantalla,
              seleccion: elementPant.selected));
        });
      }
      _dataTemp.add(Itemr(
          clave_seccion: element.clave_seccion,
          id_seccion: element.id_seccion.toString(),
          nombre_seccion: element.nombre_seccion,
          selected: element.selected,
          isExpanded: true,
          pantallas: _pantallaTemp,
          posicion: posicionTemp));
      posicionTemp++;
    });
    return _dataTemp;
  }
}

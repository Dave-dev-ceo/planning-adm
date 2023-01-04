// ignore_for_file: unused_field, unused_local_variable, unnecessary_this, no_logic_in_create_state

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/blocs/roles/formRol/form_rol_bloc.dart';
import 'package:planning/src/blocs/roles/rol/rol_bloc.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/models/model_form.dart';
import 'package:planning/src/models/model_roles.dart';
import 'package:planning/src/ui/widgets/snackbar_widget/snackbar_widget.dart';

class FormRol extends StatefulWidget {
  final Map<String, dynamic> datos;
  const FormRol({Key key, this.datos}) : super(key: key);
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => const FormRol(),
      );
  @override
  _FormRolState createState() => _FormRolState(this.datos);
}

class _FormRolState extends State<FormRol> {
  final SharedPreferencesT _sharedPreferences = SharedPreferencesT();
  final Map<String, dynamic> datos;

  GlobalKey<FormState> formKey = GlobalKey();

  BuildContext _dialogContext;

  TextEditingController claveCtrl;
  TextEditingController nombreCtrl;

  final Map<int, Widget> _estatus = {
    0: const Text(
      'Activo',
      style: TextStyle(fontSize: 12),
    ),
    1: const Text(
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

  int contador = 0;

  @override
  void initState() {
    rolBloc = BlocProvider.of<RolBloc>(context);
    rolFormBloc = BlocProvider.of<FormRolBloc>(context);
    if (datos['accion'] == 0) {
      rolFormBloc.add(GetFormRolEvent());
    } else if (datos['accion'] == 1) {
      ItemModelRol rol = datos['data'];
      rolFormBloc.add(GetFormRolEvent(idRol0: rol.result.idRol));
    }
    _setInitialController();
    _data = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: BlocListener<RolBloc, RolState>(
          // ignore: void_checks
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
            } else {}
          },
          child: Container(
            width: double.infinity,
            alignment: Alignment.center,
            //child: Expanded(
            child: Container(
              width: 800,
              margin: const EdgeInsets.all(10.0),
              child: Form(
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
    claveCtrl = TextEditingController(
        text: datos['accion'] == 1 ? datos['data'].result.claveRol : '');
    nombreCtrl = TextEditingController(
        text: datos['accion'] == 1 ? datos['data'].result.nombreRol : '');

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
      {bool obscureT = false,
      int maxL = 0}) {
    return formItemsDesign(
        icono,
        TextFormField(
          enabled: isEnabled,
          keyboardType: inputType,
          controller: controller,
          decoration: InputDecoration(
            labelText: titulo,
          ),
          validator: validator,
          inputFormatters: inputF,
          obscureText: obscureT,
          maxLength: maxL,
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
        _formPermisos(),
        const SizedBox(
          height: 20.0,
        ),
        ElevatedButton(
          onPressed: () {
            _save(contextForm);
          },
          child: Text((datos['accion'] == 0 ? 'Crear' : 'Editar') + ' rol',
              style: const TextStyle(fontSize: 18, color: Colors.black)),
          style: ElevatedButton.styleFrom(
            backgroundColor: hexToColor('#fdf4e5'), // background
            foregroundColor: Colors.white, // foreground
            padding: const EdgeInsets.symmetric(horizontal: 68, vertical: 25),
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
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Card(child: ListTile(leading: Icon(icon), title: item)),
    );
  }

  _save(BuildContext contextSB) {
    try {
      List<SeccionRol> _dataTemp = [];
      for (var element in _data) {
        List _pantallasSeccion = [];
        if (element.pantallas.isNotEmpty) {
          for (var elementPantallas in element.pantallas) {
            _pantallasSeccion.add({
              'id_pantalla': elementPantallas.idPantalla,
              'clave_pantalla': elementPantallas.clavePantalla,
              'nombre_pantalla': elementPantallas.nombrePantalla,
              'selected': elementPantallas.seleccion
            });
          }
        }
        Map<String, dynamic> jsonRol = {
          'id_seccion': element.idSeccion,
          'clave_seccion': element.claveSeccion,
          'nombre_seccion': element.nombreSeccion,
          'selected': element.selected,
          'pantallas': _pantallasSeccion
        };
        _dataTemp.add(SeccionRol(jsonRol));
      }
      ItemModelFormRol _formRolesTemp = ItemModelFormRol(_dataTemp);
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
            '"id_rol"': datos['data'].result.idRol,
            '"clave_rol"': '"${claveCtrl.text}"',
            '"nombre_rol"': '"${claveCtrl.text}"',
            '"permisos"': _formRolesTemp.toJsonStr()
          };
          rolBloc.add(EditarRolEvent(jsonRol));
        }
      } else {
        MostrarAlerta(
            mensaje:
                'Ingrese todos los datos requeridos para ${datos['accion'] == 0 ? 'agregar' : 'editar'} rol',
            tipoMensaje: TipoMensaje.advertencia);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  _dialogMSG(String title, String msg, String type) {
    Widget child;
    if (type == "msg") {
      child = Text(msg);
    } else if (type == "loading") {
      child = const Center(child: LoadingCustom());
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
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              actions: type != "log"
                  ? <Widget>[
                      TextButton(
                        child: const Text('Cerrar'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ]
                  : null);
        });
  }

  _dialogSpinner(String title) {
    Widget child = const LoadingCustom();
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
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
          );
        });
  }

  String validateNombre(String value) {
    String pattern = r"[a-zA-ZñÑáéíóúÁÉÍÓÚ\s]+";
    RegExp regExp = RegExp(pattern);
    if (value == null || value == '') {
      return "El campo es requerido";
    }
    return null;
  }

  String validateClave(String value) {
    String pattern = r"[a-zA-ZñÑáéíóúÁÉÍÓÚ\s]+";
    RegExp regExp = RegExp(pattern);
    if (value == null || value == '') {
      return "El campo es requerido";
    }
    return null;
  }

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  _formPermisos() {
    List<Widget> dataForm = <Widget>[const Text('Permisos del rol:')];
    return BlocBuilder<FormRolBloc, FormRolState>(
      builder: (context, state) {
        if (state is FormRolInitial) {
          return const Center(child: LoadingCustom());
        } else if (state is ErrorTokenFormRolState) {
          return _showDialogMsg(context);
        } else if (state is LoadingMostrarFormRol) {
          _formRoles = null;
          return const Center(child: LoadingCustom());
        } else if (state is MostrarFormRol) {
          if (_formRoles == null && contador <= 1) {
            _formRoles = state.form;
            _data = _generateItems(_formRoles);
            contador++;
          }

          if (_data.isNotEmpty) {
            return _listaBuild();
          } else {
            return const Center(
              child: Text('No hay datos'),
            );
          }
        } else if (state is ErrorMostrarFormRol) {
          return Center(
            child: Text(state.message),
          );
        } else {
          return const Center(child: Text('Sin permisos'));
        }
      },
    );
  }

  Widget _listaBuild() {
    int position = 0;
    return ExpansionPanelList(
      animationDuration: const Duration(milliseconds: 500),
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
              leading: const Icon(Icons.view_module),
              title: Text(item.nombreSeccion),
              trailing: Wrap(spacing: 12, children: <Widget>[
                Checkbox(
                    value: item.selected,
                    onChanged: (value) {
                      setState(() {
                        item.selected = value;
                        if (item.selected) {
                          for (var element in item.pantallas) {
                            element.seleccion = true;
                          }
                        } else {
                          for (var element in item.pantallas) {
                            element.seleccion = false;
                          }
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
    );
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
                  leading: const Icon(Icons.preview),
                  trailing: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Checkbox(
                        value: itemPantalla[index].seleccion,
                        onChanged: (value) {
                          setState(() {
                            itemPantalla[index].seleccion = value;
                            if (itemPantalla[index].seleccion) {
                              _data[positionHeader].selected = true;
                            } else if (!itemPantalla[index].seleccion) {
                              var boolPosition = false;
                              for (var element in itemPantalla) {
                                if (element.seleccion) {
                                  boolPosition = true;
                                }
                              }
                              _data[positionHeader].selected = boolPosition;
                            }
                          });
                        }),
                  ),
                  title: Text(itemPantalla[index].nombrePantalla),
                );
              }),
        ),
      )
    ];
    return lista;
  }

  _showDialogMsg(BuildContext contextT) {
    _dialogContext = contextT;
    return AlertDialog(
      title: const Text(
        "Sesión",
        textAlign: TextAlign.center,
      ),
      content: const Text(
          'Lo sentimos, la sesión ha caducado. Inicie sesión de nuevo.'),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      actions: <Widget>[
        TextButton(
          child: const Text('Cerrar'),
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
    for (var element in data.form) {
      List<ItemPantalla> _pantallaTemp = [];
      if (element.pantallas != null) {
        for (var elementPant in element.pantallas) {
          _pantallaTemp.add(ItemPantalla(
            clavePantalla: elementPant.clavePantalla,
            idPantalla: elementPant.idPantalla,
            nombrePantalla: elementPant.nombrePantalla,
            seleccion: elementPant.selected,
          ));
        }
      }
      _dataTemp.add(Itemr(
          claveSeccion: element.claveSeccion,
          idSeccion: element.idSeccion.toString(),
          nombreSeccion: element.nombreSeccion,
          selected: element.selected,
          isExpanded: true,
          pantallas: _pantallaTemp,
          posicion: posicionTemp));
      posicionTemp++;
    }
    return _dataTemp;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:planning/src/blocs/roles/roles_bloc.dart';
import 'package:planning/src/blocs/usuarios/usuario/usuario_bloc.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/models/item_model_usuarios.dart';
import 'package:planning/src/models/model_roles.dart';

class FormUsuario extends StatefulWidget {
  final Map<String, dynamic> datos;
  const FormUsuario({Key key, this.datos}) : super(key: key);
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => FormUsuario(),
      );
  @override
  _FormUsuarioState createState() => _FormUsuarioState(this.datos);
}

class _FormUsuarioState extends State<FormUsuario> {
  SharedPreferencesT _sharedPreferences = new SharedPreferencesT();
  final Map<String, dynamic> datos;
  RolesBloc rolesBloc;

  ItemModelRoles _roles;
  GlobalKey<FormState> formKey = new GlobalKey();

  BuildContext _dialogContext;

  TextEditingController nombreCtrl;
  TextEditingController correoCtrl;
  TextEditingController telefonoCtrl;
  TextEditingController pwdCtrl;
  TextEditingController confirmPwdCtrl;
  bool esAdmin;

  bool valid = false;

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

  ItemModelUsuario itemModelUsuario;
  UsuarioBloc usuarioBloc;

  _FormUsuarioState(this.datos);

  int _mySelectionG = 0;
  int _rolSelect = 0;

  @override
  void initState() {
    usuarioBloc = BlocProvider.of<UsuarioBloc>(context);
    rolesBloc = BlocProvider.of<RolesBloc>(context);
    rolesBloc.add(ObtenerRolesEvent());
    _setInitialController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(datos);
    return SingleChildScrollView(
      child: BlocListener<UsuarioBloc, UsuarioState>(
        listener: (context, state) {
          // Alta de usuario
          if (state is LoadingCrearUsuarioState) {
            _dialogSpinner('');
          } else if (state is UsuarioCreadoState) {
            Navigator.pop(_dialogContext);
            Navigator.pop(context, state.data);
          } else if (state is ErrorCrearUsuarioState) {
            Navigator.pop(_dialogContext);
            _dialogMSG(
                'Error al ${datos['accion'] == 0 ? 'crear' : 'editar'} usuario: ',
                state.message,
                'msg');
          }
          // Edicion de usuario
          else if (state is LoadingEditarUsuarioState) {
            _dialogSpinner('');
          } else if (state is UsuarioEditadoState) {
            Navigator.pop(_dialogContext);
            Navigator.pop(context, state.data);
          } else if (state is ErrorEditarUsuarioState) {
            Navigator.pop(_dialogContext);
            _dialogMSG(
                'Error al ${datos['accion'] == 0 ? 'crear' : 'editar'} usuario: ',
                state.message,
                'msg');
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
    );
  }

  _setInitialController() {
    nombreCtrl = new TextEditingController(
        text: datos['accion'] == 1 ? datos['data'].result.nombre_completo : '');
    correoCtrl = new TextEditingController(
        text: datos['accion'] == 1 ? datos['data'].result.correo : '');
    telefonoCtrl = new TextEditingController(
        text: datos['accion'] == 1
            ? datos['data'].result.telefono.toString()
            : '');
    pwdCtrl = new TextEditingController();
    confirmPwdCtrl = new TextEditingController();
    _estatusSeleccionado = datos['accion'] == 1
        ? datos['data'].result.estatus == 'A'
            ? 0
            : 1
        : _estatusSeleccionado;
    esAdmin = datos['accion'] == 1 ? datos['data'].result.admin : false;
  }

  agregarInput(
      IconData icono,
      TextInputType inputType,
      TextEditingController controller,
      String titulo,
      Function validator,
      List<TextInputFormatter> inputF,
      {bool obscureT: false,
      int maxL: 0}) {
    return formItemsDesign(
        icono,
        TextFormField(
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
        agregarInput(Icons.person, TextInputType.name, nombreCtrl,
            'Nombre completo', validateNombre, null,
            maxL: 150),
        agregarInput(Icons.email, TextInputType.emailAddress, correoCtrl,
            'Correo', validateCorreo, null,
            maxL: 100),
        agregarInput(Icons.phone, TextInputType.emailAddress, telefonoCtrl,
            'Teléfono', validateTelefono, null,
            // <TextInputFormatter>[FilteringTextInputFormatter.allow(new RegExp(r'^(?:[+0][1-9])?[0-9]{10,12}$'))]
            maxL: 13),
        datos['accion'] == 0
            ? agregarInput(Icons.lock, TextInputType.visiblePassword, pwdCtrl,
                'Contraseña', validatePwd, null,
                obscureT: true, maxL: 30)
            : SizedBox.shrink(),
        datos['accion'] == 0
            ? agregarInput(
                Icons.lock,
                TextInputType.visiblePassword,
                confirmPwdCtrl,
                'Confirmar Contraseña',
                validateConfirmPwd,
                null,
                obscureT: true,
                maxL: 30)
            : SizedBox.shrink(),
        datos['accion'] == 1
            ? formItemsDesign(
                Icons.bar_chart,
                Row(
                  children: [
                    Expanded(child: Text('Estatus')),
                    Expanded(
                      child: MaterialSegmentedControl(
                        children: _estatus,
                        selectionIndex: _estatusSeleccionado,
                        borderColor: Color(0xFF000000),
                        selectedColor: Color(0xFF000000),
                        unselectedColor: Colors.white,
                        borderRadius: 32.0,
                        horizontalPadding: EdgeInsets.all(8),
                        onSegmentChosen: (index) {
                          setState(() {
                            _estatusSeleccionado = index;
                          });
                        },
                      ),
                    ),
                  ],
                ))
            : SizedBox.shrink(),
        formItemsDesign(
            Icons.group,
            Row(
              children: <Widget>[
                Text('Rol a Asignar'),
                SizedBox(
                  width: 15,
                ),
                _listaRoles(),
              ],
            )),
        ElevatedButton(
          onPressed: () {
            _save(contextForm);
          },
          child: Text(datos['accion'] == 0 ? 'Crear Usuario' : 'Editar Usuario',
              style: TextStyle(fontSize: 18, color: Colors.white)),
          style: ElevatedButton.styleFrom(
            primary: hexToColor('#000000'), // background
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
    if (formKey.currentState.validate()) {
      if (_mySelectionG != 0) {
        if (datos['accion'] == 0) {
          Map<String, dynamic> jsonUsuario = {
            'nombre_completo': nombreCtrl.text,
            'correo': correoCtrl.text,
            'telefono': telefonoCtrl.text,
            'pwd': pwdCtrl.text,
            'admin': true,
            'id_rol': _mySelectionG,
          };
          usuarioBloc.add(CrearUsuarioEvent(jsonUsuario));
        } else {
          Map<String, dynamic> jsonUsuario = {
            'id_usuario': datos['data'].result.id_usuario,
            'nombre_completo': nombreCtrl.text,
            'correo': correoCtrl.text,
            'telefono': telefonoCtrl.text,
            'estatus': _estatusSeleccionado == 0 ? 'A' : 'I',
            'id_rol': _mySelectionG,
          };
          usuarioBloc.add(EditarUsuarioEvent(jsonUsuario));
        }
      } else {
        ScaffoldMessenger.of(contextSB).showSnackBar(SnackBar(
            content: Text(
                'Seleccione un rol para poder ${datos['accion'] == 0 ? 'agregar' : 'editar'} usuario')));
      }
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
      return "El nombre es necesario";
    } else if (!regExp.hasMatch(value)) {
      return "El nombre debe de ser a-z y A-Z";
    }
    return null;
  }

  String validateCorreo(String value) {
    RegExp regExp = new RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if (value.length == 0) {
      return 'Dato requerido';
    } else if (!regExp.hasMatch(value)) {
      return 'Formato de correo inválido';
    } else {
      return null;
    }
  }

  String validateTelefono(String value) {
    RegExp regExp = new RegExp(r'^(?:[+0][1-9])?[0-9]{10,12}$');
    if (value.length == 0) {
      return 'Dato requerido';
    } else if (!regExp.hasMatch(value)) {
      return 'Número telefónico inválido';
    } else {
      return null;
    }
  }

  String validatePwd(String value) {
    RegExp regExp = new RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    if (value.length == 0) {
      return 'Dato requerido';
    } else if (!regExp.hasMatch(value)) {
      return 'La contraseña debe tener al menos 8 dígitos, una letra mayúscula, una letra minúscula y un número';
    } else {
      return null;
    }
  }

  String validateConfirmPwd(String value) {
    RegExp regExp = new RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    if (value.length == 0) {
      return 'Dato requerido';
    } else {
      if (!regExp.hasMatch(value)) {
        return 'La contraseña debe tener al menos 8 dígitos, una letra mayúscula, una letra minúscula y un número';
      } else if (pwdCtrl.text != value) {
        return 'Las contraseñas deben coincidir';
      } else {
        return null;
      }
    }
  }

  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  // INPUT SELECT PARA ROL DE USUARIO
  bool banderaSeleccion = true;

  _listaRoles() {
    return BlocBuilder<RolesBloc, RolesState>(
      builder: (context, state) {
        if (state is RolesInitial) {
          return Center(child: CircularProgressIndicator());
        } else if (state is ErrorTokenRoles) {
          print('Error en token');
          return _showDialogMsg(context);
        } else if (state is LoadingRoles) {
          return Center(child: CircularProgressIndicator());
        } else if (state is MostrarRoles) {
          _roles = state.roles;
          if (banderaSeleccion && _roles.roles != null) {
            _rolSelect = datos['accion'] == 1 ? datos['data'].result.id_rol : 0;
            _roles.roles.any((rol) => rol.id_rol == _rolSelect)
                ? _mySelectionG = _rolSelect
                : _mySelectionG = 0;
            banderaSeleccion = false;
          } else {
            // banderaSeleccion = true;
          }
          return _dropDownRoles(_roles);
        } else if (state is ErrorObtenerRoles) {
          return Center(
            child: Text(state.message),
          );
        } else {
          return Center(child: Text('Sin permisos'));
        }
      },
    );
  }

  _dropDownRoles(ItemModelRoles roles) {
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
          _mySelectionG = newValue;
        });
      },
      items: roles.roles.map((rol) {
        return DropdownMenuItem(
          value: rol.id_rol,
          child: Text(
            rol.nombre_rol,
            style: TextStyle(fontSize: 18),
          ),
        );
      }).toList(),
    );
  }

  _showDialogMsg(BuildContext contextT) {
    _dialogContext = contextT;
    return AlertDialog(
      title: Text(
        "Sesión",
        textAlign: TextAlign.center,
      ),
      content: Text(
          'Lo sentimos la sesión a caducado, por favor inicie sesión de nuevo.'),
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
}

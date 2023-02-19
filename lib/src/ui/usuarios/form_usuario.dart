// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/blocs/roles/roles_bloc.dart';
import 'package:planning/src/blocs/usuarios/usuario/usuario_bloc.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/models/item_model_usuarios.dart';
import 'package:planning/src/models/model_roles.dart';
import 'package:planning/src/ui/widgets/snackbar_widget/snackbar_widget.dart';

class FormUsuario extends StatefulWidget {
  final Map<String, dynamic>? datos;
  const FormUsuario({Key? key, this.datos}) : super(key: key);
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => const FormUsuario(),
      );
  @override
  _FormUsuarioState createState() => _FormUsuarioState(datos);
}

class _FormUsuarioState extends State<FormUsuario> {
  final SharedPreferencesT _sharedPreferences = SharedPreferencesT();
  final Map<String, dynamic>? datos;
  late RolesBloc rolesBloc;

  late ItemModelRoles _roles;
  GlobalKey<FormState> formKey = GlobalKey();

  late BuildContext _dialogContext;

  TextEditingController? nombreCtrl;
  TextEditingController? correoCtrl;
  TextEditingController? telefonoCtrl;
  TextEditingController? pwdCtrl;
  TextEditingController? confirmPwdCtrl;
  bool? esAdmin;

  bool valid = false;

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

  int? _estatusSeleccionado;

  ItemModelUsuario? itemModelUsuario;
  late UsuarioBloc usuarioBloc;

  _FormUsuarioState(this.datos);

  int? _mySelectionG = 0;
  int? _rolSelect = 0;

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
    return SingleChildScrollView(
      controller: ScrollController(),
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
                'Error al ${datos!['accion'] == 0 ? 'crear' : 'editar'} usuario: ',
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
                'Error al ${datos!['accion'] == 0 ? 'crear' : 'editar'} usuario: ',
                state.message,
                'msg');
          }
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
    );
  }

  _setInitialController() {
    nombreCtrl = TextEditingController(
        text: datos!['accion'] == 1 ? datos!['data'].result.nombreCompleto : '');
    correoCtrl = TextEditingController(
        text: datos!['accion'] == 1 ? datos!['data'].result.correo : '');
    telefonoCtrl = TextEditingController(
        text: datos!['accion'] == 1
            ? datos!['data'].result.telefono.toString()
            : '');
    pwdCtrl = TextEditingController();
    confirmPwdCtrl = TextEditingController();
    _estatusSeleccionado = datos!['accion'] == 1
        ? datos!['data'].result.estatus == 'A'
            ? 0
            : 1
        : _estatusSeleccionado;
    esAdmin = datos!['accion'] == 1 ? datos!['data'].result.admin : false;
  }

  agregarInput(
    IconData icono,
    TextInputType inputType,
    TextEditingController? controller,
    String titulo,
    Function validator,
    List<TextInputFormatter>? inputF, {
    bool obscureT = false,
    int maxL = 0,
  }) {
    return formItemsDesign(
        icono,
        TextFormField(
          keyboardType: inputType,
          controller: controller,
          decoration: InputDecoration(
            labelText: titulo,
          ),
          validator: validator as String? Function(String?)?,
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
        datos!['accion'] == 0
            ? agregarInput(Icons.lock, TextInputType.visiblePassword, pwdCtrl,
                'Contraseña', validatePwd, null,
                obscureT: true, maxL: 30)
            : const SizedBox.shrink(),
        datos!['accion'] == 0
            ? agregarInput(
                Icons.lock,
                TextInputType.visiblePassword,
                confirmPwdCtrl,
                'Confirmar contraseña',
                validateConfirmPwd,
                null,
                obscureT: true,
                maxL: 30)
            : const SizedBox.shrink(),
        datos!['accion'] == 1
            ? formItemsDesign(
                Icons.bar_chart,
                Row(
                  children: [
                    const Expanded(child: Text('Estatus')),
                    Expanded(
                      child: MaterialSegmentedControl(
                        children: _estatus,
                        selectionIndex: _estatusSeleccionado,
                        borderColor: const Color(0xFF000000),
                        selectedColor: const Color(0xFF000000),
                        unselectedColor: Colors.white,
                        borderRadius: 32.0,
                        horizontalPadding: const EdgeInsets.all(8),
                        onSegmentChosen: (dynamic index) {
                          setState(() {
                            _estatusSeleccionado = index;
                          });
                        },
                      ),
                    ),
                  ],
                ))
            : const SizedBox.shrink(),
        formItemsDesign(
            Icons.group,
            Row(
              children: <Widget>[
                const Text('Rol a asignar'),
                const SizedBox(
                  width: 15,
                ),
                _listaRoles(),
              ],
            )),
        ElevatedButton(
          onPressed: () {
            _save(contextForm);
          },
          child: Text(datos!['accion'] == 0 ? 'Crear usuario' : 'Editar usuario',
              style: const TextStyle(fontSize: 18, color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: hexToColor('#000000'), // background
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
    if (formKey.currentState!.validate()) {
      if (_mySelectionG != 0) {
        if (datos!['accion'] == 0) {
          Map<String, dynamic> jsonUsuario = {
            'nombre_completo': nombreCtrl!.text,
            'correo': correoCtrl!.text,
            'telefono': telefonoCtrl!.text,
            'pwd': pwdCtrl!.text,
            'admin': false,
            'id_rol': _mySelectionG,
          };
          usuarioBloc.add(CrearUsuarioEvent(jsonUsuario));
        } else {
          Map<String, dynamic> jsonUsuario = {
            'id_usuario': datos!['data'].result.idUsuario,
            'nombre_completo': nombreCtrl!.text,
            'correo': correoCtrl!.text,
            'telefono': telefonoCtrl!.text,
            'estatus': _estatusSeleccionado == 0 ? 'A' : 'I',
            'id_rol': _mySelectionG,
          };
          usuarioBloc.add(EditarUsuarioEvent(jsonUsuario));
        }
      } else {
        MostrarAlerta(
            mensaje:
                'Seleccione un rol para poder ${datos!['accion'] == 0 ? 'agregar' : 'editar'} usuario',
            tipoMensaje: TipoMensaje.advertencia);
      }
    }
  }

  _dialogMSG(String title, String msg, String type) {
    Widget? child;
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

  String? validateNombre(String value) {
    String pattern = r"[a-zA-ZñÑáéíóúÁÉÍÓÚ\s]+";
    RegExp regExp = RegExp(pattern);
    if (value.length < 5) {
      return "El nombre es necesario";
    } else if (!regExp.hasMatch(value)) {
      return "El nombre debe de ser a-z y A-Z";
    }
    return null;
  }

  String? validateCorreo(String value) {
    RegExp regExp = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if (value.isEmpty) {
      return 'Dato requerido';
    } else if (!regExp.hasMatch(value)) {
      return 'Formato de correo inválido';
    } else {
      return null;
    }
  }

  String? validateTelefono(String value) {
    RegExp regExp = RegExp(r'^(?:[+0][1-9])?[0-9]{10,12}$');
    if (value.isEmpty) {
      return 'Dato requerido';
    } else if (!regExp.hasMatch(value)) {
      return 'Número telefónico inválido';
    } else {
      return null;
    }
  }

  String? validatePwd(String value) {
    RegExp regExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    if (value.isEmpty) {
      return 'Dato requerido';
    } else if (!regExp.hasMatch(value)) {
      return 'La contraseña debe tener al menos 8 caracteres, una letra mayúscula, una letra minúscula y un número';
    } else {
      return null;
    }
  }

  String? validateConfirmPwd(String value) {
    RegExp regExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    if (value.isEmpty) {
      return 'Dato requerido';
    } else {
      if (!regExp.hasMatch(value)) {
        return 'La contraseña debe tener al menos 8 caracteres, una letra mayúscula, una letra minúscula y un número';
      } else if (pwdCtrl!.text != value) {
        return 'Las contraseñas deben coincidir';
      } else {
        return null;
      }
    }
  }

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  // INPUT SELECT PARA ROL DE USUARIO
  bool banderaSeleccion = true;

  _listaRoles() {
    return BlocBuilder<RolesBloc, RolesState>(
      builder: (context, state) {
        if (state is RolesInitial) {
          return const Center(child: LoadingCustom());
        } else if (state is ErrorTokenRoles) {
          return _showDialogMsg(context);
        } else if (state is LoadingRoles) {
          return const Center(child: LoadingCustom());
        } else if (state is MostrarRoles) {
          _roles = state.roles;
          if (banderaSeleccion && _roles.roles != null) {
            _rolSelect = datos!['accion'] == 1 ? datos!['data'].result.idRol : 0;
            _roles.roles.any((rol) => rol.idRol == _rolSelect)
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
          return const Center(child: Text('Sin permisos'));
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
        color: const Color(0xFF000000),
      ),
      onChanged: (dynamic newValue) {
        setState(() {
          _mySelectionG = newValue;
        });
      },
      items: roles.roles.map((rol) {
        return DropdownMenuItem(
          value: rol.idRol,
          child: Text(
            rol.nombreRol!,
            style: const TextStyle(fontSize: 18),
          ),
        );
      }).toList(),
    );
  }

  _showDialogMsg(BuildContext contextT) {
    _dialogContext = contextT;
    return AlertDialog(
      title: const Text(
        "Sesión",
        textAlign: TextAlign.center,
      ),
      content: const Text(
          'Lo sentimos, la sesión ha caducado. Por favor inicie sesión de nuevo.'),
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
}

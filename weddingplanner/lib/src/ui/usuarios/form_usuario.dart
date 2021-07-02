import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:weddingplanner/src/blocs/usuarios/usuario/usuario_bloc.dart';
import 'package:weddingplanner/src/models/item_model_usuarios.dart';

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
  final Map<String, dynamic> datos;

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

  @override
  void initState() {
    usuarioBloc = BlocProvider.of<UsuarioBloc>(context);
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
            _dialogMSG('Error al ${datos['accion'] == 0 ? 'crear' : 'editar'} usuario: ', state.message, 'msg');
          }
          // Edicion de usuario
          else if (state is LoadingEditarUsuarioState) {
            _dialogSpinner('');
          } else if (state is UsuarioEditadoState) {
            Navigator.pop(_dialogContext);
            Navigator.pop(context, state.data);
          } else if (state is ErrorEditarUsuarioState) {
            Navigator.pop(_dialogContext);
            _dialogMSG('Error al ${datos['accion'] == 0 ? 'crear' : 'editar'} usuario: ', state.message, 'msg');
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
              child: formUI(),
            ),
          ),
        ),
      ),
    );
  }

  _setInitialController() {
    nombreCtrl = new TextEditingController(text: datos['accion'] == 1 ? datos['data'].result.nombre_completo : '');
    correoCtrl = new TextEditingController(text: datos['accion'] == 1 ? datos['data'].result.correo : '');
    telefonoCtrl = new TextEditingController(text: datos['accion'] == 1 ? datos['data'].result.telefono.toString() : '');
    pwdCtrl = new TextEditingController();
    confirmPwdCtrl = new TextEditingController();
    _estatusSeleccionado = datos['accion'] == 1
        ? datos['data'].result.estatus == 'A'
            ? 0
            : 1
        : _estatusSeleccionado;
    esAdmin = datos['accion'] == 1 ? datos['data'].result.admin : false;
  }

  agregarInput(IconData icono, TextInputType inputType, TextEditingController controller, String titulo, Function validator, List<TextInputFormatter> inputF,
      {bool obscureT: false, int maxL: 0}) {
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

  Widget formUI() {
    return Column(
      children: <Widget>[
        agregarInput(Icons.person, TextInputType.name, nombreCtrl, 'Nombre completo', validateNombre, null, maxL: 150),
        agregarInput(Icons.email, TextInputType.emailAddress, correoCtrl, 'Correo', validateCorreo, null, maxL: 100),
        agregarInput(Icons.phone, TextInputType.emailAddress, telefonoCtrl, 'Teléfono', validateTelefono, null,
            // <TextInputFormatter>[FilteringTextInputFormatter.allow(new RegExp(r'^(?:[+0][1-9])?[0-9]{10,12}$'))]
            maxL: 13),
        datos['accion'] == 0
            ? agregarInput(Icons.lock, TextInputType.visiblePassword, pwdCtrl, 'Contraseña', validatePwd, null, obscureT: true, maxL: 30)
            : SizedBox.shrink(),
        datos['accion'] == 0
            ? agregarInput(Icons.lock, TextInputType.visiblePassword, confirmPwdCtrl, 'Confirmar Contraseña', validateConfirmPwd, null,
                obscureT: true, maxL: 30)
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
                        borderColor: Color(0xFF880B55),
                        selectedColor: Color(0xFF880B55),
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
            Icons.admin_panel_settings,
            Row(
              children: [
                Text('¿Es administrador?'),
                Checkbox(
                  checkColor: Colors.white,
                  value: esAdmin,
                  onChanged: (bool value) {
                    setState(() {
                      esAdmin = value;
                    });
                  },
                )
              ],
            )),
        ElevatedButton(
          onPressed: () {
            _save();
          },
          child: Text(datos['accion'] == 0 ? 'Crear usuario' : 'Editar Usuario', style: TextStyle(fontSize: 18, color: Colors.white)),
          style: ElevatedButton.styleFrom(
            primary: hexToColor('#880B55'), // background
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

  _save() {
    if (formKey.currentState.validate()) {
      if (datos['accion'] == 0) {
        Map<String, dynamic> jsonUsuario = {
          'nombre_completo': nombreCtrl.text,
          'correo': correoCtrl.text,
          'telefono': telefonoCtrl.text,
          'pwd': pwdCtrl.text,
          'admin': esAdmin,
        };
        usuarioBloc.add(CrearUsuarioEvent(jsonUsuario));
      } else {
        Map<String, dynamic> jsonUsuario = {
          'id_usuario': datos['data'].result.id_usuario,
          'nombre_completo': nombreCtrl.text,
          'correo': correoCtrl.text,
          'telefono': telefonoCtrl.text,
          'estatus': _estatusSeleccionado == 0 ? 'A' : 'I',
          'admin': esAdmin,
        };
        usuarioBloc.add(EditarUsuarioEvent(jsonUsuario));
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
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
}

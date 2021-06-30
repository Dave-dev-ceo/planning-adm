import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingplanner/src/blocs/usuarios/usuario/usuario_bloc.dart';
import 'package:weddingplanner/src/models/item_model_usuarios.dart';
import 'package:weddingplanner/src/ui/widgets/call_to_action/call_to_action.dart';

class FormUsuario extends StatefulWidget {
  const FormUsuario({Key key}) : super(key: key);
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => FormUsuario(),
      );
  @override
  _FormUsuarioState createState() => _FormUsuarioState();
}

class _FormUsuarioState extends State<FormUsuario> {
  GlobalKey<FormState> formKey = new GlobalKey();

  TextEditingController nombreCtrl;
  TextEditingController correoCtrl;
  TextEditingController telefonoCtrl;
  TextEditingController pwdCtrl;
  TextEditingController confirmPwdCtrl;
  bool esAdmin;

  bool valid = false;

  ItemModelUsuario itemModelUsuario;
  UsuarioBloc usuarioBloc;

  @override
  void initState() {
    usuarioBloc = BlocProvider.of<UsuarioBloc>(context);
    _setInitialController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
    );
  }

  Widget formUI() {
    return Column(
      children: <Widget>[
        formItemsDesign(
            Icons.person,
            TextFormField(
              onChanged: (value) => setState(() {
                valid = formKey.currentState.validate();
              }),
              keyboardType: TextInputType.name,
              maxLength: 150,
              controller: nombreCtrl,
              decoration: new InputDecoration(
                labelText: 'Nombre completo',
              ),
              validator: validateNombre,
              autovalidateMode: AutovalidateMode.always,
            )),
        formItemsDesign(
            Icons.email,
            TextFormField(
              onChanged: (value) => setState(() {
                valid = formKey.currentState.validate();
              }),
              controller: correoCtrl,
              decoration: new InputDecoration(
                labelText: 'Correo',
              ),
              keyboardType: TextInputType.emailAddress,
              maxLength: 100,
              validator: validateCorreo,
              autovalidateMode: AutovalidateMode.always,
            )),
        formItemsDesign(
            Icons.phone,
            TextFormField(
              onChanged: (value) => setState(() {
                valid = formKey.currentState.validate();
              }),
              controller: telefonoCtrl,
              decoration: new InputDecoration(
                labelText: 'Teléfono',
              ),
              keyboardType: TextInputType.phone,
              maxLength: 10,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              validator: validateTelefono,
              autovalidateMode: AutovalidateMode.always,
            )),
        formItemsDesign(
            Icons.lock,
            TextFormField(
              onChanged: (value) => setState(() {
                valid = formKey.currentState.validate();
              }),
              controller: pwdCtrl,
              decoration: new InputDecoration(
                labelText: 'Contraseña',
              ),
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              maxLength: 10,
              validator: validatePwd,
              autovalidateMode: AutovalidateMode.always,
            )),
        formItemsDesign(
            Icons.lock,
            TextFormField(
              onChanged: (value) => setState(() {
                valid = formKey.currentState.validate();
              }),
              controller: confirmPwdCtrl,
              decoration: new InputDecoration(
                labelText: 'Confirmar Contraseña',
              ),
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              maxLength: 10,
              validator: validateConfirmPwd,
              autovalidateMode: AutovalidateMode.always,
            )),
        ElevatedButton(
          onPressed: valid
              ? () {
                  _save();
                }
              : null,
          child: Text('Guardar',
              style: TextStyle(fontSize: 18, color: Colors.white)),
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

  // String pwdPattern = ;

  _setInitialController() {
    nombreCtrl = new TextEditingController();
    correoCtrl = new TextEditingController();
    telefonoCtrl = new TextEditingController();
    pwdCtrl = new TextEditingController();
    confirmPwdCtrl = new TextEditingController();
    esAdmin = false;
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
      return 'FOrmato de número telefónico inválido';
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

  _save() {
    if (formKey.currentState.validate()) {
      Map<String, dynamic> jsonUsuario = {
        'nombre_completo': nombreCtrl.text,
        'correo': correoCtrl.text,
        'telefono': telefonoCtrl.text,
        'pwd': pwdCtrl.text,
        'admin': esAdmin
      };
      // usuarioBloc.add(CrearUsuarioEvent(jsonUsuario));
      return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('GG EZ'),
      ));
    } else {
      return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Form no válido'),
      ));
    }
  }

  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
}

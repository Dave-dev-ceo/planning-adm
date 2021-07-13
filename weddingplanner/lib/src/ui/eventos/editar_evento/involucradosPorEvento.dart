import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InvolucradosPorEvento extends StatefulWidget {
  const InvolucradosPorEvento({Key key}) : super(key: key);

  @override
  _InvolucradosPorEventoState createState() => _InvolucradosPorEventoState();
}

class _InvolucradosPorEventoState extends State<InvolucradosPorEvento> {
  // Controllers data Involucrado
  TextEditingController nombreInvoCtrl;
  TextEditingController telefonoInvoCtrl;
  TextEditingController emailInvoCtrl;
  TextEditingController passwdInvoCtrl;
  TextEditingController passwdConfirmInvoCtrl;
  bool esUsr = false;

  @override
  void initState() {
    _setInitialController();
    _clearControllerInvo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Wrap(
            children: <Widget>[
              formItemsDesign(
                  Icons.person,
                  TextFormField(
                    controller: nombreInvoCtrl,
                    decoration: new InputDecoration(
                      labelText: 'Nombre',
                    ),
                    validator: validateNombre,
                  ),
                  500.0,
                  80.0),
              formItemsDesign(
                  Icons.phone,
                  TextFormField(
                    controller: telefonoInvoCtrl,
                    decoration: new InputDecoration(
                      labelText: 'Teléfono',
                    ),
                    validator: validateTelefono,
                  ),
                  500.0,
                  80.0),
            ],
          ),
          Wrap(
            children: <Widget>[
              formItemsDesign(
                  Icons.email,
                  TextFormField(
                    controller: emailInvoCtrl,
                    decoration: new InputDecoration(
                      labelText: 'Correo',
                    ),
                    validator: validateCorreo,
                  ),
                  500.0,
                  80.0),
              formItemsDesign(
                  Icons.import_contacts,
                  Row(
                    children: [
                      Text('¿Puede ver información de evento?'),
                      Checkbox(
                        value: esUsr,
                        onChanged: (bool value) {
                          setState(() {
                            esUsr = !esUsr;
                          });
                        },
                      ),
                    ],
                  ),
                  500.0,
                  80.0),
              // BlocListener(listener: listener)
            ],
          ),
          esUsr
              ? Wrap(
                  children: <Widget>[
                    esUsr
                        ? agregarInput(Icons.lock, TextInputType.visiblePassword, passwdInvoCtrl, 'Contraseña', validatePwd, null, obscureT: true, maxL: 30)
                        : SizedBox.shrink(),
                    esUsr
                        ? agregarInput(Icons.lock, TextInputType.visiblePassword, passwdConfirmInvoCtrl, 'Confirmar Contraseña', validateConfirmPwd, null,
                            obscureT: true, maxL: 30)
                        : SizedBox.shrink(),
                    // BlocListener(listener: listener)
                  ],
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  agregarInput(IconData icono, TextInputType inputType, TextEditingController controller, String titulo, Function validator, List<TextInputFormatter> inputF,
      {bool obscureT: false, int maxL: 0, largo: 500, ancho: 80}) {
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
        ),
        500.0,
        80.0);
  }

  _setInitialController() {
    nombreInvoCtrl = new TextEditingController();
    telefonoInvoCtrl = new TextEditingController();
    emailInvoCtrl = new TextEditingController();
    passwdInvoCtrl = new TextEditingController();
    passwdConfirmInvoCtrl = new TextEditingController();
  }

  _clearControllerInvo() {
    nombreInvoCtrl.clear();
    telefonoInvoCtrl.clear();
    emailInvoCtrl.clear();
    passwdInvoCtrl.clear();
    passwdConfirmInvoCtrl.clear();
    setState(() {
      esUsr = false;
    });
  }

  formItemsDesign(icon, item, large, ancho) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3),
      child: Container(
        child: Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), elevation: 10, child: ListTile(leading: Icon(icon), title: item)),
        width: large,
        height: ancho,
      ),
    );
  }

  String validateNombre(String value) {
    String pattern = r"[a-zA-ZñÑáéíóúÁÉÍÓÚ\s]+";
    RegExp regExp = new RegExp(pattern);
    if (value.length < 10) {
      return "Mínimo 10 caractéres";
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
      } else if (passwdInvoCtrl.text != value) {
        return 'Las contraseñas deben coincidir';
      } else {
        return null;
      }
    }
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/blocs/login/login_bloc.dart';
import 'package:planning/src/ui/login/login.dart';
import 'package:planning/src/ui/widgets/text_form_filed/password_wplanner.dart';
import 'package:responsive_grid/responsive_grid.dart';

class RecoverPasswordPage extends StatefulWidget {
  final String token;

  const RecoverPasswordPage({Key key, @required this.token}) : super(key: key);
  @override
  _RecoverPasswordState createState() => _RecoverPasswordState();
}

class _RecoverPasswordState extends State<RecoverPasswordPage> {
  final _keyForm = GlobalKey<FormState>();

  TextEditingController newPassword = TextEditingController(text: '');
  TextEditingController repeatNewPassWord = TextEditingController(text: '');

  LoginBloc loginBloc;
  Timer timer;

  @override
  void initState() {
    loginBloc = BlocProvider.of<LoginBloc>(context);
    loginBloc.add(ValidateTokenEvent(widget.token));
    timer = Timer.periodic(Duration(minutes: 1), (timer) {
      loginBloc.add(ValidateTokenEvent(widget.token));
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        centerTitle: true,
        title: Text('Cambiar contraseña'),
      ),
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) async {
          if (state is TokenExpiradoState) {
            Future.delayed(Duration(seconds: 4), () {
              Navigator.of(context).pushReplacementNamed('/');
            });
          } else if (state is PasswordChangedState) {
            _mostrarMensaje('Se ha cambiado la contraseña', Colors.green);
            Navigator.of(context).pop();

            Navigator.of(context).pushReplacementNamed('/');
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            if (state is TokenValidadoState) {
              return changePasswordWidget(size, context);
            } else {
              return Center(
                child: Text(
                    'El enlace ya expiro. \nLa pagina se redireccionara al login'),
              );
            }
          },
        ),
      ),
    );
  }

  Center changePasswordWidget(Size size, BuildContext context) {
    return Center(
        child: Container(
      width: size.width,
      height: size.height,
      color: Colors.white,
      child: Form(
        key: _keyForm,
        child: Column(
          children: [
            SizedBox(
              height: 15.0,
            ),
            Text(
              'Ingrese los siguientes campos',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(
              height: 15.0,
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: size.width * 0.4),
              child: ResponsiveGridRow(
                children: [
                  ResponsiveGridCol(
                    md: 12,
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: PasswordWplanner(
                        controller: newPassword,
                        floatingText: 'Nueva contraseña',
                        hintText: 'Nueva contraseña',
                        inputStyle: TextStyle(color: Colors.black),
                        hintStyle: TextStyle(color: Colors.grey),
                        autoFocus: false,
                        hasFloatingPlaceholder: true,
                        prefixIcon: Icon(Icons.password),
                        suffixIcon: Icon(
                          Icons.remove_red_eye,
                          color: Colors.grey,
                        ),
                        color: Colors.black,
                        iconColor: Colors.grey,
                        iconColorSelect: Colors.black,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(color: Colors.black)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(color: Colors.black)),
                        validador: (value) {
                          if (!_validaPsw(value)) {
                            return 'Campo requerido con una minuscula, una mayúscula, un número y un minimo de 8 caracteres.';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  ResponsiveGridCol(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: PasswordWplanner(
                        floatingText: 'Confirmar contraseña',
                        controller: repeatNewPassWord,
                        hintText: 'Confirmar contraseña',
                        inputStyle: TextStyle(color: Colors.black),
                        hintStyle: TextStyle(color: Colors.grey),
                        autoFocus: false,
                        hasFloatingPlaceholder: true,
                        prefixIcon: Icon(Icons.password),
                        suffixIcon: Icon(
                          Icons.remove_red_eye,
                          color: Colors.grey,
                        ),
                        color: Colors.black,
                        iconColor: Colors.grey,
                        iconColorSelect: Colors.black,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(color: Colors.black)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(color: Colors.black)),
                        validador: (value) {
                          if (value != newPassword.text) {
                            _mostrarMensaje(
                                'La contraseña no coincide', Colors.red);
                            return 'Debe coincidir con la contraseña.';
                          } else if (value.isEmpty) {
                            return 'Campo requerido.';
                          }
                          return null;
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            ElevatedButton(
              onPressed: () async {
                if (_keyForm.currentState.validate()) {
                  loginBloc.add(
                      ChangeAndRecoverPassword(newPassword.text, widget.token));
                } else {
                  _mostrarMensaje(
                      'Los campos no coiciden o estan vacios', Colors.red);
                }
              },
              child: Text('Guardar'),
            )
          ],
        ),
      ),
    ));
  }

  bool _validaPsw(String txt) {
    bool temp = false;

    // filtros
    bool mayusculas = false;
    bool minusculas = false;
    bool numeros = false;

    // expresiones regulares
    RegExp validaMayusculas = RegExp(r'[A-Z]');
    RegExp validaMinusculas = RegExp(r'[a-z]');
    RegExp validaNumeros = RegExp(r'[\d]');

    // validaciones
    if (validaMayusculas.hasMatch(txt)) mayusculas = true;
    if (validaMinusculas.hasMatch(txt)) minusculas = true;
    if (validaNumeros.hasMatch(txt)) numeros = true;

    if (txt.length > 7 && mayusculas && minusculas && numeros) temp = true;

    return temp;
  }

  void _mostrarMensaje(String descripcion, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(descripcion),
      backgroundColor: color,
      duration: Duration(seconds: 3),
    ));
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/blocs/login/login_bloc.dart';
import 'package:planning/src/ui/widgets/snackbar_widget/snackbar_widget.dart';
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
    timer = Timer.periodic(const Duration(minutes: 1), (timer) {
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
        title: const Text('Cambiar contraseña'),
      ),
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) async {
          if (state is TokenExpiradoState) {
            Future.delayed(const Duration(seconds: 4), () {
              Navigator.of(context).pushReplacementNamed('/');
            });
          } else if (state is PasswordChangedState) {
            MostrarAlerta(
                mensaje: 'Se ha cambiado la contraseña',
                tipoMensaje: TipoMensaje.correcto);
            Navigator.of(context).pop();

            Navigator.of(context).pushReplacementNamed('/');
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            if (state is TokenValidadoState) {
              return changePasswordWidget(size, context);
            } else if (state is TokenExpiradoState) {
              return const Center(
                child: Text(
                    'El enlace ya expiró. \nLa página se redireccionará al inicio de sesión'),
              );
            } else {
              return const Center(
                child: LoadingCustom(),
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
            const SizedBox(
              height: 15.0,
            ),
            Text(
              'Ingrese los siguientes campos',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(
              height: 15.0,
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: size.width * 0.4),
              child: ResponsiveGridRow(
                children: [
                  ResponsiveGridCol(
                    md: 12,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: PasswordWplanner(
                        controller: newPassword,
                        floatingText: 'Nueva contraseña',
                        hintText: 'Nueva contraseña',
                        inputStyle: const TextStyle(color: Colors.black),
                        hintStyle: const TextStyle(color: Colors.grey),
                        autoFocus: false,
                        hasFloatingPlaceholder: true,
                        prefixIcon: const Icon(Icons.password),
                        suffixIcon: const Icon(
                          Icons.remove_red_eye,
                          color: Colors.grey,
                        ),
                        color: Colors.black,
                        iconColor: Colors.grey,
                        iconColorSelect: Colors.black,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(color: Colors.black)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(color: Colors.black)),
                        validador: (value) {
                          if (!_validaPsw(value)) {
                            return 'Campo requerido con una minúscula, una mayúscula, un número y un mínimo de 8 caracteres.';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  ResponsiveGridCol(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: PasswordWplanner(
                        floatingText: 'Confirmar contraseña',
                        controller: repeatNewPassWord,
                        hintText: 'Confirmar contraseña',
                        inputStyle: const TextStyle(color: Colors.black),
                        hintStyle: const TextStyle(color: Colors.grey),
                        autoFocus: false,
                        hasFloatingPlaceholder: true,
                        prefixIcon: const Icon(Icons.password),
                        suffixIcon: const Icon(
                          Icons.remove_red_eye,
                          color: Colors.grey,
                        ),
                        color: Colors.black,
                        iconColor: Colors.grey,
                        iconColorSelect: Colors.black,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(color: Colors.black)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(color: Colors.black)),
                        validador: (value) {
                          if (value != newPassword.text) {
                            MostrarAlerta(
                              mensaje: 'La contraseña no coincide',
                              tipoMensaje: TipoMensaje.error,
                            );
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
            const SizedBox(
              height: 10.0,
            ),
            ElevatedButton(
              onPressed: () async {
                if (_keyForm.currentState.validate()) {
                  loginBloc.add(
                      ChangeAndRecoverPassword(newPassword.text, widget.token));
                } else {
                  MostrarAlerta(
                      mensaje: 'Los campos no coiciden o estan vacíos',
                      tipoMensaje: TipoMensaje.advertencia);
                }
              },
              child: const Text('Guardar'),
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
}

//import 'dart:ffi';

// ignore_for_file: unused_element

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/blocs/login/login_bloc.dart';
import 'package:planning/src/models/eventoModel/evento_resumen_model.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/resources/api_provider.dart';
import 'package:planning/src/ui/widgets/snackbar_widget/snackbar_widget.dart';

// Padilla
import 'package:planning/src/ui/widgets/text_form_filed/password_wplanner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final int _index = 0;
  LoginBloc loginBloc;
  TextEditingController emailCtrl = TextEditingController(text: '');
  TextEditingController passwordCtrl = TextEditingController(text: '');
  TextEditingController emailRCtrl = TextEditingController();
  TextEditingController passwordRCtrl = TextEditingController();
  TextEditingController passwordConfirRCtrl = TextEditingController();
  TextEditingController nombreRCtrl = TextEditingController();
  TextEditingController telefonoRCtrl = TextEditingController();
  TextEditingController correoRecuperacionCtrl = TextEditingController();
  final SharedPreferencesT _sharedPreferences = SharedPreferencesT();
  BuildContext _ingresando;
  final bool _visible = true;
  ApiProvider api = ApiProvider();

  @override
  void initState() {
    loginBloc = BlocProvider.of<LoginBloc>(context);

    super.initState();
    _getCorreo();
    _checkSession();
  }

  // * Analiza si el correo existe en la preferencias y lo setea al controlador del texto
  _getCorreo() async {
    String correo = await _sharedPreferences.getCorreo();

    if (correo != null) {
      emailCtrl.text = correo;
    }
  }

  void _checkSession() async {
    bool sesion = await _sharedPreferences.getSession();
    int involucrado = await _sharedPreferences.getIdInvolucrado();
    int idEvento = await _sharedPreferences.getIdEvento();
    String titulo = await _sharedPreferences.getEventoNombre();
    String nombreUser = await _sharedPreferences.getNombre();
    String image = await _sharedPreferences.getImagen();
    String portada = await _sharedPreferences.getPortada();
    String fechaEvento = await _sharedPreferences.getFechaEvento();

    Map data = {'name': await _sharedPreferences.getNombre(), 'imag': image};

    if (sesion) {
      if (involucrado == null) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home', arguments: data);
        }
      } else {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/dashboardInvolucrado',
              arguments: EventoResumenModel(
                idEvento: idEvento,
                descripcion: titulo,
                nombreCompleto: nombreUser,
                boton: false,
                portada: portada,
                img: image,
                fechaEvento: DateTime.tryParse(fechaEvento).toLocal(),
              ));
        }
        // Navigator.pushNamed(context, '/eventos', arguments: {
        //   'idEvento': idEvento,
        //   'nEvento': titulo,
        //   'nombre': nombreUser,
        //   'boton': false,
        //   'imag': image
        // });
      }
    }
  }

  _dialogMSG(String title, String msg, String type) {
    Widget child;
    if (type == "msg") {
      child = Text(msg);
    } else if (type == "log") {
      child = AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: _visible ? 1.0 : 0.0,
          child: Image.asset(
            'assets/new_logo.png',
            height: 100.0,
            width: 150.0,
            color: Colors.purple,
          ));
    }
    showDialog(
        context: context,
        //barrierDismissible: false,
        builder: (BuildContext context) {
          _ingresando = context;
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

  _decorationText(String text) {
    return InputDecoration(
      floatingLabelStyle: TextStyle(
        color: Colors.purple[100],
      ),
      labelText: text,
      labelStyle: TextStyle(color: Colors.purple[100]),
      fillColor: Colors.black,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: const BorderSide(
          color: Colors.black,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide(
          color: Colors.purple[100],
          width: 2.0,
        ),
      ),
    );
  }

  _authDataUser(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is ErrorLogginState) {
          Navigator.pop(_ingresando);
          // Navigator.pushNamed(context, '/');
          _dialogMSG('Datos inválidos', state.message, 'msg');
        } else if (state is LogginState) {
          _dialogMSG('Iniciando sesión', '', 'log');
        } else if (state is MsgLogginState) {
          // Navigator.pop(_ingresando);
          _dialogMSG('Datos inválidos', state.message, 'msg');
        } else if (state is LoggedState) {
          //int idPlanner = await _sharedPreferences.getIdPlanner();
          Navigator.pop(_ingresando);
          if (state.response['usuario']['id_involucrado'] == 'null') {
            Map data = {
              'name': state.response['usuario']['nombre_completo'],
              'imag': state.response['usuario']['imagen']
            };
            _sharedPreferences.setCorreo(emailCtrl.text);
            Navigator.pushReplacementNamed(context, '/home', arguments: data);
          } else {
            _sharedPreferences.setCorreo(emailCtrl.text);

            Navigator.pushReplacementNamed(context, '/dashboardInvolucrado',
                arguments: EventoResumenModel(
                  boton: false,
                  idEvento: state.response['usuario']['id_evento'],
                  descripcion: state.response['usuario']['descripcion'],
                  nombreCompleto: state.response['usuario']['nombre_completo'],
                  img: state.response['usuario']['imagen'],
                  portada: state.response['usuario']['portada'],
                  fechaEvento: DateTime.tryParse(
                          state.response['usuario']['fecha_evento'])
                      .toLocal(),
                ));
          }
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(
            height: 10.0,
          ),
          Image.asset(
            'assets/new_logo.png',
            height: 180.0,
            width: 450,
          ),
          const SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(32.0, 40.0, 32.0, 4.0),
            child: TextFormField(
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.black),
              decoration: _decorationText("Correo"),
              cursorColor: Colors.purple[100],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(32.0, 20.0, 32.0, 4.0),
            //Padilla
            child: Center(
              child: PasswordWplanner(
                // WP
                controller: passwordCtrl,
                suffixIcon: Icon(
                  Icons.remove_red_eye,
                  color: Colors.purple[100],
                ),
                color: Colors.purple[100],
                iconColor: Colors.purple[100],
                iconColorSelect: Colors.black,
                inputStyle: const TextStyle(color: Colors.black),
                hintStyle: TextStyle(color: Colors.purple[100]),
                autoFocus: false,
                hasFloatingPlaceholder: true,
                // pattern: r'.*[@$#.*].*',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide:
                        BorderSide(width: 2.0, color: Colors.purple[100])),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(color: Colors.black)),
                onSubmit: (_) {
                  if ((emailCtrl.text.trim() == '') ||
                      (passwordCtrl.text.trim() == '')) {
                    _dialogMSG('Datos inválidos', 'Correo o contraseña vacíos.',
                        'msg');
                  } else {
                    loginBloc.add(LogginEvent(
                        emailCtrl.text.trim(), passwordCtrl.text.trim()));
                  }
                },
              ),
            ),
            //FinPadilla
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(32.0, 5.0, 32.0, 1.0),
            child: TextButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                  overlayColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.hovered)) {
                        return Colors.purple.withOpacity(0.04);
                      }
                      if (states.contains(MaterialState.focused) ||
                          states.contains(MaterialState.pressed)) {
                        return Colors.purple.withOpacity(0.12);
                      }
                      return null; // Defer to the widget's default.
                    },
                  ),
                ),
                onPressed: () {
                  if ((emailCtrl.text.trim() == '') ||
                      (passwordCtrl.text.trim() == '')) {
                    _dialogMSG('Datos inválidos', 'Correo o contraseña vacíos.',
                        'msg');
                  } else {
                    loginBloc.add(LogginEvent(
                        emailCtrl.text.trim(), passwordCtrl.text.trim()));
                  }
                },
                child: const Text(
                  'Iniciar sesión',
                  style: TextStyle(fontSize: 17),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextButton(
              onPressed: () async {
                await launchUrlString(
                    'https://www.planning.com.mx/#testimonials');
              },
              child: Text('Registrarse'),
            ),
          ),
          recoverPasswordButton(context),
          const SizedBox(
            height: 10,
          ),
          if (!(defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.iOS))
            Text('¡Descarga la aplicación!'),
          if (!(defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.iOS))
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MediaQuery.of(context).size.width > 580
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: botones,
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: botones,
                    ),
            )
        ],
      ),
    );
  }

  final botones = <Widget>[
    Container(
      height: 50,
      margin: EdgeInsets.all(4.0),
      child: Image.asset('assets/badge_play.png'),
    ),
    GestureDetector(
      onTap: () async {
        await launchUrl(
            Uri.parse('https://apps.apple.com/mx/app/planning/id1627823627'));
      },
      child: Container(
        margin: EdgeInsets.all(4.0),
        height: 50,
        child: Image.asset('assets/badge_apple.png'),
      ),
    )
  ];

  Padding recoverPasswordButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: TextButton(
        onPressed: () {
          showDialog(
              barrierColor: Colors.transparent,
              context: context,
              builder: (context) => const RecoverPasswordDialog());
        },
        child: const Text(
          'Olvidé mi contraseña',
          style: TextStyle(fontSize: 12.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    loginBloc = BlocProvider.of<LoginBloc>(context);
    double heightA = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: heightA < 780 ? heightA = 1024 : heightA,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: Image.asset('assets/fondo2.jpg').image,
                  fit: BoxFit.cover)),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 100.0,
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  SizedBox(
                    width: 370,
                    height: 760,
                    child: Center(
                      child: IndexedStack(
                        index: _index,
                        children: <Widget>[
                          _authDataUser(context),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 130.0,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // valida telefono
  bool _validaPhone(String txt) {
    bool temp = false;
    // exp regular
    RegExp validaPhone = RegExp(r"^[\d]{10,10}$");
    if (validaPhone.hasMatch(txt)) temp = true;
    return temp;
  }
}

class RecoverPasswordDialog extends StatefulWidget {
  const RecoverPasswordDialog({Key key}) : super(key: key);

  @override
  State<RecoverPasswordDialog> createState() => _RecoverPasswordDialogState();
}

class _RecoverPasswordDialogState extends State<RecoverPasswordDialog> {
  LoginBloc loginBloc;

  TextEditingController correoRecuperacionCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    loginBloc = BlocProvider.of<LoginBloc>(context);
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is CorreoSentState) {
          correoRecuperacionCtrl.clear();

          MostrarAlerta(
              mensaje: 'Se ha enviado el correo',
              tipoMensaje: TipoMensaje.correcto);
          Navigator.of(context).pop();
        } else if (state is CorreoNotFoundState) {
          correoRecuperacionCtrl.clear();

          MostrarAlerta(
              mensaje: 'Este correo no está registrado',
              tipoMensaje: TipoMensaje.correcto);
        }
      },
      child: AlertDialog(
        title: Text(
          'Recuperar contraseña',
          style: Theme.of(context).textTheme.headline5,
        ),
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: size.width * 0.3,
            maxHeight: size.height * 0.4,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Ingrese su correo electrónico de recuperación',
              ),
              const SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  onFieldSubmitted: (_) {
                    _submit();
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Correo electrónico',
                    labelText: 'Correo electrónico',
                  ),
                  controller: correoRecuperacionCtrl,
                ),
              )
            ],
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 3.0,
              ),
              onPressed: _submit,
              child: const Text('Enviar'),
            ),
          )
        ],
      ),
    );
  }

  _submit() async {
    RegExp regExpEmail = RegExp(
        r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");

    if (regExpEmail.hasMatch(correoRecuperacionCtrl.text)) {
      loginBloc.add(RecoverPasswordEvent(correoRecuperacionCtrl.text));
    } else {
      MostrarAlerta(
          mensaje: 'Ingrese un correo válido', tipoMensaje: TipoMensaje.error);
    }
  }
}

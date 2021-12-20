import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/blocs/login/login_bloc.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/resources/api_provider.dart';
import 'package:planning/src/ui/widgets/text_form_filed/password_wplanner.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  int _index = 0;
  LoginBloc loginBloc;
  TextEditingController emailCtrl = new TextEditingController(text: '');
  TextEditingController passwordCtrl = new TextEditingController(text: '');
  TextEditingController emailRCtrl = new TextEditingController();
  TextEditingController passwordRCtrl = new TextEditingController();
  TextEditingController passwordConfirRCtrl = new TextEditingController();
  TextEditingController nombreRCtrl = new TextEditingController();
  TextEditingController telefonoRCtrl = new TextEditingController();
  TextEditingController correoRecuperacionCtrl = new TextEditingController();
  SharedPreferencesT _sharedPreferences = new SharedPreferencesT();
  BuildContext _ingresando;
  bool _visible = true;
  ApiProvider api = new ApiProvider();

  @override
  void initState() {
    loginBloc = BlocProvider.of<LoginBloc>(context);

    super.initState();
    _checkSession();
  }

  void _checkSession() async {
    bool sesion = await _sharedPreferences.getSession();
    int involucrado = await _sharedPreferences.getIdInvolucrado();
    int idEvento = await _sharedPreferences.getIdEvento();
    String titulo = await _sharedPreferences.getEventoNombre();
    String nombreUser = await _sharedPreferences.getNombre();
    String image = await _sharedPreferences.getImagen();

    Map data = {'name': await _sharedPreferences.getNombre(), 'imag': image};

    if (sesion) {
      if (involucrado == null) {
        Navigator.pushNamed(context, '/home', arguments: data);
      } else {
        Navigator.pushNamed(context, '/eventos', arguments: {
          'idEvento': idEvento,
          'nEvento': titulo,
          'nombre': nombreUser,
          'boton': false,
          'imag': image
        });
      }
    }
  }

  _dialogMSG(String title, String msg, String type) {
    Widget child;
    if (type == "msg") {
      child = Text(msg);
    } else if (type == "log") {
      child = AnimatedOpacity(
          duration: Duration(milliseconds: 500),
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
        borderSide: BorderSide(
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
          _dialogMSG(
              'Datos invalidos', 'Correo o contraseña incorrectos', 'msg');
        } else if (state is LogginState) {
          _dialogMSG('Iniciando sesión', '', 'log');
        } else if (state is MsgLogginState) {
          Navigator.pop(_ingresando);
          _dialogMSG('Datos inválidos', state.message, 'msg');
        } else if (state is LoggedState) {
          //int idPlanner = await _sharedPreferences.getIdPlanner();
          Navigator.pop(_ingresando);
          if (state.response['usuario']['id_involucrado'] == 'null') {
            Map data = {
              'name': state.response['usuario']['nombre_completo'],
              'imag': state.response['usuario']['imagen']
            };
            Navigator.pushNamed(context, '/home', arguments: data);
          } else {
            Navigator.pushNamed(context, '/eventos', arguments: {
              'idEvento': state.response['usuario']['id_evento'],
              'nEvento': state.response['usuario']['descripcion'],
              'nombre': state.response['usuario']['nombre_completo'],
              'boton': false,
              'imag': state.response['usuario']['imagen']
            });
          }
        }
      },
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          Image.asset(
            'assets/new_logo.png',
            height: 180.0,
            width: 450,
          ),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(32.0, 40.0, 32.0, 4.0),
            child: TextFormField(
              controller: emailCtrl,
              style: TextStyle(color: Colors.black),
              decoration: _decorationText("Correo"),
              cursorColor: Colors.purple[100],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(32.0, 20.0, 32.0, 4.0),
            // child: TextFormField(
            //   controller: passwordCtrl,
            //   obscureText: true,
            //   enableSuggestions: false,
            //   autocorrect: false,
            //   style: TextStyle(color: Colors.black),
            //   decoration: _decorationText("Contraseña"),
            //   cursorColor: Colors.purple[100],
            // ),
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
                inputStyle: TextStyle(color: Colors.black),
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
                    borderSide: BorderSide(color: Colors.black)),
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
                      if (states.contains(MaterialState.hovered))
                        return Colors.purple.withOpacity(0.04);
                      if (states.contains(MaterialState.focused) ||
                          states.contains(MaterialState.pressed))
                        return Colors.purple.withOpacity(0.12);
                      return null; // Defer to the widget's default.
                    },
                  ),
                ),
                onPressed: () => loginBloc.add(LogginEvent(
                    emailCtrl.text.trim(), passwordCtrl.text.trim())),
                child: Text(
                  'Iniciar Sesión',
                  style: TextStyle(fontSize: 17),
                )),
          ),
          recoverPasswordButton(context),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Padding recoverPasswordButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: TextButton(
        onPressed: () {
          showDialog(
              barrierColor: Colors.transparent,
              context: context,
              builder: (context) => RecoverPasswordDialog());
        },
        child: Text(
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
                  SizedBox(
                    height: 100.0,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Container(
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
                  SizedBox(
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
  @override
  State<RecoverPasswordDialog> createState() => _RecoverPasswordDialogState();
}

class _RecoverPasswordDialogState extends State<RecoverPasswordDialog> {
  LoginBloc loginBloc;

  TextEditingController correoRecuperacionCtrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    loginBloc = BlocProvider.of<LoginBloc>(context);
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is CorreoSentState) {
          correoRecuperacionCtrl.clear();

          _showMessage('Se ha enviado el correo', Colors.green);
          Navigator.of(context).pop();
        } else if (state is CorreoNotFoundState) {
          correoRecuperacionCtrl.clear();

          _showMessage('Este correo no está registrado', Colors.red);
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
              Text(
                'Ingrese su correo electrónico de recuperación',
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  decoration: InputDecoration(
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
              onPressed: () async {
                RegExp regExpEmail = RegExp(
                    r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");

                if (regExpEmail.hasMatch(correoRecuperacionCtrl.text)) {
                  await loginBloc
                      .add(RecoverPasswordEvent(correoRecuperacionCtrl.text));
                } else {
                  _showMessage('Ingrese un correo válido', Colors.red);
                }
              },
              child: Text('Enviar'),
            ),
          )
        ],
      ),
    );
  }

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: color,
        duration: Duration(seconds: 2),
      ),
    );
  }
}

//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingplanner/src/blocs/login/login_bloc.dart';
import 'package:weddingplanner/src/models/item_model_preferences.dart';

// Padilla
import 'package:weddingplanner/src/ui/widgets/text_form_filed/password_wplanner.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  int _index = 0;
  dynamic loginBloc;
  TextEditingController emailCtrl = new TextEditingController(text: 'padiiyaa@gmail.com');
  // TextEditingController emailCtrl = new TextEditingController(text: 'soporte@grupotum.com');
  TextEditingController passwordCtrl = new TextEditingController(text: 'N0v4-2020');
  TextEditingController emailRCtrl = new TextEditingController();
  TextEditingController passwordRCtrl = new TextEditingController();
  TextEditingController nombreRCtrl = new TextEditingController();
  SharedPreferencesT _sharedPreferences = new SharedPreferencesT();
  BuildContext _ingresando;
  bool _visible = true;

  @override
  void initState() {
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

    Map data = {
      'name':await _sharedPreferences.getNombre(),
      'imag':image
    };

    if (sesion) {
      if(involucrado == null) {
        Navigator.pushNamed(context, '/home', arguments: data);
      } else {
        Navigator.pushNamed(context, '/eventos', arguments: {'idEvento': idEvento, 'nEvento':titulo, 'nombre':nombreUser,'boton':false,'imag':image});
      }
    }
  }

  _registroPlanner() async {
    if (emailRCtrl.text == "" ||
        emailRCtrl.text == null ||
        nombreRCtrl.text == "" ||
        nombreRCtrl.text == null ||
        passwordRCtrl.text == "" ||
        passwordRCtrl.text == null) {
      showDialog(
          context: context,
          //barrierDismissible: false,
          builder: (BuildContext context) {
            //_ingresando = context;
            return AlertDialog(
              title: Text(
                "Registro",
                textAlign: TextAlign.center,
              ),
              content: Text('No puede dejar campos vacíos'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              actions: <Widget>[
                TextButton(
                  child: Text('Cerrar'),
                  onPressed: () {
                    //_index = 0;
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    } else {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            _ingresando = context;
            return AlertDialog(
              title: Text(
                "Registrando",
                textAlign: TextAlign.center,
              ),
              content: AnimatedOpacity(
                  duration: Duration(milliseconds: 500),
                  opacity: _visible ? 1.0 : 0.0,
                  child: Image.asset(
                    'assets/logo.png',
                    height: 100.0,
                    width: 150.0,
                    color: Colors.purple,
                  )),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
            );
          });
      /*Map<String, String> json = {
        "nombre_completo": nombreRCtrl.text,
        "correo": emailRCtrl.text,
        "contrasena": passwordRCtrl.text
      };*/
//      int response = await api.registroPlanner(json);
      int response = 0;
      if (response == 0) {
        emailRCtrl.clear();
        passwordRCtrl.clear();
        nombreRCtrl.clear();
        _index = 0;
        Navigator.pop(_ingresando);
        showDialog(
            context: context,
            //barrierDismissible: false,
            builder: (BuildContext context) {
              //_ingresando = context;
              return AlertDialog(
                title: Text(
                  "Registro",
                  textAlign: TextAlign.center,
                ),
                content: Text('Planner Registrado con éxito'),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0))),
                actions: <Widget>[
                  TextButton(
                    child: Text('Cerrar'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });

        //Navigator.pushNamed(context, '/dasboard');
      } else if (response == 1) {
        Navigator.pop(_ingresando);
        showDialog(
            context: context,
            //barrierDismissible: false,
            builder: (BuildContext context) {
              //_ingresando = context;
              return AlertDialog(
                title: Text(
                  "Datos invalidos",
                  textAlign: TextAlign.center,
                ),
                content: Text('No se pudo realizar el registro'),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0))),
                actions: <Widget>[
                  TextButton(
                    child: Text('Cerrar'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      } else if (response == 2) {
        Navigator.pop(_ingresando);
        showDialog(
            context: context,
            //barrierDismissible: false,
            builder: (BuildContext context) {
              //_ingresando = context;
              return AlertDialog(
                title: Text(
                  "Error",
                  textAlign: TextAlign.center,
                ),
                content: Text('Registro invalido'),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0))),
                actions: <Widget>[
                  TextButton(
                    child: Text('Cerrar'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
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
            'assets/logo.png',
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

  _registrarDataUser() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 10.0,
        ),
        Image.asset(
          'assets/logo.png',
          height: 180.0,
          width: 450,
        ),
        SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(32.0, 40.0, 32.0, 4.0),
          child: TextFormField(
            controller: nombreRCtrl,
            style: TextStyle(color: Colors.white),
            decoration: new InputDecoration(
              labelText: "Nombre",
              labelStyle: TextStyle(color: Colors.purple[100]),
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                  color: Colors.purple[100],
                  width: 2.0,
                ),
              ),
            ),
            cursorColor: Colors.purple[100],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(32.0, 20.0, 32.0, 4.0),
          child: TextFormField(
            controller: emailRCtrl,
            style: TextStyle(color: Colors.white),
            decoration: new InputDecoration(
              labelText: "Correo",
              labelStyle: TextStyle(color: Colors.purple[100]),
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                  color: Colors.purple[100],
                  width: 2.0,
                ),
              ),
            ),
            cursorColor: Colors.purple[100],
          ),
        ),
        //SizedBox(height: 15.0,),
        Padding(
          padding: const EdgeInsets.fromLTRB(32.0, 20.0, 32.0, 4.0),
          child: TextFormField(
            controller: passwordRCtrl,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            style: TextStyle(color: Colors.white),
            decoration: new InputDecoration(
              labelText: "Contraseña",
              labelStyle: TextStyle(color: Colors.purple[100]),
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                  color: Colors.purple[100],
                  width: 2.0,
                ),
              ),
            ),
            cursorColor: Colors.purple[100],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(32.0, 20.0, 32.0, 4.0),
          child: TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
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
              onPressed: () {
                _registroPlanner();
              },
              child: Text(
                'Registrarse',
                style: TextStyle(fontSize: 17),
              )),
        ),
        SizedBox(
          height: 10,
        ),
        //Row(
        //children: <Widget>[
        //Padding(
        //padding: const EdgeInsets.fromLTRB(32.0, 20.0, 32.0, 4.0),
        //      child:
        //Expanded(
        //child:
        TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
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
            onPressed: () {
              setState(() {
                _index = 0;
              });
            },
            child: Text(
              'Acceso',
              style: TextStyle(fontSize: 12),
            )),
        // ),
        //),
        //Padding(
        //padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 4.0),
        //child:
        /*Expanded(
                                              child: TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
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
                onPressed: () {setState(() {
                  _index = 1;
                }); },
                child: Text('Registro',style: TextStyle(fontSize: 12),)
              ),*/
        //    ),
        //),
        //],
        // )
      ],
    );
  }

  _decorationText(String text) {
    return InputDecoration(
      labelText: text,
      labelStyle: TextStyle(color: Colors.purple[100]),
      fillColor: Colors.white,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide(
          color: Colors.white,
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
          //Navigator.pop(_ingresando);
          _dialogMSG('Datos invalidos', state.message, 'msg');
        } else if (state is LoggedState) {
          //int idPlanner = await _sharedPreferences.getIdPlanner();
          Navigator.pop(_ingresando);
          if(state.response['usuario']['id_involucrado'] == 'null') {
            Map data = {
              'name':state.response['usuario']['nombre_completo'],
              'imag':state.response['usuario']['imagen']
            };
            Navigator.pushNamed(context, '/home', arguments: data);
          } else {
            Navigator.pushNamed(context, '/eventos', arguments: {'idEvento': state.response['usuario']['id_evento'], 'nEvento':state.response['usuario']['descripcion'], 'nombre':state.response['usuario']['nombre_completo'],'boton':false,'imag':state.response['usuario']['imagen']});
          }
        }
      },
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          Image.asset(
            'assets/logo.png',
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
              style: TextStyle(color: Colors.white),
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
            //   style: TextStyle(color: Colors.white),
            //   decoration: _decorationText("Contraseña"),
            //   cursorColor: Colors.purple[100],
            // ),
            //Padilla
            child: Center(
              child: PasswordWplanner(
                // WP
                controller: passwordCtrl,
                suffixIcon: Icon(Icons.remove_red_eye,color: Colors.purple[100],),
                color: Colors.purple[100],
                iconColor: Colors.purple[100],
                iconColorSelect: Colors.white,
                inputStyle: TextStyle(color: Colors.white),
                hintStyle: TextStyle(color: Colors.purple[100]),
                autoFocus: false,
                hasFloatingPlaceholder: true,
                // pattern: r'.*[@$#.*].*',
                border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(width: 2.0, color: Colors.purple[100])),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(color: Colors.white)
                ),
              ),
            ),
            //FinPadilla
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(32.0, 20.0, 32.0, 1.0),
            child: TextButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
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
          SizedBox(
            height: 10,
          ),
          //Row(
          //children: <Widget>[
          //Padding(
          //padding: const EdgeInsets.fromLTRB(32.0, 20.0, 32.0, 4.0),
          //      child:
          /*          Expanded(
                                                  child: 
                                                  TextButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
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
                    onPressed: () {setState(() {
                      _index = 0;
                    }); },
                    child: Text('Login',style: TextStyle(fontSize: 12),)
                  ),*/
          //    ),
          //),
          //Padding(
          //padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 4.0),
          //child:
          //    Expanded(
          //                          child:
          TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
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
              onPressed: () {
                setState(() {
                  _index = 1;
                });
              },
              child: Text(
                'Registro',
                style: TextStyle(fontSize: 12),
              )),
          //),
          //),
          //],
          // )
        ],
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
                  image: Image.asset('assets/fondo.jpg').image,
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
                    height: 600,
                    child: Center(
                      child: IndexedStack(
                        index: _index,
                        children: <Widget>[
                          _authDataUser(context),
                          _registrarDataUser()
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
}

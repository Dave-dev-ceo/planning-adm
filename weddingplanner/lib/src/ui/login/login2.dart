import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingplanner/src/blocs/login/login_bloc.dart';
import 'package:weddingplanner/src/ui/home/home_admin.dart';

class LoginT extends StatefulWidget {
  
  @override
  _LoginTState createState() => _LoginTState();
}

class _LoginTState extends State<LoginT> {
  TextEditingController emailCtrl;

  TextEditingController passwordCtrl;

  BuildContext _ingresando;
  @override
  void initState() {
    super.initState();
    emailCtrl = new TextEditingController();
    passwordCtrl = new TextEditingController();
  }

  _decorationInput(){
    return InputDecoration(
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
    );
  }

  _meterialState(){
    return MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
          if (states.contains(MaterialState.hovered))
            return Colors.purple.withOpacity(0.04);
          if (states.contains(MaterialState.focused) ||
              states.contains(MaterialState.pressed))
            return Colors.purple.withOpacity(0.12);
          return null; // Defer to the widget's default.
      },
    );
  }

  void _showError(BuildContext context, String message) {
    Navigator.pop(_ingresando);
    final snackBar = SnackBar(
      content: Container(
        height: 30,
        child: Center(
          child: Text(message),
        ),
      ),
      backgroundColor: Colors.red,  
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _dialog(BuildContext context){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
       _ingresando = context;
          return AlertDialog(
            title: Text(
              "Iniciando sesión",
              textAlign: TextAlign.center,
            ),
            content: Image.asset('assets/logo.png',height: 100.0,width: 150.0,color: Colors.purple,),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
           
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.purple, 
          child: BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if(state is ErrorLogginState){
                _showError(context, state.message);
              }else if(state is LogginState){
                _dialog(context);
              }
              else if(state is LoggedState){
                Navigator.pop(_ingresando);
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => HomeAdmin()));
              }
            },
            child: BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                return Form(
                  child: Column(
                    children: <Widget>[
                      Padding(padding: const EdgeInsets.fromLTRB(32.0, 40.0, 32.0, 4.0),
                        child: TextFormField(
                          controller: emailCtrl,
                          style: TextStyle(color: Colors.white),
                                decoration: _decorationInput(),
                                  cursorColor: Colors.purple[100],
                                  
                        ),
                      ),
                      Padding(padding: const EdgeInsets.fromLTRB(32.0, 20.0, 32.0, 4.0),
                                child: TextFormField(
                                  controller: passwordCtrl,
                                  obscureText: true,
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  style: TextStyle(color: Colors.white),
                                  decoration: _decorationInput(),
                                  cursorColor: Colors.purple[100],
                                  
                        ),
                      ),
                      Padding(padding: const EdgeInsets.fromLTRB(32.0, 20.0, 32.0, 1.0),
                          child: TextButton(
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            overlayColor: _meterialState(),
                          ),
                          onPressed: () => loginBloc.add(LogginEvent(emailCtrl.text.trim(),passwordCtrl.text.trim())),
                          child: Text('Iniciar Sesión',style: TextStyle(fontSize: 17),)
                        ),
                      ),
                    ],
                  ),
                );
              }
            )
          )
        )
      )
    );
  }
}
//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:weddingplanner/src/models/item_model_preferences.dart';
import 'package:weddingplanner/src/resources/api_provider.dart';
class Login extends StatefulWidget {
  
  const Login({Key key}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  int _index = 0;
  ApiProvider api = new ApiProvider();
  TextEditingController  emailCtrl = new TextEditingController();
  TextEditingController  passwordCtrl = new TextEditingController();
  TextEditingController  emailRCtrl = new TextEditingController();
  TextEditingController  passwordRCtrl = new TextEditingController();
  TextEditingController  nombreRCtrl = new TextEditingController();
  SharedPreferencesT _sharedPreferences = new SharedPreferencesT();
  BuildContext _ingresando;
  bool _visible = true;
  @override
  void initState(){
    super.initState();
    _checkSession();
  }
  void _checkSession()async{
    bool sesion = await  _sharedPreferences.getSession();
    if(sesion){
      Navigator.pushNamed(context, '/dasboard');
    }
  }
  _registroPlanner() async{
    if(emailRCtrl.text == "" || emailRCtrl.text == null 
    || nombreRCtrl.text == "" || nombreRCtrl.text == null
    || passwordRCtrl.text == "" || passwordRCtrl.text == null){
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
            actions: <Widget>[TextButton(
              child: Text('Cerrar'),
              onPressed: () {
                //_index = 0;
                Navigator.of(context).pop();
              },
           ),
          ],
           
          );
        });
    }else{
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
              child: Image.asset('assets/logo.png',height: 100.0,width: 150.0,color: Colors.purple,)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
           
          );
        });
        Map <String,String> json = {
          "nombre_completo":nombreRCtrl.text,
       "correo":emailRCtrl.text,
       "contrasena":passwordRCtrl.text
      };
    int response = await api.registroPlanner(json);
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
            actions: <Widget>[TextButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
           ),
          ],
           
          );
        });
      
      //Navigator.pushNamed(context, '/dasboard');  
      } else if(response == 1){
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
            actions: <Widget>[TextButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
           ),
          ],
           
          );
        });
      }else if(response == 2){
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
            actions: <Widget>[TextButton(
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
  _login() async{
    if(emailCtrl.text == "" || emailCtrl.text == null 
    || passwordCtrl.text == "" || passwordCtrl.text == null){
      showDialog(
        context: context,
        //barrierDismissible: false,
        builder: (BuildContext context) {
       //_ingresando = context;
          return AlertDialog(
            title: Text(
              "Acceso",
              textAlign: TextAlign.center,
            ),
            content: Text('Favor de ingresar correo y contraseña'),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            actions: <Widget>[TextButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
           ),
          ],
           
          );
        });
    }else{
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
            content: AnimatedOpacity(
              duration: Duration(milliseconds: 500),
              opacity: _visible ? 1.0 : 0.0,
              child: Image.asset('assets/logo.png',height: 100.0,width: 150.0,color: Colors.purple,)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
           
          );
        });

    Map <String,String> json = {
       "correo":emailCtrl.text,
       "contrasena":passwordCtrl.text
      };
    int response = await api.loginPlanner(json);
    if (response == 0) {
      Navigator.pop(_ingresando);
      Navigator.pushNamed(context, '/dasboard');  
      } else if(response == 1){
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
            content: Text('Correo o contraseña incorrectos'),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            actions: <Widget>[TextButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
           ),
          ],
           
          );
        });
      }else if(response == 2){
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
            content: Text('No se pudo iniciar sesión vuelva a intentarlo'),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            actions: <Widget>[TextButton(
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
  _registrarDataUser(){
    return Column(
      children: <Widget>[
        SizedBox(height: 10.0,),
        Image.asset('assets/logo.png',height: 180.0,width: 450,),
        SizedBox(height: 10.0,),
        Padding(padding: const EdgeInsets.fromLTRB(32.0, 40.0, 32.0, 4.0),
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
        Padding(padding: const EdgeInsets.fromLTRB(32.0, 20.0, 32.0, 4.0),
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
        Padding(padding: const EdgeInsets.fromLTRB(32.0, 20.0, 32.0, 4.0),
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
            onPressed: () { _registroPlanner();},
            child: Text('Registrarse',style: TextStyle(fontSize: 17),)
          ),
        ),
        SizedBox(height: 10,),
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
                onPressed: () {setState(() {
                  _index = 0;
                }); },
                child: Text('Acceso',style: TextStyle(fontSize: 12),)
              ),
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
  _authDataUser(){
    return Column(
      children: <Widget>[
        SizedBox(height: 10.0,),
        Image.asset('assets/logo.png',height: 180.0,width: 450,),
        SizedBox(height: 10.0,),
        Padding(padding: const EdgeInsets.fromLTRB(32.0, 40.0, 32.0, 4.0),
                  child: TextFormField(
                    controller: emailCtrl,
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
        Padding(padding: const EdgeInsets.fromLTRB(32.0, 20.0, 32.0, 4.0),
                  child: TextFormField(
                    controller: passwordCtrl,
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
          padding: const EdgeInsets.fromLTRB(32.0, 20.0, 32.0, 1.0),
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
            onPressed: () { _login();},
            child: Text('Iniciar Sesión',style: TextStyle(fontSize: 17),)
          ),
        ),
        SizedBox(height: 10,),
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
                onPressed: () {setState(() {
                  _index = 1;
                }); },
                child: Text('Registro',style: TextStyle(fontSize: 12),)
              ),
                      //),
            //),  
          //],
       // )
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    double heightA = MediaQuery.of(context).size.height;
    return SafeArea(
      child: 
      Scaffold(
        body: 
        Container(
            width: double.infinity,
            height: heightA<780?heightA=1024:heightA,
            decoration: BoxDecoration(image: DecorationImage(image: Image.asset('assets/fondo.jpg').image, fit: BoxFit.cover)),
            child: SingleChildScrollView(
                          child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 100.0,),
                    //Image.asset('assets/logo.png',height: 120.0,width: 170.0,),
                    SizedBox(height: 15.0,),
                    Container(
                        width: 370,
                        height: 600,
                        /*decoration: BoxDecoration(
                        //boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 30, offset: Offset(2, 2))],
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.0),
                        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
                          Colors.white.withOpacity(0.0),
                          Colors.white.withOpacity(0.0),
                        ], stops: [
                          0.0,
                          1.0,
                        ])),*/
                        child: Center(
                          child: 
                          //_authDataUser(),
                          IndexedStack(
          index: _index,
          children: <Widget>[ 
            _authDataUser(),
            _registrarDataUser()
          ],
        ),
                        ),
                        
                      ),
                    SizedBox(height: 130.0,)
                  ],
                ),
              ),
            ),
          ),
        ),
      );
           
  }
}

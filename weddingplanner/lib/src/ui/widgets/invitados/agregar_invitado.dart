import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:weddingplanner/src/resources/invitados_api_provider.dart';


class AgregarInvitados extends StatefulWidget {
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => AgregarInvitados(),
      );

  @override
  _AgregarInvitadosState createState() => _AgregarInvitadosState();
}

class _AgregarInvitadosState extends State<AgregarInvitados> {
GlobalKey<FormState> keyForm = new GlobalKey();

 TextEditingController  nombreCtrl = new TextEditingController();

 TextEditingController  emailCtrl = new TextEditingController();

 TextEditingController  apellidosCtrl = new TextEditingController();

 TextEditingController  telefonoCtrl = new TextEditingController();

 InvitadosApiProvider api = new InvitadosApiProvider();

Color hexToColor(String code) {
      return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
    }

/*_borderTextForm(){
  return OutlineInputBorder(
    borderRadius: new BorderRadius.circular(25.0),
    borderSide: new BorderSide(
    ),
  );
}*/

  @override
  Widget build(BuildContext context) {
    return 
        SingleChildScrollView(
          child: new Container(
            margin: new EdgeInsets.all(10.0),
            child: new Form(
              key: keyForm,
              child: formUI(),
            ),
          ),
        );
      /*SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SafeArea(
              child: Center(
                  //padding: EdgeInsets.symmetric(horizontal: 150.0),
                  child: FocusTraversalGroup(
                    child: Form(
                    key: _formKey,
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(top: 140.0)),
                        Text('Registro de invitado',style: new TextStyle(color: hexToColor("#8FCACB"), fontSize: 25.0),),
                        Padding(padding: EdgeInsets.only(top: 50.0)),
                        Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: ConstrainedBox(
                                constraints: BoxConstraints.tight(const Size(500,100)),
                                child: Wrap(
                                  children: <Widget>[
                                    TextFormField(
                                      decoration: new InputDecoration(
                                        labelText: "Ingresa el nombre",
                                        fillColor: Colors.white,
                                        border: _borderTextForm(),
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Falta nombre';
                                        }
                                      },
                                    ),
                                    //Padding(padding: EdgeInsets.only(top: 20.0)),
                                    TextFormField(
                                      decoration: new InputDecoration(
                                        labelText: "ingrese los apellidos",
                                        fillColor: Colors.white,
                                        border: _borderTextForm(),
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Faltan los apellidos';
                                        }
                                      },
                                    ),
                                    //Padding(padding: EdgeInsets.only(top: 20.0)),
                                    TextFormField(
                                      decoration: new InputDecoration(
                                        labelText: "ingrese el email",
                                        fillColor: Colors.white,
                                        border: _borderTextForm(),
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Falta email';
                                        }
                                      },
                                    ),
                                    //Padding(padding: EdgeInsets.only(top: 20.0)),
                                    TextFormField(
                                      decoration: new InputDecoration(
                                        labelText: "ingrese número telefónico",
                                        fillColor: Colors.white,
                                        border: _borderTextForm(),
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Falta número telefónico';
                                        }
                                      },
                                    ),
                                    Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: 
                          RaisedButton.icon(
                            
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                Scaffold.of(context)
                                    .showSnackBar(SnackBar(content: Text('Processing Data')));
                              }
                            },
                            icon: Icon(Icons.send),
                            label: Text("Registrar invitado", style: new TextStyle(fontSize: 25.0),),
                            
                          ),
                        ),
                                  ],
                                ),
                              ),
                            ),    
                          ],
                        ),
                        
                      ],
                    ),
                  ),
                )
              )
            )
          ],
        ),
      )*/ 
  }

  formItemsDesign(icon, item) {
   return Padding(
     padding: EdgeInsets.symmetric(vertical: 7),
     child: Card(child: ListTile(leading: Icon(icon), title: item)),
   );
 }

 String gender = 'H';

 Widget formUI() {
   return  Column(
     children: <Widget>[
       formItemsDesign(
           Icons.person,
           TextFormField(
             controller: nombreCtrl,
             decoration: new InputDecoration(
               labelText: 'Nombre',
             ),
             validator: validateNombre,
           )),
       formItemsDesign(
           Icons.rowing,
           TextFormField(
             controller: apellidosCtrl,
               decoration: new InputDecoration(
                 labelText: 'Apellidos',
               ),
               validator: validateApellidos,)),
       formItemsDesign(
           null,
           Column(children: <Widget>[
             Text("Genero"),
             RadioListTile<String>(
               title: const Text('Hombre'),
               value: 'H',
               groupValue: gender,
               onChanged: (value) {
                 setState(() {
                   gender = value;
                 });
               },
             ),
             RadioListTile<String>(
               title: const Text('Mujer'),
               value: 'M',
               groupValue: gender,
               onChanged: (value) {
                 setState(() {
                   gender = value;
                 });
               },
             )
           ])),
       formItemsDesign(
           Icons.email,
           TextFormField(
             controller: emailCtrl,
               decoration: new InputDecoration(
                 labelText: 'Email',
               ),
               keyboardType: TextInputType.emailAddress,
               maxLength: 32,
               validator: validateEmail,)),
       formItemsDesign(
          Icons.phone,
           TextFormField(
             controller: telefonoCtrl,
               decoration: new InputDecoration(
                 labelText: 'Numero de telefono',
               ),
               keyboardType: TextInputType.phone,
               maxLength: 10,
               validator: validateTelefono,)),
   GestureDetector(
   onTap: (){
     save();
   },child: Container(
         margin: new EdgeInsets.all(30.0),
         alignment: Alignment.center,
         decoration: ShapeDecoration(
           shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(30.0)),
           gradient: LinearGradient(colors: [
             Color(0xFF0EDED2),
             Color(0xFF03A0FE),
           ],
               begin: Alignment.topLeft, end: Alignment.bottomRight),
         ),
         child: Text("Guardar",
             style: TextStyle(
                 color: Colors.white,
                 fontSize: 18,
                 fontWeight: FontWeight.w500)),
         padding: EdgeInsets.only(top: 16, bottom: 16),
       ))
     ],
   );
 }
  String validateApellidos(String value) {
   String pattern = r"[a-zA-ZñÑáéíóúÁÉÍÓÚ\s]+";
   RegExp regExp = new RegExp(pattern);
   if (value.length == 0) {
     return "El apellido es necesario";
   } else if (!regExp.hasMatch(value)) {
     return "El apellido debe de ser a-z y A-Z";
   }
   return null;
 }

 String validateNombre(String value) {
   String pattern = r"[a-zA-ZñÑáéíóúÁÉÍÓÚ\s]+";
   RegExp regExp = new RegExp(pattern);
   if (value.length == 0) {
     return "El nombre es necesario";
   } else if (!regExp.hasMatch(value)) {
     return "El nombre debe de ser a-z y A-Z";
   }
   return null;
 }

 String validateTelefono(String value) {
   String patttern = r'(^[0-9]*$)';
   RegExp regExp = new RegExp(patttern);
   if (value.length == 0) {
     return "El telefono es necesario";
   } else if (value.length != 10) {
     return "El numero debe tener 10 digitos";
   }else if (!regExp.hasMatch(value)) {
     return "El numero debe ser de 0-9";
   }
   return null;
 }

 String validateEmail(String value) {
   String pattern =
       r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
   RegExp regExp = new RegExp(pattern);
   if (value.length == 0) {
     return "El correo es necesario";
   } else if (!regExp.hasMatch(value)) {
     return "Correo invalido";
   } else {
     return null;
   }
 }

 save() async{
   if (keyForm.currentState.validate()) {
     
     Map <String,String> json = {
       "nombre":nombreCtrl.text,
       "apellidos":apellidosCtrl.text,
       "telefono":telefonoCtrl.text,
       "email":emailCtrl.text,
       "genero":gender,
      "id_evento":"1"
      };
     //json.
     bool response = await api.createInvitados(json);

     //bloc.insertInvitados;
      //print(response);
      if (response) {
        keyForm.currentState.reset();
        final snackBar = SnackBar(
            content: Container(
              height: 30,
              child: Center(
              child: Text('Invitado registrado'),
            ),
              //color: Colors.red,
            ),
            backgroundColor: Colors.green,  
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);  
      } else {
        final snackBar = SnackBar(
          content: Container(
            height: 30,
            child: Center(
            child: Text('Error: No se pudo realizar el registro'),
          ),
            //color: Colors.red,
          ),
          backgroundColor: Colors.red,  
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      
   }
 }
}
import 'package:flutter/material.dart';
import 'package:weddingplanner/src/resources/api_provider.dart';
import 'package:weddingplanner/src/resources/my_flutter_app_icons.dart';
import 'package:weddingplanner/src/ui/widgets/call_to_action/call_to_action.dart';
class FullScreenDialogEdit extends StatefulWidget {
  //final int id;

  const FullScreenDialogEdit({Key key}) : super(key: key);
  @override
  _FullScreenDialogEditState createState() => _FullScreenDialogEditState();
}

class _FullScreenDialogEditState extends State<FullScreenDialogEdit> {
  ApiProvider api = new ApiProvider();
  //final int id;
  
  GlobalKey<FormState> keyForm = new GlobalKey();

  TextEditingController  nombreCtrl = new TextEditingController();

  TextEditingController  emailCtrl = new TextEditingController();

  //TextEditingController  apellidosCtrl = new TextEditingController();

  TextEditingController  telefonoCtrl = new TextEditingController();


  String dropdownValue = 'Hombre';

 //_FullScreenDialogEditState(this.id);
  
  _dropDownGenero(){
    return DropdownButton(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_drop_down_outlined),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.pink),
      underline: Container(
        height: 2,
        color: Colors.pink,
      ),
      onChanged: (newValue) {
        setState(() {
            dropdownValue = newValue;
        });
      },
      items: <String>['Hombre', 'Mujer'].map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item, style: TextStyle(fontSize: 18),),
        );
      }).toList(),
    );
  }
 String gender = 'H';
formItemsDesign(icon, item, large) {
   return Padding(
     padding: EdgeInsets.symmetric(vertical: 3),
     child: Container(child: Card(child: ListTile(leading: Icon(icon), title: item)), width: large,),
   );
  }
  Widget formUI() {
    String nombre = "Victor Maunel Sanchez Rodriguez";
   return  Column(
     children: <Widget>[
       Wrap(
         children:<Widget>[
           
            formItemsDesign(
           Icons.person,
           TextFormField(
             controller: nombreCtrl,
             decoration: new InputDecoration(
               labelText: 'Nombre completo',
             ),
             validator: validateNombre,
           ),500.0),
       formItemsDesign(
           MyFlutterApp.transgender,
           Row(
             children: <Widget>[
               Text('Genero'),
               SizedBox(width: 15,),
                      _dropDownGenero(),
             ],),
             500.0
             )
            //Container(width: 300,child: TextFormField(initialValue: nombre,decoration: InputDecoration(labelText: 'Nombre'))),
         ]
       ),
      GestureDetector(
        onTap: (){
          save();
        },
        child: 
        CallToAction('Guardar')
      )
     ] 
   );
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
     if(dropdownValue == "Hombre"){
       gender = "H";
     }else if(dropdownValue == "Mujer"){
       gender = "M";
     }
     Map <String,String> json = {
       "nombre":nombreCtrl.text,
       "telefono":telefonoCtrl.text,
       "email":emailCtrl.text,
       "genero":gender,
      //"id_evento":id.toString()
      };
     //json.
     bool response = await api.createInvitados(json);

     //bloc.insertInvitados;
      //print(response);
      if (response) {
        keyForm.currentState.reset();
        nombreCtrl.clear();
        telefonoCtrl.clear();
        emailCtrl.clear();
        dropdownValue = "Hombre";
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
    @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        appBar: AppBar(
          title: Text('Editar Invitado'),
          automaticallyImplyLeading: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            alignment: Alignment.center,
                      //child: Expanded(
                                              child: 
                                              new Container(
              width: 1200,
              margin: new EdgeInsets.all(10.0),
              child: new Form(
                key: keyForm,
                child: formUI(),
              ),
            ),
                      ),
          //),
        )
    );
  }
}
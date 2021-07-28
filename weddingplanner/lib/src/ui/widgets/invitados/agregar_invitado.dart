import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:weddingplanner/src/resources/api_provider.dart';
import 'package:weddingplanner/src/ui/widgets/call_to_action/call_to_action.dart';
import '../../../resources/my_flutter_app_icons.dart';

class AgregarInvitados extends StatefulWidget {
  final int id;

  const AgregarInvitados({Key key, this.id}) : super(key: key);
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => AgregarInvitados(),
      );

  @override
  _AgregarInvitadosState createState() => _AgregarInvitadosState(id);
}

class _AgregarInvitadosState extends State<AgregarInvitados> {
  final int id;
  GlobalKey<FormState> keyForm = new GlobalKey();

  TextEditingController nombreCtrl = new TextEditingController();

  TextEditingController emailCtrl = new TextEditingController();

  //TextEditingController  apellidosCtrl = new TextEditingController();

  TextEditingController telefonoCtrl = new TextEditingController();

  ApiProvider api = new ApiProvider();

  String dropdownValue = 'Hombre';

  _AgregarInvitadosState(this.id);

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
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        //child: Expanded(
        child: new Container(
          width: 800,
          margin: new EdgeInsets.all(10.0),
          child: new Form(
            key: keyForm,
            child: formUI(),
          ),
        ),
      ),
      //),
    );
  }

  formItemsDesign(icon, item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7),
      child: Card(child: ListTile(leading: Icon(icon), title: item)),
    );
  }

  _dropDown2() {
    return DropdownButton(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_drop_down_outlined),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Color(0xFF000000)),
      underline: Container(
        height: 2,
        color: Color(0xFF000000),
      ),
      onChanged: (newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <String>['Hombre', 'Mujer'].map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(
            item,
            style: TextStyle(fontSize: 18),
          ),
        );
      }).toList(),
    );
  }

  String gender = 'H';

  Widget formUI() {
    return Column(
      children: <Widget>[
        formItemsDesign(
            Icons.person,
            TextFormField(
              controller: nombreCtrl,
              decoration: new InputDecoration(
                labelText: 'Nombre completo',
              ),
              validator: validateNombre,
            )),
        formItemsDesign(
            MyFlutterApp.transgender,
            Row(
              children: <Widget>[
                Text('Genero'),
                SizedBox(
                  width: 50,
                ),
                _dropDown2(),
              ],
            )
            /*Row(
             children: <Widget>[
               Column(
                  children: <Widget>[
                      Text('genero'),
                      _dropDown2(),
                  ],
                ),
                Column(
             children: <Widget>[
                Text('genero'),
                _dropDown2(),
             ],
           )
             ],)*/

            /*Column(children: <Widget>[
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
           ])*/
            ),
        formItemsDesign(
            Icons.email,
            TextFormField(
              controller: emailCtrl,
              decoration: new InputDecoration(
                labelText: 'Correo',
              ),
              keyboardType: TextInputType.emailAddress,
              maxLength: 32,
              validator: validateEmail,
            )),
        formItemsDesign(
            Icons.phone,
            TextFormField(
              controller: telefonoCtrl,
              decoration: new InputDecoration(
                labelText: 'Teléfono',
              ),
              keyboardType: TextInputType.phone,
              maxLength: 10,
              validator: validateTelefono,
            )),
        GestureDetector(
            onTap: () {
              save();
            },
            child: CallToAction('Guardar'))
      ],
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
    } else if (!regExp.hasMatch(value)) {
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

  save() async {
    if (keyForm.currentState.validate()) {
      if (dropdownValue == "Hombre") {
        gender = "H";
      } else if (dropdownValue == "Mujer") {
        gender = "M";
      }
      Map<String, String> json = {
        "nombre": nombreCtrl.text,
        "telefono": telefonoCtrl.text,
        "email": emailCtrl.text,
        "genero": gender,
        "id_evento": id.toString()
      };
      //json.
      bool response = await api.createInvitados(json, context);

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
}

// ignore_for_file: no_logic_in_create_state

import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:planning/src/resources/api_provider.dart';
import 'package:planning/src/ui/widgets/call_to_action/call_to_action.dart';
import 'package:planning/src/ui/widgets/snackbar_widget/snackbar_widget.dart';

class AgregarInvitados extends StatefulWidget {
  final int? id;

  const AgregarInvitados({Key? key, this.id}) : super(key: key);
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => const AgregarInvitados(),
      );

  @override
  _AgregarInvitadosState createState() => _AgregarInvitadosState(id);
}

class _AgregarInvitadosState extends State<AgregarInvitados> {
  final int? id;
  GlobalKey<FormState> keyForm = GlobalKey();

  TextEditingController nombreCtrl = TextEditingController();

  TextEditingController emailCtrl = TextEditingController();

  //TextEditingController  apellidosCtrl = new TextEditingController();

  TextEditingController telefonoCtrl = TextEditingController();
  TextEditingController numeroAcomp = TextEditingController();

  ApiProvider api = ApiProvider();

  int acompanantes = 0;

  String dropdownValue = 'Hombre';

  _AgregarInvitadosState(this.id);

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

/*_borderTextForm(){
  return OutlineInputBorder(
    borderRadius: new BorderRadius.circular(25.0),
    borderSide: new BorderSide(
    ),
  );
}*/
  late FlCountryCodePicker countryPicker;
  late CountryCode countryCode;

  @override
  void initState() {
    numeroAcomp.text = '0';
    countryCode = CountryCode(name: 'MX', code: 'México', dialCode: '+52');

    countryPicker = FlCountryCodePicker(
      searchBarDecoration:
          InputDecoration(labelText: 'País, Clave o Clave LADA'),
      title: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Selecciona tu país',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        //child: Expanded(
        child: Container(
          width: 800,
          margin: const EdgeInsets.all(10.0),
          child: Form(
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
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Card(child: ListTile(leading: Icon(icon), title: item)),
    );
  }

  Widget formUI() {
    return Column(
      children: <Widget>[
        formItemsDesign(
            Icons.person,
            TextFormField(
              controller: nombreCtrl,
              decoration: const InputDecoration(
                labelText: 'Nombre completo',
              ),
              validator: validateNombre,
            )),
        formItemsDesign(
            Icons.email,
            TextFormField(
              controller: emailCtrl,

              decoration: const InputDecoration(
                labelText: 'Correo',
              ),
              keyboardType: TextInputType.emailAddress,
              maxLength: 32,
              // validator: validateEmail,
            )),
        formItemsDesign(
          Icons.phone,
          TextFormField(
            controller: telefonoCtrl,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              labelText: 'Teléfono',
              prefix: GestureDetector(
                onTap: () async {
                  // Show the country code picker when tapped.
                  final code = await countryPicker.showPicker(context: context);
                  // Null check
                  if (code != null) {
                    setState(() {
                      countryCode = code;
                    });
                  }
                },
                child: Tooltip(
                  message: 'Seleccionar',
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4.0, vertical: 4.0),
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                        border: Border.all(
                          color: Colors.black,
                        )),
                    child: Text(
                      countryCode.dialCode,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
            keyboardType: TextInputType.phone,
            maxLength: 10,
            //validator: validateTelefono,
          ),
        ),
        //formItemsDesign(
        //    Icons.people,
        //    ListTile(
        //      title: TextFormField(
        //        controller: numeroAcomp,
        //        enabled: false,
        //        decoration: const InputDecoration(
        //          labelText: 'Número de acompañantes',
        //          contentPadding: EdgeInsets.symmetric(
        //            vertical: 2.0,
        //          ),
        //        ),
        //        keyboardType: TextInputType.number,
        //        maxLength: 3,
        //        validator: validarNumAcomp,
        //      ),
        //      trailing: Row(
        //        mainAxisSize: MainAxisSize.min,
        //        children: [
        //          IconButton(
        //              onPressed: () {
        //                setState(() {
        //                  if (acompanantes > 0) {
        //                    acompanantes--;
        //                    numeroAcomp.text = acompanantes.toString();
        //                  }
        //                });
        //              },
        //              icon: const Icon(Icons.keyboard_arrow_down)),
        //          IconButton(
        //              onPressed: () {
        //                setState(() {
        //                  acompanantes++;
        //                  numeroAcomp.text = acompanantes.toString();
        //                });
        //              },
        //              icon: const Icon(Icons.keyboard_arrow_up))
        //        ],
        //      ),
        //    )),
        GestureDetector(
            onTap: () {
              save();
            },
            child: const CallToAction('Guardar'))
      ],
    );
  }

  String? validarNumAcomp(String value) {
    if (value == null || int.parse(value) < 0) {
      return 'El número de invitados es requerido';
    } else {
      return null;
    }
  }

  String? validateNombre(String? value) {
    String pattern = r"[a-zA-ZñÑáéíóúÁÉÍÓÚ\s]+";
    RegExp regExp = RegExp(pattern);
    if (value!.isEmpty) {
      return "El nombre es necesario";
    } else if (!regExp.hasMatch(value)) {
      return "El nombre debe de ser a-z y A-Z";
    }
    return null;
  }

  String? validateTelefono(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = RegExp(patttern);
    if (value.isEmpty) {
      return "El teléfono es necesario";
    } else if (value.length != 10) {
      return "El número debe tener 10 dígitos";
    } else if (!regExp.hasMatch(value)) {
      return "El número debe ser de 0-9";
    }
    return null;
  }

  String? validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return "El correo es necesario";
    } else if (!regExp.hasMatch(value)) {
      return "Correo inválido";
    } else {
      return null;
    }
  }

  save() async {
    if (keyForm.currentState!.validate()) {
      Map<String, String> json = {
        "nombre": nombreCtrl.text,
        "telefono": telefonoCtrl.text,
        "email": emailCtrl.text,
        "numeroAcomp": numeroAcomp.text,
        "id_evento": id.toString(),
        'codigo_pais': countryCode.dialCode,
      };
      //json.
      bool response = (await api.createInvitados(json, context))!;

      //bloc.insertInvitados;
      if (response) {
        keyForm.currentState!.reset();
        nombreCtrl.clear();
        telefonoCtrl.clear();
        emailCtrl.clear();
        numeroAcomp.text = '0';
        dropdownValue = "Hombre";
        MostrarAlerta(
            mensaje: 'Invitado registrado', tipoMensaje: TipoMensaje.correcto);
      } else {
        MostrarAlerta(
            mensaje: 'Error: No se pudo realizar el registro',
            tipoMensaje: TipoMensaje.error);
      }
    }
  }
}

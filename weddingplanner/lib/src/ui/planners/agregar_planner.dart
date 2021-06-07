import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingplanner/src/blocs/paises/paises_bloc.dart';
import 'package:weddingplanner/src/models/item_model_paises.dart';
import 'package:weddingplanner/src/ui/widgets/call_to_action/call_to_action.dart';

class AgregarPlanners extends StatefulWidget {
  const AgregarPlanners({Key key}) : super(key: key);
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => AgregarPlanners(),
      );

  @override
  _AgregarPlannersState createState() => _AgregarPlannersState();
}

class _AgregarPlannersState extends State<AgregarPlanners> {
  PaisesBloc paisesBloc;
  ItemModelPaises itemModelPaises;
  //final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    paisesBloc = BlocProvider.of<PaisesBloc>(context);
    paisesBloc.add(FechtPaisesEvent());
    super.initState();
  }

  String _mySelectionP = "0";
  GlobalKey<FormState> keyForm = new GlobalKey();

  TextEditingController nombreCtrl = new TextEditingController();

  TextEditingController emailCtrl = new TextEditingController();

  TextEditingController telefonoCtrl = new TextEditingController();

  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  _dropDownPaises(ItemModelPaises paises) {
    return DropdownButton(
      value: _mySelectionP,
      icon: const Icon(Icons.arrow_drop_down_outlined),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Color(0xFF880B55)),
      underline: Container(
        height: 2,
        color: Color(0xFF880B55),
      ),
      onChanged: (newValue) {
        setState(() {
          _mySelectionP = newValue;
        });
      },
      items: paises.results.map((item) {
        return DropdownMenuItem(
          value: item.idPais.toString(),
          child: Text(
            item.pais,
            style: TextStyle(fontSize: 18),
          ),
        );
      }).toList(),
    );
  }

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

  /*Widget formUI() {
    return BlocBuilder<PaisesBloc, PaisesState>(
        builder: (context, state) {
          if(state is PaisesInitialState){
                return Center(child: CircularProgressIndicator());
              }else if(state is LoadingPaisesState) {
                return Center(child: CircularProgressIndicator());
              }else if (state is MostrarPaisesState){
                itemModelPaises = state.paises;
                return Column(
                  children: <Widget>[
                    formItemsDesign(
                        Icons.person,
                        TextFormField(
                          controller: nombreCtrl,
                          decoration: new InputDecoration(
                            labelText: 'Empresa',
                          ),
                          validator: validateNombre,
                        )),
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
                    formItemsDesign(
                        Icons.phone,
                        Row(
                          children: <Widget>[
                            Text('País'),
                            SizedBox(
                              width: 15,
                            ),
                            _dropDownPaises(state.paises),
                          ],
                        )),
                    GestureDetector(
                        onTap: () {
                          save();
                        },
                        child: CallToAction('Guardar'))
                  ],
                );
              }else if (state is ErrorListaPaisesState){
                return Center(child: Text(state.message),);
                //_showError(context, state.message);
              }else{
                return Center(child: CircularProgressIndicator());
              }
        },
      );
  }*/
  Widget formUI() {
    return Column(
      children: <Widget>[
        formItemsDesign(
            Icons.person,
            TextFormField(
              controller: nombreCtrl,
              decoration: new InputDecoration(
                labelText: 'Empresa',
              ),
              validator: validateNombre,
            )),
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
            Container(
              child: BlocBuilder<PaisesBloc, PaisesState>(
                builder: (context, state) {
                  if(state is PaisesInitialState){
                        return Center(child: CircularProgressIndicator());
                      }else if(state is LoadingPaisesState) {
                        return Center(child: CircularProgressIndicator());
                      }else if (state is MostrarPaisesState){
                        itemModelPaises = state.paises;
                        return formItemsDesign(
                          Icons.phone,
                          Row(
                            children: <Widget>[
                              Text('País'),
                              SizedBox(
                                width: 15,
                              ),
                              _dropDownPaises(state.paises),
                            ],
                          ));
                      }else if (state is ErrorListaPaisesState){
                        return Center(child: Text(state.message),);
                        //_showError(context, state.message);
                      }else{
                        return Center(child: CircularProgressIndicator());
                      }
                },
              )
    ),
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
      Map<String, String> json = {
        "nombre_empresa": nombreCtrl.text,
        "telefono": telefonoCtrl.text,
        "email": emailCtrl.text
      };
    }
  }
}

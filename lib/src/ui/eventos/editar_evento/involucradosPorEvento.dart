import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingplanner/src/blocs/involucrados/involucrados_bloc.dart';

class InvolucradosPorEvento extends StatefulWidget {
  const InvolucradosPorEvento({Key key}) : super(key: key);

  @override
  _InvolucradosPorEventoState createState() => _InvolucradosPorEventoState();
}

class _InvolucradosPorEventoState extends State<InvolucradosPorEvento> {
  // variables bloc
  InvolucradosBloc involucradosBloc;

  // variables class
  bool saveShow = false;
  Involucrado item = Involucrado(
    idInvolucrado: 0,
    nombre: '',
    email: '',
    telefono: ''
  );

  @override
  void initState() {
    super.initState();
    involucradosBloc = BlocProvider.of<InvolucradosBloc>(context);
    involucradosBloc.add(SelectInvolucrado());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvolucradosBloc,InvolucradosState>(
      builder: (context, state) {
        if(state is InvolucradosInitial) {
          return Center(child: CircularProgressIndicator(),);
        } else if(state is InvolucradosLogging) {
          return Center(child: CircularProgressIndicator(),);
        } else if(state is InvolucradosSelect) {
          if(state.autorizacion.contrato.length > 0) {
            item = Involucrado(
              idInvolucrado:state.autorizacion.contrato[0].idInvolucrado,
              nombre:state.autorizacion.contrato[0].nombreCompleto,
              email:state.autorizacion.contrato[0].email,
              telefono:state.autorizacion.contrato[0].telefono
            );
          } else {
            item = Involucrado(
              idInvolucrado:0,
              nombre:'',
              email:'',
              telefono:''
            );
          }
          return viewForm();
        } else if(state is InvolucradosInsert) {
          if(state.autorizacion.contrato.length > 0) {
            item = Involucrado(
              idInvolucrado:state.autorizacion.contrato[0].idInvolucrado,
              nombre:state.autorizacion.contrato[0].nombreCompleto,
              email:state.autorizacion.contrato[0].email,
              telefono:state.autorizacion.contrato[0].telefono
            );
          }
          return viewForm();
        } else {
          return Center(child: CircularProgressIndicator(),);
        }
      },
    );
  }

  Widget viewForm() {
    return  Container(
      child: Column(
        children: <Widget>[
          formItemsDesign(
              Icons.person,
              TextFormField(
                controller: TextEditingController(text: item.nombre),
                decoration: new InputDecoration(
                  labelText: 'Nombre',
                ),
                onChanged: (valor) {
                  item.nombre = valor;
                },
              ),
              500.0,
              80.0),
          formItemsDesign(
              Icons.phone,
              TextFormField(
                controller: TextEditingController(text: item.telefono),
                decoration: new InputDecoration(
                  labelText: 'Teléfono',
                ),
                onChanged: (valor) {
                  item.telefono = valor;
                },
              ),
              500.0,
              80.0),
          formItemsDesign(
              Icons.email,
              TextFormField(
                controller: TextEditingController(text: item.email),
                decoration: new InputDecoration(
                  labelText: 'Correo',
                ),
                onChanged: (valor) {
                  item.email = valor;
                },
              ),
              500.0,
              80.0),
          SizedBox(height: 30.0,),
          IconButton(
            icon: Icon(Icons.save),
            color: Colors.black,
            onPressed: () => validaTodo(),
          ),
          SizedBox(height: 30.0,),
        ],
      ),
    );
  }

  formItemsDesign(icon, item, large, ancho) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3),
      child: Container(
        child: Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), elevation: 10, child: ListTile(leading: Icon(icon), title: item)),
        width: large,
        height: ancho,
      ),
    );
  }

  bool validateNombre(String value) {
    String pattern = r"[a-zA-ZñÑáéíóúÁÉÍÓÚ\s]+";
    RegExp regExp = new RegExp(pattern);
    if (value.length < 10) {
      return false;
    } else if (!regExp.hasMatch(value)) {
      return false;
    }
    return true;
  }

  bool validateCorreo(String value) {
    RegExp regExp = new RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if (value.length == 0) {
      return false;
    } else if (!regExp.hasMatch(value)) {
      return false;
    } else {
      return true;
    }
  }

  bool validateTelefono(String value) {
    RegExp regExp = new RegExp(r'^(?:[+0][1-9])?[0-9]{10,12}$');
    if (value.length == 0) {
      return false;
    } else if (!regExp.hasMatch(value)) {
      return false;
    } else {
      return true;
    }
  }

  validaTodo() {
    if(validateNombre(item.nombre) && validateCorreo(item.email) && validateTelefono(item.telefono)) {
      involucradosBloc.add(InsertInvolucrado(item));
      _mensaje('Involucrado actualizado.');
    } else if(!validateNombre(item.nombre)) {
      _mensaje('Inserta un nombre valido.');
    } else if(!validateTelefono(item.telefono)) {
      _mensaje('Inserta un telefono valido.');
    } else if(!validateCorreo(item.email)) {
      _mensaje('Inserta un correo electronico valido.');
    } else {
      _mensaje('Inserta valores validos.');
    }
  }

  // mensaje
  Future<void> _mensaje(String txt) async {
    return await ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(txt),
      )
    );
  }
}

class Involucrado {
  int idInvolucrado;
  String nombre;
  String email;
  String telefono;

  Involucrado({
    this.idInvolucrado,
    this.nombre,
    this.email,
    this.telefono
  });

  // solucion al enviar objetos al servidor
  Map<String, dynamic> toJson() =>{
    'id_involucrado':idInvolucrado,
    'nombre_completo':nombre,
    'email':email,
    'telefono':telefono,
  };
}

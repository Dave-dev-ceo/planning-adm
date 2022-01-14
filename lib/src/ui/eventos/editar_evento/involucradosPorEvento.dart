import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/blocs/involucrados/involucrados_bloc.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/ui/widgets/snackbar_widget/snackbar_widget.dart';

class InvolucradosPorEvento extends StatefulWidget {
  const InvolucradosPorEvento({Key key}) : super(key: key);

  @override
  _InvolucradosPorEventoState createState() => _InvolucradosPorEventoState();
}

class _InvolucradosPorEventoState extends State<InvolucradosPorEvento> {
  // variables bloc
  InvolucradosBloc involucradosBloc;

  // Variable involucrado
  bool isInvolucrado = false;

  // variables class
  bool saveShow = false;
  Involucrado item =
      Involucrado(idInvolucrado: 0, nombre: '', email: '', telefono: '');

  @override
  void initState() {
    super.initState();
    involucradosBloc = BlocProvider.of<InvolucradosBloc>(context);
    involucradosBloc.add(SelectInvolucrado());
    getIdInvolucrado();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvolucradosBloc, InvolucradosState>(
      builder: (context, state) {
        if (state is InvolucradosInitial) {
          return Center(
            child: LoadingCustom(),
          );
        } else if (state is InvolucradosLogging) {
          return Center(
            child: LoadingCustom(),
          );
        } else if (state is InvolucradosSelect) {
          if (state.autorizacion.contrato.length > 0) {
            item = Involucrado(
                idInvolucrado: state.autorizacion.contrato[0].idInvolucrado,
                nombre: state.autorizacion.contrato[0].nombreCompleto,
                email: state.autorizacion.contrato[0].email,
                telefono: state.autorizacion.contrato[0].telefono);
          } else {
            item = Involucrado(
                idInvolucrado: 0, nombre: '', email: '', telefono: '');
          }
          return viewForm();
        } else if (state is InvolucradosInsert) {
          if (state.autorizacion.contrato.length > 0) {
            item = Involucrado(
                idInvolucrado: state.autorizacion.contrato[0].idInvolucrado,
                nombre: state.autorizacion.contrato[0].nombreCompleto,
                email: state.autorizacion.contrato[0].email,
                telefono: state.autorizacion.contrato[0].telefono);
          }
          return viewForm();
        } else {
          return Center(
            child: LoadingCustom(),
          );
        }
      },
    );
  }

  void getIdInvolucrado() async {
    final _idInvolucrado = await SharedPreferencesT().getIdInvolucrado();

    if (_idInvolucrado != null) {
      isInvolucrado = true;
    }
  }

  Widget viewForm() {
    return Container(
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
          SizedBox(
            height: 30.0,
          ),
          !isInvolucrado
              ? IconButton(
                  icon: Icon(Icons.save),
                  color: Colors.black,
                  onPressed: () => validaTodo(),
                )
              : Text(''),
          SizedBox(
            height: 30.0,
          ),
        ],
      ),
    );
  }

  formItemsDesign(icon, item, large, ancho) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3),
      child: Container(
        child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 10,
            child: ListTile(leading: Icon(icon), title: item)),
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
    if (validateNombre(item.nombre) &&
        validateCorreo(item.email) &&
        validateTelefono(item.telefono)) {
      involucradosBloc.add(InsertInvolucrado(item));
      MostrarAlerta(
          mensaje: 'Involucrado actualizado.',
          tipoMensaje: TipoMensaje.correcto);
    } else if (!validateNombre(item.nombre)) {
      MostrarAlerta(
          mensaje: 'Inserta un nombre valido.',
          tipoMensaje: TipoMensaje.advertencia);
    } else if (!validateTelefono(item.telefono)) {
      MostrarAlerta(
          mensaje: 'Inserta un telefono valido.',
          tipoMensaje: TipoMensaje.advertencia);
    } else if (!validateCorreo(item.email)) {
      MostrarAlerta(
          mensaje: 'Inserta un correo electronico valido.',
          tipoMensaje: TipoMensaje.advertencia);
    } else {
      MostrarAlerta(
          mensaje: 'Inserta valores validos.', tipoMensaje: TipoMensaje.error);
    }
  }
}

class Involucrado {
  int idInvolucrado;
  String nombre;
  String email;
  String telefono;

  Involucrado({this.idInvolucrado, this.nombre, this.email, this.telefono});

  // solucion al enviar objetos al servidor
  Map<String, dynamic> toJson() => {
        'id_involucrado': idInvolucrado,
        'nombre_completo': nombre,
        'email': email,
        'telefono': telefono,
      };
}

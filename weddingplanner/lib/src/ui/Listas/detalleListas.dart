import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetalleListas extends StatefulWidget {
  final int idLista;
  const DetalleListas({Key key, this.idLista}) : super(key: key);

  @override
  _DetalleListasState createState() => _DetalleListasState(idLista);
}

class _DetalleListasState extends State<DetalleListas> {
  final int idListas;
  GlobalKey<FormState> keyForm = new GlobalKey();

  TextEditingController nombreCtrl;
  TextEditingController descripcionCtrl;

  TextEditingController cantidadCtrl;

  _DetalleListasState(this.idListas);

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(child: Form(key: keyForm, child: _formLista()))
            ],
          ),
        ),
      ),
    );
  }

  Widget _formLista() {
    return Container(
      width: 1100,
      child: Card(
        color: Colors.white,
        elevation: 12,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: <Widget>[
            Wrap(
              alignment: WrapAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: nombreCtrl,
                  decoration: new InputDecoration(labelText: 'Nombre'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

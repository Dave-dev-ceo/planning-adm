// ignore_for_file: missing_return

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/blocs/asistencia/asistencia_bloc.dart';

class DialogAlert extends StatefulWidget {
  final String dataInfo;

  const DialogAlert({Key key, @required this.dataInfo}) : super(key: key);

  @override
  _DialogAlertState createState() => _DialogAlertState(dataInfo: dataInfo);
}

class _DialogAlertState extends State<DialogAlert> {
  List<String> lista = [];
  final String dataInfo;
  @override
  void initState() {
    _extraerData();
    super.initState();
  }

  Future<void> _extraerData() {
    String valor = "";
    for (var i = 0; i < dataInfo.length; i++) {
      if (dataInfo[i] == "|" && dataInfo[i + 1] == "|") {
        i = i + 2;
        valor = "";
        for (var f = i; f < dataInfo.length; f++) {
          if (dataInfo[f] != "|") {
            valor = valor + dataInfo[f];
          } else {
            break;
          }
        }
        lista.add(valor);
      }
    }
  }

  _DialogAlertState({@required this.dataInfo});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: false,
      title: Center(child: Text('Datos de invitado')),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            Padding(
              child: Center(
                  child: Text('Evento: ' +
                      (lista.elementAt(6) != 'null'
                          ? lista.elementAt(6)
                          : 'Sin evento asignado'))),
              padding: EdgeInsets.all(10),
            ),
            Padding(
              child: Center(
                  child: Text('Nombre: ' +
                      (lista.elementAt(1) != 'null'
                          ? lista.elementAt(1)
                          : 'Sin nombre'))),
              padding: EdgeInsets.all(10),
            ),
            Padding(
              child: Center(
                  child: Text('Grupo: ' +
                      (lista.elementAt(4) != 'null'
                          ? lista.elementAt(4)
                          : 'Sin grupo'))),
              padding: EdgeInsets.all(10),
            ),
            Padding(
              child: Center(
                  child: Text('Mesa: ' +
                      (lista.elementAt(5) != 'null'
                          ? lista.elementAt(5)
                          : 'Sin mesa'))),
              padding: EdgeInsets.all(10),
            ),
            Padding(
              child: Center(
                  child: Text('Email: ' +
                      (lista.elementAt(3) != 'null'
                          ? lista.elementAt(3)
                          : 'Sin email'))),
              padding: EdgeInsets.all(10),
            ),
            Padding(
              child: Center(
                  child: Text('Teléfono: ' +
                      (lista.elementAt(2) != 'null'
                          ? lista.elementAt(2)
                          : 'Sin teléfono'))),
              padding: EdgeInsets.all(10),
            ),
          ],
        ),
      ),
      actions: [
        _botonesAlert(),
      ],
    );
  }

  Row _botonesAlert() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
            flex: 5,
            child: TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancelar'))),
        Expanded(
            flex: 5,
            child: TextButton(
                onPressed: () => _guardarAsistencia(
                    int.parse(lista.elementAt(0)), lista.elementAt(1), true),
                child: Text('Aceptar'))),
      ],
    );
  }

  _guardarAsistencia(int idInvitado, String nombre, bool asistenciaValor) {
    // BlocProvider - cargamos el evento
    AsistenciaBloc asistenciaBloc;
    asistenciaBloc = BlocProvider.of<AsistenciaBloc>(context);
    asistenciaBloc.add(SaveAsistenciaEvent(idInvitado, asistenciaValor));
    Navigator.pop(context, true);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('¡Bienvenido!'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Center(
                      child: Text(
                          '${lista.elementAt(1)} estás en el evento ${lista.elementAt(6)}')),
                  Center(child: Text('Gracias por asistir.')),
                ],
              ),
            ),
            actions: [
              Expanded(
                  flex: 5,
                  child: TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text('Ok'))),
            ],
          );
        });
  }
}

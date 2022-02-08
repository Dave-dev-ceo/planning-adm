// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:planning/src/models/item_model_evento.dart';
import 'package:planning/src/ui/eventos/editar_evento/editar_evento.dart';

class FullScreenDialogEditEvento extends StatefulWidget {
  final Map<String, dynamic> evento;

  const FullScreenDialogEditEvento({Key key, @required this.evento})
      : super(key: key);
  @override
  _FullScreenDialogAddEventoState createState() =>
      _FullScreenDialogAddEventoState(evento['evento']);
}

class _FullScreenDialogAddEventoState
    extends State<FullScreenDialogEditEvento> {
  final ItemModelEvento evento;
  _FullScreenDialogAddEventoState(this.evento);
  @override
  void initState() {
    super.initState();
  }

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Editar evento'),
          actions: const [],
          automaticallyImplyLeading: true,
        ),
        body: SafeArea(
          child: EditarEvento(evento: evento),
        ));
  }
}

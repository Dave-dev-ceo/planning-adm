// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:planning/src/ui/Listas/detalle_listas.dart';

class FullScreenDialogDetalleListasEvent extends StatefulWidget {
  final Map<String, dynamic>? lista;
  const FullScreenDialogDetalleListasEvent({Key? key, required this.lista})
      : super(key: key);
  @override
  _FullScreenDialogDetalleListasState createState() =>
      _FullScreenDialogDetalleListasState(lista);
}

class _FullScreenDialogDetalleListasState
    extends State<FullScreenDialogDetalleListasEvent> {
  final Map<String, dynamic>? lista;

  _FullScreenDialogDetalleListasState(this.lista);

  @override
  void initState() {
    super.initState();
  }

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  Widget build(BuildContext context) {
    return DetalleListas(lista: lista);
  }
}

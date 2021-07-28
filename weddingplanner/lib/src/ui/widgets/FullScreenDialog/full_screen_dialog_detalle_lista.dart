import 'package:flutter/material.dart';
import 'package:weddingplanner/src/models/item_model_listas.dart';

class FullScreenDialogDetalleListasEvent extends StatefulWidget {
  final Map<String, dynamic> datos;
  const FullScreenDialogDetalleListasEvent({Key key, @required this.datos})
      : super(key: key);
  @override
  _FullScreenDialogDetalleListasState createState() =>
      _FullScreenDialogDetalleListasState(this.datos['event']);
}

class _FullScreenDialogDetalleListasState
    extends State<FullScreenDialogDetalleListasEvent> {
  final ItemModelListas datos;

  _FullScreenDialogDetalleListasState(this.datos);

  @override
  void initState() {
    super.initState();
  }

  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text('Detallado de Listas'),
      //backgroundColor: hexToColor('#7030a0'),
      actions: [],
      automaticallyImplyLeading: true,
    ));
  }
}

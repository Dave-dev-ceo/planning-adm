import 'package:flutter/material.dart';
import 'package:weddingplanner/src/ui/Listas/detalleListas.dart';

class FullScreenDialogDetalleListasEvent extends StatefulWidget {
  final Map<String, dynamic> lista;
  const FullScreenDialogDetalleListasEvent({Key key, @required this.lista})
      : super(key: key);
  @override
  _FullScreenDialogDetalleListasState createState() =>
      _FullScreenDialogDetalleListasState(lista);
}

class _FullScreenDialogDetalleListasState
    extends State<FullScreenDialogDetalleListasEvent> {
  final Map<String, dynamic> lista;

  _FullScreenDialogDetalleListasState(this.lista);

  @override
  void initState() {
    super.initState();
  }

  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  Widget build(BuildContext context) {
    return DetalleListas(lista: lista);
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('Detallado de Listas'),
    //     actions: [],
    //     automaticallyImplyLeading: true,
    //   ),
    //   body: SingleChildScrollView(
    //     child: DetalleListas(idLista: idLista),
    //   ),
    // );
  }
}

import 'package:flutter/material.dart';
//import 'package:planning/src/ui/contratos/agregar_contrato.dart';

class FullScreenDialogAddContrato extends StatefulWidget {
  const FullScreenDialogAddContrato({Key key}) : super(key: key);
  @override
  _FullScreenDialogAddContratoState createState() =>
      _FullScreenDialogAddContratoState();
}

class _FullScreenDialogAddContratoState
    extends State<FullScreenDialogAddContrato> {
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
        title: Text('Seleccione una plantilla'),
        backgroundColor: hexToColor('#fdf4e5'),
        actions: [],
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: /*AgregarContrato()*/ Container(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:weddingplanner/src/ui/contratos/agregar_contrato.dart';

class FullScreenDialogAddContrato extends StatefulWidget {
  final String descripcionMachote;

  const FullScreenDialogAddContrato({Key key, this.descripcionMachote}) : super(key: key);
  @override
  _FullScreenDialogAddContratoState createState() => _FullScreenDialogAddContratoState(descripcionMachote);
}

class _FullScreenDialogAddContratoState extends State<FullScreenDialogAddContrato> {
  final String descripcionMachote;
  _FullScreenDialogAddContratoState(this.descripcionMachote);
  
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
          title: Text('Agregar Contrato'),
          backgroundColor: hexToColor('#880B55'),
          actions: [],
          automaticallyImplyLeading: true,
        ),
        body:  SafeArea(
          child: AgregarContrato(descripcionMachote: descripcionMachote,),
        ),
    );
  }
}
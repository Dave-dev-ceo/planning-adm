import 'package:flutter/material.dart';
import 'package:planning/src/ui/machotes/agregar_machotes.dart';

class FullScreenDialogAddMachote extends StatefulWidget {
  final List<String> dataMachote;
  //final String claveMachote;
  const FullScreenDialogAddMachote({Key key, this.dataMachote})
      : super(key: key);
  @override
  _FullScreenDialogAddMachoteState createState() =>
      _FullScreenDialogAddMachoteState(dataMachote);
}

class _FullScreenDialogAddMachoteState
    extends State<FullScreenDialogAddMachote> {
  final List<String> dataMachote;

  //var claveMachote;
  //final String claveMachote;
  _FullScreenDialogAddMachoteState(this.dataMachote);

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
        title: Text('Agregar plantilla'),
        backgroundColor: hexToColor('#fdf4e5'),
        actions: [],
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: AgregarMachote(
            descripcionMachote: dataMachote[0], claveMachote: dataMachote[1]),
      ),
    );
  }
}

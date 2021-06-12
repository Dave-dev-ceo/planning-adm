import 'package:flutter/material.dart';
import 'package:weddingplanner/src/ui/machotes/agregar_machotes.dart';

class FullScreenDialogAddMachote extends StatefulWidget {
  final String descripcionMachote;

  const FullScreenDialogAddMachote({Key key, this.descripcionMachote})
      : super(key: key);
  @override
  _FullScreenDialogAddMachoteState createState() =>
      _FullScreenDialogAddMachoteState(descripcionMachote);
}

class _FullScreenDialogAddMachoteState
    extends State<FullScreenDialogAddMachote> {
  final String descripcionMachote;
  _FullScreenDialogAddMachoteState(this.descripcionMachote);

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
        title: Text('Agregar Plantilla'),
        backgroundColor: hexToColor('#880B55'),
        actions: [],
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: AgregarMachote(
          descripcionMachote: descripcionMachote,
        ),
      ),
    );
  }
}

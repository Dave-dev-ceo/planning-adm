import 'package:flutter/material.dart';
import 'package:weddingplanner/src/ui/actividades/actividades_timing.dart';
import 'package:weddingplanner/src/ui/eventos/agregar_evento.dart';

class FullScreenDialogAddActividades extends StatefulWidget {
  final int idTiming;
  const FullScreenDialogAddActividades({Key key, this.idTiming})
      : super(key: key);
  @override
  _FullScreenDialogAddActividadesState createState() =>
      _FullScreenDialogAddActividadesState(idTiming);
}

class _FullScreenDialogAddActividadesState
    extends State<FullScreenDialogAddActividades> {
  final int idTiming;

  _FullScreenDialogAddActividadesState(this.idTiming);
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
        title: Text('Agregar Actividades'),
        actions: [],
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
          child: AgregarActividades(
        idTiming: idTiming,
      )),
    );
  }
}

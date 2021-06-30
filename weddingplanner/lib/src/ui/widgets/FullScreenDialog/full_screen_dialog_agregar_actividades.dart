import 'package:flutter/material.dart';
import 'package:weddingplanner/src/ui/actividades/actividades_timing.dart';
import 'package:weddingplanner/src/ui/eventos/agregar_evento.dart';

class FullScreenDialogAddActividades extends StatefulWidget {

  const FullScreenDialogAddActividades({Key key}) : super(key: key);
  @override
  _FullScreenDialogAddActividadesState createState() => _FullScreenDialogAddActividadesState();
}

class _FullScreenDialogAddActividadesState extends State<FullScreenDialogAddActividades> {
  
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
          //backgroundColor: hexToColor('#7030a0'),
          actions: [],
          automaticallyImplyLeading: true,
        ),
        body:  SafeArea(
        child: 
            AgregarActividades()
      ),
    );
  }
}
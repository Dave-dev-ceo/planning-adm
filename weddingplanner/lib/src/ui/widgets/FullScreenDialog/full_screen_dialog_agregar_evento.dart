import 'package:flutter/material.dart';
import 'package:weddingplanner/src/ui/eventos/agregar_evento.dart';

class FullScreenDialogAddEvento extends StatefulWidget {

  const FullScreenDialogAddEvento({Key key}) : super(key: key);
  @override
  _FullScreenDialogAddEventoState createState() => _FullScreenDialogAddEventoState();
}

class _FullScreenDialogAddEventoState extends State<FullScreenDialogAddEvento> {
  
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
          title: Text('Agregar Evento'),
          //backgroundColor: hexToColor('#7030a0'),
          actions: [],
          automaticallyImplyLeading: true,
        ),
        body:  SafeArea(
        child: 
            AgregarEvento()
      ),
    );
  }
}
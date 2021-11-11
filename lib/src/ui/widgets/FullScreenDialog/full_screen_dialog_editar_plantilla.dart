import 'package:flutter/material.dart';
import 'package:planning/src/ui/machotes/editar_plantillas.dart';

class FullScreenDialogEditPlantilla extends StatefulWidget {
  final List<String> dataPlantilla;
  //final String claveMachote;
  const FullScreenDialogEditPlantilla({Key key, this.dataPlantilla})
      : super(key: key);
  @override
  _FullScreenDialogEditPlantillaState createState() =>
      _FullScreenDialogEditPlantillaState(dataPlantilla);
}

class _FullScreenDialogEditPlantillaState
    extends State<FullScreenDialogEditPlantilla> {
  final List<String> dataPlantilla;

  //var claveMachote;
  //final String claveMachote;
  _FullScreenDialogEditPlantillaState(this.dataPlantilla);

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
        backgroundColor: hexToColor('#fdf4e5'),
        actions: [],
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: EditarPlantillas(
          descripcionPlantilla: dataPlantilla[0],
          clavePlantilla: dataPlantilla[1],
          plantilla: dataPlantilla[2],
          idMachote: dataPlantilla[3].toString(),
        ),
      ),
    );
  }
}

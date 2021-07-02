import 'package:flutter/material.dart';
import 'package:weddingplanner/src/ui/usuarios/form_usuario.dart';

class FullScreenDialogAddUsuario extends StatefulWidget {
  final Map<String, dynamic> datos;
  const FullScreenDialogAddUsuario({Key key, @required this.datos})
      : super(key: key);
  @override
  _FullScreenDialogAddUsuarioState createState() =>
      _FullScreenDialogAddUsuarioState(this.datos);
}

class _FullScreenDialogAddUsuarioState
    extends State<FullScreenDialogAddUsuario> {
  final Map<String, dynamic> datos;

  _FullScreenDialogAddUsuarioState(this.datos);
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
        title: Text(datos['accion'] == 0
            ? 'Agregar Usuario'
            : 'Editar Datos de usuario'),
        //backgroundColor: hexToColor('#7030a0'),
        actions: [],
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: FormUsuario(datos: datos), //FormUsuario(),
      ),
    );
  }
}

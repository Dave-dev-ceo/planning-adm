import 'package:flutter/material.dart';
import 'package:weddingplanner/src/ui/usuarios/form_usuario.dart';

class FullScreenDialogAddUsuario extends StatefulWidget {
  const FullScreenDialogAddUsuario({Key key}) : super(key: key);
  @override
  _FullScreenDialogAddUsuarioState createState() =>
      _FullScreenDialogAddUsuarioState();
}

class _FullScreenDialogAddUsuarioState
    extends State<FullScreenDialogAddUsuario> {
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
        title: Text('Agregar Usuario'),
        //backgroundColor: hexToColor('#7030a0'),
        actions: [],
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: FormUsuario(), //FormUsuario(),
      ),
    );
  }
}

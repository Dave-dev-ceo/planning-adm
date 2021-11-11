import 'package:flutter/material.dart';
import 'package:planning/src/ui/Roles/form_rol.dart';

class FullScreenDialogAddRol extends StatefulWidget {
  final Map<String, dynamic> datos;
  const FullScreenDialogAddRol({Key key, @required this.datos})
      : super(key: key);
  @override
  _FullScreenDialogAddRolState createState() =>
      _FullScreenDialogAddRolState(this.datos);
}

class _FullScreenDialogAddRolState extends State<FullScreenDialogAddRol> {
  final Map<String, dynamic> datos;

  _FullScreenDialogAddRolState(this.datos);
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
        title:
            Text(datos['accion'] == 0 ? 'Agregar Rol' : 'Editar Datos de Rol'),
        actions: [],
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: FormRol(datos: datos), //FormUsuario(),
      ),
    );
  }
}

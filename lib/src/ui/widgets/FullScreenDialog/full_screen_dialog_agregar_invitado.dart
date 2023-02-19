// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:planning/src/resources/api_provider.dart';
import 'package:planning/src/ui/widgets/invitados/agregar_invitado.dart';

class FullScreenDialogAdd extends StatefulWidget {
  final int? id;

  const FullScreenDialogAdd({Key? key, this.id}) : super(key: key);
  @override
  _FullScreenDialogAddState createState() => _FullScreenDialogAddState(id);
}

class _FullScreenDialogAddState extends State<FullScreenDialogAdd> {
  ApiProvider api = ApiProvider();
  final int? id;
  _FullScreenDialogAddState(this.id);

  @override
  void initState() {
    super.initState();
  }

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  Widget build(BuildContext context) {
    //return DefaultTabController(
    //length: 2,
    //child:
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar invitado'),
        backgroundColor: hexToColor('#fdf4e5'),
        actions: const [],
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: AgregarInvitados(
          id: id,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class MesasPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Table(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/asignarMesas');
        },
        tooltip: 'Asignar Mesas',
        child: Icon(Icons.assignment),
      ),
    );
  }
}

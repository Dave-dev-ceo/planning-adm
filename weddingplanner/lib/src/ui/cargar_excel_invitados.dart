import 'package:flutter/material.dart';

import 'home.dart';

class CargarExcel extends StatelessWidget {
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => CargarExcel(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wedding Planner"),
        backgroundColor: Colors.pink[900],
        ),
      drawer: MenuLateral(),
      body: Center(
        child: Text("Cargar Excel"),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class CargarExcel extends StatelessWidget {
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => CargarExcel(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WeddingPlannet"),
        backgroundColor: Colors.blue[300],
      ),
      body: Center(
        child: Text("Cargar Excel"),
      ),
    );
  }
}
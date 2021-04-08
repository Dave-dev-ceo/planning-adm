import 'package:flutter/material.dart';

class AgregarInvitados extends StatelessWidget {
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => AgregarInvitados(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WeddingPlannet"),
        backgroundColor: Colors.blue[300],
      ),
      body: Container(
        child: Row(children: [
          Text('Nombre'),
          Column(
            children: [
              
            ],
          )  
        ],),
      )
    );
  }
}
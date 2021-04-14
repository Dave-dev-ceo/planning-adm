import 'package:flutter/material.dart';
class MenuLateral extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: ListView(
        children: <Widget>[
          new UserAccountsDrawerHeader(
              accountName: Text("Planner"),
              accountEmail: Text("weddingplanner@gmail.com"),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage("https://ichef.bbci.co.uk/news/660/cpsprodpb/6AFE/production/_102809372_machu.jpg"),
                fit: BoxFit.cover
              )
            ),
          ),
          Ink(
            color: Colors.pink[900],
            child: new ListTile(
              title: Text("Invitados", style: TextStyle(color: Colors.white),),
            ),
          ),
          new ListTile(
            title: Text("Involucrados"),
            onTap: (){},
          ),
          new ListTile(
            title: Text("Proveedores"),
          ),
          new ListTile(
            title: Text("Mesas"),
          )
        ],
      ) ,
    );
  }
}
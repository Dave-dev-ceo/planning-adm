import 'package:flutter/material.dart';

class AgregarActividades extends StatefulWidget {
  const AgregarActividades({ Key key }) : super(key: key);

  @override
  _AgregarActividadesState createState() => _AgregarActividadesState();
}

class _AgregarActividadesState extends State<AgregarActividades> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text('Actividades'),),
    );
  }
}
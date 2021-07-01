import 'package:flutter/material.dart';

class AgregarActividades extends StatefulWidget {
  const AgregarActividades({ Key key }) : super(key: key);

  @override
  _AgregarActividadesState createState() => _AgregarActividadesState();
}

class _AgregarActividadesState extends State<AgregarActividades> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 1200,
              height: 200,
              child: Card(
                color: Colors.white,
                elevation: 12,
                shadowColor: Colors.black12,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              )
          ],
        )
      ),
    );
  }
}
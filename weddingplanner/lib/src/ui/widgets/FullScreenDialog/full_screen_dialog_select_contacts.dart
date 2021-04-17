import 'package:flutter/material.dart';
class FullScreenDialog extends StatefulWidget {
  @override
  _FullScreenDialogState createState() => _FullScreenDialogState();
}

class _FullScreenDialogState extends State<FullScreenDialog> {
  Card miCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(15, 10, 25, 0),
            title: Text('Titulo'),
            subtitle: Text(
                'Este es el subtitulo del card. Aqui podemos colocar descripción de este card.'),
            leading: Icon(Icons.home),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(onPressed:() {} , child: Text('Aceptar')),
              FlatButton(onPressed: () => {}, child: Text('Cancelar'))
            ],
          )
        ],
      ),
    );
  }
  String dropdownValue = 'Seleccione un grupo';
  _dropDown(){
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_drop_down_outlined),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.pink),
      underline: Container(
        height: 2,
        color: Colors.pink,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <String>['Seleccione un grupo', 'General', 'Nuevo grupo']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: TextStyle(fontSize: 18),),
        );
      }).toList(),
    );
  }
  @override
  Widget build(BuildContext context) {
    //var pantalla = MediaQuery.of(context).size;
    //var pan = MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Color(0xFF6200EE),
        title: Text('Seleccionar Contactos'),
      ),
      body:  Column(
        children: <Widget>[
          Container(
            height: 70,
            width: double.infinity,
            child: Center(
                child: _dropDown(),
              ),
            ),
          Expanded(
                      child: SingleChildScrollView(
                //child: //Container(
                  //margin: EdgeInsets.all(5.0),
                  //width: double.infinity,
                  //color: Colors.amber,
                  child: Column(
                    children :<Widget>[
                      miCard(),
                      miCard(),
                      miCard(),
                      miCard(),
                      miCard()
                    ],
                  ),
                ),
          ),
           // ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        child: const Icon(Icons.cloud_upload_outlined),
        //backgroundColor: Colors.green,
      ),
      
      
      
        
    );
  }
}
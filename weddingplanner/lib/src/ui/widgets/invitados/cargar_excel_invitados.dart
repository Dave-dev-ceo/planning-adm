//import 'dart:js';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'dart:io';
import 'package:weddingplanner/src/resources/invitados_api_provider.dart';

import 'package:weddingplanner/src/ui/widgets/call_to_action/call_to_action.dart';
//import 'package:path/path.dart';
class CargarExcel extends StatefulWidget {
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => CargarExcel(),
      );

  @override
  _CargarExcelState createState() => _CargarExcelState();
}

class _CargarExcelState extends State<CargarExcel> {
  InvitadosApiProvider api = new InvitadosApiProvider();

  _readExcel() async{
    /// Use FilePicker to pick files in Flutter Web
  
    FilePickerResult pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      allowMultiple: false,
    );
  
    /// file might be picked
    
    if (pickedFile != null) {
      var bytes = pickedFile.files.single.bytes;
      
      if(bytes == null){
        bytes = File(pickedFile.files[0].path).readAsBytesSync();
      }
      
      
      var excel = Excel.decodeBytes(bytes);
      bool bandera = true;
      for (var table in excel.tables.keys) {
        //print(table); //sheet Name
        //print(excel.tables[table].maxCols);
        //print(excel.tables[table].maxRows);
        var xx = excel.tables[table].rows;
        if(xx[0][0]=="NOMBRE" && xx[0][1]=="APELLIDOS" && xx[0][2]=="EMAIL" && xx[0][3]=="TELÉFONO"){
          for( var i = 1 ; i < xx.length; i++ ) { 
            Map <String,String> json = {
              "nombre":xx[i][0],
              "apellidos":xx[i][1],
              "telefono":xx[i][3].toString(),
              "email":xx[i][2],
              "id_evento":"1"
            };
            bool response = await api.createInvitados(json);
            if(response){

            }else{
              bandera = false;
            }   
          }
          if(bandera){
            final snackBar = SnackBar(
                content: Container(
                  height: 30,
                  child: Center(
                  child: Text('Se importo el archivo con éxito'),
                ),
                  //color: Colors.red,
                ),
                backgroundColor: Colors.green,  
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }else{
            final snackBar = SnackBar(
              content: Container(
                height: 30,
                child: Center(
                child: Text('Error: No se pudo realizar el registro'),
              ),
                //color: Colors.red,
              ),
              backgroundColor: Colors.red,  
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } 
        }else{
          final snackBar = SnackBar(
          content: Container(
            height: 30,
            child: Center(
            child: Text('Estructura incorrecta'),
          ),
            //color: Colors.red,
          ),
          backgroundColor: Colors.red,  
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
          
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //_ReadExcel();
    return Container(
      width: double.infinity,
        child: Center(
          child: Row(
            children: <Widget>[
                Expanded(
                  child: Center(
                    child:GestureDetector(
                      onTap: (){
                        _readExcel();
                      },
                      child: CallToAction('Importar Exel'),
                    ), 
                  ),
                ),
                Expanded(
                  child: Center(
                    child:GestureDetector(
                      onTap: (){
                        print('Contactos');
                      },
                      child: CallToAction('Importar Contactos'),
                    ), 
                  ),
                ),
                /*Container(
                  width: 600,
                  //color: Colors.green,
                  child: Center(
                    child: Container(
                      width: 300,
                      height: 50,
                      child: ElevatedButton.icon(
                        label: Text('Importar Excel'),
                        icon: Icon(Icons.web),
                        onPressed: () {
                          print('Pressed');
                        },
                      ),
                    ),
                  ) 
                ),
                Container(
                  width: 600,
                  //color: Colors.grey,
                  child: Center(
                    child: Container(
                      width: 300,
                      height: 50,
                      child: ElevatedButton.icon(
                        label: Text('Importar Contactos'),
                        icon: Icon(Icons.web),
                        onPressed: () {
                          print('Pressed');
                        },
                      ),
                    ),
                  ) 
                ),*/

              
            ],
          ),  
        )
      );
  }
}
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'dart:io';
//import 'package:path/path.dart';
class CargarExcel extends StatelessWidget {
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => CargarExcel(),
      );
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
    for (var table in excel.tables.keys) {
      print(table); //sheet Name
      print(excel.tables[table].maxCols);
      print(excel.tables[table].maxRows);
      for (var row in excel.tables[table].rows) {
        print("$row");
      }
    }
  }
  }
  @override
  Widget build(BuildContext context) {
    //_ReadExcel();
    return Scaffold(
      appBar: AppBar(
        title: Text("Wedding Planner"),
        backgroundColor: Colors.pink[900],
        ),
      body: Center(
        child: FloatingActionButton(
          backgroundColor: Colors.red,
          child: Text('Excel'),
          
          onPressed: (){
          _readExcel();
        },),
      ),
    );
  }
}
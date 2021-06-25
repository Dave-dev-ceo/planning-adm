import 'package:flutter/material.dart';

class DialogAlert extends StatefulWidget {
  final String dataInfo;
  

  const DialogAlert({ Key key,@required this.dataInfo }) : super(key: key);

  @override
  _DialogAlertState createState() => _DialogAlertState(dataInfo: dataInfo);
}

class _DialogAlertState extends State<DialogAlert> {
  
  List<String> lista = [];
  final String dataInfo;
  @override
  void initState(){
    _extraerData();
    super.initState();
  }
  Future<void> _extraerData(){
    String valor="";
    for (var i = 0; i < dataInfo.length; i++) {
    if(dataInfo[i]=="|"&&dataInfo[i+1]=="|"){
      i = i + 2;
      valor = "";
      for(var f = i; f < dataInfo.length; f++) {
        if(dataInfo[f] != "|"){
          valor = valor + dataInfo[f];  
        }else{
          break;
        }
      }
      lista.add(valor);
    
    }  
    //print(dataInfo[i]);
   }
  }

  _DialogAlertState({@required this.dataInfo});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text('Inivtado')),
      content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Padding(child: Center(child: Text(lista.elementAt(1))),padding: EdgeInsets.all(15),),
                    Padding(child: Center(child: Text(lista.elementAt(2))),padding: EdgeInsets.all(15),),
                    Padding(child: Center(child: Text(lista.elementAt(3))),padding: EdgeInsets.all(15),),
                ],
              ),
      ),
      actions: [
        TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text('Aceptar'))
      ],
    );
  }
}
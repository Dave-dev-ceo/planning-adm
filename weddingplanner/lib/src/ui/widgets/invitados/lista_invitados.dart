//import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weddingplanner/src/blocs/blocs.dart';
import 'package:weddingplanner/src/models/item_model_grupos.dart';
import 'package:weddingplanner/src/resources/api_provider.dart';
//import 'package:weddingplanner/src/ui/widgets/FullScreenDialog/full_screen_dialog_agregar_invitado.dart';
//import 'package:weddingplanner/src/ui/widgets/FullScreenDialog/full_screen_dialog_editar_invitado.dart';
import '../../../models/item_model_invitados.dart';
//import '../../../blocs/invitados_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'home.dart';

class ListaInvitados extends StatefulWidget {
  final int idEvento;

  const ListaInvitados({Key key, this.idEvento}) : super(key: key);
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => ListaInvitados(),
      );
  @override
  _ListaInvitadosState createState() => _ListaInvitadosState(idEvento);
}

class _ListaInvitadosState extends State<ListaInvitados> {
  final TextStyle estiloTxt = TextStyle(fontWeight: FontWeight.bold);
  final int idEvento;

  _ListaInvitadosState(this.idEvento);  
  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
  alertaLlamada(){
    showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
                title: Text('Permisos denegados'),
                content: Text('Por favor habilitar el acceso a contactos'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              )); 
  }
  listaInvitados(BuildContext cont){
    ///bloc.dispose();
    blocInvitados.fetchAllInvitados(cont);
    return StreamBuilder(
            stream: blocInvitados.allInvitados,
            builder: (context, AsyncSnapshot<ItemModelInvitados> snapshot) {
              if (snapshot.hasData) {
                return buildList(snapshot);
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return Center(child: CircularProgressIndicator());
            },
          );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Container(
        width: double.infinity,
        child: Center(
          child:
            listaInvitados(context),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/addInvitados', arguments: idEvento);
        },
        child: const Icon(Icons.person_add),
        
        backgroundColor: Colors.pink[300],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
    );
  }
  Widget buildList(AsyncSnapshot<ItemModelInvitados> snapshot) {
    return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PaginatedDataTable(
            header: Text('Invitados'),
            rowsPerPage: 8,
            showCheckboxColumn: false,
            columns: [
              DataColumn(label: Text('Nombre', style:estiloTxt)),
              DataColumn(label: Text('Telefono', style:estiloTxt)),
              DataColumn(label: Text('Grupo', style:estiloTxt)),
              DataColumn(label: Text('Asistencia', style:estiloTxt)),
              //DataColumn(label: Text('', style:estiloTxt),),
              //DataColumn(label: Text('', style:estiloTxt)),
            ],
            
            source: _DataSource(snapshot.data.results,context,idEvento),
          ),
        ],
      );
  }
  
}
class _Row {
  _Row(
    this.valueId,
    this.valueA,
    this.valueB,
    this.valueC,
    this.valueD,
  );
  final int valueId;
  final String valueA;
  final String valueB;
  final String valueC;
  final String valueD;

  bool selected = false;
}

class _DataSource extends DataTableSource {
  BuildContext _cont;
  final int idEvento;
  List<dynamic> _grupos = [];
  ApiProvider api = new ApiProvider();
  _DataSource(context,BuildContext cont, this.idEvento) {
    _rows = <_Row>[];
    for (int i = 0; i < context.length; i++) {
      _rows.add(_Row(context[i].idInvitado,context[i].nombre, context[i].telefono, (context[i].grupo==null?'Sin grupo':context[i].grupo), context[i].asistencia));  
    }
    _cont=cont;
  }

  _viewShowDialog(String numero){
      showDialog(
          context: _cont,
          builder: (BuildContext context) => CupertinoAlertDialog(
                title: Text('Llamada'),
                content: Text('Se llamara al numero $numero'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('Cancelar',style: TextStyle(color: Colors.red),),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoDialogAction(
                    child: Text('Confirmar'),
                    onPressed: () {
                      launch('tel://$numero');
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ));
  }
  _updateEstatus(int idInvitado, int idEstatusInvitado) async{
    Map<String,String> json = 
    {
      "id_invitado" : idInvitado.toString(),
      "id_estatus_invitado" : idEstatusInvitado.toString()
    };
    
    bool response = await api.updateEstatusInvitado(json, _cont);
    if (response) {
      _ListaInvitadosState(idEvento).listaInvitados(_cont);
      print("actualizado");
    } else {
      print("error update");
    }
  }
  _viewShowDialogEditar(int idInvitado) async{
    final result = await Navigator.of(_cont).pushNamed('/editInvitado',arguments: idInvitado); 
    if(result==null){
      _ListaInvitadosState(idEvento).listaInvitados(_cont);
    }
  }
  _listaGrupos(){
    ///bloc.dispose();
    blocGrupos.fetchAllGrupos(_cont);
    return StreamBuilder(
            stream: blocGrupos.allGrupos,
            builder: (context, AsyncSnapshot<ItemModelGrupos> snapshot) {
              if (snapshot.hasData) {
                //_mySelection = ((snapshot.data.results.length - 1).toString());
                //print(snapshot.data.results);
                
                
                return _dataGrupo(snapshot.data);
                //print(snapshot.data);
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return Center(child: CircularProgressIndicator());
            },
          );
  }
  _dataGrupo(ItemModelGrupos grupos){
    print(grupos.results.length);
    /*List<Text> lT;
    for(int i = 0; i < grupos.results.length; i++){
      print(grupos.results.elementAt(i).nombreGrupo);
      Text(grupos.results.elementAt(i).nombreGrupo);
      lT.
    }
    
    return lT;*/
    return ListView.builder(
        itemCount: grupos.results.length,
        //padding: const EdgeInsets.only(top: 10),
        itemBuilder: (BuildContext context,int index){
          print(grupos.results.elementAt(index).nombreGrupo);
          return Container(
                      child: Center(
                        child:Text(grupos.results.elementAt(index).nombreGrupo)));
        }
      );
  }
  _viewShowDialogGrupo(int idInvitado){
     
      print(_grupos.length);
      showDialog(
          context: _cont,
          builder: (BuildContext context) => CupertinoAlertDialog(
                //title: Text('Seleccionar Grupo'),
                content: Container(
                    height: 120,
                    child: //Column(
                      //children: [
                        CupertinoPicker(
                          itemExtent: 32.0, 
                          onSelectedItemChanged: (value){
                            print(value);

                          }, 
                          children: <Widget>[
                            Text('Data 0'),
                            Text('Data 1'),
                            Text('Data 2'),
                            Text('Data 3'),
                            Text('Data 4'),
                            Text('Data 5'),
                            Text('Data 6'),
                            Text('Data 7'),
                             //_listaGrupos(),
                            //for(String data in _grupos) Text(data),
                            ]),
                           // _listaGrupos(),
                     // ],
                    //),
                  ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('Cancelar',style: TextStyle(color: Colors.red),),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoDialogAction(
                    child: Text('Confirmar'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ));
  }
  _viewShowDialogEstatus(int idInvitado){
      showDialog(
          context: _cont,
          builder: (BuildContext context) => CupertinoAlertDialog(
                //title: Text('Llamada'),
                //content: Text('Se llamara al numero $numero'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('Confirmado'),
                    onPressed: () {
                      _updateEstatus(idInvitado, 1);
                      Navigator.of(context).pop();
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text('Sin Confirmar'),
                    onPressed: () {
                      _updateEstatus(idInvitado, 2);
                      Navigator.of(context).pop();
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text('No Asiste'),
                    onPressed: () {
                      _updateEstatus(idInvitado, 3);
                      
                      Navigator.of(context).pop();
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text('Cerrar',style: TextStyle(color: Colors.red),),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ));
  }

  List<_Row> _rows;

  int _selectedCount = 0;
  
  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= _rows.length) return null;
    final row = _rows[index];
    return DataRow.byIndex(
      index: index,
      selected: row.selected,
      onSelectChanged: (value) {
        if (row.selected != value) {
          print(value);
          _selectedCount += value ? 1 : -1;
          assert(_selectedCount >= 0);
          row.selected = value;
          //notifyListeners();
        }
      },
      cells: [
        //DataCell(Text(row.valueId.toString())),
        DataCell(Text(row.valueA), onTap: (){_viewShowDialogEditar(row.valueId);}),
        DataCell(Text(row.valueB), onTap: (){_viewShowDialog(row.valueB);}),
        DataCell(Text(row.valueC), ),//onTap: (){_viewShowDialogGrupo(row.valueId);}),
        DataCell(Text(row.valueD),onTap: (){_viewShowDialogEstatus(row.valueId);},),
        //DataCell(Icon(Icons.edit)),
        //DataCell(Icon(Icons.delete)),
      ],
    );
  }

  @override
  int get rowCount => _rows.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}

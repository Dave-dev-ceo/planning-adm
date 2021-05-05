//import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weddingplanner/src/resources/api_provider.dart';
import 'package:weddingplanner/src/ui/widgets/FullScreenDialog/full_screen_dialog_agregar_invitado.dart';
import 'package:weddingplanner/src/ui/widgets/FullScreenDialog/full_screen_dialog_editar_invitado.dart';
import '../../../models/item_model_invitados.dart';
import '../../../blocs/invitados_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'home.dart';

class ListaInvitados extends StatefulWidget {
  final int id;

  const ListaInvitados({Key key, this.id}) : super(key: key);
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => ListaInvitados(),
      );
  @override
  _ListaInvitadosState createState() => _ListaInvitadosState(id);
}

class _ListaInvitadosState extends State<ListaInvitados> {
  final TextStyle estiloTxt = TextStyle(fontWeight: FontWeight.bold);
  final int id;

  _ListaInvitadosState(this.id);  
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
  listaInvitados(){
    ///bloc.dispose();
    bloc.fetchAllInvitados(id);
    return StreamBuilder(
            stream: bloc.allInvitados,
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
            listaInvitados(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
          context, MaterialPageRoute(builder: (context) => FullScreenDialogAdd(id: id,)));
        },
        child: const Icon(Icons.person_add),
        
        backgroundColor: Colors.pink[300],
      ),
      
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
            
            source: _DataSource(snapshot.data.results,context,id),
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
  final int id;
  ApiProvider api = new ApiProvider();
  _DataSource(context,BuildContext cont, this.id) {
    _rows = <_Row>[];
    for (int i = 0; i < context.length; i++) {
      _rows.add(_Row(context[i].idInvitado,context[i].nombre, context[i].telefono, (context[i].grupo==null?'Sin grupo':context[i].grupo), context[i].asistencia));  
    }
    _cont=cont;
  }
  /*void _reset() {
    Navigator.pushReplacement(
      _cont,
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        pageBuilder: (_, __, ___) => ListaInvitados(),
      ),
    );
  }*/

  /*_viewShowDialogEditar(int id){
    Navigator.push(
          _cont, MaterialPageRoute(builder: (context) => FullScreenDialogEdit(id: id,)));
  }*/

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
    
    bool response = await api.updateEstatusInvitado(json);
    if (response) {
      //_reset();
      _ListaInvitadosState(id).listaInvitados();
      print("actualizado");
    } else {
      print("error update");
    }
  }
  _viewShowDialogEditar(int idInvitado) async{
    final result = await Navigator.push(
          _cont, MaterialPageRoute(builder: (context) => FullScreenDialogEdit(id: idInvitado,))); 
    if(result==null){
      _ListaInvitadosState(id).listaInvitados();
    }
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
                    child: Text('Pendiente'),
                    onPressed: () {
                      _updateEstatus(idInvitado, 2);
                      Navigator.of(context).pop();
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text('Cancelado'),
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
        DataCell(Text(row.valueB),onTap: (){_viewShowDialog(row.valueB);}),
        DataCell(Text(row.valueC)),
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

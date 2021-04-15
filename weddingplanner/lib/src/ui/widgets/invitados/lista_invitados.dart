import 'package:flutter/material.dart';
import '../../../models/item_model_invitados.dart';
import '../../../blocs/invitados_bloc.dart';
//import 'home.dart';

class ListaInvitados extends StatefulWidget {
  
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => ListaInvitados(),
      );
  @override
  _ListaInvitadosState createState() => _ListaInvitadosState();
}

class _ListaInvitadosState extends State<ListaInvitados> {
  final TextStyle estiloTxt = TextStyle(fontWeight: FontWeight.bold);
  _listaInvitados(){
    ///bloc.dispose();
    bloc.fetchAllInvitados();
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
    return Container(
      width: double.infinity,
      //color: Colors.pink,
      child: Center(
        
        //alignment: Alignment.center,
        //crossAxisAlignment: CrossAxisAlignment.start,
        //mainAxisAlignment: MainAxisAlignment.center,
        child:
          _listaInvitados(),
        
      ),
    );
    /*return DefaultTabController(
      length: 3, 
      child: Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          tabs: [
            Tab(text: 'Lista',icon: Icon(Icons.list),),
            Tab(text: 'Agregar' ,icon: Icon(Icons.add),),
            Tab(text: 'Cargar excel ó contact_listaInvitados()
        backgroundColor: Colors.pink[900],
        ),
      body:TabBarView(
        children: [
          _listaInvitados(),
          Center(
            child: Text('Registro'),
          ),
          Center(
            child: Text('Excel'),
          ),
        ],
      ),
    ))
    ;*/
  }
  Widget buildList(AsyncSnapshot<ItemModelInvitados> snapshot) {
    return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PaginatedDataTable(
            header: Text('Invitados'),
            rowsPerPage: 5,
            showCheckboxColumn: false,
            columns: [
              DataColumn(label: Text('Nombre', style:estiloTxt)),
              DataColumn(label: Text('Telefono', style:estiloTxt)),
              DataColumn(label: Text('Email', style:estiloTxt)),
              DataColumn(label: Text('Asistencia', style:estiloTxt)),
            ],
            
            source: _DataSource(snapshot.data.results),
          ),
        ],
      );
  }
}
class _Row {
  _Row(
    this.valueA,
    this.valueB,
    this.valueC,
    this.valueD,
  );

  final String valueA;
  final String valueB;
  final String valueC;
  final String valueD;

  bool selected = false;
}

class _DataSource extends DataTableSource {
  _DataSource(context) {
    _rows = <_Row>[];
    for (int i = 0; i < context.length; i++) {
      _rows.add(_Row(context[i].nombre, context[i].telefono, context[i].email, context[i].asistencia));  
    }
    
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
        DataCell(Text(row.valueA)),
        DataCell(Text(row.valueB)),
        DataCell(Text(row.valueC)),
        DataCell(Text(row.valueD)),
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
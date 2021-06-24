import 'package:flutter/material.dart';
import 'package:weddingplanner/src/models/item_model_publicaciones.dart';

class AdminLanding extends StatefulWidget {
  const AdminLanding({ Key key }) : super(key: key);

  @override
  _AdminLandingState createState() => _AdminLandingState();
}

class _AdminLandingState extends State<AdminLanding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
 
  
  Widget buildList(ItemModelPublicaciones snapshot) {
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        PaginatedDataTable(
          header: Text('Planners'),
          rowsPerPage: 8,
          showCheckboxColumn: false,
          columns: [
            DataColumn(label: Text('Titulo')),
            DataColumn(label: Text('Tipo')),
            DataColumn(label: Text('Estatus')),
            //DataColumn(label: Text('', style:estiloTxt),),
            //DataColumn(label: Text('', style:estiloTxt)),
          ],
          source: _DataSource(snapshot.results, context),
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

  _DataSource(context, BuildContext cont) {
    _rows = <_Row>[];
    for (int i = 0; i < context.length; i++) {
      _rows.add(_Row(context[i].idPlanner, context[i].empresa, context[i].correo,
          context[i].telefono, context[i].pais));
    }
    _cont = cont;
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
        DataCell(
          Text(row.valueA),
        ),
        DataCell(
          Text(row.valueB),
        ),
        DataCell(
          Text(row.valueC),
        ),
        DataCell(
          Text(row.valueD),
        ),
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

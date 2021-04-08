import 'package:flutter/material.dart';

//import '../res/res.dart' as res;
class ListaInvitados extends StatefulWidget {
  
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => ListaInvitados(),
      );
  @override

  @override
  _ListaInvitadosState createState() => _ListaInvitadosState();
}

class _ListaInvitadosState extends State<ListaInvitados> {
  @override
  void initState() {
    super.initState();
    //_vpc = VideoPlayerController();
  }
  final TextStyle estiloTxt = TextStyle(fontWeight: FontWeight.bold);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WeddingPlannet"),
        backgroundColor: Colors.blue[300],
      ),
      body:
      ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PaginatedDataTable(
            header: Text('Invitados'),
            rowsPerPage: 8,
            showCheckboxColumn: false,
            columns: [
              DataColumn(label: Text('Nombre', style:estiloTxt)),
              DataColumn(label: Text('Telefono', style:estiloTxt)),
              DataColumn(label: Text('Email', style:estiloTxt)),
              DataColumn(label: Text('Asistencia', style:estiloTxt)),
            ],
            source: _DataSource(context),
          ),
        ],
      ),
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
  final int valueD;

  bool selected = false;
}

class _DataSource extends DataTableSource {
  _DataSource(this.context) {
    _rows = <_Row>[
      _Row('Cell A1', 'CellB1', 'CellC1', 1),
      _Row('Cell A2', 'CellB2', 'CellC2', 2),
      _Row('Cell A3', 'CellB3', 'CellC3', 3),
      _Row('Cell A4', 'CellB4', 'CellC4', 4),
      _Row('Cell A4', 'CellB4', 'CellC4', 4),
      _Row('Cell A4', 'CellB4', 'CellC4', 4),
      _Row('Cell A4', 'CellB4', 'CellC4', 4),
      _Row('Cell A4', 'CellB4', 'CellC4', 4),
      _Row('Cell A4', 'CellB4', 'CellC4', 4),
      _Row('Cell A4', 'CellB4', 'CellC4', 4),
      _Row('Cell A4', 'CellB4', 'CellC4', 4),
      _Row('Cell A4', 'CellB4', 'CellC4', 4),
      _Row('Cell A4', 'CellB4', 'CellC4', 4),
      _Row('Cell A4', 'CellB4', 'CellC4', 4),
      _Row('Cell A4', 'CellB4', 'CellC4', 4),
    ];
  }

  final BuildContext context;
  List<_Row> _rows;

  int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    //return null;
    assert(index >= 0);
    if (index >= _rows.length) return null;
    final row = _rows[index];
    return DataRow.byIndex(
      index: index,
      //selected: row.selected,
      onSelectChanged: (value) {
        if (row.selected != value) {
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
        DataCell(Text(row.valueD.toString())),
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
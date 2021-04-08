import 'package:flutter/material.dart';

class _Row {
  _Row(
    this.nombre,
    this.telefono,
    this.email,
    this.asistencia,
  );

  final String nombre;
  final String telefono;
  final String email;
  final String asistencia;
  bool selected = false;
}

class _DataSource extends DataTableSource {
  _DataSource(this.context) {
    _rows = <_Row>[
      _Row('Cell A1', 'CellB1', 'CellC1', ''),
      _Row('Cell A2', 'CellB2', 'CellC2', ''),
      _Row('Cell A3', 'CellB3', 'CellC3', ''),
      _Row('Cell A4', 'CellB4', 'CellC4', ''),
    ];
  }

  final BuildContext context;
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
          _selectedCount += value ? 1 : -1;
          assert(_selectedCount >= 0);
          row.selected = value;
          notifyListeners();
        }
      },
      cells: [
        DataCell(Text(row.nombre)),
        DataCell(Text(row.telefono)),
        DataCell(Text(row.email)),
        DataCell(Text(row.asistencia)),
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
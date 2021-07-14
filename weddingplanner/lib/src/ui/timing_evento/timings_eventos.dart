// imports dart/flutter
import 'package:flutter/material.dart';

class TimingsEventos extends StatefulWidget {
  const TimingsEventos({ Key key }) : super(key: key);

  @override
  _TimingsEventosState createState() => _TimingsEventosState();
}

class _TimingsEventosState extends State<TimingsEventos> {

  //stilos
  final TextStyle _boldStyle = TextStyle(fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _rowTiming(),
    );
  }

  // ventanas - filas
  Widget _rowTiming() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        _crearTabla(),
        _crearTabla(),
      ],
    );
  }

  // fila 1 - tabla-timing // la columna de la tabla no cubre todo su espacio
  // Widget _tablaTiming() {
  //   return Expanded(
  //     child: Column(
  //       children: [
  //         _crearTabla(),
  //       ],
  //     ),
  //   );
  // }

  // crea tabla-timing
  Widget _crearTabla() {
    return Expanded(
      child: PaginatedDataTable(
        header: _crearHeader(),
        columns: _crearColumnas(),
        source: DTS(timingsList: _crearLista()),
        rowsPerPage: 1,
        // showCheckboxColumn: null,
      ),
    );
  }

  // crear header
  Widget _crearHeader() {
    return null;
  }

  // crear columnas
  List<DataColumn> _crearColumnas() {
    return [
      DataColumn(
        label: Text(
          'Timing',
          style: _boldStyle,
        ),
      ),
    ];
  }

  // crear lista
  List<List<DataCell>> _crearLista() {
    List<List<DataCell>> timingsList = [];
    
    // testData
    List<DataCell> timingsListNoData = [
      DataCell(Text('Sin datos')),
    ];

    // send data
    timingsList.add(timingsListNoData);
    return timingsList;
  }

}

class DTS extends DataTableSource {
  // modelo
  final List<List<DataCell>> _timingsList;

  DTS({
    @required List<List<DataCell>> timingsList
  }) : _timingsList = timingsList,
    assert(timingsList != null);

  @override
  DataRow getRow(int index) {
    return DataRow.byIndex(
      index: index,
      cells: _timingsList[index],
    );
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => _timingsList.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;

}
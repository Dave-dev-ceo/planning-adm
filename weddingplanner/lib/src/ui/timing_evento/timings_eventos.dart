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
      children: <Widget>[
        _tablaTiming(),
      ],
    );
  }

  // fila 1 - tabla-timing
  Widget _tablaTiming() {
    return Column(
      children: <Widget>[
        //_crearTabla(),
      ],
    );
  }

  // crea tabla-timing
  Widget _crearTabla() {
    return PaginatedDataTable(
      header: _crearHeader(),
      columns: _crearColumnas(),
      source: DTS(),
      // rowsPerPage: null,
      // showCheckboxColumn: null,
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
          'Nombre',
          style: _boldStyle,
        ),
      ),
    ];
  }

  // crear lista

}

class DTS extends DataTableSource {
  @override
  DataRow getRow(int index) {
    // TODO: implement getRow
    return null;
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => 10;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;

}
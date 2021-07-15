// imports dart/flutter
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';

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
      padding: EdgeInsets.all(30.0),
      child: Center(child: _agregarTabla()),
    );
  }

  Widget _agregarTabla(){
    return ListView(
      children: [
        StickyHeader(
          header: _crearHeader(),
          content: _crearTabla(),
        ),
      ],
    );
  }

  // crea tabla-timing
  Widget _crearTabla() {
    return SizedBox(
      width: double.infinity,
      child: PaginatedDataTable(
        // header: _crearHeader(),
        columns: _crearColumnas(),
        source: DTS(timingsList: _crearLista()),
        rowsPerPage: 1,
        // showCheckboxColumn: null,
      ),
    );
  }

  // crear header
  Widget _crearHeader() {
    return Container(
      height: 100.0,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 35.0),
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 3, child: Text('Actividades', style: TextStyle(fontSize: 20.0),)),
            Expanded(
                flex: 5,
                child: TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                      ),
                      hintText: 'Buscar...'),
                  // onChanged: (valor) {_buscadorInvitados(valor,asistencia);},
                )),
          ],
        ),
      ),
    );
  }

  // crear columnas
  List<DataColumn> _crearColumnas() {
    return [
      DataColumn(
        label: Text(
          '',
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
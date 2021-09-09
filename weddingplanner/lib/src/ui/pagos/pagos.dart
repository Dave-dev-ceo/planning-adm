import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:weddingplanner/src/models/item_model_pagos.dart';

class Pagos extends StatefulWidget {
  Pagos({Key key}) : super(key: key);

  @override
  _PagosState createState() => _PagosState();
}

class _PagosState extends State<Pagos> {
  // vaiables modelo
  ItemModelPagos itemPago;

  // styles
  final TextStyle _boldStyle = TextStyle(fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bloc(),
    );
  }

  _bloc() {
    return _stickyHeader(itemPago);
  }

  _stickyHeader(itemPago) {
    return Center(
      child: ListView(
        children: [
          StickyHeader(header: _getHeader(), content: _getContent(itemPago))
        ],
      ),
    );
  }

  _getHeader() {
    return Container(
        height: 100.0,
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 35.0),
        alignment: Alignment.centerLeft,
        child: _crearHeader());
  }

  _crearHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text('Pagos',style: TextStyle(fontSize: 20.0),)
          ),
        ],
      ),
    );
  }

  _getContent(itemPago) {
    return Expanded(
        child: SizedBox(
      width: double.infinity,
      child: PaginatedDataTable(
        // header: _crearHeader(asistencia),
        columns: _crearColumna(),
        source: DTS(pago: _crearLista(itemPago)),
        onRowsPerPageChanged: null,
        // rowsPerPage: itemPago.pagos.length == 0 ? 1 : itemPago.pagos.length,
        dataRowHeight: 90.0,
      ),
    ));
  }

  List<DataColumn> _crearColumna() {
    return [
      DataColumn(
        label: Text('Cantidad',style: _boldStyle,),
      ),
      DataColumn(
        label: Text('Poveedor',style: _boldStyle,),
      ),
      DataColumn(
        label: Text('Descripción',style: _boldStyle,),
      ),
      DataColumn(
        label: Text('P/U',style: _boldStyle,),
      ),
      DataColumn(
        label: Text('Total',style: _boldStyle,),
      ),
      DataColumn(
        label: Text('Anticipo',style: _boldStyle,),
      ),
      DataColumn(
        label: Text('Saldo',style: _boldStyle,),
      ),
    ];
  }

  _crearLista(itemPago) {
    List<List<DataCell>> pagosList = [];
    // if (itemPago.pagos.length > 0) {
    //   itemPago.pagos.forEach((element) {
    //     List<DataCell> pagosListTemp = [
    //       DataCell(
    //         Text('')
    //       ),
    //       DataCell(
    //         Text('')
    //       ),
    //       DataCell(
    //         Text('')
    //       ),
    //     ];
    //     pagosList.add(pagosListTemp);
    //   });
    // } else {
      List<DataCell> pagosListNoData = [
        DataCell(Text('Sin datos')),
        DataCell(Text('Sin datos')),
        DataCell(Text('Sin datos')),
        DataCell(Text('Sin datos')),
        DataCell(Text('Sin datos')),
        DataCell(Text('Sin datos')),
        DataCell(Text('Sin datos')),
      ];
      pagosList.add(pagosListNoData);
    // }

    return pagosList;
  }
}

class DTS extends DataTableSource {
  // modelo
  final List<List<DataCell>> _pagos;

  DTS({@required List<List<DataCell>> pago})
      : _pagos = pago,
        assert(pago != null);

  @override
  DataRow getRow(int index) {
    return DataRow.byIndex(
      index: index,
      cells: _pagos[index],
    );
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => _pagos.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
}

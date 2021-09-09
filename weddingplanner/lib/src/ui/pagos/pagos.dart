import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:weddingplanner/src/blocs/pagos/pagos_bloc.dart';
import 'package:weddingplanner/src/models/item_model_pagos.dart';

class Pagos extends StatefulWidget {
  Pagos({Key key}) : super(key: key);

  @override
  _PagosState createState() => _PagosState();
}

class _PagosState extends State<Pagos> {
  // variables bloc
  PagosBloc pagosBloc;

  // vaiables modelo
  ItemModelPagos itemPago;

  // styles
  final TextStyle _boldStyle = TextStyle(fontWeight: FontWeight.bold);

  @override
  void initState() { 
    super.initState();
    pagosBloc = BlocProvider.of<PagosBloc>(context);
    pagosBloc.add(SelectPagosEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bloc(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _botonAction(),
    );
  }

  _bloc() {
    return BlocBuilder<PagosBloc, PagosState>(
      builder: (context, state) {
        if(state is PagosInitial) {
          return Center(child: CircularProgressIndicator(),);
        } else if(state is PagosLogging) {
          return Center(child: CircularProgressIndicator(),);
        }  else if(state is PagosSelect) {
          return _stickyHeader(state.pagos);
        } else {
          return Center(child: CircularProgressIndicator(),);
        }
      },
    );
    
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
        rowsPerPage: itemPago.pagos.length == 0 ? 1 : itemPago.pagos.length+1,
        dataRowHeight: 25.0,
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

  _crearLista(ItemModelPagos itemPago) {
    List<List<DataCell>> pagosList = [];
    if (itemPago.pagos.length > 0) {
      var total = 0;
      var saldo = 0;
      itemPago.pagos.forEach((element) {
        total += element.total;
        saldo += element.saldo;
        List<DataCell> pagosListTemp = [
          DataCell(
            Center(
              child: Row(
                children: [
                  Expanded(
                    child: Icon(Icons.delete),
                  ),
                  Expanded(
                    child: Text('${element.cantidad}'),
                  )
                ],
              ),
            ),
            onTap: () => _deletePago(element.idConcepto)
          ),
          DataCell(
            Center(child: Text('${element.proveedor}')),
            onTap: () => _editarPago(element.idConcepto)
          ),
          DataCell(
            Text('${element.descripcion}'),
            onTap: () => _editarPago(element.idConcepto)
          ),
          DataCell(
            Text('\$${element.precioUnitario}.00'),
            onTap: () => _editarPago(element.idConcepto)
          ),
          DataCell(
            Text('\$${element.total}.00'),
            onTap: () => _editarPago(element.idConcepto)
          ),
          DataCell(
            Text('\$${element.anticipo}.00'),
            onTap: () => _editarPago(element.idConcepto)
          ),
          DataCell(
            Text('\$${element.saldo}.00'),
            onTap: () => _editarPago(element.idConcepto)
          ),
        ];
        pagosList.add(pagosListTemp);
      });
      List<DataCell> pagosLast = [
        DataCell(Center(),),
        DataCell(Center(),),
        DataCell(Center(),),
        DataCell(Center(),),
        DataCell(Center(child: Text('\$${total}.00',style: _boldStyle),),),
        DataCell(Center(),),
        DataCell(Center(child: Text('\$${saldo}.00',style: _boldStyle),),),
      ];
      pagosList.add(pagosLast);
    } else {
      List<DataCell> pagosListNoData = [
        DataCell(Text('Sin datos')),
        DataCell(Text('Sin datos')),
        DataCell(Text('Sin datos')),
        DataCell(Text('Sin datos')),
        DataCell(Text('Sin datos')),
        DataCell(Text('Sin datos')),
        DataCell(Text('Sin datos')),
      ];

      // for(int i = 0; i<101; i++ )
      pagosList.add(pagosListNoData);
    }

    return pagosList;
  }

  _botonAction() {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () => _agregarPago(),
    );
  }

  _agregarPago() {
    Navigator.pushNamed(context, '/addPagosForm');
  }

  _editarPago(idConcepto) {
    Navigator.pushNamed(context, '/editPagosForm',arguments: idConcepto);
  }

  _deletePago(idConcepto) {
    _alertaBorrar(idConcepto);
  }

  Future<void> _alertaBorrar(int id) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Estás por borrar un pago.'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                // Center(child: Text('La actividad: $Nombre')),
                // SizedBox(height: 15.0,),
                Center(child: Text('¿Deseas confirmar?')),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Confirmar'),
              onPressed: () {
                Navigator.of(context).pop();
                pagosBloc.add(DeletePagosEvent(id));
                _mensaje('Pago borrado');
              },
            ),
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // mensaje
  Future<void> _mensaje(String txt) async {
    return await ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(txt),
      )
    );
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

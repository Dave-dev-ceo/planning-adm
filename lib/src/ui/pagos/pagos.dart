import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/blocs/historialPagos/historialpagos_bloc.dart';
import 'package:planning/src/logic/historial_pagos/historial_pagos_logic.dart';
import 'package:planning/src/logic/pagos_logic.dart';
import 'package:planning/src/models/historialPagos/historial_pagos_model.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/ui/pagos/agregar_pago_dialog.dart';
import 'package:planning/src/utils/utils.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:planning/src/blocs/pagos/pagos_bloc.dart';
import 'package:planning/src/models/item_model_pagos.dart';

class Pagos extends StatefulWidget {
  Pagos({Key key}) : super(key: key);

  @override
  _PagosState createState() => _PagosState();
}

class _PagosState extends State<Pagos> with SingleTickerProviderStateMixin {
  // variables bloc
  PagosBloc pagosBloc;
  HistorialPagosBloc historialPagosBloc;

  // vaiables modelo
  ItemModelPagos itemPago;

  // logic
  ConsultasPagosLogic pagosLogic = ConsultasPagosLogic();
  NumberFormat f = new NumberFormat("#,##0.00", "en_US");
  TabController _tabController;

  // styles
  final TextStyle _boldStyle = TextStyle(fontWeight: FontWeight.bold);
  SharedPreferencesT _sharedPreferences = new SharedPreferencesT();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  HistorialPagosLogic logicPagos = HistorialPagosLogic();

  bool isInvolucrado;

  int totalpresupuestos = 0;
  int totalsaldopresupuestoInterno = 0;
  int totalsaldopresupuestoEvento = 0;
  double totalpagosInternos = 0;
  double totalpagosEventos = 0;
  int index = 0;

  @override
  void initState() {
    super.initState();

    pagosBloc = BlocProvider.of<PagosBloc>(context);
    historialPagosBloc = BlocProvider.of<HistorialPagosBloc>(context);
    pagosBloc.add(SelectPagosEvent());
    historialPagosBloc.add(MostrarHistorialPagosEvent());

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      index = _tabController.index;
    });
    isInvolucradoFunction();
  }

  @override
  void dispose() {
    super.dispose();
  }

  isInvolucradoFunction() async {
    var idInvolucrado = await _sharedPreferences.getIdInvolucrado();

    if (idInvolucrado != null) {
      isInvolucrado = true;
    } else {
      isInvolucrado = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(child: bodyPagosPlanner()),
          SingleChildScrollView(child: pagosEventos())
        ],
      ),
      bottomNavigationBar: TabBar(
        controller: _tabController,
        tabs: [
          Tab(
            text: 'Interno',
            icon: Tooltip(
              message: 'Interno',
              child: Icon(Icons.insert_chart_outlined_sharp),
            ),
          ),
          Tab(
            text: 'Evento',
            icon: Tooltip(
              message: 'Evento',
              child: Icon(Icons.event),
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _botonAction(),
    );
  }

  Widget pagosEventos() {
    return Column(
      children: [
        _bloc(),
        SizedBox(height: 10.0),
        Row(
          children: [
            SizedBox(
              width: 20.0,
            ),
            Text(
              'Pagos',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(
              width: 100,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.black),
                onPressed: () {
                  _abrirDialog('E', false, HistorialPagosModel());
                },
                child: Text(
                  'Agregar Pago',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        _historialDePagos('E'),
        SizedBox(
          height: 100.0,
        )
      ],
    );
  }

  Widget bodyPagosPlanner() {
    return Column(
      children: [
        _bloc(),
        SizedBox(height: 10.0),
        Row(
          children: [
            SizedBox(
              width: 20.0,
            ),
            Text(
              'Pagos',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(
              width: 100,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.black),
              onPressed: () {
                _abrirDialog('I', false, HistorialPagosModel());
              },
              child: Text(
                'Agregar Pago',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        _historialDePagos('I'),
        SizedBox(
          height: 100.0,
        )
      ],
    );
  }

  Widget _historialDePagos(String tipoPresupuesto) {
    return BlocBuilder<HistorialPagosBloc, HistorialPagosState>(
      builder: (context, state) {
        if (state is LoadingHistorialPagosState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is MostrarHistorialPagosState) {
          totalsaldopresupuestoInterno = 0;
          totalsaldopresupuestoEvento = 0;
          totalpagosInternos = 0;
          totalpagosEventos = 0;
          state.listaPagos.forEach((pago) {
            if ('E' == pago.tipoPresupuesto) {
              totalpagosEventos += pago.pago;
            } else {
              totalpagosInternos += pago.pago;
            }
          });

          totalsaldopresupuestoEvento =
              totalpresupuestos - int.tryParse(totalpagosEventos.toString());

          totalsaldopresupuestoInterno =
              totalpresupuestos - int.tryParse(totalpagosInternos.toString());

          return buildTablePagos(state.listaPagos, tipoPresupuesto);
        } else {
          return Container();
        }
      },
    );
  }

  Widget buildTablePagos(
      List<HistorialPagosModel> pagos, String tipoPresupuesto) {
    return PaginatedDataTable(
      columns: [
        DataColumn(
          label: Text(
            '',
            style: _boldStyle,
          ),
        ),
        DataColumn(
          label: Text(
            'Fecha',
            style: _boldStyle,
          ),
        ),
        DataColumn(
          label: Text(
            'Concepto',
            style: _boldStyle,
          ),
        ),
        DataColumn(
          label: Text(
            'Monto',
            style: _boldStyle,
          ),
          numeric: true,
        ),
      ],
      source: DTS(
          pago: (tipoPresupuesto == 'I')
              ? _crearListaPagos(pagos)
              : _crearListaPagosEventos(pagos)),
      onRowsPerPageChanged: null,
      rowsPerPage: pagos.length == 0 ? 1 : pagos.length + 1,
      dataRowHeight: 25.0,
    );
  }

  List<List<DataCell>> _crearListaPagos(List<HistorialPagosModel> pagos) {
    List<List<DataCell>> pagosEventosList = [];

    pagos.forEach((pago) {
      if ('I' == pago.tipoPresupuesto) {
        List<DataCell> pagosListTemp = [
          DataCell(
              Center(
                child: Icon(
                  Icons.delete,
                ),
              ), onTap: () async {
            await showDialog(
              context: _scaffoldKey.currentContext,
              builder: (context) => AlertDialog(
                title: Text('Eliminar pago'),
                content: Text(
                    '¿Desea eliminar el pago con concepto: ${pago.concepto}?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final resp =
                          await logicPagos.eliminarPagoEvento(pago.idPago);

                      if (resp == 'Ok') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Se ha eliminado el pago'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.of(context, rootNavigator: true).pop(true);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(resp),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: Text('Aceptar'),
                  ),
                ],
              ),
            ).then((value) => {
                  if (value != null)
                    {
                      context
                          .read<HistorialPagosBloc>()
                          .add(MostrarHistorialPagosEvent()),
                      if (value)
                        {
                          pagosBloc.add(SelectPagosEvent()),
                        }
                    }
                });
          }),
          DataCell(
            Text(
              '${pago.fecha.day}-${pago.fecha.month}-${pago.fecha.year}',
            ),
          ),
          DataCell(
            Text(pago.concepto),
            onTap: () {
              _abrirDialog('I', true, pago);
            },
          ),
          DataCell(
              Text(
                pago.pago.toString(),
              ), onTap: () {
            _abrirDialog('I', true, pago);
          }),
        ];
        pagosEventosList.add(pagosListTemp);
      }
    });

    return pagosEventosList;
  }

  List<List<DataCell>> _crearListaPagosEventos(
      List<HistorialPagosModel> pagos) {
    List<List<DataCell>> pagosEventosList = [];

    if (pagos.length > 0) {
      pagos.forEach((pago) {
        if ('E' == pago.tipoPresupuesto) {
          List<DataCell> pagosListTemp = [
            DataCell(
                Center(
                  child: Icon(
                    Icons.delete,
                  ),
                ), onTap: () async {
              await showDialog(
                context: _scaffoldKey.currentContext,
                builder: (context) => AlertDialog(
                  title: Text('Eliminar pago'),
                  content: Text(
                      '¿Desea eliminar el pago con concepto: ${pago.concepto}?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () async {
                        final resp =
                            await logicPagos.eliminarPagoEvento(pago.idPago);

                        if (resp == 'Ok') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Se ha eliminado el pago'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.of(context, rootNavigator: true).pop(true);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(resp),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: Text('Aceptar'),
                    ),
                  ],
                ),
              ).then((value) => {
                    if (value != null)
                      {
                        context
                            .read<HistorialPagosBloc>()
                            .add(MostrarHistorialPagosEvent()),
                        if (value) {pagosBloc.add(SelectPagosEvent())}
                      }
                  });
            }),
            DataCell(
              Text(
                '${pago.fecha.day}-${pago.fecha.month}-${pago.fecha.year}',
              ),
            ),
            DataCell(Text(pago.concepto), onTap: () {
              _abrirDialog('E', true, pago);
            }),
            DataCell(
                Text(
                  pago.pago.toString(),
                ), onTap: () {
              _abrirDialog('E', true, pago);
            }),
          ];
          pagosEventosList.add(pagosListTemp);
        }
      });
    } else {
      List<DataCell> pagosListWitoutData = [
        DataCell(Text('Sin datos')),
        DataCell(Text('Sin datos')),
        DataCell(Text('Sin datos')),
        DataCell(Text('Sin datos')),
      ];
      pagosEventosList.add(pagosListWitoutData);
    }

    return pagosEventosList;
  }

  _bloc() {
    return BlocBuilder<PagosBloc, PagosState>(
      builder: (context, state) {
        if (state is PagosInitial) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is PagosLogging) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is PagosSelect) {
          totalpresupuestos = 0;
          state.pagos.pagos.forEach((pago) {
            totalpresupuestos += pago.total;
          });

          return _stickyHeader(state.pagos);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  _stickyHeader(itemPago) {
    return Center(
      child: ListView(
        shrinkWrap: true,
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              index == 0 ? 'Presupuesto Interno' : 'Presupuesto del Evento',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          RichText(
            text: TextSpan(
              text: 'Total: ',
              children: [
                TextSpan(
                  text: '\$${f.format(totalpresupuestos)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: 8.0,
          ),
          RichText(
            text: TextSpan(
              text: 'Pagos: ',
              children: [
                TextSpan(
                  text: index == 0
                      ? '\$${f.format(totalpagosInternos)}'
                      : '\$${f.format(totalpagosEventos)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: 8.0,
          ),
          RichText(
            text: TextSpan(
              text: 'Saldo: ',
              children: [
                TextSpan(
                  text: index == 0
                      ? '\$${f.format(totalsaldopresupuestoInterno)}'
                      : '\$${f.format(totalsaldopresupuestoEvento)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _getContent(itemPago) {
    return PaginatedDataTable(
      // header: _crearHeader(asistencia),
      columns: _crearColumna(),
      source: DTS(pago: _crearLista(itemPago)),
      onRowsPerPageChanged: null,
      rowsPerPage: itemPago.pagos.length == 0 ? 1 : itemPago.pagos.length + 1,
      dataRowHeight: 25.0,
    );
  }

  List<DataColumn> _crearColumna() {
    return [
      DataColumn(
        label: Text(
          'Cantidad',
          style: _boldStyle,
        ),
      ),
      DataColumn(
        label: Text(
          'Poveedor',
          style: _boldStyle,
        ),
      ),
      DataColumn(
        label: Text(
          'Descripción',
          style: _boldStyle,
        ),
      ),
      DataColumn(
        label: Text(
          'P/U',
          style: _boldStyle,
        ),
      ),
    ];
  }

  _abrirDialog(
      String tipoPresupuesto, bool edit, HistorialPagosModel pago) async {
    await showDialog(
      context: _scaffoldKey.currentContext,
      builder: (context) => AgregarPagoDialog(
        tipoPresupuesto: tipoPresupuesto,
        isEdit: edit,
        pagoModel: pago,
      ),
    ).then(
      (value) => {
        if (value != null)
          {
            if (value)
              {
                {pagosBloc.add(SelectPagosEvent())}
              }
          }
      },
    );
  }

  _crearLista(ItemModelPagos itemPago) {
    List<List<DataCell>> pagosList = [];
    if (itemPago.pagos.length > 0) {
      var total = 0;
      var saldo = 0;
      itemPago.pagos.forEach((element) {
        total += element.total;
        saldo += element.saldo;
        String precioUnitario = f.format(element.precioUnitario);

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
              onTap: () => _deletePago(element.idConcepto)),
          DataCell(Center(child: Text('${element.proveedor}')),
              onTap: () => _editarPago(element.idConcepto)),
          DataCell(Text('${element.descripcion}'),
              onTap: () => _editarPago(element.idConcepto)),
          DataCell(
              Align(
                  alignment: Alignment.centerRight,
                  child: Text('\$$precioUnitario')),
              onTap: () => _editarPago(element.idConcepto)),
        ];
        pagosList.add(pagosListTemp);
      });
      List<DataCell> pagosLast = [
        DataCell(
          Center(),
        ),
        DataCell(
          Center(),
        ),
        DataCell(
          Center(),
        ),
        DataCell(
          Center(),
        ),
      ];
      pagosList.add(pagosLast);
    } else {
      List<DataCell> pagosListNoData = [
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

  Widget _botonAction() {
    return SpeedDial(
      icon: Icons.more_vert,
      children: [
        SpeedDialChild(
          label: 'Agregar presupuesto',
          child: Icon(Icons.add),
          onTap: () => _agregarPago(),
        ),
        SpeedDialChild(
          label: 'Descargar PDF',
          child: Icon(Icons.download),
          onTap: () async {
            final data = await pagosLogic.downlooadPagosEvento();
            if (data != null) {
              buildPDFDownload(data, 'Pagos-Evento');
            }
          },
        )
      ],
    );
  }

  _agregarPago() {
    Navigator.pushNamed(context, '/addPagosForm');
  }

  _editarPago(idConcepto) {
    Navigator.pushNamed(context, '/editPagosForm', arguments: idConcepto);
  }

  _deletePago(idConcepto) {
    _alertaBorrar(idConcepto);
  }

  Future<void> _alertaBorrar(int id) {
    return showDialog<void>(
      context: _scaffoldKey.currentContext,
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
    return await ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(txt),
    ));
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

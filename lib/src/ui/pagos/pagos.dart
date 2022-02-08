// ignore_for_file: unused_local_variable

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/blocs/historialPagos/historialpagos_bloc.dart';
import 'package:planning/src/logic/historial_pagos/historial_pagos_logic.dart';
import 'package:planning/src/logic/pagos_logic.dart';
import 'package:planning/src/models/historialPagos/historial_pagos_model.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/ui/pagos/agregar_pago_dialog.dart';
import 'package:planning/src/ui/widgets/snackbar_widget/snackbar_widget.dart';
import 'package:planning/src/utils/utils.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:planning/src/blocs/pagos/pagos_bloc.dart';
import 'package:planning/src/models/item_model_pagos.dart';

class Pagos extends StatefulWidget {
  const Pagos({Key key}) : super(key: key);

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
  NumberFormat f = NumberFormat("#,##0.00", "en_US");
  TabController _tabController;

  // styles
  final TextStyle _boldStyle = const TextStyle(fontWeight: FontWeight.bold);
  final SharedPreferencesT _sharedPreferences = SharedPreferencesT();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  HistorialPagosLogic logicPagos = HistorialPagosLogic();

  bool isInvolucrado = false;
  bool isPressed = false;
  int index = 0;
  Size size;

  var myGroup = AutoSizeGroup();

  @override
  void initState() {
    super.initState();

    pagosBloc = BlocProvider.of<PagosBloc>(context);
    historialPagosBloc = BlocProvider.of<HistorialPagosBloc>(context);
    pagosBloc.add(SelectPagosEvent());
    // historialPagosBloc.add(MostrarHistorialPagosEvent());

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
      setState(() {
        isInvolucrado = true;
        index = 1;
      });
    } else {
      setState(() {
        isInvolucrado = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    if (isInvolucrado) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Presupuestos'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          controller: ScrollController(),
          child: RefreshIndicator(
            color: Colors.blue,
            onRefresh: () async {
              pagosBloc.add(SelectPagosEvent());
              historialPagosBloc.add(MostrarHistorialPagosEvent());
            },
            child: _bloc('E'),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: _botonAction(),
      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        body: TabBarView(
          controller: _tabController,
          children: [
            SingleChildScrollView(
                controller: ScrollController(),
                child: RefreshIndicator(
                    color: Colors.blue,
                    onRefresh: () async {
                      pagosBloc.add(SelectPagosEvent());
                      historialPagosBloc.add(MostrarHistorialPagosEvent());
                    },
                    child: _bloc('I'))),
            SingleChildScrollView(
                controller: ScrollController(),
                child: RefreshIndicator(
                    color: Colors.blue,
                    onRefresh: () async {
                      pagosBloc.add(SelectPagosEvent());
                      historialPagosBloc.add(MostrarHistorialPagosEvent());
                    },
                    child: _bloc('E')))
          ],
        ),
        bottomNavigationBar: TabBar(
          controller: _tabController,
          tabs: const [
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
  }

  Widget buildTablePagos(
      List<HistorialPagosModel> pagos, String tipoPresupuesto) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: PaginatedDataTable(
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
        rowsPerPage: pagos.isEmpty ? 1 : pagos.length + 1,
        dataRowHeight: 25.0,
      ),
    );
  }

  List<List<DataCell>> _crearListaPagos(List<HistorialPagosModel> pagos) {
    List<List<DataCell>> pagosEventosList = [];

    if (pagos.isNotEmpty) {
      for (var pago in pagos) {
        if ('I' == pago.tipoPresupuesto) {
          List<DataCell> pagosListTemp = [
            DataCell(
                const Center(
                  child: Icon(
                    Icons.delete,
                  ),
                ), onTap: () async {
              if (!isInvolucrado) {
                await showDialog(
                  context: _scaffoldKey.currentContext,
                  builder: (context) => AlertDialog(
                    title: const Text('Eliminar pago'),
                    content: Text(
                        '¿Desea eliminar el pago con concepto: ${pago.concepto}?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () async {
                          final resp =
                              await logicPagos.eliminarPagoEvento(pago.idPago);

                          if (resp == 'Ok') {
                            MostrarAlerta(
                                mensaje: 'Se ha eliminado el pago',
                                tipoMensaje: TipoMensaje.correcto);
                            Navigator.of(context, rootNavigator: true)
                                .pop(true);
                          } else {
                            MostrarAlerta(
                                mensaje: resp, tipoMensaje: TipoMensaje.error);
                          }
                        },
                        child: const Text('Aceptar'),
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
              }
            }),
            DataCell(
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${pago.fecha.day}-${pago.fecha.month}-${pago.fecha.year}',
                ),
              ),
              onTap: () {
                if (!isInvolucrado) {
                  _abrirDialog('I', true, pago);
                }
              },
            ),
            DataCell(
              Align(
                  alignment: Alignment.centerLeft, child: Text(pago.concepto)),
              onTap: () {
                if (!isInvolucrado) {
                  _abrirDialog('I', true, pago);
                }
              },
            ),
            DataCell(
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '\$${f.format(pago.pago)}',
                  ),
                ), onTap: () {
              if (!isInvolucrado) {
                _abrirDialog('I', true, pago);
              }
            }),
          ];
          pagosEventosList.add(pagosListTemp);
        }
      }
    } else {
      List<DataCell> pagosListWitoutData = [
        const DataCell(Text('Sin datos')),
        const DataCell(Text('Sin datos')),
        const DataCell(Text('Sin datos')),
        const DataCell(Text('Sin datos')),
      ];
      pagosEventosList.add(pagosListWitoutData);
    }

    return pagosEventosList;
  }

  List<List<DataCell>> _crearListaPagosEventos(
      List<HistorialPagosModel> pagos) {
    List<List<DataCell>> pagosEventosList = [];

    if (pagos.isNotEmpty) {
      for (var pago in pagos) {
        if ('E' == pago.tipoPresupuesto) {
          List<DataCell> pagosListTemp = [
            DataCell(
                const Center(
                  child: Icon(
                    Icons.delete,
                  ),
                ), onTap: () async {
              if (!isInvolucrado) {
                await showDialog(
                  context: _scaffoldKey.currentContext,
                  builder: (context) => AlertDialog(
                    title: const Text('Eliminar pago'),
                    content: Text(
                        '¿Desea eliminar el pago con concepto: ${pago.concepto}?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () async {
                          final resp =
                              await logicPagos.eliminarPagoEvento(pago.idPago);

                          if (resp == 'Ok') {
                            MostrarAlerta(
                                mensaje: 'Se ha eliminado el pago',
                                tipoMensaje: TipoMensaje.correcto);
                            Navigator.of(context, rootNavigator: true)
                                .pop(true);
                          } else {
                            MostrarAlerta(
                                mensaje: resp, tipoMensaje: TipoMensaje.error);
                          }
                        },
                        child: const Text('Aceptar'),
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
              }
            }),
            DataCell(
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${pago.fecha.day}-${pago.fecha.month}-${pago.fecha.year}',
                  ),
                ), onTap: () {
              if (!isInvolucrado) {
                _abrirDialog('E', true, pago);
              }
            }),
            DataCell(
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(pago.concepto)), onTap: () {
              if (!isInvolucrado) {
                _abrirDialog('E', true, pago);
              }
            }),
            DataCell(
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '\$${f.format(pago.pago)}',
                  ),
                ), onTap: () {
              if (!isInvolucrado) {
                _abrirDialog('E', true, pago);
              }
            }),
          ];
          pagosEventosList.add(pagosListTemp);
        }
      }
    } else {
      List<DataCell> pagosListWitoutData = [
        const DataCell(Text('Sin datos')),
        const DataCell(Text('Sin datos')),
        const DataCell(Text('Sin datos')),
        const DataCell(Text('Sin datos')),
      ];
      pagosEventosList.add(pagosListWitoutData);
    }

    return pagosEventosList;
  }

  _bloc(String tipoPage) {
    setState(() {});
    return BlocBuilder<PagosBloc, PagosState>(
      builder: (context, state) {
        if (state is PagosInitial) {
          return const Center(
            child: LoadingCustom(),
          );
        } else if (state is PagosLogging) {
          return const Center(
            child: LoadingCustom(),
          );
        } else if (state is PagosSelect) {
          int totalsaldopresupuesto = 0;
          int totalpagos = 0;
          int totalpresupuestos = 0;
          if (state.pagos != null && state.pagos.pagos.isNotEmpty ||
              state.listaPagos != null && state.listaPagos.isNotEmpty) {
            isPressed = true;
            for (var pago in state.pagos.pagos) {
              if (tipoPage == pago.tipoPresupuesto) {
                totalpresupuestos += pago.total;
              }
            }

            for (var pago in state.listaPagos) {
              if (tipoPage == pago.tipoPresupuesto) {
                totalpagos += pago.pago.toInt();
              }
            }

            totalsaldopresupuesto = totalpresupuestos - totalpagos;

            bool canAddPay = false;

            if (totalpresupuestos > 0) {
              canAddPay = true;
            }

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  _stickyHeader(
                    state.pagos,
                    tipoPage,
                    totalsaldopresupuesto,
                    totalpagos,
                    totalpresupuestos,
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      const SizedBox(
                        width: 20.0,
                      ),
                      const Text(
                        'Pagos',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      const SizedBox(
                        width: 100,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.black),
                        onPressed: !isInvolucrado
                            ? () {
                                if (canAddPay) {
                                  _abrirDialog(
                                      tipoPage, false, HistorialPagosModel());
                                } else {
                                  MostrarAlerta(
                                      mensaje:
                                          'Es necesario agregar presupuestos.',
                                      tipoMensaje: TipoMensaje.advertencia);
                                }
                              }
                            : null,
                        child: const Text(
                          'Agregar Pago',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  buildTablePagos(state.listaPagos, tipoPage),
                  const SizedBox(
                    height: 100.0,
                  )
                ],
              ),
            );
          } else {
            return Center(
              child: ListView(
                shrinkWrap: true,
                children: [
                  StickyHeader(
                    header: _getHeader(
                        totalsaldopresupuesto, totalpagos, totalpresupuestos),
                    content: Container(
                        height: 100.0,
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 35.0),
                        alignment: Alignment.centerLeft,
                        child: const Center(
                          child: Text(
                            'No existen presupuestos registrados.',
                            style: TextStyle(fontSize: 15.0),
                          ),
                        )),
                  )
                ],
              ),
            );
          }
        } else {
          return const Center(
            child: LoadingCustom(),
          );
        }
      },
    );
  }

  _stickyHeader(itemPago, String tipoPage, int totalsaldopresupuesto,
      int totalpagos, int totalpresupuestos) {
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          StickyHeader(
              header: _getHeader(
                  totalsaldopresupuesto, totalpagos, totalpresupuestos),
              content: _getContent(itemPago, tipoPage))
        ],
      ),
    );
  }

  _getHeader(int totalsaldopresupuesto, int totalpagos, int totalpresupuestos) {
    return Container(
        height: size.width > 500 ? 100.0 : 120.0,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 35.0),
        alignment: Alignment.centerLeft,
        child:
            _crearHeader(totalsaldopresupuesto, totalpagos, totalpresupuestos));
  }

  _crearHeader(
      int totalsaldopresupuesto, int totalpagos, int totalpresupuestos) {
    if (size.width > 500) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Text(
                index == 0 ? 'Presupuesto Interno' : 'Presupuesto del Evento',
                style: const TextStyle(fontFamily: 'Comfortaa', fontSize: 20.0),
                maxLines: 2,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AutoSizeText.rich(
                  TextSpan(
                    text: 'Total: ',
                    style: const TextStyle(
                        color: Colors.black, fontFamily: 'Comfortaa'),
                    children: [
                      TextSpan(
                        text:
                            '\$${totalpresupuestos > 0 ? f.format(totalpresupuestos) : totalpresupuestos}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'Comfortaa',
                        ),
                      )
                    ],
                  ),
                  minFontSize: 5.0,
                  maxLines: 2,
                  style: const TextStyle(fontSize: 15),
                  group: myGroup,
                ),
                const SizedBox(
                  width: 8.0,
                ),
                AutoSizeText.rich(
                  TextSpan(
                    text: 'Pagos: ',
                    style: const TextStyle(
                        color: Colors.black, fontFamily: 'Comfortaa'),
                    children: [
                      TextSpan(
                        text:
                            '\$${totalpagos > 0 ? f.format(totalpagos) : totalpagos}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: 'Comfortaa'),
                      ),
                    ],
                  ),
                  minFontSize: 10.0,
                  maxLines: 2,
                  style: const TextStyle(fontSize: 15),
                  group: myGroup,
                ),
                const SizedBox(
                  width: 8.0,
                ),
                AutoSizeText.rich(
                  TextSpan(
                    text: 'Saldo: ',
                    style: const TextStyle(
                        color: Colors.black, fontFamily: 'Comfortaa'),
                    children: [
                      TextSpan(
                        text:
                            '\$${totalsaldopresupuesto > 0 ? f.format(totalsaldopresupuesto) : totalsaldopresupuesto}',
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Comfortaa'),
                      )
                    ],
                  ),
                  group: myGroup,
                  minFontSize: 10.0,
                  maxLines: 2,
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            )
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              index == 0 ? 'Presupuesto Interno' : 'Presupuesto del Evento',
              style: const TextStyle(fontFamily: 'Comfortaa', fontSize: 20.0),
              maxLines: 2,
            ),
            const SizedBox(
              height: 10.0,
            ),
            AutoSizeText.rich(
              TextSpan(
                text: 'Total: ',
                style: const TextStyle(
                    color: Colors.black, fontFamily: 'Comfortaa'),
                children: [
                  TextSpan(
                    text:
                        '\$${totalpresupuestos > 0 ? f.format(totalpresupuestos) : totalpresupuestos}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Comfortaa'),
                  )
                ],
              ),
              minFontSize: 5.0,
              maxLines: 2,
              style: const TextStyle(fontSize: 15),
              group: myGroup,
            ),
            const SizedBox(
              height: 8.0,
            ),
            AutoSizeText.rich(
              TextSpan(
                text: 'Saldo: ',
                style: const TextStyle(
                    color: Colors.black, fontFamily: 'Comfortaa'),
                children: [
                  TextSpan(
                    text:
                        '\$${totalsaldopresupuesto > 0 ? f.format(totalsaldopresupuesto) : totalsaldopresupuesto}',
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Comfortaa'),
                  )
                ],
              ),
              group: myGroup,
              minFontSize: 10.0,
              maxLines: 2,
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(
              height: 8.0,
            ),
            AutoSizeText.rich(
              TextSpan(
                text: 'Pagos: ',
                style: const TextStyle(
                    color: Colors.black, fontFamily: 'Comfortaa'),
                children: [
                  TextSpan(
                    text:
                        '\$${totalpagos > 0 ? f.format(totalpagos) : totalpagos}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Comfortaa'),
                  ),
                ],
              ),
              minFontSize: 10.0,
              maxLines: 2,
              style: const TextStyle(fontSize: 15),
              group: myGroup,
            ),
          ],
        ),
      );
    }
  }

  _getContent(itemPago, String tipoPage) {
    return Container(
      alignment: Alignment.center,
      child: PaginatedDataTable(
        // header: _crearHeader(asistencia),
        columns: _crearColumna(),
        source: DTS(pago: _crearLista(itemPago, tipoPage)),
        onRowsPerPageChanged: null,
        rowsPerPage: itemPago.pagos.length == 0 ? 1 : itemPago.pagos.length + 1,
        dataRowHeight: 25.0,
      ),
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
      DataColumn(
        label: Text(
          'Total',
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

  _crearLista(ItemModelPagos itemPago, String tipoPage) {
    List<List<DataCell>> pagosList = [];
    if (itemPago.pagos.isNotEmpty) {
      isPressed = true;
      var total = 0;
      var saldo = 0;
      for (var element in itemPago.pagos) {
        total += element.total;
        saldo += element.saldo;
        String precioUnitario = f.format(element.precioUnitario);

        List<DataCell> pagosListTemp = [
          DataCell(
              Center(
                child: Row(
                  children: [
                    const Expanded(
                      child: Icon(Icons.delete),
                    ),
                    Expanded(
                      child: Text('${element.cantidad}'),
                    )
                  ],
                ),
              ), onTap: () {
            if (!isInvolucrado) {
              _deletePago(element.idConcepto);
            }
          }),
          DataCell(
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(element.proveedor)), onTap: () {
            if (!isInvolucrado) {
              _editarPago(element.idConcepto);
            }
          }),
          DataCell(
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(element.descripcion)), onTap: () {
            if (!isInvolucrado) {
              _editarPago(element.idConcepto);
            }
          }),
          DataCell(
              Align(
                  alignment: Alignment.centerRight,
                  child: Text('\$$precioUnitario')), onTap: () {
            if (!isInvolucrado) {
              _editarPago(element.idConcepto);
            }
          }),
          DataCell(
              Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                      '\$${f.format(element.cantidad * element.precioUnitario)}')),
              onTap: () {
            if (!isInvolucrado) {
              _editarPago(element.idConcepto);
            }
          }),
        ];
        if (tipoPage == element.tipoPresupuesto) {
          pagosList.add(pagosListTemp);
        }
      }

      if (pagosList.isEmpty) {
        List<DataCell> pagosListNoData = [
          const DataCell(Text('Sin datos')),
          const DataCell(Text('Sin datos')),
          const DataCell(Text('Sin datos')),
          const DataCell(Text('Sin datos')),
          const DataCell(Text('Sin datos')),
        ];
        pagosList.add(pagosListNoData);
      }
    } else {
      List<DataCell> pagosListNoData = [
        const DataCell(Text('Sin datos')),
        const DataCell(Text('Sin datos')),
        const DataCell(Text('Sin datos')),
        const DataCell(Text('Sin datos')),
        const DataCell(Text('Sin datos')),
      ];

      // for(int i = 0; i<101; i++ )
      pagosList.add(pagosListNoData);
    }

    return pagosList;
  }

  Widget _botonAction() {
    return SpeedDial(
      icon: Icons.more_vert,
      tooltip: 'Opciones',
      children: [
        !isInvolucrado
            ? SpeedDialChild(
                label: 'Agregar presupuesto',
                child: const Icon(Icons.add),
                onTap: () => _agregarPago(),
              )
            : SpeedDialChild(),
        SpeedDialChild(
          label: 'Descargar PDF',
          child: const Icon(Icons.download),
          onTap: () async {
            final data = index == 0
                ? await pagosLogic.downlooadPagosEvento('I')
                : await pagosLogic.downlooadPagosEvento('E');
            if (data != null) {
              downloadFile(data, 'Pagos-Evento');
            }
          },
        )
      ],
    );
  }

  _agregarPago() {
    Navigator.pushNamed(context, '/addPagosForm',
            arguments: index == 0 ? 'I' : 'E')
        .then((value) => {pagosBloc.add(SelectPagosEvent()), setState(() {})});
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
              children: const <Widget>[
                // Center(child: Text('La actividad: $Nombre')),
                // SizedBox(height: 15.0,),
                Center(child: Text('¿Deseas confirmar?')),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirmar'),
              onPressed: () {
                Navigator.of(context).pop();
                pagosBloc.add(DeletePagosEvent(id));
                setState(() {
                  isPressed = false;
                });
                MostrarAlerta(
                    mensaje: 'Pago borrado', tipoMensaje: TipoMensaje.correcto);
              },
            ),
          ],
        );
      },
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
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _pagos.length;

  @override
  int get selectedRowCount => 0;
}

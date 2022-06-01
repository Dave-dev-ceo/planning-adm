// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/logic/asistencia_logic.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/utils/utils.dart';
import 'package:sticky_headers/sticky_headers.dart';

// bloc
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/blocs/asistencia/asistencia_bloc.dart';

// model
import 'package:planning/src/models/item_model_asistencia.dart';

class Asistencia extends StatefulWidget {
  const Asistencia({Key key}) : super(key: key);

  @override
  _AsistenciaState createState() => _AsistenciaState();
}

class _AsistenciaState extends State<Asistencia> {
  // variables bloc
  AsistenciaBloc asistenciaBloc;
  final asistenciaLogic = FetchListaAsistenciaLogic();

  // variables model
  ItemModelAsistencia itemModelAsistencia;
  ItemModelAsistencia copyItemFinal;

  //stilos
  final TextStyle _boldStyle = const TextStyle(fontWeight: FontWeight.bold);

  // Variable involucrado
  bool isInvolucrado = false;

  // ini
  @override
  void initState() {
    super.initState();
    // BlocProvider - cargamos el evento
    asistenciaBloc = BlocProvider.of<AsistenciaBloc>(context);
    asistenciaBloc.add(FetchAsistenciaPorPlannerEvent());
    getIdInvolucrado();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(bottom: 30.0),
        padding: const EdgeInsets.all(30.0),
        // BlocBuilder - revisamos el estado
        child: BlocBuilder<AsistenciaBloc, AsistenciaState>(
          builder: (context, state) {
            // state Iniciando
            if (state is AsistenciaInitialState) {
              return const Center(
                child: LoadingCustom(),
              );
            } else if (state is LodingAsistenciaState) {
              return const Center(
                child: LoadingCustom(),
              );
            } else if (state is MostrarAsistenciaState) {
              // buscador en header
              if (state.asistencia != null) {
                if (itemModelAsistencia != state.asistencia) {
                  itemModelAsistencia = state.asistencia;
                  if (itemModelAsistencia != null) {
                    copyItemFinal = itemModelAsistencia.copy();
                  }
                }
              } else {
                asistenciaBloc.add(FetchAsistenciaPorPlannerEvent());
                return const Center(
                  child: LoadingCustom(),
                );
              }
              if (copyItemFinal != null) {
                return getAsistencia(copyItemFinal, size);
              } else {
                return const Center(child: Text('Sin datos'));
              }
            }
            // fin buscador
            // state Error
            else if (state is ErrorMostrarAsistenciaState) {
              return Center(child: Text(state.message));
            } else if (state is SavedAsistenciaState) {
              return const Center(child: Text('Cambiando asistencia'));
            } else {
              return const Center(child: Text('no data'));
            }
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton:
          _crearBotonFlotante(MediaQuery.of(context).size.width),
    );
  }

  void getIdInvolucrado() async {
    final _idInvolucrado = await SharedPreferencesT().getIdInvolucrado();

    if (_idInvolucrado != null) {
      isInvolucrado = true;
    }
  }

  Widget getAsistencia(asistencia, Size size) {
    return Center(
      child: RefreshIndicator(
        color: Colors.blue,
        onRefresh: () async {
          asistenciaBloc.add(FetchAsistenciaPorPlannerEvent());
        },
        child: ListView(
          children: [
            StickyHeader(
              header: Container(
                  height: 100.0,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 35.0),
                  alignment: Alignment.centerLeft,
                  child: _crearHeader(asistencia)),
              content: _crearTabla(asistencia, size),
            ),
          ],
        ),
      ),
    );
  }

  Widget _crearTabla(asistencia, Size size) {
    return SizedBox(
      width: double.infinity,
      child: PaginatedDataTable(
        // header: _crearHeader(asistencia),
        columns: _crearColumna(),
        source: DTS(invitadosList: _crearLista(asistencia)),
        onRowsPerPageChanged: null,
        rowsPerPage: asistencia.asistencias.length == 0
            ? 1
            : asistencia.asistencias.length,
        dataRowHeight: size.width < 560 ? 130.0 : 100,
      ),
    );
  }

  Widget _crearHeader(asistencia) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
              flex: 3,
              child: Text(
                'Asistencia',
                style: TextStyle(fontSize: 20.0),
              )),
          Expanded(
              flex: 5,
              child: TextField(
                decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                    ),
                    hintText: 'Buscar...'),
                onChanged: (valor) {
                  _buscadorInvitados(valor, asistencia);
                },
              )),
        ],
      ),
    );
  }

  List<DataColumn> _crearColumna() {
    return [
      DataColumn(
        label: Text(
          '',
          style: _boldStyle,
        ),
      ),
    ];
  }

  List<List<DataCell>> _crearLista(ItemModelAsistencia itemModel) {
    List<List<DataCell>> invitadosList = [];
    if (itemModel.asistencias.isNotEmpty) {
      for (var element in itemModel.asistencias) {
        List<DataCell> invitadosListTemp = [
          DataCell(
            !isInvolucrado
                ? SwitchListTile(
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          element.nombre,
                          style: _boldStyle,
                        ),
                        Text(
                          'Grupo: ${element.grupo}',
                          style:
                              const TextStyle(overflow: TextOverflow.ellipsis),
                        ),
                        Text(
                          'Mesa: ${element.mesa}',
                          style:
                              const TextStyle(overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                    value: element.asistencia,
                    onChanged: (value) {
                      _guardarAsistencia(element.idInvitado, value);
                      setState(() => element.asistencia = value);
                    },
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Text(
                          element.nombre,
                          style: _boldStyle,
                        ),
                      ),
                      Expanded(child: Text('Grupo: ${element.grupo}')),
                      Expanded(child: Text('Mesa: ${element.mesa}')),
                    ],
                  ),
          )
        ];
        invitadosList.add(invitadosListTemp);
      }
    } else {
      List<DataCell> invitadosListNoData = [
        const DataCell(Text('Sin datos')),
      ];
      invitadosList.add(invitadosListNoData);
    }

    return invitadosList;
  }

  _guardarAsistencia(int idInvitado, bool asistenciaValor) {
    // BlocProvider - cargamos el evento
    asistenciaBloc.add(SaveAsistenciaEvent(idInvitado, asistenciaValor));
  }

  _buscadorInvitados(String valor, ItemModelAsistencia asistencia) {
    if (valor.length > 2) {
      List<dynamic> buscador = itemModelAsistencia.asistencias
          .where((element) =>
              element.nombre.toLowerCase().contains(valor.toLowerCase()) ||
              element.grupo.toLowerCase().contains(valor.toLowerCase()) ||
              element.mesa.toLowerCase().contains(valor.toLowerCase()))
          .toList();
      setState(() {
        copyItemFinal.asistencias.clear();
        if (buscador.isNotEmpty) {
          for (var element in buscador) {
            copyItemFinal.asistencias.add(element);
          }
        } else {}
      });
    } else {
      setState(() {
        if (itemModelAsistencia != null) {
          copyItemFinal = itemModelAsistencia.copy();
        }
      });
    }
  }

  // colores
  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  // boton flotante
  SpeedDial _crearBotonFlotante(double pHz) {
    return SpeedDial(
      icon: Icons.more_vert,
      tooltip: 'Opciones',
      children: [
        SpeedDialChild(
            onTap: () async {
              final result = await Navigator.of(context).pushNamed('/lectorQr');
            },
            child: const Icon(Icons.qr_code_outlined),
            label: 'Codigo QR'),
        SpeedDialChild(
          child: const Icon(Icons.download),
          onTap: () async {
            final data = await asistenciaLogic.downloadPDFAsistencia();

            if (data != null) {
              downloadFile(data, 'asistencia');
            }
          },
          label: 'Descargar PDf',
        )
      ],
    );
  }
}

class DTS extends DataTableSource {
  // modelo
  final List<List<DataCell>> _invitadosList;

  DTS({@required List<List<DataCell>> invitadosList})
      : _invitadosList = invitadosList,
        assert(invitadosList != null);

  @override
  DataRow getRow(int index) {
    return DataRow.byIndex(
      index: index,
      cells: _invitadosList[index],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _invitadosList.length;

  @override
  int get selectedRowCount => 0;
}

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

// bloc
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingplanner/src/blocs/asistencia/asistencia_bloc.dart';

// model
import 'package:weddingplanner/src/models/item_model_asistencia.dart';

class Asistencia extends StatefulWidget {
  Asistencia({Key key}) : super(key: key);

  @override
  _AsistenciaState createState() => _AsistenciaState();
}

class _AsistenciaState extends State<Asistencia> {
  // variables bloc
  AsistenciaBloc asistenciaBloc;

  //stilos
  final TextStyle _boldStyle = TextStyle(fontWeight: FontWeight.bold);

  // variables tablaAsistencia
  ItemModelAsistencia itemModelAsistencia;
  ItemModelAsistencia copyItemFinal;
  int _rowPerPage = 10;

  // ini
  @override
  void initState() {
    super.initState();
    // BlocProvider - cargamos el evento
    asistenciaBloc = BlocProvider.of<AsistenciaBloc>(context);
    asistenciaBloc.add(FetchAsistenciaPorPlannerEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30.0),
        // BlocBuilder - revisamos el estado
        child: BlocBuilder<AsistenciaBloc, AsistenciaState>(
          builder: (context, state) {
            // state Iniciando
            if(state is AsistenciaInitialState)
              return Center(child: CircularProgressIndicator());
            // state Loading
            else if(state is LodingAsistenciaState)
              return Center(child: CircularProgressIndicator());
            // state Data
            else if(state is MostrarAsistenciaState){
              // buscador en header
              if (state.asistencia != null) {
                if(itemModelAsistencia != state.asistencia){
                  itemModelAsistencia = state.asistencia;
                  if (itemModelAsistencia != null) {
                    copyItemFinal = itemModelAsistencia.copy();
                  }
                }
              } else {
                asistenciaBloc.add(FetchAsistenciaPorPlannerEvent());
                return Center(child: CircularProgressIndicator());
              }
              if(copyItemFinal != null) {
                return getAsistencia(copyItemFinal);
              }else {
                return Center(child: Text('Sin datos'));
              }
            }
            // fin buscador
            // state Error
            else if(state is ErrorMostrarAsistenciaState)
              return Center(child: Text(state.message));
            // update
            else if(state is SavedAsistenciaState)
              return Center(child: Text('Cambiando asistencia'));
            // state No Data
            else
              return Center(child: Text('no data'));
          },
        ),
      ),
      floatingActionButton: _crearBotonFlotante(MediaQuery.of(context).size.width),
    );
  }

  Widget getAsistencia(asistencia) {
    return Center(
      child: ListView(
        children: [_crearTabla(asistencia)],
      ),
    );
  }

  Widget _crearTabla(asistencia) {
    return PaginatedDataTable(
      header: _crearHeader(asistencia),
      columns: _crearColumna(),
      source: DTS(invitadosList:_crearLista(asistencia)),
      onRowsPerPageChanged: _changePerPages,
      rowsPerPage: _rowPerPage,
    );
  }

  Widget _crearHeader(asistencia) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 3, child: Text('Asistencia')),
          Expanded(
              flex: 5,
              child: TextField(
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                    ),
                    hintText: 'Buscar...'),
                onChanged: (valor) {_buscadorInvitados(valor,asistencia);},
              )),
        ],
      ),
    );
  }

  List<DataColumn> _crearColumna() {
    return [
      DataColumn(
        label: Text(
          'Nombre',
          style: _boldStyle,
        ),
      ),
      DataColumn(
        label: Text(
          'Mesa',
          style: _boldStyle,
        ),
      ),
      DataColumn(
        label: Text(
          'Grupo',
          style: _boldStyle,
        ),
      ),
      DataColumn(
        label: Text(
          'Asistencia',
          style: _boldStyle,
        ),
      )
    ];
  }

  List<List<DataCell>> _crearLista(ItemModelAsistencia itemModel) {
    List<List<DataCell>> invitadosList = [];
    if(itemModel.asistencias.length > 0){
      itemModel.asistencias.forEach((element) {
        List<DataCell> invitadosListTemp = [
          DataCell(Text('${element.nombre}')),
          DataCell(Text('${element.mesa}')),
          DataCell(Text('${element.grupo}')),
          DataCell(Checkbox(
            value: element.asistencia,
            onChanged: (valor){
              _guardarAsistencia(element.id_invitado,valor);
              setState(() => element.asistencia = valor);
            },
          )),
        ];
        invitadosList.add(invitadosListTemp);
      });
    }
    else {
      List<DataCell> invitadosListNoData = [
        DataCell(Text('Sin datos')),
        DataCell(Text('Sin datos')),
        DataCell(Text('Sin datos')),
        DataCell(Text('Sin datos')),
      ];
      invitadosList.add(invitadosListNoData);
    }

    return invitadosList;
  }

  _changePerPages(valor) {
    setState(() => _rowPerPage = valor);
  }

  _guardarAsistencia(int idInvitado,bool asistenciaValor) {
    // print('id: $idInvitado \nvalor: $asistenciaValor');
    // BlocProvider - cargamos el evento
    asistenciaBloc.add(SaveAsistenciaEvent(idInvitado, asistenciaValor));
  }

  _buscadorInvitados(String valor, ItemModelAsistencia asistencia) {
    if(valor.length > 2) {
      List<dynamic> buscador = itemModelAsistencia.asistencias.where((element) =>
        element.nombre.toLowerCase().contains(valor.toLowerCase()) ||
        element.grupo.toLowerCase().contains(valor.toLowerCase()) ||
        element.mesa.toLowerCase().contains(valor.toLowerCase())
      ).toList();
      setState((){
        copyItemFinal.asistencias.clear();
        if(buscador.length > 0) {
          buscador.forEach((element) {
            copyItemFinal.asistencias.add(element);
          });
        }
        else {}
      });
    } else {
      setState((){
        if (itemModelAsistencia != null) {
          copyItemFinal = itemModelAsistencia.copy();
        }
      });
    }
  }

  // colores
  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  // boton flotante
  SpeedDial _crearBotonFlotante(double pHz) {
    return SpeedDial(
      marginEnd: pHz - 100,
      marginBottom: 20,

      icon: Icons.add,
      activeIcon: Icons.close_rounded,
      buttonSize: 56.0,
      visible: true,

      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,

      tooltip: 'Opciones',
      heroTag: 'Opciones',
      backgroundColor: Colors.white,
      foregroundColor: Colors.white,
      elevation: 8.0,
      shape: CircleBorder(),

      gradientBoxShape: BoxShape.circle,
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [hexToColor("#880B55"), hexToColor("#880B55")],
      ),
      children: [
        SpeedDialChild(
          foregroundColor: Colors.white,
          child: Tooltip(
            child: Icon(Icons.qr_code_outlined),
            message: "Escáner Código QR",
          ),
          backgroundColor: hexToColor("#880B55"),
          onTap: () async {
            final result = await Navigator.of(context).pushNamed('/lectorQr');
          },
        ),
      ],
    );
  }
}

class DTS extends DataTableSource {
  // modelo
  final List<List<DataCell>> _invitadosList;

  DTS({
    @required List<List<DataCell>> invitadosList
  }) : _invitadosList = invitadosList,
    assert(invitadosList != null);

  @override
  DataRow getRow(int index) {
    return DataRow.byIndex(
      index: index,
      cells: _invitadosList[index],
    );
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => _invitadosList.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
}
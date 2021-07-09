import 'package:flutter/material.dart';

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

  // variables model
  ItemModelAsistencia itemModelAsistencia;

  //stilos
  final TextStyle _boldStyle = TextStyle(fontWeight: FontWeight.bold);

  // variables tablaAsistencia
  var dts = DTS();
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
            else if(state is MostrarAsistenciaState)
              return getAsistencia(state.asistencia);
            // state Error
            else if(state is ErrorMostrarAsistenciaState)
              return Center(child: Text(state.message));
            // state No Data
            else
              return Center(child: Text('no data'));
          },
        ),
      ),
    );
  }
  
  Widget getAsistencia(asistencia) {
    return Center(
      child: ListView(
        children: [_crearTabla()],
      ),
    );
  }

  Widget _crearTabla() {
    return PaginatedDataTable(
      header: _crearHeader(),
      columns: _crearColumna(),
      source: dts,
      onRowsPerPageChanged: _changePerPages,
      rowsPerPage: _rowPerPage,
    );
  }

  Widget _crearHeader() {
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

  _changePerPages(valor) {
    setState(() {
      return _rowPerPage = valor;
    });
  }
}

class DTS extends DataTableSource {
  @override
  DataRow getRow(int index) {
    return DataRow.byIndex(index: index, cells: [
      DataCell(Text("#cell$index")),
      DataCell(Text("#cell$index")),
      DataCell(Text("#cell$index")),
      DataCell(Checkbox(
        value: true,
        onChanged: (valor) {},
      )),
    ]);
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => 100;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
}

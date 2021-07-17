// imports dart/flutter
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';

// blocs
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingplanner/src/blocs/actividadesTiming/actividadestiming_bloc.dart';

// model
import 'package:weddingplanner/src/models/item_model_actividades_timings.dart';

class TimingsEventos extends StatefulWidget {
  const TimingsEventos({Key key}) : super(key: key);

  @override
  _TimingsEventosState createState() => _TimingsEventosState();
}

class _TimingsEventosState extends State<TimingsEventos> {
  // variables bloc
  ActividadestimingBloc eventoTimingBloc;

  // variables model
  ItemModelActividadesTimings itemModel;
  ItemModelActividadesTimings copyItemModel;

  //stilos
  final TextStyle _boldStyle = TextStyle(fontWeight: FontWeight.bold);

  // ini
  @override
  void initState() {
    super.initState();
    eventoTimingBloc = BlocProvider.of<ActividadestimingBloc>(context);
    eventoTimingBloc.add(FetchActividadesTimingsPorIdPlannerEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActividadestimingBloc, ActividadestimingState>(
      builder: (context, state) {
        if (state is ActividadestimingInitial) {
          return Center(child: CircularProgressIndicator());
        } else if (state is LoadingActividadesTimingsState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is MostrarActividadesTimingsEventosState) {
            // buscador en header
            if (state.actividadesTimings != null) {
              if(itemModel != state.actividadesTimings){
                itemModel = state.actividadesTimings;
                if (itemModel != null) {
                  copyItemModel = itemModel.copy();
                }
              }
            } else {
              eventoTimingBloc.add(FetchActividadesTimingsPorIdPlannerEvent());
              return Center(child: CircularProgressIndicator());
            }
            if(copyItemModel != null) {
              return Container(
                padding: EdgeInsets.all(30.0),
                child: Center(child: _agregarTabla(copyItemModel)),
              );
            }else {
              return Center(child: Text('Sin datos'));
            }
        } else if (state is ErrorMostrarActividadesTimingsState) {
          return Center(
            child: Text(state.message),
          );
          //_showError(context, state.message);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _agregarTabla(ItemModelActividadesTimings copyItemModelWidget) {
    return ListView(
      children: [
        StickyHeader(
          header: _crearHeader(),
          content: _crearTabla(copyItemModelWidget),
        ),
      ],
    );
  }

  // crea tabla-timing
  Widget _crearTabla(ItemModelActividadesTimings copyItemModelWidget) {
    return SizedBox(
      width: double.infinity,
      child: PaginatedDataTable(
        // header: _crearHeader(),
        columns: _crearColumnas(),
        source: DTS(timingsList: _crearLista(copyItemModelWidget)),
        rowsPerPage: copyItemModelWidget.results.length,
        // showCheckboxColumn: true,
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
            Expanded(
                flex: 3,
                child: Text(
                  'Actividades',
                  style: TextStyle(fontSize: 20.0),
                )),
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
  List<List<DataCell>> _crearLista(ItemModelActividadesTimings copyItemModelWidget) {
    List<List<DataCell>> timingsList = [];

    // llenado de lista
    if(copyItemModelWidget.results.length > 0) {
      copyItemModelWidget.results.forEach((element) {
        List<DataCell> timingsListTemp = [
          DataCell(
            Text(element.nombreActividad)            
          )
        ];
        timingsList.add(timingsListTemp);
      });
    } else {
      // testData
      List<DataCell> timingsListNoData = [
        DataCell(Text('Sin datos')),
      ];

      // send data
      timingsList.add(timingsListNoData);
    }

    return timingsList;
  }

  //
}

class DTS extends DataTableSource {
  // modelo
  final List<List<DataCell>> _timingsList;

  DTS({@required List<List<DataCell>> timingsList})
      : _timingsList = timingsList,
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

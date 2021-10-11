import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingplanner/src/blocs/timings/timings_bloc.dart';
import 'package:weddingplanner/src/models/item_model_timings.dart';

class Timing extends StatefulWidget {
  const Timing({Key key}) : super(key: key);

  @override
  _TimingState createState() => _TimingState();
}

class _TimingState extends State<Timing> {
  final TextStyle estiloTxt = TextStyle(fontWeight: FontWeight.bold);
  TextEditingController timingCtrl = new TextEditingController();
  TimingsBloc timingBloc;
  ItemModelTimings itemModelTimings;
  ItemModelTimings filterTimings;
  bool bandera = false;
  List<bool> sort = [false, false, false, false];
  int _sortColumnIndex = 0;
  bool sortArrow = false;

  bool crt = true;

  _TimingState();

  @override
  void initState() {
    timingBloc = BlocProvider.of<TimingsBloc>(context);
    timingBloc.add(FetchTimingsPorPlannerEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: BlocBuilder<TimingsBloc, TimingsState>(
            builder: (context, state) {
              if (state is TimingsInitial) {
                return Center(child: CircularProgressIndicator());
              } else if (state is LoadingTimingsState) {
                return Center(child: CircularProgressIndicator());
              } else if (state is MostrarTimingsState) {
                if (crt) {
                  itemModelTimings = state.usuarios;
                  filterTimings = itemModelTimings; //.copy()
                  crt = false;
                }
                return _constructorTable(filterTimings);
              } else if (state is ErrorMostrarTimingsState) {
                return Center(
                  child: Text(state.message),
                );
                //_showError(context, state.message);
              } else {
                return buildList(filterTimings);
              }
            },
          ),
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // floatingActionButton: FloatingActionButton(
      //   heroTag: null,
      //   child: Icon(Icons.add),
      //   onPressed: () {
      //     setState(() {
      //       bandera = !bandera;
      //     });
      //   },
      // ),
    );
  }

  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  formItemsDesign(icon, item, large, ancho) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3),
      child: Container(
        child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 10,
            child: ListTile(leading: Icon(icon), title: item)),
        width: large,
        height: ancho,
      ),
    );
  }

  _constructorTable(ItemModelTimings model) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(
            height: 50.0,
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(15),
            child: formItemsDesign(
                null,
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: timingCtrl,
                        decoration: new InputDecoration(
                          labelText: 'Cronograma',
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        child: Container(
                          margin: const EdgeInsets.all(15),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 12),
                          child: FittedBox(
                            child: Text(
                              "Agregar",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w100,
                                  color: Colors.black),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: hexToColor('#fdf4e5'),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onTap: () async {
                          crt = true;
                          timingBloc.add(
                              CreateTimingsEvent({"timing": timingCtrl.text}));
                        },
                      ),
                    ),
                  ],
                ),
                570.0,
                80.0),
          ),
          Center(
            child:
                Container(height: 400.0, width: 600.0, child: buildList(model)
                    //listaEstatusInvitaciones(context),
                    ),
          ),
        ],
      ),
    );
  }

  Widget buildList(ItemModelTimings snapshot) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(16),
      children: [
        PaginatedDataTable(
          sortColumnIndex: _sortColumnIndex,
          sortAscending: sortArrow,
          header: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(height: 30, child: Text('Cronogramas')),
              Container(
                height: 30,
                child: TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                      ),
                      hintText: 'Buscar...'),
                  onChanged: (String value) async {
                    if (value.length > 2) {
                      List<dynamic> usrs = itemModelTimings.results
                          .where((imu) => imu.nombre_timing
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                          .toList();
                      setState(() {
                        filterTimings.results.clear();
                        if (usrs.length > 0) {
                          for (var usr in usrs) {
                            filterTimings.results.add(usr);
                          }
                        } else {}
                      });
                    } else {
                      setState(() {
                        filterTimings = itemModelTimings.copy();
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          rowsPerPage: snapshot.results.length > 8
              ? 8
              : snapshot.results.length < 1
                  ? 1
                  : snapshot.results.length,
          showCheckboxColumn: bandera,
          columns: [
            DataColumn(
                label: Text('Cronograma'),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    snapshot.results.length > 0
                        ? itemModelTimings = onSortColum(
                            columnIndex, ascending, itemModelTimings)
                        : null;
                  });
                }),
          ],
          source: _DataSource(snapshot.results, context),
        ),
      ],
    );
  }

  ItemModelTimings onSortColum(
      int columnIndex, bool ascending, ItemModelTimings sortData) {
    sort[columnIndex] = !sort[columnIndex];
    switch (columnIndex) {
      case 0:
        sort[columnIndex]
            ? sortData.results
                .sort((a, b) => a.nombre_timing.compareTo((b.nombre_timing)))
            : sortData.results
                .sort((a, b) => b.nombre_timing.compareTo(a.nombre_timing));
        break;
    }
    _sortColumnIndex = columnIndex;
    sortArrow = !sortArrow;

    return sortData;
  }
}

class _Row {
  _Row(
    this.valueId,
    this.valueA,
  );
  final int valueId;
  final String valueA;

  bool selected = false;
}

class _DataSource extends DataTableSource {
  BuildContext _cont;
  _DataSource(context, BuildContext cont) {
    _rows = <_Row>[];
    if (context.length > 0) {
      for (int i = 0; i < context.length; i++) {
        _rows.add(_Row(context[i].id_timing, context[i].nombre_timing));
      }
    } else {
      _rows.add(_Row(null, 'Sin datos'));
    }
    _cont = cont;
  }

  List<_Row> _rows;

  int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= _rows.length) return null;
    final row = _rows[index];
    return DataRow.byIndex(
      index: index,
      selected: row.selected,
      onSelectChanged: (value) {
        if (row.selected != value) {
          _selectedCount += value ? 1 : -1;
          assert(_selectedCount >= 0);
          row.selected = value;
          notifyListeners();
        }
      },
      cells: [
        DataCell(Text(row.valueA), onTap: () {
          Navigator.pushNamed(_cont, '/addActividadesTiming',
              arguments: row.valueId);
        }),
      ],
    );
  }

  @override
  int get rowCount => _rows.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}

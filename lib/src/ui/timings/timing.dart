// ignore_for_file: unused_element
import 'package:flutter/cupertino.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/ui/widgets/snackbar_widget/snackbar_widget.dart';
import 'package:planning/src/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_grid/responsive_grid.dart';

import 'package:planning/src/blocs/timings/timings_bloc.dart';
import 'package:planning/src/logic/timings_logic.dart';
import 'package:planning/src/models/item_model_timings.dart';

class Timing extends StatefulWidget {
  const Timing({Key key}) : super(key: key);

  @override
  _TimingState createState() => _TimingState();
}

class _TimingState extends State<Timing> {
  final TextStyle estiloTxt = TextStyle(fontWeight: FontWeight.bold);

  final formState = GlobalKey<FormState>();
  TextEditingController timingCtrl = new TextEditingController();
  TimingsBloc timingBloc;
  ItemModelTimings itemModelTimings;
  ItemModelTimings filterTimings;
  FetchListaTimingsLogic timingsLogic = FetchListaTimingsLogic();
  bool bandera = false;
  List<bool> sort = [false, false, false, false];
  int _sortColumnIndex = 0;
  bool sortArrow = false;
  String dropdownValue = 'A';
  bool crt = true;

  _TimingState();

  List<dynamic> listaEstatus = [
    {'descripcion': 'Activo', 'value': 'A'},
    {'descripcion': 'Inactivo', 'value': 'I'}
  ];

  @override
  void initState() {
    timingBloc = BlocProvider.of<TimingsBloc>(context);
    timingBloc.add(FetchTimingsPorPlannerEvent(dropdownValue));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        color: Colors.blue,
        onRefresh: () async {
          timingBloc.add(FetchTimingsPorPlannerEvent('A'));
        },
        child: SingleChildScrollView(
          child: BlocBuilder<TimingsBloc, TimingsState>(
            builder: (context, state) {
              if (state is TimingsInitial) {
                return Center(
                  child: LoadingCustom(),
                );
              } else if (state is LoadingTimingsState) {
                return Center(
                  child: LoadingCustom(),
                );
              } else if (state is MostrarTimingsState) {
                if (crt) {
                  itemModelTimings = state.usuarios;
                  filterTimings = itemModelTimings; //.copy()
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Descargar PDF',
        child: Icon(Icons.file_download_sharp),
        onPressed: () async {
          final data = await timingsLogic.downloadPDFTiming();

          if (data != null) {
            await downloadFile(data, 'Cronogramas');
          }
        },
      ),
    );
  }

  Future<void> _refresTiming() async {
    Future.delayed(Duration(seconds: 200), () {
      setState(() {});
    });
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
                      child: Form(
                        key: formState,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7.5),
                          child: TextFormField(
                            controller: timingCtrl,
                            decoration: new InputDecoration(
                              labelText: 'Cronograma',
                            ),
                            validator: (value) {
                              if (value == null || value == '') {
                                return 'Campo no debe ir vacio';
                              } else {
                                return null;
                              }
                            },
                          ),
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
                          if (formState.currentState.validate()) {
                            crt = true;
                            timingBloc.add(CreateTimingsEvent(
                                {"timing": timingCtrl.text}));
                            timingCtrl.clear();
                          } else {
                            MostrarAlerta(
                                mensaje: 'El Campo esta vacio',
                                tipoMensaje: TipoMensaje.advertencia);
                          }
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
                Container(height: 400.0, width: 600.0, child: buildList2(model)
                    //listaEstatusInvitaciones(context),
                    ),
          ),
        ],
      ),
    );
  }

  Widget buildList2(ItemModelTimings listItemModelTimings) {
    return SingleChildScrollView(
      child: Card(
        margin: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Cronograma'),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: DropdownButton<String>(
                  isExpanded: true,
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  iconSize: 24,
                  style: const TextStyle(color: Colors.black54),
                  underline: Container(
                    height: 2,
                    color: Colors.black,
                  ),
                  onChanged: (newValue) async {
                    setState(() {
                      dropdownValue = newValue;
                    });
                    await timingBloc
                        .add(FetchTimingsPorPlannerEvent(dropdownValue));
                  },
                  items: [
                    DropdownMenuItem(
                      child: Text("Activo", style: TextStyle(fontSize: 16)),
                      value: 'A',
                    ),
                    DropdownMenuItem(
                      child: Text("Inactivo", style: TextStyle(fontSize: 16)),
                      value: 'I',
                    )
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
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
                    setState(
                      () {
                        filterTimings = itemModelTimings.copy();
                      },
                    );
                  }
                },
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: listItemModelTimings.results.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          enableFeedback: true,
                          hoverColor: Colors.white,
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (context) => EditTimingDialog(
                                name: listItemModelTimings
                                    .results[index].nombre_timing,
                                idCronograma: listItemModelTimings
                                    .results[index].id_timing,
                                estatus:
                                    listItemModelTimings.results[index].estatus,
                              ),
                            ).then((value) async => {
                                  if (value != null)
                                    {
                                      if (value)
                                        {
                                          await timingBloc.add(
                                              FetchTimingsPorPlannerEvent('A')),
                                          setState(() {})
                                        }
                                    }
                                });
                          },
                          icon: Icon(
                            Icons.edit,
                            size: 14.0,
                          ),
                        ),
                        SizedBox(width: 3.0),
                        IconButton(
                          onPressed: () async {
                            showDialog(
                                context: context,
                                builder: (context) =>
                                    BlocListener<TimingsBloc, TimingsState>(
                                      listener: (context, state) {
                                        if (state is TimingDeletedState) {
                                          if (state.wasDeletedTiming) {
                                            Navigator.of(context).pop();
                                            MostrarAlerta(
                                                mensaje:
                                                    'El cronograma se elimino correctamente',
                                                tipoMensaje:
                                                    TipoMensaje.correcto);
                                          } else {
                                            Navigator.of(context).pop();
                                            MostrarAlerta(
                                                mensaje: 'Ocurrio un error',
                                                tipoMensaje: TipoMensaje.error);
                                          }
                                        }
                                      },
                                      child: CupertinoAlertDialog(
                                        content: RichText(
                                          text: TextSpan(
                                            text:
                                                '¿Esta seguro de eliminar el cronograma?\n',
                                            style: TextStyle(
                                              color: Colors.black,
                                              decorationStyle:
                                                  TextDecorationStyle.dotted,
                                            ),
                                            children: [
                                              TextSpan(
                                                text:
                                                    '\nEl cronograma se eliminara de los eventos, al igual que sus actividades',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          CupertinoDialogAction(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Cancelar'),
                                          ),
                                          CupertinoDialogAction(
                                            child: Text('Aceptar'),
                                            onPressed: () async {
                                              await timingBloc.add(
                                                  DeleteTimingPlannerEvent(
                                                      listItemModelTimings
                                                          .results[index]
                                                          .id_timing));
                                            },
                                          ),
                                        ],
                                      ),
                                    ));
                          },
                          icon: Icon(Icons.delete_forever),
                        )
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed('/addActividadesTiming',
                          arguments:
                              listItemModelTimings.results[index].id_timing);
                    },
                    title:
                        Text(listItemModelTimings.results[index].nombre_timing),
                  );
                })
          ],
        ),
      ),
    );
  }

  Widget buildList(ItemModelTimings snapshot) {
    snapshot.results.forEach((element) {
      print(element.toString());
    });
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

class EditTimingDialog extends StatefulWidget {
  final String name;
  final int idCronograma;
  final String estatus;
  EditTimingDialog({Key key, this.name, this.idCronograma, this.estatus})
      : super(key: key);

  @override
  _EditTimingDialogState createState() => _EditTimingDialogState();
}

class _EditTimingDialogState extends State<EditTimingDialog> {
  String name;
  String estatus;
  int idCronograma;
  bool _isActivo;
  TimingsBloc timingsBloc;
  @override
  void initState() {
    timingsBloc = BlocProvider.of<TimingsBloc>(context);
    estatus = widget.estatus;
    name = widget.name;
    idCronograma = widget.idCronograma;
    if (widget.estatus == 'A') {
      _isActivo = true;
    } else {
      _isActivo = false;
    }
    super.initState();
  }

  final keyFormCrono = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AlertDialog(
      title: Center(child: Text('Editar cronograma')),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: size.height * 0.6,
          maxWidth: size.width * 0.5,
          minWidth: size.width * 0.4,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
              key: keyFormCrono,
              child: ResponsiveGridRow(
                children: [
                  ResponsiveGridCol(
                    md: 12,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: name,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Nombre del cronograma',
                        ),
                        validator: (value) {
                          if (value != null && value != '') {
                            return null;
                          } else {
                            return 'El campo es requerido';
                          }
                        },
                        onChanged: (value) {
                          name = value;
                        },
                      ),
                    ),
                  ),
                  ResponsiveGridCol(
                    md: 12,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CheckboxListTile(
                        value: _isActivo,
                        onChanged: (value) {
                          setState(() {
                            _isActivo ? _isActivo = false : _isActivo = true;
                            _isActivo ? estatus = 'A' : estatus = 'I';
                          });
                        },
                        title: Text(_isActivo ? 'Activo' : 'Inactivo'),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () async {
            if (keyFormCrono.currentState.validate()) {
              await timingsBloc
                  .add(UpdateTimingEvent(idCronograma, name, estatus));

              await timingsBloc.add(FetchTimingsPorPlannerEvent('A'));

              Navigator.of(context).pop(true);
            } else {
              print('Incorrecto');
            }
          },
          child: Text('Aceptar'),
        )
      ],
    );
  }
}

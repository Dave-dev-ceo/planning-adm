import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingplanner/src/blocs/usuarios/usuarios_bloc.dart';
import 'package:weddingplanner/src/models/item_model_usuarios.dart';

class Usuarios extends StatefulWidget {
  const Usuarios({Key key}) : super(key: key);

  @override
  _UsuariosState createState() => _UsuariosState();
}

class _UsuariosState extends State<Usuarios> {
  final TextStyle estiloTxt = TextStyle(fontWeight: FontWeight.bold);
  UsuariosBloc usuariosBloc;
  ItemModelUsuarios itemModelUsuarios;
  bool bandera = false;
  List<bool> sort = [false, false, false, false];
  int _sortColumnIndex = 0;
  bool sortArrow = false;

  _UsuariosState();

  @override
  void initState() {
    usuariosBloc = BlocProvider.of<UsuariosBloc>(context);
    usuariosBloc.add(FetchUsuariosPorPlannerEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: BlocBuilder<UsuariosBloc, UsuariosState>(
          builder: (context, state) {
            if (state is UsuariosInitialState) {
              return Center(child: CircularProgressIndicator());
            } else if (state is LoadingUsuariosState) {
              return Center(child: CircularProgressIndicator());
            } else if (state is MostrarUsuariosState) {
              itemModelUsuarios = state.usuarios;
              return buildList(itemModelUsuarios);
            } else if (state is ErrorMostrarUsuariosState) {
              return Center(
                child: Text(state.message),
              );
              //_showError(context, state.message);
            } else {
              return buildList(itemModelUsuarios);
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        child: Icon(Icons.add),
        onPressed: () {
          setState(() {
            bandera = !bandera;
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
    );
  }

  Widget buildList(ItemModelUsuarios snapshot) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        PaginatedDataTable(
          sortColumnIndex: _sortColumnIndex,
          sortAscending: sortArrow,
          header: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(child: Text('Usuarios')),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                    ),
                    prefixText: "Buscar:",
                  ),
                  onSubmitted: (String value) async {
                    await showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Thanks!'),
                          content: Text(
                              'You typed "$value", which has length ${value.characters.length}.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          rowsPerPage:
              snapshot.results.length < 8 ? snapshot.results.length : 8,
          showCheckboxColumn: bandera,
          columns: [
            DataColumn(
                label: Text('Nombre'),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    itemModelUsuarios =
                        onSortColum(columnIndex, ascending, itemModelUsuarios);
                  });
                }),
            DataColumn(
                label: Text('telefono'),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    itemModelUsuarios =
                        onSortColum(columnIndex, ascending, itemModelUsuarios);
                  });
                }),
            DataColumn(
                label: Text('Correo'),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    itemModelUsuarios =
                        onSortColum(columnIndex, ascending, itemModelUsuarios);
                  });
                }),
            DataColumn(
                label: Text('¿Es administrador?'),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    itemModelUsuarios =
                        onSortColum(columnIndex, ascending, itemModelUsuarios);
                  });
                }),
          ],
          source: _DataSource(snapshot.results, context),
        ),
      ],
    );
  }

  ItemModelUsuarios onSortColum(
      int columnIndex, bool ascending, ItemModelUsuarios sortData) {
    sort[columnIndex] = !sort[columnIndex];
    switch (columnIndex) {
      case 0:
        sort[columnIndex]
            ? sortData.results.sort(
                (a, b) => a.nombre_completo.compareTo((b.nombre_completo)))
            : sortData.results
                .sort((a, b) => b.nombre_completo.compareTo(a.nombre_completo));
        break;
      case 1:
        sort[columnIndex]
            ? sortData.results
                .sort((a, b) => a.telefono.compareTo((b.telefono)))
            : sortData.results.sort((a, b) => b.telefono.compareTo(a.telefono));
        break;
      case 2:
        sort[columnIndex]
            ? sortData.results.sort((a, b) => a.correo.compareTo((b.correo)))
            : sortData.results.sort((a, b) => b.correo.compareTo(a.correo));
        break;
      case 3:
        sort[columnIndex]
            ? itemModelUsuarios.results.sort((a, b) {
                String stra = a.admin ? 'Si' : 'No';
                String strb = b.admin ? 'Si' : 'No';
                return stra.compareTo(strb);
              })
            : itemModelUsuarios.results.sort((a, b) {
                String stra = a.admin ? 'Si' : 'No';
                String strb = b.admin ? 'Si' : 'No';
                return strb.compareTo(stra);
              });
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
    this.valueB,
    this.valueC,
    this.valueD,
  );
  final int valueId;
  final String valueA;
  final String valueB;
  final String valueC;
  final String valueD;

  bool selected = false;
}

class _DataSource extends DataTableSource {
  _DataSource(context, BuildContext cont) {
    _rows = <_Row>[];
    for (int i = 0; i < context.length; i++) {
      _rows.add(_Row(
          context[i].id_usuario,
          context[i].nombre_completo,
          context[i].telefono,
          context[i].correo,
          context[i].admin ? 'Si' : 'No'));
    }
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
          print(row.valueB);
        }),
        DataCell(
          Text(row.valueB),
        ),
        DataCell(
          Text(row.valueC),
        ),
        DataCell(
          Text(row.valueD),
        ),
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

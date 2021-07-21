import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingplanner/src/blocs/usuarios/usuarios_bloc.dart';
import 'package:weddingplanner/src/models/item_model_usuarios.dart';
import 'package:weddingplanner/src/ui/Roles/roles.dart';

class Usuarios extends StatefulWidget {
  const Usuarios({Key key}) : super(key: key);

  @override
  _UsuariosState createState() => _UsuariosState();
}

UsuariosBloc usuariosBloc;

class _UsuariosState extends State<Usuarios> {
  final TextStyle estiloTxt = TextStyle(fontWeight: FontWeight.bold);
  ItemModelUsuarios itemModelUsuarios;
  ItemModelUsuarios filterUsuarios;
  bool bandera = false;
  List<bool> sort = [false, false, false, false];
  int _sortColumnIndex = 0;
  bool sortArrow = false;
  List<Widget> footerTabs;

  _UsuariosState();

  @override
  void initState() {
    usuariosBloc = BlocProvider.of<UsuariosBloc>(context);
    usuariosBloc.add(FetchUsuariosPorPlannerEvent());
    footerTabs = [
      BlocBuilder<UsuariosBloc, UsuariosState>(
        builder: (context, state) {
          if (state is UsuariosInitialState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is LoadingUsuariosState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is MostrarUsuariosState) {
            if (state.usuarios != null) {
              if (itemModelUsuarios != state.usuarios) {
                itemModelUsuarios = state.usuarios;
                if (itemModelUsuarios != null) {
                  filterUsuarios = itemModelUsuarios.copy();
                }
                crt = false;
              }
            } else {
              crt = true;
              usuariosBloc.add(FetchUsuariosPorPlannerEvent());
              return Center(child: CircularProgressIndicator());
            }
            if (filterUsuarios.usuarios != null) {
              return buildList(filterUsuarios);
            } else {
              return Center(child: Text('Sin datos'));
            }
          } else if (state is ErrorMostrarUsuariosState) {
            return Center(
              child: Text(state.message),
            );
          } else {
            crt = true;
            return Center(child: Text('no data'));
          }
        },
      ),
      // Roles()
      Center(child: Text('En construccin'))
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          child: IndexedStack(index: _selectedIndex, children: footerTabs)),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        child: Icon(Icons.add),
        onPressed: () {
          setState(() {
            mostrarForm(context, 0, null);
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.gavel),
            label: 'Usuarios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Roles',
          )
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget buildList(ItemModelUsuarios snapshot) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        PaginatedDataTable(
          sortColumnIndex: _sortColumnIndex,
          sortAscending: sortArrow,
          header: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Text('Usuarios'),
                ),
                Expanded(
                  /* height: 30, */
                  flex: 5,
                  child: TextField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                        ),
                        hintText: 'Buscar...'),
                    onChanged: (String value) async {
                      if (value.length > 2) {
                        List<dynamic> usrs = itemModelUsuarios.usuarios
                            .where((imu) =>
                                imu.nombre_completo
                                    .toLowerCase()
                                    .contains(value.toLowerCase()) ||
                                imu.correo
                                    .toLowerCase()
                                    .contains(value.toLowerCase()) ||
                                imu.telefono
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                            .toList();
                        setState(() {
                          filterUsuarios.usuarios.clear();
                          if (usrs.length > 0) {
                            for (var usr in usrs) {
                              filterUsuarios.usuarios.add(usr);
                            }
                          } else {}
                        });
                      } else {
                        setState(() {
                          if (itemModelUsuarios != null) {
                            filterUsuarios = itemModelUsuarios.copy();
                          }
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          rowsPerPage: snapshot.usuarios.length > 8
              ? 8
              : snapshot.usuarios.length < 1
                  ? 1
                  : snapshot.usuarios.length,
          showCheckboxColumn: bandera,
          columns: [
            DataColumn(
                label: Text('Nombre'),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    snapshot.usuarios.length > 0
                        ? filterUsuarios =
                            onSortColum(columnIndex, ascending, filterUsuarios)
                        : null;
                  });
                }),
            DataColumn(
                label: Text('Teléfono'),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    snapshot.usuarios.length > 0
                        ? filterUsuarios =
                            onSortColum(columnIndex, ascending, filterUsuarios)
                        : null;
                  });
                }),
            DataColumn(
                label: Text('Correo'),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    snapshot.usuarios.length > 0
                        ? filterUsuarios =
                            onSortColum(columnIndex, ascending, filterUsuarios)
                        : null;
                  });
                }),
            DataColumn(
                label: Text('Estatus'),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    snapshot.usuarios.length > 0
                        ? filterUsuarios =
                            onSortColum(columnIndex, ascending, filterUsuarios)
                        : null;
                  });
                }),
          ],
          source:
              _DataSource(snapshot != null ? snapshot.usuarios : [], context),
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
            ? sortData.usuarios.sort(
                (a, b) => a.nombre_completo.compareTo((b.nombre_completo)))
            : sortData.usuarios
                .sort((a, b) => b.nombre_completo.compareTo(a.nombre_completo));
        break;
      case 1:
        sort[columnIndex]
            ? sortData.usuarios
                .sort((a, b) => a.telefono.compareTo((b.telefono)))
            : sortData.usuarios
                .sort((a, b) => b.telefono.compareTo(a.telefono));
        break;
      case 2:
        sort[columnIndex]
            ? sortData.usuarios.sort((a, b) => a.correo.compareTo((b.correo)))
            : sortData.usuarios.sort((a, b) => b.correo.compareTo(a.correo));
        break;
      case 3:
        sort[columnIndex]
            ? sortData.usuarios.sort((a, b) {
                String stra = a.estatus == 'A' ? 'Activo' : 'Inactivo';
                String strb = b.estatus == 'A' ? 'Activo' : 'Inactivo';
                return stra.compareTo(strb);
              })
            : sortData.usuarios.sort((a, b) {
                String stra = a.estatus == 'A' ? 'Activo' : 'Inactivo';
                String strb = b.estatus == 'A' ? 'Activo' : 'Inactivo';
                return strb.compareTo(stra);
              });
        break;
    }
    _sortColumnIndex = columnIndex;
    sortArrow = !sortArrow;

    return sortData;
  }

  // TABS
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int _selectedIndex = 0;
}

bool crt = true;

Future<bool> mostrarForm(formContext, accion, usr) async {
  dynamic usuario = await Navigator.pushNamed(
      formContext, '${accion == 0 ? '/crearUsuario' : '/editarUsuario'}',
      arguments: {'accion': accion, 'data': usr});
  if (usuario != null) {
    ScaffoldMessenger.of(formContext).showSnackBar(SnackBar(
      content: Text(
          '${usuario.result.nombre_completo} ${accion == 0 ? 'Agregado a Usuarios' : 'editado'}'),
      onVisible: () {
        usuariosBloc.add(FetchUsuariosPorPlannerEvent());
        crt = true;
      },
    ));
    return true;
  } else {
    return false;
  }
}

class _DataSource extends DataTableSource {
  ItemModelUsuarios ims;
  BuildContext _gridContext;
  _DataSource(context, this._gridContext) {
    _rows = <_Row>[];
    if (context.length > 0) {
      ims = new ItemModelUsuarios(context);
      for (int i = 0; i < context.length; i++) {
        _rows.add(_Row(
            context[i].id_usuario,
            context[i].nombre_completo,
            context[i].telefono,
            context[i].correo,
            context[i].estatus == 'A' ? 'Activo' : 'Inactivo'));
      }
    } else {
      _rows.add(_Row(null, 'Sin datos', '', '', ''));
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
        DataCell(Text(row.valueA), onTap: () async {
          ItemModelUsuario user;
          ims.usuarios.forEach((usr) {
            if (usr.id_usuario == row.valueId) {
              user = new ItemModelUsuario(usr);
            }
          });
          mostrarForm(_gridContext, 1, user);
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

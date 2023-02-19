import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/blocs/usuarios/usuarios_bloc.dart';
import 'package:planning/src/logic/usuarios.logic.dart';
import 'package:planning/src/models/item_model_usuarios.dart';
import 'package:planning/src/ui/Roles/roles.dart';
import 'package:planning/src/ui/widgets/snackbar_widget/snackbar_widget.dart';
import 'package:planning/src/utils/utils.dart';

class Usuarios extends StatefulWidget {
  const Usuarios({Key? key}) : super(key: key);

  @override
  _UsuariosState createState() => _UsuariosState();
}

late UsuariosBloc usuariosBloc;

class _UsuariosState extends State<Usuarios> {
  final TextStyle estiloTxt = const TextStyle(fontWeight: FontWeight.bold);
  ItemModelUsuarios? itemModelUsuarios;
  ItemModelUsuarios? filterUsuarios;
  UsuarioCrud usuariosLogic = UsuarioCrud();
  bool bandera = false;
  List<bool> sort = [false, false, false, false];
  int _sortColumnIndex = 0;
  bool sortArrow = false;
  late List<Widget> footerTabs;

  _UsuariosState();

  @override
  void initState() {
    usuariosBloc = BlocProvider.of<UsuariosBloc>(context);
    usuariosBloc.add(FetchUsuariosPorPlannerEvent());
    footerTabs = [
      BlocBuilder<UsuariosBloc, UsuariosState>(
        builder: (context, state) {
          if (state is UsuariosInitialState) {
            return const Center(child: LoadingCustom());
          } else if (state is LoadingUsuariosState) {
            return const Center(child: LoadingCustom());
          } else if (state is MostrarUsuariosState) {
            if (state.usuarios != null) {
              if (itemModelUsuarios != state.usuarios) {
                itemModelUsuarios = state.usuarios;
                if (itemModelUsuarios != null) {
                  filterUsuarios = itemModelUsuarios!.copy();
                }
                crt = false;
              }
            } else {
              crt = true;
              usuariosBloc.add(FetchUsuariosPorPlannerEvent());
              return const Center(child: LoadingCustom());
            }
            if (filterUsuarios!.usuarios != null) {
              return buildList(filterUsuarios!);
            } else {
              return const Center(child: Text('Sin datos'));
            }
          } else if (state is ErrorMostrarUsuariosState) {
            return Center(
              child: Text(state.message),
            );
          } else {
            crt = true;
            if (filterUsuarios!.usuarios != null) {
              return buildList(filterUsuarios!);
            } else {
              return const Center(child: Text('Sin datos'));
            }
          }
        },
      ),
      const Roles()
      // Center(child: Text('En construccin'))
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        color: Colors.blue,
        onRefresh: () async {
          usuariosBloc.add(FetchUsuariosPorPlannerEvent());
        },
        child: SizedBox(
            width: double.infinity,
            child: IndexedStack(index: _selectedIndex, children: footerTabs)),
      ),
      floatingActionButton: _selectedIndex == 0 ? _expasibleFab() : null,
      floatingActionButtonLocation:
          _selectedIndex == 0 ? FloatingActionButtonLocation.endFloat : null,
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

  Widget _expasibleFab() {
    return SpeedDial(
      tooltip: 'Opciones',
      icon: Icons.more_vert,
      children: [
        SpeedDialChild(
          label: 'Descargar PDF',
          onTap: () async {
            final data = await usuariosLogic.downloadPdfUsuarios();

            if (data != null) {
              downloadFile(data, 'Usuarios');
            }
          },
          child: const Icon(Icons.download),
        ),
        SpeedDialChild(
          label: 'Añadir Usuario',
          child: const Icon(Icons.add),
          onTap: () {
            setState(() {
              mostrarForm(context, 0, null);
            });
          },
        ),
      ],
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
                const Expanded(
                  flex: 3,
                  child: Text('Usuarios'),
                ),
                Expanded(
                  /* height: 30, */
                  flex: 5,
                  child: TextField(
                    decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                        ),
                        hintText: 'Buscar...'),
                    onChanged: (String value) async {
                      if (value.length > 2) {
                        List<dynamic> usrs = itemModelUsuarios!.usuarios
                            .where((imu) =>
                                imu.nombreCompleto!
                                    .toLowerCase()
                                    .contains(value.toLowerCase()) ||
                                imu.correo!
                                    .toLowerCase()
                                    .contains(value.toLowerCase()) ||
                                imu.telefono!
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                            .toList();
                        setState(() {
                          filterUsuarios!.usuarios.clear();
                          if (usrs.isNotEmpty) {
                            for (var usr in usrs) {
                              filterUsuarios!.usuarios.add(usr);
                            }
                          } else {}
                        });
                      } else {
                        setState(() {
                          if (itemModelUsuarios != null) {
                            filterUsuarios = itemModelUsuarios!.copy();
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
              : snapshot.usuarios.isEmpty
                  ? 1
                  : snapshot.usuarios.length,
          showCheckboxColumn: bandera,
          columns: [
            DataColumn(
                label: const Text('Nombre'),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    snapshot.usuarios.isNotEmpty
                        ? filterUsuarios =
                            onSortColum(columnIndex, ascending, filterUsuarios)
                        : null;
                  });
                }),
            DataColumn(
                label: const Text('Teléfono'),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    snapshot.usuarios.isNotEmpty
                        ? filterUsuarios =
                            onSortColum(columnIndex, ascending, filterUsuarios)
                        : null;
                  });
                }),
            DataColumn(
                label: const Text('Correo'),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    snapshot.usuarios.isNotEmpty
                        ? filterUsuarios =
                            onSortColum(columnIndex, ascending, filterUsuarios)
                        : null;
                  });
                }),
            DataColumn(
                label: const Text('Estatus'),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    snapshot.usuarios.isNotEmpty
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

  ItemModelUsuarios? onSortColum(
      int columnIndex, bool ascending, ItemModelUsuarios? sortData) {
    sort[columnIndex] = !sort[columnIndex];
    switch (columnIndex) {
      case 0:
        sort[columnIndex]
            ? sortData!.usuarios
                .sort((a, b) => a.nombreCompleto!.compareTo(b.nombreCompleto!))
            : sortData!.usuarios
                .sort((a, b) => b.nombreCompleto!.compareTo(a.nombreCompleto!));
        break;
      case 1:
        sort[columnIndex]
            ? sortData!.usuarios
                .sort((a, b) => a.telefono!.compareTo(b.telefono!))
            : sortData!.usuarios
                .sort((a, b) => b.telefono!.compareTo(a.telefono!));
        break;
      case 2:
        sort[columnIndex]
            ? sortData!.usuarios.sort((a, b) => a.correo!.compareTo(b.correo!))
            : sortData!.usuarios.sort((a, b) => b.correo!.compareTo(a.correo!));
        break;
      case 3:
        sort[columnIndex]
            ? sortData!.usuarios.sort((a, b) {
                String stra = a.estatus == 'A' ? 'Activo' : 'Inactivo';
                String strb = b.estatus == 'A' ? 'Activo' : 'Inactivo';
                return stra.compareTo(strb);
              })
            : sortData!.usuarios.sort((a, b) {
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
      formContext, accion == 0 ? '/crearUsuario' : '/editarUsuario',
      arguments: {'accion': accion, 'data': usr});
  if (usuario != null) {
    MostrarAlerta(
      mensaje:
          '${usuario.result.nombreCompleto} ${accion == 0 ? 'Agregado usuarios' : 'editado'}',
      onVisible: () {
        usuariosBloc.add(FetchUsuariosPorPlannerEvent());
        crt = true;
      },
      tipoMensaje: TipoMensaje.correcto,
    );
    return true;
  } else {
    return false;
  }
}

class _DataSource extends DataTableSource {
  late ItemModelUsuarios ims;
  final BuildContext _gridContext;
  _DataSource(context, this._gridContext) {
    _rows = <_Row>[];
    if (context.length > 0) {
      ims = ItemModelUsuarios(context);
      for (int i = 0; i < context.length; i++) {
        _rows.add(_Row(
            context[i].idUsuario,
            context[i].nombreCompleto,
            context[i].telefono,
            context[i].correo,
            context[i].estatus == 'A' ? 'Activo' : 'Inactivo'));
      }
    }
  }

  late List<_Row> _rows;

  int _selectedCount = 0;

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= _rows.length) return null;
    final row = _rows[index];
    return DataRow.byIndex(
      index: index,
      selected: row.selected!,
      onSelectChanged: (value) {
        if (row.selected != value) {
          _selectedCount += value! ? 1 : -1;
          assert(_selectedCount >= 0);
          row.selected = value;
          notifyListeners();
        }
      },
      cells: [
        DataCell(Text(row.valueA!), onTap: () async {
          ItemModelUsuario? user;
          for (var usr in ims.usuarios) {
            if (usr.idUsuario == row.valueId) {
              user = ItemModelUsuario(usr);
            }
          }
          mostrarForm(_gridContext, 1, user);
        }),
        DataCell(
          Text(row.valueB!),
        ),
        DataCell(
          Text(row.valueC!),
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
  final int? valueId;
  final String? valueA;
  final String? valueB;
  final String? valueC;
  final String valueD;

  bool? selected = false;
}

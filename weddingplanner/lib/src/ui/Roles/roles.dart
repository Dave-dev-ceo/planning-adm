import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingplanner/src/blocs/roles/roles_bloc.dart';
import 'package:weddingplanner/src/blocs/usuarios/usuarios_bloc.dart';
import 'package:weddingplanner/src/models/item_model_usuarios.dart';
import 'package:weddingplanner/src/models/model_roles.dart';

class Roles extends StatefulWidget {
  const Roles({Key key}) : super(key: key);

  @override
  _RolesState createState() => _RolesState();
}

RolesBloc rolesBloc;

class _RolesState extends State<Roles> {
  final TextStyle estiloTxt = TextStyle(fontWeight: FontWeight.bold);
  ItemModelRoles itemModelRoles;
  ItemModelRoles filterRoles;
  bool bandera = false;
  List<bool> sort = [false, false, false, false];
  int _sortColumnIndex = 0;
  bool sortArrow = false;

  _RolesState();

  @override
  void initState() {
    rolesBloc = BlocProvider.of<RolesBloc>(context);
    rolesBloc.add(ObtenerRolesPlannerEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<RolesBloc, RolesState>(
        builder: (context, state) {
          if (state is RolesInitial) {
            return Center(child: CircularProgressIndicator());
          } else if (state is LoadingRolesPlanner) {
            return Center(child: CircularProgressIndicator());
          } else if (state is MostrarRolesPlanner) {
            if (state.roles != null) {
              if (itemModelRoles != state.roles) {
                itemModelRoles = state.roles;
                if (itemModelRoles != null) {
                  filterRoles = itemModelRoles.copy();
                }
                crt = false;
              }
            } else {
              crt = true;
              rolesBloc.add(ObtenerRolesPlannerEvent());
              return Center(child: CircularProgressIndicator());
            }
            if (filterRoles.roles != null) {
              return buildList(filterRoles);
            } else {
              return Center(child: Text('Sin datos'));
            }
          } else if (state is ErrorObtenerRolesPlanner) {
            return Center(
              child: Text(state.message),
            );
          } else {
            crt = true;
            if (filterRoles.roles != null) {
              return buildList(filterRoles);
            } else {
              return Center(child: Text('Sin datos'));
            }
          }
        },
      ),
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
    );
  }

  Widget buildList(ItemModelRoles snapshot) {
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
                  child: Text('Roles'),
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
                        List<dynamic> usrs = itemModelRoles.roles
                            .where((imu) =>
                                imu.clave_rol
                                    .toLowerCase()
                                    .contains(value.toLowerCase()) ||
                                imu.nombre_rol
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                            .toList();
                        setState(() {
                          filterRoles.roles.clear();
                          if (usrs.length > 0) {
                            for (var usr in usrs) {
                              filterRoles.roles.add(usr);
                            }
                          } else {}
                        });
                      } else {
                        setState(() {
                          if (itemModelRoles != null) {
                            filterRoles = itemModelRoles.copy();
                          }
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          rowsPerPage: snapshot.roles.length > 8
              ? 8
              : snapshot.roles.length < 1
                  ? 1
                  : snapshot.roles.length,
          showCheckboxColumn: bandera,
          columns: [
            DataColumn(
                label: Text('Clave Rol'),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    snapshot.roles.length > 0
                        ? filterRoles =
                            onSortColum(columnIndex, ascending, filterRoles)
                        : null;
                  });
                }),
            DataColumn(
                label: Text('Nombre Rol'),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    snapshot.roles.length > 0
                        ? filterRoles =
                            onSortColum(columnIndex, ascending, filterRoles)
                        : null;
                  });
                }),
          ],
          source: _DataSource(snapshot != null ? snapshot.roles : [], context),
        ),
      ],
    );
  }

  ItemModelRoles onSortColum(
      int columnIndex, bool ascending, ItemModelRoles sortData) {
    sort[columnIndex] = !sort[columnIndex];
    switch (columnIndex) {
      case 0:
        sort[columnIndex]
            ? sortData.roles
                .sort((a, b) => a.clave_rol.compareTo((b.clave_rol)))
            : sortData.roles.sort((a, b) => b.clave_rol.compareTo(a.clave_rol));
        break;
      case 1:
        sort[columnIndex]
            ? sortData.roles
                .sort((a, b) => a.nombre_rol.compareTo((b.nombre_rol)))
            : sortData.roles
                .sort((a, b) => b.nombre_rol.compareTo(a.nombre_rol));
        break;
    }
    _sortColumnIndex = columnIndex;
    sortArrow = !sortArrow;

    return sortData;
  }
}

bool crt = true;

Future<bool> mostrarForm(formContext, accion, usr) async {
  dynamic rol = await Navigator.pushNamed(
      formContext, '${accion == 0 ? '/crearRol' : '/editarRol'}',
      arguments: {'accion': accion, 'data': usr});
  if (rol != null) {
    ScaffoldMessenger.of(formContext).showSnackBar(SnackBar(
      content: Text(
          '${rol.roles.nombre_rol} ${accion == 0 ? 'Agregado a Roles' : 'editado'}'),
      onVisible: () {
        rolesBloc.add(ObtenerRolesPlannerEvent());
        crt = true;
      },
    ));
    return true;
  } else {
    return false;
  }
}

class _DataSource extends DataTableSource {
  ItemModelRoles ims;
  BuildContext _gridContext;
  _DataSource(context, this._gridContext) {
    _rows = <_Row>[];
    if (context.length > 0) {
      ims = new ItemModelRoles(context);
      for (int i = 0; i < context.length; i++) {
        _rows.add(_Row(
            context[i].id_rol, context[i].clave_rol, context[i].nombre_rol));
      }
    } else {
      _rows.add(_Row(null, 'Sin datos', ''));
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
          ItemModelRol rol;
          ims.roles.forEach((rl) {
            if (rol.result.id_rol == row.valueId) {
              rol = new ItemModelRol(rl);
            }
          });
          // mostrarForm(_gridContext, 1, rol);
        }),
        DataCell(
          Text(row.valueB),
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
  );
  final int valueId;
  final String valueA;
  final String valueB;

  bool selected = false;
}

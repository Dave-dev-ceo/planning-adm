import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/blocs/roles/roles_bloc.dart';
import 'package:planning/src/models/model_roles.dart';
import 'package:planning/src/ui/widgets/snackbar_widget/snackbar_widget.dart';

class Roles extends StatefulWidget {
  const Roles({Key? key}) : super(key: key);

  @override
  _RolesState createState() => _RolesState();
}

late RolesBloc rolesBloc;

class _RolesState extends State<Roles> {
  final TextStyle estiloTxt = const TextStyle(fontWeight: FontWeight.bold);
  ItemModelRoles? itemModelRoles;
  ItemModelRoles? filterRoles;
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
            return const Center(child: LoadingCustom());
          } else if (state is LoadingRolesPlanner) {
            return const Center(child: LoadingCustom());
          } else if (state is MostrarRolesPlanner) {
            if (state.roles != null) {
              if (itemModelRoles != state.roles) {
                itemModelRoles = state.roles;
                if (itemModelRoles != null) {
                  filterRoles = itemModelRoles!.copy();
                }
                crt = false;
              }
            } else {
              crt = true;
              rolesBloc.add(ObtenerRolesPlannerEvent());
              return const Center(child: LoadingCustom());
            }
            if (filterRoles?.roles != null) {
              return buildList(filterRoles!);
            } else {
              return const Center(child: Text('Sin datos'));
            }
          } else if (state is ErrorObtenerRolesPlanner) {
            return Center(
              child: Text(state.message),
            );
          } else {
            crt = true;
            if (filterRoles?.roles != null) {
              return buildList(filterRoles!);
            } else {
              return const Center(child: Text('Sin datos'));
            }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        child: const Icon(Icons.add),
        onPressed: () {
          mostrarForm(context, 0, null);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget buildList(ItemModelRoles snapshot) {
    return ListView(
      controller: ScrollController(),
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
                  child: Text('Roles'),
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
                        List<dynamic> usrs = itemModelRoles!.roles
                            .where((imu) =>
                                imu.claveRol!
                                    .toLowerCase()
                                    .contains(value.toLowerCase()) ||
                                imu.nombreRol!
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                            .toList();
                        setState(() {
                          filterRoles!.roles.clear();
                          if (usrs.isNotEmpty) {
                            for (var usr in usrs) {
                              filterRoles!.roles.add(usr);
                            }
                          } else {}
                        });
                      } else {
                        setState(() {
                          if (itemModelRoles != null) {
                            filterRoles = itemModelRoles!.copy();
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
              : snapshot.roles.isEmpty
                  ? 1
                  : snapshot.roles.length,
          showCheckboxColumn: bandera,
          columns: [
            DataColumn(
                label: const Text('Clave'),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    snapshot.roles.isNotEmpty
                        ? filterRoles =
                            onSortColum(columnIndex, ascending, filterRoles)
                        : null;
                  });
                }),
            DataColumn(
                label: const Text('Nombre'),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    snapshot.roles.isNotEmpty
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

  ItemModelRoles? onSortColum(
      int columnIndex, bool ascending, ItemModelRoles? sortData) {
    sort[columnIndex] = !sort[columnIndex];
    switch (columnIndex) {
      case 0:
        sort[columnIndex]
            ? sortData!.roles.sort((a, b) => a.claveRol!.compareTo(b.claveRol!))
            : sortData!.roles
                .sort((a, b) => b.claveRol!.compareTo(a.claveRol!));
        break;
      case 1:
        sort[columnIndex]
            ? sortData!.roles
                .sort((a, b) => a.nombreRol!.compareTo(b.nombreRol!))
            : sortData!.roles
                .sort((a, b) => b.nombreRol!.compareTo(a.nombreRol!));
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
      formContext, accion == 0 ? '/crearRol' : '/editarRol',
      arguments: {'accion': accion, 'data': usr});
  if (rol != null) {
    MostrarAlerta(
      mensaje:
          '${rol.result.nombreRol} ${accion == 0 ? 'Agregado a roles' : 'editado'}',
      onVisible: () {
        rolesBloc.add(ObtenerRolesPlannerEvent());
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
  late ItemModelRoles ims;
  final BuildContext _gridContext;
  _DataSource(context, this._gridContext) {
    _rows = <_Row>[];
    if (context.length > 0) {
      ims = ItemModelRoles(context);
      for (int i = 0; i < context.length; i++) {
        _rows.add(
            _Row(context[i].idRol, context[i].claveRol, context[i].nombreRol));
      }
    } else {
      _rows.add(_Row(null, 'Sin datos', ''));
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
          final _rol = ims.roles.firstWhere((rl) => rl.idRol == row.valueId);
          ItemModelRol rol = ItemModelRol(_rol);
          mostrarForm(_gridContext, 1, rol);
        }),
        DataCell(
          Text(row.valueB!),
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
  final int? valueId;
  final String? valueA;
  final String? valueB;

  bool? selected = false;
}

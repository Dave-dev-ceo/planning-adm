import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/blocs/planners/planners_bloc.dart';
import 'package:planning/src/models/plannerModel/planner_model.dart';
import 'package:planning/src/ui/administrar_planners/plantillas_sistema.dart';

class AdminPlannerPage extends StatefulWidget {
  const AdminPlannerPage({Key? key}) : super(key: key);

  @override
  State<AdminPlannerPage> createState() => _AdminPlannerPageState();
}

class _AdminPlannerPageState extends State<AdminPlannerPage>
    with TickerProviderStateMixin {
  late PlannersBloc plannersBloc;

  int sortColumnIndex = 0;
  List<bool> sort = [false, false, false, false];

  bool valor = false;

  bool sortArrow = false;

  List<PlannerModel> planners = [];
  List<PlannerModel> plannersFiltradosGlobal = [];
  TabController? _tabController;

  int currentIndex = 0;

  @override
  void initState() {
    plannersBloc = BlocProvider.of<PlannersBloc>(context);
    plannersBloc.add(ObtenerPlannersEvent());
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Administrar'),
        bottom: TabBar(
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          indicatorColor: Colors.black,
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.label,
          isScrollable: true,
          tabs: const [
            Tab(
              text: 'Planners',
              icon: FaIcon(FontAwesomeIcons.userGear),
            ),
            Tab(
              text: 'Plantillas',
              icon: FaIcon(FontAwesomeIcons.fileContract),
            )
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          plannersBuild(),
          const PlantillasSistemaPage(),
        ],
      ),
      //floatingActionButton: currentIndex == 0
      //    ? FloatingActionButton(
      //        onPressed: () {
      //          if (_tabController.index == 0) {
      //            Navigator.of(context)
      //                .pushNamed(
      //                  '/detallesPlanner',
      //                  arguments: 0,
      //                )
      //                .then(
      //                  (_) => {
      //                    BlocProvider.of<PlannersBloc>(context)
      //                        .add(ObtenerPlannersEvent())
      //                  },
      //                );
      //          } else {}
      //        },
      //        child: const FaIcon(FontAwesomeIcons.userPlus),
      //      )
      //    : null,
    );
  }

  Widget plannersBuild() {
    return BlocListener<PlannersBloc, PlannersState>(
      listener: (context, state) {},
      child: BlocBuilder<PlannersBloc, PlannersState>(
        builder: (context, state) {
          if (state is LoadingPlannersState) {
            return const Center(
              child: LoadingCustom(),
            );
          } else if (state is MostrarPlannersState) {
            if (state.planners.isNotEmpty) {
              planners = state.planners;
              plannersFiltradosGlobal = state.plannersFiltrados;
              return buildLisPlanners(plannersFiltradosGlobal);
            } else {
              return const Center(
                child: Text('Sin planners'),
              );
            }
          } else {
            return const Center(
              child: Text('Sin planners'),
            );
          }
        },
      ),
    );
  }

  Widget buildLisPlanners(List<PlannerModel> plannersFiltrados) {
    return ListView(
      children: [
        PaginatedDataTable(
          columns: [
            DataColumn(
                label: const Text('Nombre'),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    plannersFiltrados =
                        onShorColum(columnIndex, ascending, plannersFiltrados);
                  });
                }),
            DataColumn(
                label: const Text('Teléfono'),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    plannersFiltrados =
                        onShorColum(columnIndex, ascending, plannersFiltrados);
                  });
                }),
            DataColumn(
                label: const Text('Correo'),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    plannersFiltrados =
                        onShorColum(columnIndex, ascending, plannersFiltrados);
                  });
                }),
            DataColumn(
                label: const Text('Estatus'),
                onSort: (columnIndex, ascending) {
                  setState(() {
                    plannersFiltrados =
                        onShorColum(columnIndex, ascending, plannersFiltrados);
                  });
                }),
          ],
          source: _DataSourcePlanners(plannersFiltrados, context),
          header: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const Expanded(
                  child: Text('Planners'),
                ),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                        alignLabelWithHint: true,
                        prefixIcon: FaIcon(
                          FontAwesomeIcons.magnifyingGlass,
                          color: Colors.black,
                        ),
                        hintText: 'Buscar...'),
                    onChanged: (String value) {
                      if (value.length > 2) {
                        List<PlannerModel> tempPlanners = plannersFiltrados
                            .where(
                              (planner) =>
                                  planner.nombreCompleto!
                                      .toLowerCase()
                                      .contains(value.toLowerCase()) ||
                                  planner.correo!
                                      .toLowerCase()
                                      .contains(value.toLowerCase()) ||
                                  planner.telefono!
                                      .toLowerCase()
                                      .contains(value.toLowerCase()),
                            )
                            .toList();

                        if (tempPlanners.isNotEmpty) {
                          plannersFiltradosGlobal.clear();
                          for (var temp in tempPlanners) {
                            plannersFiltradosGlobal.add(temp);
                          }
                          setState(() {});
                        }
                      } else {
                        setState(() {
                          if (planners.isNotEmpty) {
                            plannersFiltradosGlobal.clear();
                            for (var planner in planners) {
                              plannersFiltradosGlobal.add(planner);
                            }
                          }
                        });
                      }
                    },
                  ),
                )
              ],
            ),
          ),
          rowsPerPage: planners.length > 8 ? 8 : planners.length,
        ),
        const SizedBox(
          height: 20.0,
        )
      ],
    );
  }

  List<PlannerModel> onShorColum(
      int columnIndex, bool ascendig, List<PlannerModel> sorData) {
    sort[columnIndex] = !sort[columnIndex];

    switch (columnIndex) {
      case 0:
        sort[columnIndex]
            ? sorData
                .sort((a, b) => a.nombreCompleto!.compareTo(b.nombreCompleto!))
            : sorData
                .sort((a, b) => b.nombreCompleto!.compareTo(a.nombreCompleto!));

        break;
      case 1:
        sort[columnIndex]
            ? sorData.sort((a, b) => a.telefono!.compareTo(b.telefono!))
            : sorData.sort((a, b) => b.telefono!.compareTo(a.telefono!));
        break;
      case 2:
        sort[columnIndex]
            ? sorData.sort((a, b) => a.correo!.compareTo(b.correo!))
            : sorData.sort((a, b) => b.correo!.compareTo(a.correo!));
        break;
      case 3:
        sort[columnIndex]
            ? sorData.sort((a, b) {
                String stra = a.estatus == 'A' ? 'Activo' : 'Inactivo';
                String strb = b.estatus == 'A' ? 'Activo' : 'Inactivo';
                return stra.compareTo(strb);
              })
            : sorData.sort((a, b) {
                String stra = a.estatus == 'A' ? 'Activo' : 'Inactivo';
                String strb = b.estatus == 'A' ? 'Activo' : 'Inactivo';
                return strb.compareTo(stra);
              });
        break;
    }
    sortColumnIndex = columnIndex;
    sortArrow = !sortArrow;

    return sorData;
  }
}

class _DataSourcePlanners extends DataTableSource {
  final List<PlannerModel> planners;
  final BuildContext context;

  _DataSourcePlanners(
    this.planners,
    this.context,
  );

  int selectedCount = 0;

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= planners.length) return null;
    final planner = planners[index];
    return DataRow.byIndex(
      cells: [
        DataCell(
          Text(planner.nombreCompleto!),
          onTap: () async {
            Navigator.of(context)
                .pushNamed(
                  '/detallesPlanner',
                  arguments: planner.idPlanner,
                )
                .then(
                  (_) => {
                    BlocProvider.of<PlannersBloc>(context)
                        .add(ObtenerPlannersEvent())
                  },
                );
          },
        ),
        DataCell(
          Text(planner.telefono!),
        ),
        DataCell(
          Text(planner.correo!),
        ),
        DataCell(
          Text(planner.estatus == 'A' ? 'Activo' : 'Inactivo'),
        ),
      ],
      index: index,
      onSelectChanged: null,
      // (value) {
      //   if (row.selected != value) {
      //     _selectedCount += value ? 1 : -1;
      //     assert(_selectedCount >= 0);
      //     row.selected = value;
      //     notifyListeners();
      //   }
      // },
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  @override
  int get selectedRowCount => selectedCount;

  @override
  int get rowCount => planners.length;
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/blocs/planners/planners_bloc.dart';
import 'package:planning/src/models/item_model_planners.dart';

class Planners extends StatefulWidget {
  const Planners({Key key}) : super(key: key);

  @override
  _PlannersState createState() => _PlannersState();
}

class _PlannersState extends State<Planners> {
  PlannersBloc plannerBloc;
  ItemModelPlanners itemModelPlanners;

  @override
  void initState() {
    plannerBloc = BlocProvider.of<PlannersBloc>(context);
    plannerBloc.add(FechtPlannersEvent());
    super.initState();
  }

  Widget buildList(ItemModelPlanners snapshot) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        PaginatedDataTable(
          header: const Text('Planners'),
          rowsPerPage: 8,
          showCheckboxColumn: false,
          columns: const [
            DataColumn(label: Text('Empresa')),
            DataColumn(label: Text('Correo')),
            DataColumn(label: Text('Teléfono')),
            DataColumn(label: Text('País')),
            //DataColumn(label: Text('', style:estiloTxt),),
            //DataColumn(label: Text('', style:estiloTxt)),
          ],
          source: _DataSource(snapshot.results, context),
        ),
      ],
    );
  }

  formItemsDesign(icon, item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Card(child: ListTile(leading: Icon(icon), title: item)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: BlocBuilder<PlannersBloc, PlannersState>(
          builder: (context, state) {
            if (state is PlannersInitialState) {
              return const Center(
                child: LoadingCustom(),
              );
            } else if (state is LoadingPlannersState) {
              return const Center(
                child: LoadingCustom(),
              );
            } else if (state is MostrarPlannersState) {
              itemModelPlanners = state.planners;
              return buildList(state.planners);
            } else if (state is ErrorListaPlannersState) {
              return Center(
                child: Text(state.message),
              );
              //_showError(context, state.message);
            } else {
              return buildList(itemModelPlanners);
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: UniqueKey(),
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed('/addPlanners');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
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
  //BuildContext _cont;

  _DataSource(context, BuildContext cont) {
    _rows = <_Row>[];
    for (int i = 0; i < context.length; i++) {
      _rows.add(_Row(context[i].idPlanner, context[i].empresa,
          context[i].correo, context[i].telefono, context[i].pais));
    }
    //_cont = cont;
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
          //notifyListeners();
        }
      },
      cells: [
        DataCell(
          Text(row.valueA),
        ),
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

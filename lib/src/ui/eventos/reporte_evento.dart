// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/blocs/blocs.dart';
import 'package:planning/src/models/item_model_reporte_evento.dart';

class ReporteEvento extends StatefulWidget {
  final String? dataView;
  final int? dataId;
  const ReporteEvento({Key? key, this.dataView, this.dataId}) : super(key: key);
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => const ReporteEvento(),
      );
  @override
  State<ReporteEvento> createState() => _ReporteEventoState(dataView, dataId);
}

class _ReporteEventoState extends State<ReporteEvento> {
  final TextStyle estiloTxt = const TextStyle(fontWeight: FontWeight.bold);
  final String? dataView;
  final int? dataId;
  bool dialVisible = true;

  _ReporteEventoState(this.dataView, this.dataId);
  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  listaReporte(BuildContext cont) {
    Map<String, String?> data = {"reporte": dataView, "id": dataId.toString()};
    blocReporte.fetchAllReportes(cont, data);
    return StreamBuilder(
      stream: blocReporte.allReportes,
      builder: (context, AsyncSnapshot<ItemModelReporte?> snapshot) {
        if (snapshot.hasData) {
          return buildList(snapshot);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return const Center(child: LoadingCustom());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //double pHz = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Center(
          child: listaReporte(context),
        ),
      ),
    );
  }

  Widget buildList(AsyncSnapshot<ItemModelReporte?> snapshot) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        PaginatedDataTable(
          header: Row(
            children: [
              const Text('Invitados'),
              const Spacer(),
              Text('Total: ${snapshot.data!.results.length}'),
            ],
          ),
          rowsPerPage: 8,
          showCheckboxColumn: false,
          columns: [
            DataColumn(label: Text('Nombre', style: estiloTxt)),
            DataColumn(label: Text('Telefono', style: estiloTxt)),
            DataColumn(label: Text('Correo', style: estiloTxt)),
          ],
          source: _DataSource(snapshot.data!.results, context),
        ),
      ],
    );
  }
}

class _Row {
  _Row(
    this.valueId,
    this.valueA,
    this.valueB,
    this.valueC,
  );
  final int? valueId;
  final String? valueA;
  final String? valueB;
  final String? valueC;

  bool? selected = false;
}

class _DataSource extends DataTableSource {
  //BuildContext _cont;
  _DataSource(context, BuildContext cont) {
    _rows = <_Row>[];
    for (int i = 0; i < context.length; i++) {
      _rows.add(_Row(context[i].idInvitado, context[i].nombre,
          context[i].telefono, context[i].email));
    }
    // _cont=cont;
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
          //notifyListeners();
        }
      },
      cells: [
        //DataCell(Text(row.valueId.toString())),
        DataCell(Text(row.valueA!)),
        DataCell(Text((row.valueB != null) ? row.valueB! : 'Sin teléfono')),
        DataCell(Text((row.valueC != null) ? row.valueC! : 'Sin correo')),
        //DataCell(Icon(Icons.edit)),
        //DataCell(Icon(Icons.delete)),
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

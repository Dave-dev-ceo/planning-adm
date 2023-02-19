// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:planning/src/models/item_model_estatus_invitado.dart';
import 'package:planning/src/models/item_model_grupos.dart';
import 'package:planning/src/resources/api_provider.dart';
import 'package:planning/src/ui/eventos/reporte_evento.dart';

class FullScreenDialogReporte extends StatefulWidget {
  final String? reporte;

  const FullScreenDialogReporte({Key? key, this.reporte}) : super(key: key);
  @override
  _FullScreenDialogReporteState createState() =>
      _FullScreenDialogReporteState(reporte);
}

class _FullScreenDialogReporteState extends State<FullScreenDialogReporte> {
  ApiProvider api = ApiProvider();
  final String? reporte;
  ItemModelEstatusInvitado? modelEstatus;
  ItemModelGrupos? _grupos;
  Map<String, String?> dataJson = {"id": "0"};
  List<Widget>? tabs;
  late int lenghtTab;
  int _pageIndex = 0;
  //var _rest;
  _FullScreenDialogReporteState(this.reporte);

  @override
  void initState() {
    super.initState();
  }

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  Future<String> _tiposReporte() async {
    // String data;
    if (reporte == "asistencia") {
      modelEstatus = await api.fetchEstatusList(context);
      lenghtTab = modelEstatus!.results.length;
      return "asistencia";
      //data = reporte;
    } else if (reporte == "relacion") {
      _grupos = await api.fetchGruposList(context);
      lenghtTab = _grupos!.results.length;
      return "relacion";
      //data = reporte;
    } else {
      return "sin reporte";
    }
    // return dataJson["reporte"];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _tiposReporte(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        ///Widget child;
        if (snapshot.hasData) {
          //_addListWidget("asistencia");
          if (snapshot.data == "asistencia") {
            return DefaultTabController(
              length: lenghtTab,
              child: Scaffold(
                appBar: AppBar(
                  title: const Text('Reporte de evento'),
                  backgroundColor: hexToColor('#fdf4e5'),
                  actions: const [],
                  automaticallyImplyLeading: true,
                  bottom: TabBar(
                    indicatorColor: Colors.black,
                    onTap: (int index) {
                      setState(() {
                        _pageIndex = index;
                      });
                    },
                    isScrollable: true,
                    tabs: //tabs,
                        [
                      for (int i = 0; i < lenghtTab; i++)
                        Tab(
                          child: Text(
                            reporte == "asistencia"
                                ? modelEstatus!.results.elementAt(i).descripcion!
                                : reporte == "relacion"
                                    ? _grupos!.results.elementAt(i).nombreGrupo!
                                    : "data",
                            style: const TextStyle(fontSize: 17),
                          ),
                        ),
                    ],
                  ),
                ),
                body: SafeArea(
                  child: TabBarView(
                    children: <Widget>[
                      for (int j = 0; j < lenghtTab; j++)
                        ReporteEvento(
                            dataView: "asistencia",
                            dataId: modelEstatus!.results
                                .elementAt(j)
                                .idEstatusInvitado),
                    ],
                  ),
                ),
              ),
            );
          } else if (snapshot.data == "relacion") {
            dataJson["reporte"] = reporte;
            return DefaultTabController(
              length: lenghtTab,
              child: Scaffold(
                appBar: AppBar(
                  title: const Text('Reporte de evento'),
                  actions: const [],
                  automaticallyImplyLeading: true,
                  bottom: TabBar(
                    onTap: (int index) {
                      setState(() {
                        dataJson["id"] = reporte == "asistencia"
                            ? modelEstatus!.results
                                .elementAt(index)
                                .idEstatusInvitado
                                .toString()
                            : reporte == "relacion"
                                ? _grupos!.results
                                    .elementAt(index)
                                    .idGrupo
                                    .toString()
                                : "null";
                        _pageIndex = index;
                      });
                    },
                    indicatorColor: Colors.white,
                    isScrollable: true,
                    tabs: [
                      for (int i = 0; i < lenghtTab; i++)
                        Tab(
                          child: Text(
                            reporte == "asistencia"
                                ? modelEstatus!.results.elementAt(i).descripcion!
                                : reporte == "relacion"
                                    ? _grupos!.results.elementAt(i).nombreGrupo!
                                    : "data",
                            style: const TextStyle(fontSize: 17),
                          ),
                        ),
                    ],
                  ),
                ),
                body: SafeArea(
                  child: IndexedStack(
                    index: _pageIndex,
                    children: <Widget>[
                      for (int j = 0; j < lenghtTab; j++)
                        const ReporteEvento(
                          dataView: "relacion",
                        ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            dataJson["reporte"] = "sin datos";
            return Scaffold(
              appBar: AppBar(
                title: const Text('Reporte de evento'),
                actions: const [],
                automaticallyImplyLeading: true,
              ),
              body: const Center(
                child: Text('Sin reportes'),
              ),
            );
          }
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Reporte de evento'),
              actions: const [],
              automaticallyImplyLeading: true,
            ),
            body: const Center(
              child: Text('El sistema está en actualización'),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Reporte de evento'),
              actions: const [],
              automaticallyImplyLeading: true,
            ),
            body: const Center(
              child: Text('El sistema tiene un error'),
            ),
          );
        }
        //return child;
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:weddingplanner/src/models/item_model_estatus_invitado.dart';
import 'package:weddingplanner/src/models/item_model_grupos.dart';
import 'package:weddingplanner/src/resources/api_provider.dart';
import 'package:weddingplanner/src/ui/eventos/reporte_evento.dart';

class FullScreenDialogReporte extends StatefulWidget {
  final String reporte;

  const FullScreenDialogReporte({Key key, this.reporte}) : super(key: key);
  @override
  _FullScreenDialogReporteState createState() =>
      _FullScreenDialogReporteState(reporte);
}

class _FullScreenDialogReporteState extends State<FullScreenDialogReporte> {
  ApiProvider api = new ApiProvider();
  final String reporte;
  ItemModelEstatusInvitado modelEstatus;
  ItemModelGrupos _grupos;
  Map<String, String> dataJson = {"id": "0"};
  List<Widget> tabs;
  int lenghtTab;
  int _pageIndex = 0;
  //var _rest;
  _FullScreenDialogReporteState(this.reporte);

  @override
  void initState() {
    super.initState();
  }

  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  Future<String> _tiposReporte() async {
    // String data;
    if (reporte == "asistencia") {
      modelEstatus = await api.fetchEstatusList(context);
      lenghtTab = modelEstatus.results.length;
      return "asistencia";
      //data = reporte;
    } else if (reporte == "relacion") {
      _grupos = await api.fetchGruposList(context);
      lenghtTab = _grupos.results.length;
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
                  title: Text('Reporte de evento'),
                  backgroundColor: hexToColor('#fdf4e5'),
                  actions: [],
                  automaticallyImplyLeading: true,
                  bottom: TabBar(
                    onTap: (int index) {
                      //dataJson['reporte']="asistencia";
                      setState(() {
                        //dataJson["id"]=modelEstatus.results.elementAt(index).idEstatusInvitado.toString();
                        _pageIndex = index;

                        print(_pageIndex);
                        //print(dataJson["id"]);
                      });
                    },
                    indicatorColor: Colors.white,
                    isScrollable: true,
                    tabs: //tabs,
                        [
                      for (int i = 0; i < lenghtTab; i++)
                        Tab(
                          child: Text(
                            reporte == "asistencia"
                                ? modelEstatus.results.elementAt(i).descripcion
                                : reporte == "relacion"
                                    ? _grupos.results.elementAt(i).nombreGrupo
                                    : "data",
                            style: TextStyle(fontSize: 17),
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
                            dataId: modelEstatus.results
                                .elementAt(j)
                                .idEstatusInvitado),
                    ],
                  ),
                  /*IndexedStack(
                        index: _pageIndex,
                        children: <Widget>[
                          //ReporteEvento(dataView: "asistencia",dataId: modelEstatus.results.elementAt(_pageIndex).idEstatusInvitado),
                          for(int j = 0; j < lenghtTab; j++) ReporteEvento(dataView: "asistencia",dataId: modelEstatus.results.elementAt(_pageIndex).idEstatusInvitado),
                        ],
                      ),*/
                ),
              ),
            );
          } else if (snapshot.data == "relacion") {
            dataJson["reporte"] = reporte;
            return DefaultTabController(
              length: lenghtTab,
              child: Scaffold(
                appBar: AppBar(
                  title: Text('Reporte de evento'),
                  actions: [],
                  automaticallyImplyLeading: true,
                  bottom: TabBar(
                    onTap: (int index) {
                      setState(() {
                        dataJson["id"] = reporte == "asistencia"
                            ? modelEstatus.results
                                .elementAt(index)
                                .idEstatusInvitado
                                .toString()
                            : reporte == "relacion"
                                ? _grupos.results
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
                                ? modelEstatus.results.elementAt(i).descripcion
                                : reporte == "relacion"
                                    ? _grupos.results.elementAt(i).nombreGrupo
                                    : "data",
                            style: TextStyle(fontSize: 17),
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
                        ReporteEvento(
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
                title: Text('Reporte de evento'),
                actions: [],
                automaticallyImplyLeading: true,
              ),
              body: Container(
                child: Center(
                  child: Text('Sin reportes'),
                ),
              ),
            );
          }
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Reporte de evento'),
              actions: [],
              automaticallyImplyLeading: true,
            ),
            body: Container(
              child: Center(
                child: Text('El sistema esta en acualización'),
              ),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text('Reporte de evento'),
              actions: [],
              automaticallyImplyLeading: true,
            ),
            body: Container(
              child: Center(
                child: Text('El sistema tiene un error'),
              ),
            ),
          );
        }
        //return child;
      },
    );
  }
}
/*class ItemModelWidgetsListTab{
  final List <Widget> tabs;
  ItemModelWidgetsListTab.addWidget(Widget wt){
    List<Widget> temp = [];
    for (int i = 0; i < parsedJson.length; i++) {
      _Grupos result = _Grupos(parsedJson[i]);
      //print(parsedJson[i]);
      temp.add(result);
    }
    _results = temp;
  }
  List<_Grupos> get results => _results;
}*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/blocs/proveedorEvento/proveedoreventos_bloc.dart';
import 'package:planning/src/logic/proveedores_evento_logic.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/models/item_model_proveedores.dart';
import 'package:planning/src/models/item_model_proveedores_evento.dart';
import 'package:planning/src/utils/utils.dart';

class ProveedorEvento extends StatefulWidget {
  const ProveedorEvento({Key key}) : super(key: key);
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => ProveedorEvento(),
      );
  @override
  _ProveedorEventoState createState() => _ProveedorEventoState();
}

class _ProveedorEventoState extends State<ProveedorEvento> {
  ProveedoreventosBloc proveedoreventosBloc;

  List<ItemProveedorEvento> _dataPrvEv = [];

  ItemModelProveedoresEvent provEvet;
  SharedPreferencesT _sharedPreferences = new SharedPreferencesT();
  var checkInvolucrado;
  // plan a
  List<Servicios> servicio = [];
  // plan b
  Map servicios = Map();

  // logic
  FetchProveedoresEventoLogic proveedoresEventoLogic =
      FetchProveedoresEventoLogic();

  void getValues() async {
    final idInvolucrado = await _sharedPreferences.getIdInvolucrado();
    setState(() {
      checkInvolucrado = idInvolucrado;
    });
  }

  @override
  void initState() {
    proveedoreventosBloc = BlocProvider.of<ProveedoreventosBloc>(context);
    proveedoreventosBloc.add(FechtProveedorEventosEvent());
    super.initState();
    getValues();
  }

  @override
  Widget build(BuildContext context) {
    if (checkInvolucrado == null) {
      return Scaffold(
        body: RefreshIndicator(
          color: Colors.blue,
          onRefresh: () async {
            await proveedoreventosBloc.add(FechtProveedorEventosEvent());
          },
          child: SingleChildScrollView(
            controller: ScrollController(),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(15),
              child: BlocBuilder<ProveedoreventosBloc, ProveedoreventosState>(
                  builder: (context, state) {
                if (state is MostrarProveedorEventoState) {
                  if (state.detlistas != null && _dataPrvEv.length == 0) {
                    state.detlistas.results.forEach((element) {});
                    _dataPrvEv = _createDataListProvEvt(state.detlistas);
                  }
                  return Column(
                    children: [
                      _listaBuild(),
                      SizedBox(
                        height: 50.0,
                      )
                    ],
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: UniqueKey(),
          child: Icon(Icons.download),
          onPressed: () async {
            final data =
                await proveedoresEventoLogic.downloadPDFProveedoresEvento();
            if (data != null) {
              downloadFile(data, 'Proveedores-Evento');
            }
          },
          tooltip: 'Descargar PDF',
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Proveedores'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(15),
            child: BlocBuilder<ProveedoreventosBloc, ProveedoreventosState>(
                builder: (context, state) {
              if (state is MostrarProveedorEventoState) {
                if (state.detlistas != null && _dataPrvEv.length == 0) {
                  state.detlistas.results.forEach((element) {});
                  _dataPrvEv = _createDataListProvEvt(state.detlistas);
                }
                return Column(
                  children: [
                    _listaInvolucrado(),
                    SizedBox(
                      height: 50.0,
                    )
                  ],
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: UniqueKey(),
          child: Icon(Icons.download),
          onPressed: () async {
            final data =
                await proveedoresEventoLogic.downloadPDFProveedoresEvento();
            if (data != null) {
              downloadFile(data, 'Proveedores-Evento');
            }
          },
          tooltip: 'Descargar PDF',
        ),
      );
    }
  }

  Widget _listaBuild() {
    return Container(
        child: ExpansionPanelList(
      animationDuration: Duration(milliseconds: 500),
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _dataPrvEv[index].isExpanded = !isExpanded;
        });
      },
      children: _dataPrvEv.map<ExpansionPanel>((ItemProveedorEvento item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(item.nombre),
              trailing: Wrap(spacing: 12, children: <Widget>[]),
            );
          },
          body: Column(children: _listServicio(item.prov, item.id_servicio)),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    ));
  }

  _createDataListProvEvt(ItemModelProveedoresEvento prov) {
    List<ItemProveedorEvento> _dataProv = [];
    prov.results.forEach((element) {
      List<ItemProveedor> _provTemp = [];

      servicios[element.idServicio] = 0;

      if (element.prov.length > 0) {
        element.prov.forEach((element2) {
          _provTemp.add(ItemProveedor(
              id_proveedor: element2['id_proveedor'],
              nombre: element2['nombre'],
              descripcion: element2['descripcion'],
              isExpanded: element2['check'],
              seleccion: element2['seleccionado'],
              observacion: element2['observacion']));

          if (element2['seleccionado']) {
            servicios[element.idServicio] = element2['id_proveedor'];
          }

          // if(checkInvolucrado != null) {
          //   if(element2['check']) {
          //     if(element2['seleccionado']) {
          //       servicios[element.idServicio] = element2['id_proveedor'];
          //     }
          //   }
          // }
        });
      }

      _dataProv.add(ItemProveedorEvento(
          id_servicio: element.idServicio,
          id_planner: element.idPlanner,
          nombre: element.nombre,
          prov: _provTemp,
          isExpanded: false,
          seleccion: element.seleccion,
          observacion: element.observacion));
    });
    return _dataProv;
  }

  List<Widget> _listServicio(List<ItemProveedor> itemServicio, int idServi) {
    List<Widget> lista = [];
    for (var opt in itemServicio) {
      final tempWidget = ListTile(
          title: Text(opt.nombre),
          subtitle: Text(opt.descripcion),
          trailing: Wrap(
            spacing: 12,
            children: <Widget>[
              SizedBox(),
              IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed('/agregarArchivo', arguments: {
                      'id_proveedor': opt.id_proveedor,
                      'id_servicio': idServi,
                      'nombre': opt.nombre,
                      'type': 0,
                      'prvEv': 0,
                      'isEvento': true,
                    });
                  },
                  icon: Icon(Icons.file_present)),
              opt.seleccion
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Seleccionado'),
                    )
                  : SizedBox(),
              opt.seleccion
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Observaciones: ${opt.observacion}'),
                    )
                  : SizedBox(),
              Checkbox(
                checkColor: Colors.black,
                value: opt.isExpanded,
                onChanged: !opt.seleccion
                    ? (value) {
                        setState(() {
                          opt.isExpanded = value;
                        });
                        Map<String, dynamic> json = {
                          'id_servicio': idServi,
                          'id_proveedor': opt.id_proveedor
                        };
                        if (opt.isExpanded) {
                          proveedoreventosBloc
                              .add(CreateProveedorEventosEvent(json));
                        } else if (!opt.isExpanded) {
                          proveedoreventosBloc
                              .add(DeleteProveedorEventosEvent(json));
                        }
                      }
                    : null,
              ),
            ],
          ));
      lista.add(tempWidget);
    }
    return lista;
  }

  insert(opt) {
    proveedoreventosBloc.add(CreateProveedorEventosEvent(
        {'id_servicio': opt.id_servicio, 'id_proveedor': opt.id_proveedor}));
  }

  // involucrados

  Widget _listaInvolucrado() {
    return Container(
        child: ExpansionPanelList(
      animationDuration: Duration(milliseconds: 500),
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _dataPrvEv[index].isExpanded = !isExpanded;
        });
      },
      children: _dataPrvEv.map<ExpansionPanel>((ItemProveedorEvento item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(item.nombre),
              trailing: Wrap(spacing: 12, children: <Widget>[]),
            );
          },
          body: Column(
            children: _listServicioInvolucrado(
                item.prov, item.id_servicio, servicios),
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    ));
  }

  List<Widget> _listServicioInvolucrado(
      List<ItemProveedor> itemServicio, int idServi, Map servicios) {
    List<Widget> lista = [];
    for (var opt in itemServicio) {
      if (opt.isExpanded) {
        final tempWidget = ListTile(
            title: Row(
              children: [
                Expanded(child: Text(opt.nombre)),
                Expanded(
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed('/agregarArchivo', arguments: {
                          'id_proveedor': opt.id_proveedor,
                          'id_servicio': idServi,
                          'nombre': opt.nombre,
                          'type': 1,
                          'prvEv': 2,
                          'isEvento': true,
                        });
                      },
                      icon: const Icon(Icons.file_present)),
                ),
              ],
            ),
            subtitle: Text(opt.descripcion),
            trailing: Wrap(
              spacing: 12,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Seleccionar: '),
                ),
                Radio(
                  value: opt.id_proveedor,
                  groupValue: servicios[idServi],
                  onChanged: (value) async {
                    setState(() {
                      servicios[idServi] = value;
                    });
                    Map data = {
                      'id_proveedor': opt.id_proveedor.toString(),
                      'id_servicio': idServi.toString()
                    };
                    await proveedoreventosBloc
                        .add(UpdateProveedorEventosEvent(data));
                    proveedoreventosBloc.add(FechtProveedorEventosEvent());
                  },
                ),
                servicios[idServi] == opt.id_proveedor
                    ? Container(
                        width: 250.0,
                        child: TextFormField(
                          controller: opt.observacion != null
                              ? TextEditingController(
                                  text: '${opt.observacion}')
                              : TextEditingController(),
                          decoration:
                              InputDecoration(hintText: 'Observaciones: '),
                          onChanged: (value) async {
                            opt.observacion = value;
                            Map data = {
                              'id_proveedor': opt.id_proveedor.toString(),
                              'id_servicio': idServi.toString(),
                              'observacion': opt.observacion
                            };
                            await proveedoreventosBloc
                                .add(UpdateProveedorEventosEvent(data));
                            proveedoreventosBloc
                                .add(FechtProveedorEventosEvent());
                          },
                        ),
                      )
                    : SizedBox()
              ],
            ));
        lista.add(tempWidget);
      }
    }
    if (lista.isEmpty) {
      lista.add(Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text('Sin datos.'),
        ),
      ));
    }
    lista.add(SizedBox(
      height: 20.0,
    ));
    return lista;
  }
}

class Servicios {
  int id;
  int radio;

  Servicios({this.id, this.radio});
}

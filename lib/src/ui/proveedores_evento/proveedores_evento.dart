import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/blocs/proveedorEvento/proveedoreventos_bloc.dart';
import 'package:planning/src/logic/proveedores_evento_logic.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/models/item_model_proveedores.dart';
import 'package:planning/src/models/item_model_proveedores_evento.dart';
import 'package:planning/src/utils/utils.dart';

class ProveedorEvento extends StatefulWidget {
  const ProveedorEvento({Key key}) : super(key: key);
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => const ProveedorEvento(),
      );
  @override
  _ProveedorEventoState createState() => _ProveedorEventoState();
}

class _ProveedorEventoState extends State<ProveedorEvento> {
  ProveedoreventosBloc proveedoreventosBloc;

  List<ItemProveedorEvento> _dataPrvEv = [];

  ItemModelProveedoresEvent provEvet;
  final SharedPreferencesT _sharedPreferences = SharedPreferencesT();
  Size size;
  // plan a
  List<Servicios> servicio = [];
  // plan b
  Map servicios = {};

  String claveRol;

  bool isInit = true;

  // logic
  FetchProveedoresEventoLogic proveedoresEventoLogic =
      FetchProveedoresEventoLogic();

  void getValues() async {
    claveRol = await _sharedPreferences.getClaveRol();
    setState(() {});
  }

  @override
  void initState() {
    getValues();
    proveedoreventosBloc = BlocProvider.of<ProveedoreventosBloc>(context);
    proveedoreventosBloc.add(FechtProveedorEventosEvent());

    super.initState();
  }

  @override
  void dispose() {
    proveedoreventosBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    if (claveRol != 'INVO') {
      return Scaffold(
        body: RefreshIndicator(
          color: Colors.blue,
          onRefresh: () async {
            proveedoreventosBloc.add(FechtProveedorEventosEvent());
          },
          child: SingleChildScrollView(
            controller: ScrollController(),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              child: BlocBuilder<ProveedoreventosBloc, ProveedoreventosState>(
                  builder: (context, state) {
                if (state is MostrarProveedorEventoState) {
                  if (state.detlistas != null && _dataPrvEv.isEmpty) {
                    _dataPrvEv = _createDataListProvEvt(state.detlistas);
                  }
                  return Column(
                    children: [
                      _listaBuild(),
                      const SizedBox(
                        height: 50.0,
                      )
                    ],
                  );
                } else {
                  return const Center(child: LoadingCustom());
                }
              }),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: UniqueKey(),
          child: const Icon(Icons.download),
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
          title: const Text('Proveedores'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            child: BlocBuilder<ProveedoreventosBloc, ProveedoreventosState>(
                builder: (context, state) {
              if (state is MostrarProveedorEventoState) {
                if (state.detlistas != null && _dataPrvEv.isEmpty) {
                  _dataPrvEv = _createDataListProvEvt(state.detlistas);
                }
                return Column(
                  children: [
                    _listaInvolucrado(),
                    const SizedBox(
                      height: 50.0,
                    )
                  ],
                );
              } else {
                return const Center(child: LoadingCustom());
              }
            }),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: UniqueKey(),
          child: const Icon(Icons.download),
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
    return ExpansionPanelList(
      animationDuration: const Duration(milliseconds: 500),
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
              trailing: Wrap(spacing: 12, children: const <Widget>[]),
            );
          },
          body: Column(children: _listServicio(item.prov, item.idServicio)),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }

  _createDataListProvEvt(ItemModelProveedoresEvento prov) {
    List<ItemProveedorEvento> _dataProv = [];
    for (var element in prov.results) {
      List<ItemProveedor> _provTemp = [];

      servicios[element.idServicio] = 0;

      if (element.prov.isNotEmpty) {
        for (var element2 in element.prov) {
          _provTemp.add(ItemProveedor(
              idProveedor: element2['id_proveedor'],
              nombre: element2['nombre'],
              descripcion: element2['descripcion'],
              isExpanded: element2['check'],
              seleccion: element2['seleccionado'],
              observacion: element2['observacion']));

          if (element2['seleccionado']) {
            servicios[element.idServicio] = element2['id_proveedor'];
          }
        }
      }

      _dataProv.add(ItemProveedorEvento(
          idServicio: element.idServicio,
          idPlanner: element.idPlanner,
          nombre: element.nombre,
          prov: _provTemp,
          isExpanded: false,
          seleccion: element.seleccion,
          observacion: element.observacion));
    }
    return _dataProv;
  }

  List<Widget> _listServicio(List<ItemProveedor> itemServicio, int idServi) {
    List<Widget> lista = [];
    for (var opt in itemServicio) {
      final tempWidget = (size.width > 500)
          ? ListTile(
              title: Text(opt.nombre),
              subtitle: Text(opt.descripcion),
              trailing: itemsProveedorWidgets(opt, idServi))
          : Card(
              elevation: 4.0,
              child: ExpansionTile(
                title: Text(
                  opt.nombre,
                  style: const TextStyle(color: Colors.black),
                ),
                subtitle: Text(
                  opt.descripcion,
                  style: const TextStyle(color: Colors.black),
                ),
                children: [
                  itemsProveedorWidgets(opt, idServi),
                ],
              ),
            );
      lista.add(tempWidget);
    }
    return lista;
  }

  Wrap itemsProveedorWidgets(ItemProveedor opt, int idServi) {
    return Wrap(
      spacing: 12,
      children: <Widget>[
        const SizedBox(),
        IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/agregarArchivo', arguments: {
                'id_proveedor': opt.idProveedor,
                'id_servicio': idServi,
                'nombre': opt.nombre,
                'type': 0,
                'prvEv': 0,
                'isEvento': true,
              });
            },
            icon: const Icon(Icons.file_present)),
        if (opt.seleccion)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Seleccionado'),
          ),
        if (opt.seleccion)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: opt.observacion != null
                ? Text('Observaciones: ${opt.observacion}')
                : null,
          ),
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
                    'id_proveedor': opt.idProveedor
                  };
                  if (opt.isExpanded) {
                    proveedoreventosBloc.add(CreateProveedorEventosEvent(json));
                  } else if (!opt.isExpanded) {
                    proveedoreventosBloc.add(DeleteProveedorEventosEvent(json));
                  }
                }
              : null,
        ),
      ],
    );
  }

  insert(opt) {
    proveedoreventosBloc.add(CreateProveedorEventosEvent(
        {'id_servicio': opt.idServicio, 'id_proveedor': opt.idProveedor}));
  }

  // involucrados

  Widget _listaInvolucrado() {
    return ExpansionPanelList(
      animationDuration: const Duration(milliseconds: 500),
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
              trailing: Wrap(spacing: 12, children: const <Widget>[]),
            );
          },
          body: Column(
            children:
                _listServicioInvolucrado(item.prov, item.idServicio, servicios),
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }

  List<Widget> _listServicioInvolucrado(
      List<ItemProveedor> itemServicio, int idServi, Map servicios) {
    List<Widget> lista = [];
    for (var opt in itemServicio) {
      if (opt.isExpanded) {
        TextEditingController textEditController = opt.observacion != null
            ? TextEditingController(text: opt.observacion)
            : TextEditingController();
        final tempWidget = ListTile(
            title: Row(
              children: [
                Expanded(child: Text(opt.nombre)),
                Expanded(
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed('/agregarArchivo', arguments: {
                          'id_proveedor': opt.idProveedor,
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
                servicios[idServi] == opt.idProveedor
                    ? SizedBox(
                        width: 250.0,
                        child: TextFormField(
                          controller: textEditController,
                          decoration: const InputDecoration(
                              hintText: 'Observaciones: '),
                          onChanged: (value) async {
                            opt.observacion = value;
                            Map data = {
                              'id_proveedor': opt.idProveedor.toString(),
                              'id_servicio': idServi.toString(),
                              'observacion': opt.observacion
                            };
                            proveedoreventosBloc
                                .add(UpdateProveedorEventosEvent(data));
                          },
                        ),
                      )
                    : const SizedBox(),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Seleccionar: '),
                ),
                Radio(
                  value: opt.idProveedor,
                  groupValue: servicios[idServi],
                  onChanged: (value) async {
                    setState(() {
                      opt.observacion = null;
                      servicios[idServi] = value;
                    });
                    Map data = {
                      'id_proveedor': opt.idProveedor.toString(),
                      'id_servicio': idServi.toString()
                    };
                    proveedoreventosBloc.add(UpdateProveedorEventosEvent(data));
                  },
                ),
              ],
            ));
        lista.add(tempWidget);
      }
    }
    if (lista.isEmpty) {
      lista.add(const Center(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Text('Sin datos'),
        ),
      ));
    }
    lista.add(const SizedBox(
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

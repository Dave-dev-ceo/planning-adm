import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/blocs/servicios/bloc/servicios_bloc_dart_bloc.dart';
import 'package:planning/src/logic/proveedores_logic.dart';
import 'package:planning/src/ui/widgets/FullScreenDialog/full_screen_dialog_agregar_proveedor.dart';
import 'package:planning/src/ui/widgets/editProveedorDialog/edit_proveedor_dialog.dart';
import 'package:planning/src/ui/widgets/text_form_filed/text_form_filed.dart';
import 'package:planning/src/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:planning/src/blocs/proveedores/proveedor_bloc.dart';
import 'package:planning/src/models/item_model_proveedores.dart';
import 'package:planning/src/models/item_model_servicios.dart';
import 'package:planning/src/ui/proveedores/servicios.dart';

class Proveedores extends StatefulWidget {
  const Proveedores({Key key}) : super(key: key);
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => const Proveedores(),
      );
  @override
  State<Proveedores> createState() => _ProveedoresState();
}

class _ProveedoresState extends State<Proveedores> {
  ProveedorBloc proveedorBloc;
  ItemModelProveedores itemModelProv;
  FetchProveedoresLogic proveedoresLogic = FetchProveedoresLogic();

  // List<ItemProveedor> _data = [];
  List<ServiciosModel> _data = [];
  List<ItemProveedor> _dataProveedores;

  Future<List<Territorio>> peticionPaises;
  Future<List<Territorio>> peticionEstados;
  Future<List<Territorio>> peticionCiudades;
  int idPais;
  int idEstado;
  int idCiudad;

  @override
  void initState() {
    proveedorBloc = BlocProvider.of<ProveedorBloc>(context);
    proveedorBloc.add(FechtProveedorEvent());
    proveedorBloc.add(FechtSevicioByProveedorEvent());
    peticionPaises = getPaises();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        color: Colors.blue,
        onRefresh: () async {
          proveedorBloc.add(FechtProveedorEvent());
          proveedorBloc.add(FechtSevicioByProveedorEvent());
        },
        child: IndexedStack(
          index: _selectedIndex,
          children: [_listaProveedore(), const Servicios()],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: expasionFabButton(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.attribution),
            label: 'Proveedores',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sell),
            label: 'Servicios',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget expasionFabButton() {
    return SpeedDial(
      tooltip: 'Opciones',
      child: const Icon(Icons.more_vert),
      children: [
        SpeedDialChild(
          child: const Icon(Icons.download),
          label: 'Descargar PDF',
          onTap: () async {
            final data = await proveedoresLogic.downloadPDFProveedor();
            if (data != null) {
              downloadFile(data, 'Proveedores');
            }
          },
        ),
        if (_selectedIndex == 0)
          SpeedDialChild(
            child: const Icon(Icons.add),
            label: 'Añadir proveedor',
            onTap: () async {
              Navigator.of(context).pushNamed('/agregarProveedores',
                  arguments: {
                    'id_lista': null,
                    'nombre': '',
                    'descripcion': ''
                  });
            },
          ),
      ],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int _selectedIndex = 0;

  Widget _listaProveedore() {
    return SingleChildScrollView(
      controller: ScrollController(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<ProveedorBloc, ProveedorState>(
            builder: (context, state) {
          if (state is MostrarSevicioByProveedorState) {
            _data = _createDataListServ(state.detlistas);
            if (_dataProveedores != null && _data != null) {
              for (var prov in _dataProveedores) {
                List<ServiciosModel> _listaServ = [];
                List<ItemProveedor> _prove = [];

                for (var elmProv in _data) {
                  if (elmProv.idServicio == prov.idServicio) {
                    _listaServ.add(ServiciosModel(
                      idServicio: elmProv.idServicio,
                      nombre: elmProv.nombre,
                      proveedores: _prove,
                    ));
                  }
                  prov.servicio = _listaServ;
                }
              }

              for (var elmProv in _data) {
                List<ItemProveedor> listaProv = [];
                for (var prov in _dataProveedores) {
                  if (elmProv.idServicio == prov.idServicio) {
                    if ((idPais == null || prov.idPais == idPais) &&
                        (idEstado == null || prov.idEstado == idEstado) &&
                        (idCiudad == null || prov.idCiudad == idCiudad)) {
                      listaProv.add(ItemProveedor(
                        idProveedor: prov.idProveedor,
                        nombre: prov.nombre,
                        descripcion: prov.descripcion,
                        estatus: prov.estatus,
                        correo: prov.correo,
                        direccion: prov.direccion,
                        telefono: prov.telefono,
                        servicio: prov.servicio,
                        idCiudad: prov.idCiudad,
                        idEstado: prov.idEstado,
                        idPais: prov.idPais,
                      ));
                    }
                  }

                  elmProv.proveedores = listaProv;
                }
              }
            }
            final size = MediaQuery.of(context).size.width < 520
                ? MediaQuery.of(context).size.width
                : 520;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    TextFormFields(
                      icon: Icons.flag,
                      item: FutureBuilder(
                        future: peticionPaises,
                        builder: (context,
                            AsyncSnapshot<List<Territorio>> snapshot) {
                          if (snapshot.hasData) {
                            final paises = snapshot.data;
                            return DropdownButtonFormField<int>(
                              isExpanded: true,
                              onChanged: (value) => setState(() {
                                if (idPais != value) idEstado = null;
                                idPais = value;
                                peticionEstados = getEstados(value);
                              }),
                              value: idPais,
                              decoration:
                                  const InputDecoration(label: Text('País')),
                              items: paises
                                  .map((p) => DropdownMenuItem<int>(
                                        child: Text(p.nombre),
                                        value: p.id,
                                      ))
                                  .toList(),
                            );
                          }

                          return const LinearProgressIndicator();
                        },
                      ),
                      large: size.toDouble(),
                      ancho: 80.0.toDouble(),
                    ),
                    if (idPais != null)
                      TextFormFields(
                        icon: Icons.map,
                        item: FutureBuilder(
                          future: peticionEstados,
                          builder: (context,
                              AsyncSnapshot<List<Territorio>> snapshot) {
                            if (snapshot.hasData) {
                              final estados = snapshot.data;
                              return DropdownButtonFormField<int>(
                                isExpanded: true,
                                value: idEstado,
                                onChanged: (value) => setState(() {
                                  if (idEstado != value) idCiudad = null;
                                  idEstado = value;
                                  peticionCiudades = getCiudades(value);
                                }),
                                decoration: const InputDecoration(
                                    label: Text('Estado')),
                                items: estados
                                    .map((e) => DropdownMenuItem(
                                          child: Text(e.nombre),
                                          value: e.id,
                                        ))
                                    .toList(),
                              );
                            }
                            return const LinearProgressIndicator();
                          },
                        ),
                        large: size.toDouble(),
                        ancho: 80.0.toDouble(),
                      ),
                    if (idEstado != null)
                      TextFormFields(
                        icon: Icons.location_city,
                        item: FutureBuilder(
                          future: peticionCiudades,
                          builder: (context,
                              AsyncSnapshot<List<Territorio>> snapshot) {
                            if (snapshot.hasData) {
                              final ciudades = snapshot.data;
                              return DropdownButtonFormField<int>(
                                isExpanded: true,
                                value: idCiudad,
                                onChanged: (value) => setState(() {
                                  idCiudad = value;
                                }),
                                decoration: const InputDecoration(
                                    label: Text('Ciudad')),
                                items: ciudades
                                    .map((c) => DropdownMenuItem(
                                          child: Text(c.nombre),
                                          value: c.id,
                                        ))
                                    .toList(),
                              );
                            }
                            return const LinearProgressIndicator();
                          },
                        ),
                        large: size.toDouble(),
                        ancho: 80.0.toDouble(),
                      ),
                    if (idPais != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          tooltip: 'Limpiar Filtros',
                          onPressed: () => setState(() {
                            idPais = null;
                            idEstado = null;
                            idCiudad = null;
                          }),
                          icon: const Icon(Icons.clear_all),
                        ),
                      )
                  ],
                ),
                _listaBuild(),
                const SizedBox(
                  height: 50.0,
                )
              ],
            );
          } else if (state is MostrarProveedorState) {
            _dataProveedores = _createDataListProv(state.detlistas);
            return const Text('');
          } else {
            return const Center(child: LoadingCustom());
          }
        }),
      ),
    );
  }

  Widget _listaBuild() {
    return Flexible(
        child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            // animationDuration: Duration(milliseconds: 500),
            children: _data
                .where((s) =>
                    (idPais == null ||
                        s.proveedores.any((p) => p.idPais == idPais)) &&
                    (idEstado == null ||
                        s.proveedores.any((p) => p.idEstado == idEstado)) &&
                    (idCiudad == null ||
                        s.proveedores.any((p) => p.idCiudad == idCiudad)))
                .map<Card>((ServiciosModel item) {
              return Card(
                child: ExpansionTile(
                  title: Text(item.nombre,
                      style: const TextStyle(
                        color: Colors.black,
                      )),
                  children: _listServicio(
                      item.proveedores, item.idProveedor, item.idServicio),
                ),
              );
            }).toList()));
  }

  List<Widget> _listServicio(
      List<ItemProveedor> itemServicio, int idProveedor, int idServicio) {
    List<Widget> lista = [];
    for (var opt in itemServicio) {
      final tempWidget = ListTile(
        leading: IconButton(
          tooltip: 'Editar',
          icon: const Icon(
            Icons.edit,
            size: 14.0,
            color: Colors.black,
          ),
          onPressed: () async {
            await showDialog(
                context: context,
                builder: (context) => EditProveedorDialog(
                      proveedor: opt,
                    )).then((_) => BlocProvider.of<ServiciosBloc>(context)
                .add(FechtServiciosEvent()));
          },
        ),
        title: Text(opt.nombre,
            style: const TextStyle(
              color: Colors.black,
            )),
        trailing: Wrap(spacing: 12, children: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                '/agregarArchivo',
                arguments: {
                  'id_proveedor': opt.idProveedor,
                  'id_servicio': idServicio,
                  'nombre': opt.nombre,
                  'type': 0,
                  'prvEv': 2,
                  'isEvento': false,
                },
              );
            },
            icon: const Icon(Icons.file_present, color: Colors.black),
          ),
          IconButton(
              onPressed: () {
                showDialog<void>(
                    context: context,
                    builder: (BuildContext context) =>
                        _eliminarDetalleLista(opt));
              },
              icon: const Icon(Icons.delete, color: Colors.black)),
        ]),
      );
      lista.add(tempWidget);
    }
    return lista;
  }

  _createDataListServ(ItemModelServicioByProv serv) {
    List<ServiciosModel> _listaServ = [];
    List<ItemProveedor> dataProv = [];
    for (var element in serv.results) {
      _listaServ.add(ServiciosModel(
        idServicio: element.idServicio,
        idProveedor: element.idProveedor,
        isExpanded: false,
        nombre: element.nombre,
        proveedores: dataProv,
      ));
    }
    return _listaServ;
  }

  _createDataListProv(ItemModelProveedores prov) {
    List<ItemProveedor> _dataProv = [];
    List<ServiciosModel> listaServ = [];
    for (var element in prov.results) {
      _dataProv.add(ItemProveedor(
        idProveedor: element.idProveedor,
        idServicio: element.idServicio,
        nombre: element.nombre,
        descripcion: element.descripcion,
        servicio: listaServ,
        isExpanded: false,
        estatus: element.estatus,
        correo: element.correo,
        direccion: element.direccion,
        telefono: element.telefono,
        idCiudad: element.idCiudad,
        idEstado: element.idEstado,
        idPais: element.idPais,
      ));
    }
    return _dataProv;
  }

  _eliminarDetalleLista(ItemProveedor proveedor) {
    return AlertDialog(
      title: const Text('Eliminar'),
      content: const Text('¿Desea eliminar el elemento?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancelar'),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () async {
            proveedor.estatus = 'I';
            proveedorBloc.add(UpdateProveedor(proveedor));
            Navigator.pop(context, 'Aceptar');
          },
          child: const Text('Aceptar'),
        ),
      ],
    );
  }
}

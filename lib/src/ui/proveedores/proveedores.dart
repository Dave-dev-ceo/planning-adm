import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/logic/proveedores_logic.dart';
import 'package:planning/src/ui/widgets/editProveedorDialog/edit_proveedor_dialog.dart';
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
        builder: (context) => Proveedores(),
      );
  @override
  _ProveedoresState createState() => _ProveedoresState();
}

class _ProveedoresState extends State<Proveedores> {
  ProveedorBloc proveedorBloc;
  ItemModelProveedores itemModelProv;
  FetchProveedoresLogic proveedoresLogic = FetchProveedoresLogic();

  // List<ItemProveedor> _data = [];
  List<ServiciosModel> _data = [];
  List<ItemProveedor> _dataProveedores;

  @override
  void initState() {
    proveedorBloc = BlocProvider.of<ProveedorBloc>(context);
    proveedorBloc.add(FechtProveedorEvent());
    proveedorBloc.add(FechtSevicioByProveedorEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        color: Colors.blue,
        onRefresh: () async {
          await proveedorBloc.add(FechtProveedorEvent());
          await proveedorBloc.add(FechtSevicioByProveedorEvent());
        },
        child: Container(
            child: IndexedStack(
          index: _selectedIndex,
          children: [_listaProveedore(), Servicios()],
        )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: expasionFabButton(),
      /* FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          Navigator.of(context).pushNamed('/agregarProveedores',
              arguments: {'id_lista': null, 'nombre': '', 'descripcion': ''});
        }, 
      ),*/
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
      child: Icon(Icons.more_vert),
      children: [
        SpeedDialChild(
          child: Icon(Icons.download),
          label: 'Descargar PDF',
          onTap: () async {
            final data = await proveedoresLogic.downloadPDFProveedor();
            if (data != null) {
              await downloadFile(data, 'Proveedores');
            }
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.add),
          label: 'Añadir proveedor',
          onTap: () async {
            Navigator.of(context).pushNamed('/agregarProveedores',
                arguments: {'id_lista': null, 'nombre': '', 'descripcion': ''});
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
        padding: EdgeInsets.all(15),
        child: BlocBuilder<ProveedorBloc, ProveedorState>(
            builder: (context, state) {
          if (state is MostrarSevicioByProveedorState) {
            _data = _createDataListServ(state.detlistas);
            if (_dataProveedores != null && _data != null) {
              _dataProveedores.forEach((prov) {
                List<ServiciosModel> _listaServ = [];
                List<ItemProveedor> _prove = [];

                _data.forEach((elmProv) {
                  if (elmProv.id_servicio == prov.id_servicio) {
                    _listaServ.add(ServiciosModel(
                        id_servicio: elmProv.id_servicio,
                        nombre: elmProv.nombre,
                        proveedores: _prove));
                  }
                  prov.servicio = _listaServ;
                });
              });

              _data.forEach((elmProv) {
                List<ItemProveedor> listaProv = [];
                _dataProveedores.forEach((prov) {
                  if (elmProv.id_servicio == prov.id_servicio) {
                    listaProv.add(ItemProveedor(
                        id_proveedor: prov.id_proveedor,
                        nombre: prov.nombre,
                        descripcion: prov.descripcion,
                        estatus: prov.estatus,
                        correo: prov.correo,
                        direccion: prov.direccion,
                        telefono: prov.telefono,
                        servicio: prov.servicio));
                  }

                  elmProv.proveedores = listaProv;
                });
              });
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _listaBuild(),
                SizedBox(
                  height: 50.0,
                )
              ],
            );
          } else if (state is MostrarProveedorState) {
            _dataProveedores = _createDataListProv(state.detlistas);
            return Text('');
          } else {
            return Center(child: LoadingCustom());
          }
        }),
      ),
    );
  }

  Widget _listaBuild() {
    return Flexible(
        child: ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            // animationDuration: Duration(milliseconds: 500),
            children: _data.map<Card>((ServiciosModel item) {
              return Card(
                child: ExpansionTile(
                    title: Text(item.nombre,
                        style: TextStyle(
                          color: Colors.black,
                        )),
                    children:
                        _listServicio(item.proveedores, item.id_proveedor),
                    trailing: Wrap(
                      spacing: 12,
                      children: <Widget>[
                        IconButton(
                            onPressed: () {
                              showDialog<void>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      _eliminarDetalleLista(
                                          item.id_servicio, item.id_proveedor));
                            },
                            icon:
                                const Icon(Icons.delete, color: Colors.black)),
                        IconButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed('/agregarArchivo', arguments: {
                                'id_proveedor': item.id_proveedor,
                                'id_servicio': item.id_servicio,
                                'nombre': item.nombre,
                                'type': 0,
                                'prvEv': 2,
                                'isEvento': false,
                              });
                            },
                            icon: const Icon(Icons.file_present,
                                color: Colors.black))
                      ],
                    )),
              );
            }).toList()));
  }

  List<Widget> _listServicio(itemServicio, id_proveedor) {
    List<Widget> lista = [];
    for (var opt in itemServicio) {
      final tempWidget = ListTile(
        leading: IconButton(
          tooltip: 'Editar',
          icon: Icon(
            Icons.edit,
            size: 14.0,
            color: Colors.black,
          ),
          onPressed: () async {
            showDialog(
                context: context,
                builder: (context) => EditProveedorDialog(
                      proveedor: opt,
                    ));
          },
        ),
        title: Text(opt.nombre,
            style: TextStyle(
              color: Colors.black,
            )),
        trailing: Wrap(spacing: 12, children: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                '/agregarArchivo',
                arguments: {
                  'id_proveedor': opt.id_proveedor,
                  'id_servicio': null,
                  'nombre': opt.nombre,
                  'type': 0,
                  'prvEv': 2,
                  'isEvento': false,
                },
              );
            },
            icon: const Icon(Icons.file_present, color: Colors.black),
          ),
        ]),
      );
      lista.add(tempWidget);
    }
    return lista;
  }

  _createDataListServ(ItemModelServicioByProv serv) {
    List<ServiciosModel> _listaServ = [];
    List<ItemProveedor> dataProv = [];
    serv.results.forEach((element) {
      _listaServ.add(ServiciosModel(
          id_servicio: element.id_servicio,
          id_proveedor: element.id_proveedor,
          isExpanded: false,
          nombre: element.nombre,
          proveedores: dataProv));
    });
    return _listaServ;
  }

  _createDataListProv(ItemModelProveedores prov) {
    List<ItemProveedor> _dataProv = [];
    List<ServiciosModel> listaServ = [];
    prov.results.forEach((element) {
      _dataProv.add(ItemProveedor(
        id_proveedor: element.id_proveedor,
        id_servicio: element.id_servicio,
        nombre: element.nombre,
        descripcion: element.descripcion,
        servicio: listaServ,
        isExpanded: false,
        estatus: element.estatus,
        correo: element.correo,
        direccion: element.direccion,
        telefono: element.telefono,
      ));
    });
    return _dataProv;
  }

  _eliminarDetalleLista(int idServ, int idProveedor) {
    return AlertDialog(
      title: const Text('Eliminar'),
      content: const Text('¿Desea eliminar el elemento?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancelar'),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => {
            proveedorBloc.add(DeleteServicioProvEvent(idServ, idProveedor)),
            Navigator.pop(context, 'Aceptar')
          },
          child: const Text('Aceptar'),
        ),
      ],
    );
  }
}

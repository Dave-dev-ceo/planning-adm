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

  List<ItemProveedor> _data = [];

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
      child: Icon(Icons.more_vert_outlined),
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
          if (state is MostrarProveedorState) {
            if (state.detlistas != null) {
              _data = _createDataListProv(state.detlistas);
            }
            return Text('');
          } else if (state is MostrarSevicioByProveedorState) {
            if (_data != null) {
              // List<ServiciosModel> listaServ = [];
              _data.forEach((elmProv) {
                List<ServiciosModel> listaServ = [];
                if (state.detlistas.results.length > 0) {
                  state.detlistas.results.forEach((sev) {
                    if (elmProv.id_proveedor == sev.id_proveedor) {
                      listaServ.add(ServiciosModel(
                          id_servicio: sev.id_servicio, nombre: sev.nombre));
                    }
                    elmProv.servicio = listaServ;
                  });
                }
              });
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
    );
  }

  Widget _listaBuild() {
    return Container(
        child: ExpansionPanelList(
      animationDuration: Duration(milliseconds: 500),
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = !isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((ItemProveedor item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              leading: IconButton(
                tooltip: 'Editar',
                icon: Icon(
                  Icons.edit,
                  size: 14.0,
                ),
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (context) => EditProveedorDialog(
                            proveedor: item,
                          ));
                },
              ),
              title: Text(item.nombre),
              subtitle: Text(item.descripcion),
              trailing: Wrap(spacing: 12, children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      '/agregarArchivo',
                      arguments: {
                        'id_proveedor': item.id_proveedor,
                        'id_servicio': null,
                        'nombre': item.nombre,
                        'type': 0,
                        'prvEv': 2,
                        'isEvento': false,
                      },
                    );
                  },
                  icon: const Icon(Icons.file_present),
                ),
              ]),
            );
          },
          body:
              Column(children: _listServicio(item.servicio, item.id_proveedor)),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    ));
  }

  List<Widget> _listServicio(itemServicio, id_proveedor) {
    List<Widget> lista = [];
    for (var opt in itemServicio) {
      final tempWidget = ListTile(
          title: Text(opt.nombre),
          trailing: Wrap(
            spacing: 12,
            children: <Widget>[
              IconButton(
                  onPressed: () => showDialog<void>(
                      context: context,
                      builder: (BuildContext context) =>
                          _eliminarDetalleLista(opt.id_servicio, id_proveedor)),
                  icon: const Icon(Icons.delete)),
              IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed('/agregarArchivo', arguments: {
                      'id_proveedor': id_proveedor,
                      'id_servicio': opt.id_servicio,
                      'nombre': opt.nombre,
                      'type': 0,
                      'prvEv': 2,
                      'isEvento': false,
                    });
                  },
                  icon: const Icon(Icons.file_present))
            ],
          ));
      lista.add(tempWidget);
    }
    return lista;
  }

  _createDataListProv(ItemModelProveedores prov) {
    List<ItemProveedor> _dataProv = [];
    List<ServiciosModel> listaServ = [];
    prov.results.forEach((element) {
      _dataProv.add(ItemProveedor(
        id_proveedor: element.id_proveedor,
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

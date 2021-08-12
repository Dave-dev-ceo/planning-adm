import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingplanner/src/blocs/proveedores/proveedor_bloc.dart';
import 'package:weddingplanner/src/models/item_model_proveedores.dart';
import 'package:weddingplanner/src/models/item_model_servicios.dart';
import 'package:weddingplanner/src/ui/proveedores/servicios.dart';

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
      body: Container(
          child: IndexedStack(
        index: _selectedIndex,
        children: [_listaProveedore(), Servicios()],
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          Navigator.of(context).pushNamed('/agregarProveedores',
              arguments: {'id_lista': null, 'nombre': '', 'descripcion': ''});
        },
      ),
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int _selectedIndex = 0;

  Widget _listaProveedore() {
    return SingleChildScrollView(
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

            return _listaBuild();
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
              title: Text(item.nombre),
              subtitle: Text(item.descripcion),
              trailing: Wrap(spacing: 12, children: <Widget>[
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/agregarArchivo',
                          arguments: {
                            'id_proveedor': item.id_proveedor,
                            'id_servicio': null,
                            'nombre': item.nombre
                          });
                    },
                    icon: const Icon(Icons.file_present)),
              ]),
            );
          },
          body: Column(children: _listServicio(item.servicio)),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    ));
  }

  List<Widget> _listServicio(itemServicio) {
    List<Widget> lista = new List<Widget>();
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
                          _eliminarDetalleLista(opt.id_servicio)),
                  icon: const Icon(Icons.delete)),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/agregarArchivo',
                        arguments: {
                          'id_proveedor': null,
                          'id_servicio': opt.id_servicio,
                          'nombre': opt.nombre
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
          isExpanded: false));
    });
    return _dataProv;
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = !isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((ItemProveedor item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text('item.headerValue'),
            );
          },
          body: ListTile(
              title: Text('item.expandedValue'),
              subtitle:
                  const Text('To delete this panel, tap the trash can icon'),
              trailing: const Icon(Icons.delete),
              onTap: () {
                setState(() {
                  _data.removeWhere(
                      (ItemProveedor currentItem) => item == currentItem);
                });
              }),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }

  _eliminarDetalleLista(int idServ) {
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
            proveedorBloc.add(DeleteServicioProvEvent(idServ)),
            Navigator.pop(context, 'Aceptar')
          },
          child: const Text('Aceptar'),
        ),
      ],
    );
  }

  _editarDetalleLista() {}
}

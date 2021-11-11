import 'package:universal_html/html.dart' as html hide Text;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:responsive_grid/responsive_grid.dart';
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
          onTap: () async {},
        ),
        SpeedDialChild(
          child: Icon(Icons.add),
          label: 'Añadir Proveedor',
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
              leading: IconButton(
                tooltip: 'Info',
                icon: Icon(
                  Icons.info,
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
                    Navigator.of(context)
                        .pushNamed('/agregarArchivo', arguments: {
                      'id_proveedor': item.id_proveedor,
                      'id_servicio': null,
                      'nombre': item.nombre,
                      'type': 0
                    });
                  },
                  icon: const Icon(Icons.file_present),
                ),
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
                    Navigator.of(context)
                        .pushNamed('/agregarArchivo', arguments: {
                      'id_proveedor': null,
                      'id_servicio': opt.id_servicio,
                      'nombre': opt.nombre,
                      'type': 0
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
      ));
    });
    return _dataProv;
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

class EditProveedorDialog extends StatefulWidget {
  final ItemProveedor proveedor;
  EditProveedorDialog({Key key, this.proveedor}) : super(key: key);

  @override
  _EditProveedorDialogState createState() => _EditProveedorDialogState();
}

class _EditProveedorDialogState extends State<EditProveedorDialog> {
  ProveedorBloc proveedorBloc;
  final keyFormEditProveedor = GlobalKey<FormState>();
  bool estatus;

  @override
  void initState() {
    (widget.proveedor.estatus == 'Activo') ? estatus = true : estatus = false;
    proveedorBloc = BlocProvider.of<ProveedorBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return AlertDialog(
      title: Center(child: Text('Editar Proveedor')),
      elevation: 1.0,
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: size.height * 0.8,
          maxWidth: size.width * 0.5,
          minWidth: size.width * 0.4,
          minHeight: size.height * 0.4,
        ),
        child: Column(
          children: [
            Form(
              key: keyFormEditProveedor,
              child: ResponsiveGridRow(
                children: [
                  ResponsiveGridCol(
                    md: 12,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value != null && value != '') {
                            return null;
                          } else {
                            return 'El campo es requerido';
                          }
                        },
                        onChanged: (value) {
                          widget.proveedor.nombre = value;
                        },
                        initialValue: widget.proveedor.nombre,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Nombre Proveedor'),
                      ),
                    ),
                  ),
                  ResponsiveGridCol(
                    md: 12,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        onChanged: (value) {
                          widget.proveedor.descripcion = value;
                        },
                        validator: (value) {
                          if (value != null && value != '') {
                            return null;
                          } else {
                            return 'El campo es requerido';
                          }
                        },
                        initialValue: widget.proveedor.descripcion,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Descripción del proveedor',
                        ),
                        maxLines: 4,
                      ),
                    ),
                  ),
                  ResponsiveGridCol(
                    md: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CheckboxListTile(
                        value: estatus,
                        onChanged: (value) {
                          setState(() {
                            (estatus) ? estatus = false : estatus = true;
                            (estatus)
                                ? widget.proveedor.estatus = 'Activo'
                                : widget.proveedor.estatus = 'Inactivo';
                          });
                        },
                        title: Text(widget.proveedor.estatus),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () async {
            if (keyFormEditProveedor.currentState.validate()) {
              await proveedorBloc.add(UpdateProveedor(widget.proveedor));
              await proveedorBloc.add(FechtProveedorEvent());
              await proveedorBloc.add(FechtSevicioByProveedorEvent());
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Se ha editado correctamente el invitado'),
                backgroundColor: Colors.green,
              ));
              Navigator.of(context).pop();
            }
          },
          child: Text('Aceptar'),
        )
      ],
    );
  }
}

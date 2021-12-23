import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/blocs/proveedores/proveedor_bloc.dart';
import 'package:planning/src/blocs/servicios/bloc/servicios_bloc_dart_bloc.dart';
import 'package:planning/src/models/item_model_proveedores.dart';
import 'package:planning/src/models/item_model_servicios.dart';
import 'package:responsive_grid/responsive_grid.dart';

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
  ServiciosBloc servicioBloc;
  int idServicio;
  List<bool> checkeds = [];
  List<int> listServiciostoAdd = [];
  bool isLoad = false;

  @override
  void initState() {
    (widget.proveedor.estatus == 'Activo') ? estatus = true : estatus = false;
    proveedorBloc = BlocProvider.of<ProveedorBloc>(context);
    servicioBloc = BlocProvider.of<ServiciosBloc>(context);
    servicioBloc.add(FechtServiciosEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Proveedor'),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          color: Colors.white,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: size.width * 0.7,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 20.0,
                ),
                Form(
                  key: keyFormEditProveedor,
                  child: ResponsiveGridRow(
                    children: [
                      ResponsiveGridCol(
                        md: 6,
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
                                labelText: 'Nombre proveedor'),
                          ),
                        ),
                      ),
                      ResponsiveGridCol(
                        md: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            onChanged: (value) {
                              widget.proveedor.correo = value;
                            },
                            validator: (value) {
                              if (value == '' || value == null) {
                                return null;
                              } else {
                                RegExp validEmail = RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                                if (validEmail.hasMatch(value)) {
                                  return null;
                                } else {
                                  return 'No es correo eléctronico valido';
                                }
                              }
                            },
                            initialValue: widget.proveedor.correo,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Correo electrónico',
                              hintText: 'Correo electrónico',
                            ),
                          ),
                        ),
                      ),
                      ResponsiveGridCol(
                        md: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            onChanged: (value) {
                              widget.proveedor.telefono = value;
                            },
                            validator: (value) {
                              if (value == '' || value == null) {
                                return null;
                              } else {
                                if (value.length != 10) {
                                  return 'El número debe tener 10 digitos';
                                } else {
                                  return null;
                                }
                              }
                            },
                            initialValue: widget.proveedor.telefono,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Teléfono',
                              hintText: 'Teléfono',
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                      ),
                      ResponsiveGridCol(
                        md: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            onChanged: (value) {
                              widget.proveedor.direccion = value;
                            },
                            initialValue: widget.proveedor.direccion,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Dirección',
                              hintText: 'Dirección',
                            ),
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
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Servicios',
                  style: Theme.of(context).textTheme.headline5,
                ),
                BlocBuilder<ServiciosBloc, ServiciosState>(
                  builder: (context, state) {
                    if (state is LoadingServiciosState) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is MostrarServiciosState) {
                      if (state.listServicios != null) {
                        return listToSelectServicios(
                            state.listServicios, widget.proveedor);
                      } else {
                        return Center(child: Text('Sin servicios'));
                      }
                    } else {
                      return Center(child: Text('Sin servicios'));
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (keyFormEditProveedor.currentState.validate()) {
            await proveedorBloc.add(UpdateProveedor(widget.proveedor));

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Se ha editado correctamente el invitado'),
              backgroundColor: Colors.green,
            ));
            Navigator.of(context).pop();
          }
        },
        child: Icon(Icons.save),
      ),
    );
  }

  Widget listToSelectServicios(
      ItemModuleServicios servicios, ItemProveedor proveedor) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: servicios.results.length,
      itemBuilder: (context, index) {
        bool temp = false;

        proveedor.servicio.forEach((element) {
          if (element.id_servicio == servicios.results[index].id_servicio) {
            temp = true;
          }
        });
        checkeds.add(temp);
        return CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(servicios.results[index].nombre),
          value: checkeds[index],
          onChanged: (value) {
            setState(() {
              if (checkeds[index]) {
                listServiciostoAdd.removeWhere((idServicio) =>
                    idServicio == servicios.results[index].id_servicio);
                proveedorBloc.add(DeleteServicioProvEvent(
                    servicios.results[index].id_servicio,
                    proveedor.id_proveedor));

                checkeds[index] = false;
              } else {
                listServiciostoAdd.add(servicios.results[index].id_servicio);
                proveedorBloc.add(InsertServicioProvEvent(
                    servicios.results[index].id_servicio,
                    proveedor.id_proveedor));
                checkeds[index] = true;
              }
            });
          },
        );
      },
    );
  }
}

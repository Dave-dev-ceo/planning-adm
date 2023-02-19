import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/blocs/proveedores/proveedor_bloc.dart';
import 'package:planning/src/blocs/servicios/bloc/servicios_bloc_dart_bloc.dart';
import 'package:planning/src/models/item_model_proveedores.dart';
import 'package:planning/src/models/item_model_servicios.dart';
import 'package:planning/src/ui/widgets/FullScreenDialog/full_screen_dialog_agregar_proveedor.dart';
import 'package:planning/src/ui/widgets/snackbar_widget/snackbar_widget.dart';
import 'package:responsive_grid/responsive_grid.dart';

class EditProveedorDialog extends StatefulWidget {
  final ItemProveedor? proveedor;
  const EditProveedorDialog({Key? key, this.proveedor}) : super(key: key);

  @override
  _EditProveedorDialogState createState() => _EditProveedorDialogState();
}

class _EditProveedorDialogState extends State<EditProveedorDialog> {
  late ProveedorBloc proveedorBloc;
  final keyFormEditProveedor = GlobalKey<FormState>();
  bool? estatus;
  late ServiciosBloc servicioBloc;
  int? idServicio;
  List<bool> checkeds = [];
  List<int?> listServiciostoAdd = [];
  bool isLoad = false;
  ItemModuleServicios? _listServicios;
  Future<List<Territorio>>? peticionPaises;
  Future<List<Territorio>>? peticionEstados;
  Future<List<Territorio>>? peticionCiudades;

  @override
  void initState() {
    (widget.proveedor!.estatus == 'Activo') ? estatus = true : estatus = false;
    proveedorBloc = BlocProvider.of<ProveedorBloc>(context);
    servicioBloc = BlocProvider.of<ServiciosBloc>(context);
    servicioBloc
        .add(FechtServiciosByProveedorEvent(widget.proveedor!.idProveedor));

    peticionPaises = getPaises();
    if (widget.proveedor!.idPais != null) {
      peticionEstados = getEstados(widget.proveedor!.idPais);
    }
    if (widget.proveedor!.idEstado != null) {
      peticionCiudades = getCiudades(widget.proveedor!.idEstado);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar proveedor'),
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
                const SizedBox(
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
                              widget.proveedor!.nombre = value;
                            },
                            initialValue: widget.proveedor!.nombre,
                            decoration: const InputDecoration(
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
                              widget.proveedor!.correo = value;
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
                            initialValue: widget.proveedor!.correo,
                            decoration: const InputDecoration(
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
                              widget.proveedor!.telefono = value;
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
                            initialValue: widget.proveedor!.telefono,
                            decoration: const InputDecoration(
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
                              widget.proveedor!.direccion = value;
                            },
                            initialValue: widget.proveedor!.direccion,
                            decoration: const InputDecoration(
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
                              widget.proveedor!.descripcion = value;
                            },
                            initialValue: widget.proveedor!.descripcion,
                            decoration: const InputDecoration(
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
                          child: FutureBuilder(
                            future: peticionPaises,
                            builder: (context,
                                AsyncSnapshot<List<Territorio>> snapshot) {
                              if (snapshot.hasData) {
                                final paises = snapshot.data!;
                                return DropdownButtonFormField<int>(
                                  isExpanded: true,
                                  onChanged: (value) => setState(() {
                                    if (widget.proveedor!.idPais != value) {
                                      widget.proveedor!.idEstado = null;
                                    }
                                    widget.proveedor!.idPais = value;
                                    peticionEstados = getEstados(value);
                                  }),
                                  value: widget.proveedor!.idPais,
                                  decoration: const InputDecoration(
                                    label: Text('País'),
                                    border: OutlineInputBorder(),
                                  ),
                                  items: paises
                                      .map((p) => DropdownMenuItem<int>(
                                            child: Text(p.nombre!),
                                            value: p.id,
                                          ))
                                      .toList(),
                                );
                              }

                              return const LinearProgressIndicator();
                            },
                          ),
                        ),
                      ),
                      if (widget.proveedor!.idPais != null)
                        ResponsiveGridCol(
                          md: 6,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FutureBuilder(
                              future: peticionEstados,
                              builder: (context,
                                  AsyncSnapshot<List<Territorio>> snapshot) {
                                if (snapshot.hasData) {
                                  final estados = snapshot.data!;
                                  return DropdownButtonFormField<int>(
                                    isExpanded: true,
                                    value: widget.proveedor!.idEstado,
                                    onChanged: (value) => setState(() {
                                      if (widget.proveedor!.idEstado != value) {
                                        widget.proveedor!.idCiudad = null;
                                      }
                                      widget.proveedor!.idEstado = value;
                                      peticionCiudades = getCiudades(value);
                                    }),
                                    decoration: const InputDecoration(
                                      label: Text('Estado'),
                                      border: OutlineInputBorder(),
                                    ),
                                    items: estados
                                        .map((e) => DropdownMenuItem(
                                              child: Text(e.nombre!),
                                              value: e.id,
                                            ))
                                        .toList(),
                                  );
                                }
                                return const LinearProgressIndicator();
                              },
                            ),
                          ),
                        ),
                      if (widget.proveedor!.idEstado != null)
                        ResponsiveGridCol(
                          md: 6,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FutureBuilder(
                              future: peticionCiudades,
                              builder: (context,
                                  AsyncSnapshot<List<Territorio>> snapshot) {
                                if (snapshot.hasData) {
                                  final ciudades = snapshot.data!;
                                  return DropdownButtonFormField<int>(
                                    style: const TextStyle(
                                        overflow: TextOverflow.ellipsis),
                                    value: widget.proveedor!.idCiudad,
                                    onChanged: (value) =>
                                        widget.proveedor!.idCiudad = value,
                                    decoration: const InputDecoration(
                                      label: Text('Ciudad'),
                                      border: OutlineInputBorder(),
                                    ),
                                    items: ciudades
                                        .map((c) => DropdownMenuItem(
                                              child: Text(c.nombre!),
                                              value: c.id,
                                            ))
                                        .toList(),
                                  );
                                }
                                return const LinearProgressIndicator();
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Servicios',
                  style: Theme.of(context).textTheme.headline5,
                ),
                BlocBuilder<ServiciosBloc, ServiciosState>(
                  builder: (context, state) {
                    if (state is LoadingServiciosState) {
                      return const Center(child: LoadingCustom());
                    } else if (state is MostrarServiciosByProveedorState) {
                      _listServicios = state.servicios;

                      List<ServiciosModel> servicio = [];
                      for (var element in state.listServiciosEvent.results) {
                        servicio.add(ServiciosModel(
                            idServicio: element.idServicio,
                            nombre: element.nombre));
                      }
                      widget.proveedor!.servicio = servicio;
                      if (_listServicios != null) {
                        return listToSelectServicios(
                            _listServicios!, widget.proveedor);
                      } else {
                        return const Center(child: Text('Sin servicios'));
                      }
                    } else {
                      return const Center(child: Text('Sin servicios'));
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: UniqueKey(),
        onPressed: () async {
          if (keyFormEditProveedor.currentState!.validate()) {
            proveedorBloc.add(UpdateProveedor(widget.proveedor));

            MostrarAlerta(
                mensaje: 'Se ha editado correctamente el invitado',
                tipoMensaje: TipoMensaje.correcto);

            Navigator.of(context).pop();
          }
        },
        child: const Icon(Icons.save),
      ),
    );
  }

  Widget listToSelectServicios(
      ItemModuleServicios servicios, ItemProveedor? proveedor) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: servicios.results.length,
      itemBuilder: (context, index) {
        bool temp = false;

        for (var element in proveedor!.servicio!) {
          if (element.idServicio == servicios.results[index].idServicio) {
            temp = true;
          }
        }
        checkeds.add(temp);
        return CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(servicios.results[index].nombre!),
          value: checkeds[index],
          onChanged: (value) {
            setState(() {
              if (checkeds[index]) {
                listServiciostoAdd.removeWhere((idServicio) =>
                    idServicio == servicios.results[index].idServicio);
                proveedorBloc.add(DeleteServicioProvEvent(
                    servicios.results[index].idServicio,
                    proveedor.idProveedor));

                checkeds[index] = false;
              } else {
                listServiciostoAdd.add(servicios.results[index].idServicio);
                proveedorBloc.add(InsertServicioProvEvent(
                    servicios.results[index].idServicio,
                    proveedor.idProveedor));
                checkeds[index] = true;
              }
            });
          },
        );
      },
    );
  }
}

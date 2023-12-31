import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/blocs/pagos/pagos_bloc.dart';
import 'package:planning/src/models/item_model_pagos.dart';
import 'package:planning/src/ui/widgets/snackbar_widget/snackbar_widget.dart';

class FormEditPago extends StatefulWidget {
  final int? id;
  const FormEditPago({Key? key, required this.id}) : super(key: key);

  @override
  _FormEditPagoState createState() => _FormEditPagoState();
}

class _FormEditPagoState extends State<FormEditPago> {
  // variable bloc
  late PagosBloc pagosBloc;

  // variable model

  // variable class
  Map itemPago = {};
  bool bandera = true;

  @override
  void initState() {
    super.initState();
    pagosBloc = BlocProvider.of<PagosBloc>(context);
    pagosBloc.add(SelectIdEvent(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        pagosBloc.add(SelectPagosEvent());
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Editar presupuesto'),
        ),
        body: SingleChildScrollView(
          child: _myBloc(),
        ),
      ),
    );
  }

  _myBloc() {
    return BlocListener<PagosBloc, PagosState>(
      listener: (context, state) {
        if (state is PagosUpdateState) {
          MostrarAlerta(
              mensaje: 'Presupuesto actualizado',
              tipoMensaje: TipoMensaje.correcto);
          pagosBloc.add(SelectIdEvent(widget.id));
        } else if (state is PagosDeleteState) {
          MostrarAlerta(
              mensaje: 'Presupuesto eliminado',
              tipoMensaje: TipoMensaje.correcto);
          Navigator.pop(context);
          pagosBloc.add(SelectPagosEvent());
        }
      },
      child: BlocBuilder<PagosBloc, PagosState>(
        builder: (context, state) {
          if (state is PagosInitial) {
            return const Center(
              child: LoadingCustom(),
            );
          } else if (state is PagosLogging) {
            return const Center(
              child: LoadingCustom(),
            );
          } else if (state is PagosSelectId) {
            if (bandera) {
              itemPago['servicios'] =
                  state.pagos.pagos[0].idServicio.toString();
              itemPago['proveedores'] =
                  state.pagos.pagos[0].idProveedor.toString();
              itemPago['cantidad'] = state.pagos.pagos[0].cantidad.toString();
              itemPago['descripcion'] =
                  state.pagos.pagos[0].descripcion.toString();
              itemPago['precio'] =
                  state.pagos.pagos[0].precioUnitario.toString();
              itemPago['total'] = state.pagos.pagos[0].total.toString();
              itemPago['anticipo'] = state.pagos.pagos[0].anticipo.toString();
              itemPago['saldo'] = state.pagos.pagos[0].saldo.toString();
              bandera = false;
            }
            return _formEditPagos(state.proveedor, state.servicio);
          } else {
            return const Center(
              child: LoadingCustom(),
            );
          }
        },
      ),
    );
  }

  _formEditPagos(proveedor, servicios) {
    return Container(
      margin: const EdgeInsets.all(20.0),
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Editar presupuesto',
                style: TextStyle(fontSize: 20.0),
              )),
          const SizedBox(
            height: 64.0,
          ),
          _selectServicios(servicios),
          const SizedBox(
            height: 32.0,
          ),
          _selectProveedores(proveedor),
          const SizedBox(
            height: 32.0,
          ),
          const Text('Cantidad:'),
          TextFormField(
            controller: TextEditingController(text: '${itemPago['cantidad']}'),
            decoration: const InputDecoration(hintText: 'Cantidad:'),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (valor) {
              itemPago['cantidad'] = valor;
            },
          ),
          const SizedBox(
            height: 32.0,
          ),
          const Text('Concepto:'),
          TextFormField(
            controller:
                TextEditingController(text: '${itemPago['descripcion']}'),
            decoration: const InputDecoration(hintText: 'Concepto:'),
            onChanged: (valor) {
              itemPago['descripcion'] = valor;
            },
          ),
          const SizedBox(
            height: 32.0,
          ),
          const Text('Precio unitario:'),
          TextFormField(
            controller: TextEditingController(text: '${itemPago['precio']}'),
            decoration: const InputDecoration(hintText: 'Precio unitario:'),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
            ],
            onChanged: (valor) {
              itemPago['precio'] = valor;
            },
          ),
          const SizedBox(
            height: 32.0,
          ),
          ElevatedButton(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('Editar'),
                SizedBox(
                  width: 10.0,
                ),
                Icon(Icons.edit),
              ],
            ),
            onPressed: () => _editPago(),
          ),
          // SizedBox(height: 32.0,),
          // ElevatedButton(
          //   child: Icon(Icons.delete),
          //   onPressed: () => _deletePago(),
          // )
        ],
      ),
    );
  }

  _selectServicios(ItemModelPagos servicios) {
    if (servicios.pagos.isNotEmpty) {
      return SizedBox(
        width: double.infinity,
        child: DropdownButton<String>(
            value: itemPago['servicios'],
            icon: const Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: const TextStyle(color: Colors.black),
            underline: Container(
              height: 2,
              color: Colors.black,
            ),
            onChanged: (String? newValue) {
              setState(() {
                itemPago['servicios'] = newValue;

                itemPago['proveedores'] = null;
              });
            },
            items: servicios.pagos.map((item) {
              return DropdownMenuItem(
                value: item.idServicio.toString(),
                child: Text(
                  item.servicio!,
                  style: const TextStyle(fontSize: 18),
                ),
              );
            }).toList()),
      );
    } else {
      return const SizedBox();
    }
  }

  _selectProveedores(ItemModelPagos proveedor) {
    if (proveedor.pagos.isNotEmpty) {
      List<DropdownMenuItem<String>> items = [];

      for (var prov in proveedor.pagos) {
        if (itemPago['servicios'] == prov.idServicio.toString()) {
          items.add(DropdownMenuItem<String>(
            value: prov.idProveedor.toString(),
            child: Text(
              prov.servicio!,
              style: const TextStyle(fontSize: 18),
            ),
          ));
        }
      }

      final value = proveedor.pagos
          .firstWhereOrNull((prov) =>
              prov.idProveedor?.toString() ==
              itemPago['proveedores']?.toString())
          ?.idProveedor
          ?.toString();

      return SizedBox(
        width: double.infinity,
        child: DropdownButton<String>(
            value: value,
            hint: const Text('Proveedores'),
            icon: const Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: const TextStyle(color: Colors.black),
            underline: Container(
              height: 2,
              color: Colors.black,
            ),
            onChanged: (String? newValue) {
              setState(() {
                itemPago['proveedores'] = newValue;
              });
            },
            items: items
            // proveedor.pagos.map((item) {
            // return DropdownMenuItem(
            // value: item.idProveedor.toString(),
            // child: Text(
            // item.proveedor,
            // style: const TextStyle(fontSize: 18),
            // ),
            // );
            // }).toList(),
            ),
      );
    } else {
      return const SizedBox();
    }
  }

  _editPago() {
    if (itemPago['cantidad'] == '' ||
        itemPago['descripcion'] == '' ||
        itemPago['precio'] == '') {
      MostrarAlerta(
          mensaje: 'Todos los campos son obligatorios',
          tipoMensaje: TipoMensaje.advertencia);
    } else {
      itemPago['id_concepto'] = widget.id.toString();
      pagosBloc.add(UpdatePagosEvent(itemPago));
    }
  }

  // _deletePago() {
  //   pagosBloc.add(DeletePagosEvent(widget.id));
  // }
}

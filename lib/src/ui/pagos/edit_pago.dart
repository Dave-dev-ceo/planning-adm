import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/blocs/pagos/pagos_bloc.dart';
import 'package:planning/src/models/item_model_pagos.dart';

class FormEditPago extends StatefulWidget {
  final int id;
  FormEditPago({Key key, @required this.id}) : super(key: key);

  @override
  _FormEditPagoState createState() => _FormEditPagoState();
}

class _FormEditPagoState extends State<FormEditPago> {
  // variable bloc
  PagosBloc pagosBloc;

  // variable model

  // variable class
  Map itemPago = Map();
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
          title: Text('Editar presupuesto'),
        ),
        body: _myBloc(),
      ),
    );
  }

  _myBloc() {
    return BlocListener<PagosBloc, PagosState>(
      listener: (context, state) {
        if (state is PagosUpdateState) {
          _mensaje('Pago actualizado');
          pagosBloc.add(SelectIdEvent(widget.id));
        } else if (state is PagosDeleteState) {
          _mensaje('Pago eliminado');
          Navigator.pop(context);
          pagosBloc.add(SelectPagosEvent());
        }
      },
      child: BlocBuilder<PagosBloc, PagosState>(
        builder: (context, state) {
          if (state is PagosInitial) {
            return Center(
              child: LoadingCustom(),
            );
          } else if (state is PagosLogging) {
            return Center(
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
            return Center(
              child: LoadingCustom(),
            );
          }
        },
      ),
    );
  }

  _formEditPagos(proveedor, servicios) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.white,
      child: ListView(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Editar presupuesto',
                    style: TextStyle(fontSize: 20.0),
                  )),
              SizedBox(
                height: 64.0,
              ),
              _selectServicios(servicios),
              SizedBox(
                height: 32.0,
              ),
              _selectProveedores(proveedor),
              SizedBox(
                height: 32.0,
              ),
              Text('Cantidad:'),
              TextFormField(
                controller:
                    TextEditingController(text: '${itemPago['cantidad']}'),
                decoration: InputDecoration(hintText: 'Cantidad:'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (valor) {
                  itemPago['cantidad'] = valor;
                },
              ),
              SizedBox(
                height: 32.0,
              ),
              Text('Concepto:'),
              TextFormField(
                controller:
                    TextEditingController(text: '${itemPago['descripcion']}'),
                decoration: InputDecoration(hintText: 'Concepto:'),
                onChanged: (valor) {
                  itemPago['descripcion'] = valor;
                },
              ),
              SizedBox(
                height: 32.0,
              ),
              Text('Precio Unitario:'),
              TextFormField(
                controller:
                    TextEditingController(text: '${itemPago['precio']}'),
                decoration: InputDecoration(hintText: 'Precio Unitario:'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (valor) {
                  itemPago['precio'] = valor;
                },
              ),
              SizedBox(
                height: 32.0,
              ),
              ElevatedButton(
                child: Icon(Icons.edit),
                onPressed: () => _editPago(),
              ),
              // SizedBox(height: 32.0,),
              // ElevatedButton(
              //   child: Icon(Icons.delete),
              //   onPressed: () => _deletePago(),
              // )
            ],
          ),
        ],
      ),
    );
  }

  _selectServicios(ItemModelPagos servicios) {
    if (servicios.pagos.length > 0) {
      return Container(
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
            onChanged: (String newValue) {
              setState(() {
                itemPago['servicios'] = newValue;
              });
            },
            items: servicios.pagos.map((item) {
              return DropdownMenuItem(
                value: item.idServicio.toString(),
                child: Text(
                  item.servicio,
                  style: TextStyle(fontSize: 18),
                ),
              );
            }).toList()),
      );
    } else {
      return SizedBox();
    }
  }

  _selectProveedores(ItemModelPagos proveedor) {
    if (proveedor.pagos.length > 0) {
      return Container(
        width: double.infinity,
        child: DropdownButton<String>(
            value: itemPago['proveedores'],
            icon: const Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: const TextStyle(color: Colors.black),
            underline: Container(
              height: 2,
              color: Colors.black,
            ),
            onChanged: (String newValue) {
              setState(() {
                itemPago['proveedores'] = newValue;
              });
            },
            items: proveedor.pagos.map((item) {
              return DropdownMenuItem(
                value: item.idProveedor.toString(),
                child: Text(
                  item.proveedor,
                  style: TextStyle(fontSize: 18),
                ),
              );
            }).toList()),
      );
    } else {
      return SizedBox();
    }
  }

  _editPago() {
    if (itemPago['cantidad'] == '' ||
        itemPago['descripcion'] == '' ||
        itemPago['precio'] == '') {
      _mensaje('Todos los campos son obligatorios.');
    } else {
      itemPago['id_concepto'] = widget.id.toString();
      pagosBloc.add(UpdatePagosEvent(itemPago));
    }
  }

  // _deletePago() {
  //   pagosBloc.add(DeletePagosEvent(widget.id));
  // }

  // mensaje
  Future<void> _mensaje(String txt) async {
    return await ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(txt),
    ));
  }
}

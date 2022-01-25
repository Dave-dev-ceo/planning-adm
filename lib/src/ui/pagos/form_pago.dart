import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/blocs/pagos/pagos_bloc.dart';
import 'package:planning/src/models/item_model_pagos.dart';
import 'package:flutter/services.dart';
import 'package:planning/src/ui/widgets/snackbar_widget/snackbar_widget.dart';

class FormPago extends StatefulWidget {
  final String tipoPresupuesto;
  FormPago({Key key, @required this.tipoPresupuesto}) : super(key: key);

  @override
  _FormPagoState createState() => _FormPagoState();
}

class _FormPagoState extends State<FormPago> {
  // variabls bloc
  PagosBloc pagosBloc;

  // variable clases
  bool bandera = true;
  Map itemPago = Map();

  @override
  void initState() {
    super.initState();
    pagosBloc = BlocProvider.of<PagosBloc>(context);
    pagosBloc.add(SelectFormPagosEvent());
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
          title: Text('Agregar presupuestos'),
        ),
        body: _myBloc(),
      ),
    );
  }

  _myBloc() {
    return BlocListener<PagosBloc, PagosState>(
      listener: (context, state) {
        if (state is PagosCreateState) {
          itemPago['cantidad'] = '';
          itemPago['concepto'] = '';
          itemPago['precio'] = '';
          pagosBloc.add(SelectFormPagosEvent());
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
          } else if (state is PagosSelectFormState) {
            if (bandera) {
              itemPago['servicios'] = '0';
              itemPago['proveedores'] = '0';
              itemPago['cantidad'] = '';
              itemPago['concepto'] = '';
              itemPago['precio'] = '';
              bandera = false;
            }
            return _formPagos(state.proveedor, state.servicios);
          } else {
            return Center(
              child: LoadingCustom(),
            );
          }
        },
      ),
    );
  }

  _formPagos(proveedor, servicios) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Agregar presupuestos',
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
          TextFormField(
            controller: TextEditingController(text: '${itemPago['cantidad']}'),
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
          TextFormField(
            controller: TextEditingController(text: '${itemPago['concepto']}'),
            decoration: InputDecoration(hintText: 'Concepto:'),
            onChanged: (valor) {
              itemPago['concepto'] = valor;
            },
          ),
          SizedBox(
            height: 32.0,
          ),
          TextFormField(
            controller: TextEditingController(text: '${itemPago['precio']}'),
            decoration: InputDecoration(hintText: 'Precio unitario:'),
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
            child: Icon(Icons.add),
            onPressed: () => _agregarPago(),
          )
        ],
      ),
    );
  }

  _selectServicios(ItemModelPagos servicios) {
    if (servicios.pagos.length > 0) {
      List temp = servicios.pagos.map((item) {
        return DropdownMenuItem<String>(
          value: item.idServicio.toString(),
          child: Text(
            item.servicio,
            style: TextStyle(fontSize: 18),
          ),
        );
      }).toList();

      temp.add(DropdownMenuItem<String>(
        value: '0',
        child: Text(
          'Servicios',
          style: TextStyle(fontSize: 18),
        ),
      ));

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
            items: temp),
      );
    } else {
      return SizedBox();
    }
  }

  _selectProveedores(ItemModelPagos proveedor) {
    if (proveedor.pagos.length > 0) {
      List temp = proveedor.pagos.map((item) {
        return DropdownMenuItem<String>(
          value: item.idProveedor.toString(),
          child: Text(
            item.proveedor,
            style: TextStyle(fontSize: 18),
          ),
        );
      }).toList();

      temp.add(DropdownMenuItem<String>(
        value: '0',
        child: Text(
          'Proveedores',
          style: TextStyle(fontSize: 18),
        ),
      ));

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
            items: temp),
      );
    } else {
      return SizedBox();
    }
  }

  _agregarPago() {
    if (itemPago['servicios'] == '0' ||
        itemPago['proveedores'] == '0' ||
        itemPago['cantidad'] == '' ||
        itemPago['concepto'] == '' ||
        itemPago['precio'] == '') {
      MostrarAlerta(
          mensaje: 'Todos los campos son obligatorios.',
          tipoMensaje: TipoMensaje.error);
    } else {
      itemPago['tipoPresupuesto'] = widget.tipoPresupuesto;
      pagosBloc.add(CrearPagosEvent(itemPago));
      MostrarAlerta(
          mensaje: 'Pago agregado', tipoMensaje: TipoMensaje.correcto);
    }
  }

  // mensaje

}

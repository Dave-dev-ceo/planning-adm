import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/blocs/pagos/pagos_bloc.dart';
import 'package:planning/src/models/item_model_pagos.dart';
import 'package:flutter/services.dart';
import 'package:planning/src/models/pago/pago_model.dart';
import 'package:planning/src/ui/widgets/snackbar_widget/snackbar_widget.dart';

class FormPago extends StatefulWidget {
  final String tipoPresupuesto;
  const FormPago({Key key, @required this.tipoPresupuesto}) : super(key: key);

  @override
  _FormPagoState createState() => _FormPagoState();
}

class _FormPagoState extends State<FormPago> {
  final _formKeyPago = GlobalKey<FormState>();
  PagoPresupuesto pagoPresupuesto = PagoPresupuesto();

  // variabls bloc
  PagosBloc pagosBloc;

  // variable clases
  bool bandera = true;
  bool tieneProovederos = true;
  bool tieneServicios = true;
  Map itemPago = {};

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
          title: const Text('Agregar presupuestos'),
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
        if (state is PagosCreateState) {
          itemPago['cantidad'] = '';
          itemPago['concepto'] = '';
          itemPago['precio'] = '';
          pagoPresupuesto = PagoPresupuesto();
          pagosBloc.add(SelectFormPagosEvent());

          MostrarAlerta(
              mensaje: 'Pago agregado', tipoMensaje: TipoMensaje.correcto);
        }
        if (state is ErrorPagosState) {
          MostrarAlerta(
            mensaje: 'No se pudo agregar el pago, valide información.',
            tipoMensaje: TipoMensaje.error,
          );
          Navigator.of(context).pop();
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
          } else if (state is PagosSelectFormState) {
            if (bandera) {
              itemPago['servicios'] = '0';
              itemPago['proveedores'] = '0';
              itemPago['cantidad'] = '';
              itemPago['concepto'] = '';
              itemPago['precio'] = '';
              bandera = false;
            }
            if (state.proveedor.pagos.isEmpty) {
              tieneProovederos = false;
            }

            if (state.servicios.pagos.isEmpty) {
              tieneServicios = false;
            }

            return _formPagos(state.proveedor, state.servicios);
          } else {
            return const Center(
              child: LoadingCustom(),
            );
          }
        },
      ),
    );
  }

  _formPagos(proveedor, servicios) {
    return Form(
      key: _formKeyPago,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.all(20.0),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Datos del presupuesto',
                  style: TextStyle(fontSize: 20.0),
                )),
            const SizedBox(
              height: 40.0,
            ),
            _selectServicios(servicios),
            const SizedBox(
              height: 32.0,
            ),
            AbsorbPointer(
              absorbing: (pagoPresupuesto.servicioId == '0'),
              child: _selectProveedores(proveedor),
            ),
            const SizedBox(
              height: 32.0,
            ),
            const Text('Cantidad:'),
            TextFormField(
              initialValue: pagoPresupuesto.cantidad?.toString(),
              decoration: const InputDecoration(hintText: 'Cantidad:'),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (valor) {
                pagoPresupuesto.cantidad = int.parse(valor);
              },
            ),
            const SizedBox(
              height: 32.0,
            ),
            const Text('Concepto:'),
            TextFormField(
              validator: (valor) {
                if (valor != null && valor != '') {
                  return null;
                }
                return 'El campo es requerido';
              },
              initialValue: pagoPresupuesto.concepto,
              decoration: const InputDecoration(hintText: 'Concepto:'),
              onChanged: (valor) {
                pagoPresupuesto.concepto = valor;
              },
            ),
            const SizedBox(
              height: 32.0,
            ),
            const Text('Precio unitario:'),
            TextFormField(
              initialValue: pagoPresupuesto.precioUnitario?.toString(),
              decoration: const InputDecoration(hintText: 'Precio unitario:'),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
              ],
              validator: (valor) {
                final temp = double.parse(valor);

                if (temp >= 0) {
                  return null;
                }
                return 'El campo es requerido';
              },
              onChanged: (valor) {
                pagoPresupuesto.precioUnitario = double.parse(valor);
              },
            ),
            const SizedBox(
              height: 32.0,
            ),
            if (widget.tipoPresupuesto != 'E')
              Container(
                margin: const EdgeInsets.all(8.0),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey)),
                child: SizedBox(
                  width: 300,
                  child: CheckboxListTile(
                    value: pagoPresupuesto.precioAdicional,
                    onChanged: (valor) {
                      setState(() {
                        pagoPresupuesto.precioAdicional = valor;
                      });
                      if (!valor) {
                        pagoPresupuesto.precioUnitarioAdicional = null;
                      }
                    },
                    title: const Text('Agregar al evento'),
                  ),
                ),
              ),
            if (widget.tipoPresupuesto != 'E')
              const SizedBox(
                height: 32.0,
              ),
            if (pagoPresupuesto.precioAdicional &&
                widget.tipoPresupuesto != 'E')
              const Text('Precio Unitario al evento:'),
            if (pagoPresupuesto.precioAdicional &&
                widget.tipoPresupuesto != 'E')
              TextFormField(
                initialValue:
                    pagoPresupuesto.precioUnitarioAdicional?.toString(),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))
                ],
                decoration: const InputDecoration(hintText: 'Monto'),
                onChanged: (valor) {
                  pagoPresupuesto.precioUnitarioAdicional =
                      double.tryParse(valor);
                },
                validator: (valor) {
                  final temp = double.parse(valor);

                  if (pagoPresupuesto.precioUnitario != null) {
                    if (temp < pagoPresupuesto.precioUnitario) {
                      return 'El precio unitario adicional no puede ser menor al precio unitario';
                    }
                  }

                  if (temp > 0) {
                    return null;
                  }
                  return 'El campo es requerido';
                },
              ),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('Agregar'),
                  SizedBox(width: 10.0),
                  Icon(Icons.add),
                ],
              ),
              onPressed: (tieneProovederos && tieneServicios)
                  ? () => _agregarPago()
                  : null,
            )
          ],
        ),
      ),
    );
  }

  _selectServicios(ItemModelPagos servicios) {
    if (servicios.pagos.isNotEmpty) {
      List temp = servicios.pagos.map((item) {
        return DropdownMenuItem<String>(
          value: item.idServicio.toString(),
          child: Text(
            item.servicio,
            style: const TextStyle(fontSize: 18),
          ),
        );
      }).toList();

      temp.add(const DropdownMenuItem<String>(
        value: '0',
        child: Text(
          'Servicios',
          style: TextStyle(fontSize: 18),
        ),
      ));

      return SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Servicio:'),
            DropdownButtonFormField<String>(
                validator: (valor) {
                  if (valor != null && valor != '0') {
                    return null;
                  } else {
                    return 'Este campo es requerido.';
                  }
                },
                value: pagoPresupuesto.servicioId,
                icon: const Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.black),
                // underline: Container(
                //   height: 2,
                //   color: Colors.black,
                // ),
                onChanged: (String newValue) {
                  setState(() {
                    pagoPresupuesto.servicioId = newValue;

                    pagoPresupuesto.proveedoresId = '0';
                  });
                },
                items: temp),
          ],
        ),
      );
    } else {
      return const Text('Sin servicios');
    }
  }

  _selectProveedores(ItemModelPagos proveedor) {
    if (proveedor.pagos.isNotEmpty) {
      List<DropdownMenuItem<String>> temp = [];

      for (var item in proveedor.pagos) {
        if (pagoPresupuesto.servicioId == item.idServicio.toString()) {
          temp.add(DropdownMenuItem<String>(
            value: item.idProveedor.toString(),
            child: Text(
              item.servicio,
              style: const TextStyle(fontSize: 18),
            ),
          ));
        }
      }

      temp.add(const DropdownMenuItem<String>(
        value: '0',
        child: Text(
          'Proveedores',
          style: TextStyle(fontSize: 18),
        ),
      ));

      return SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Proveedor:'),
            DropdownButtonFormField<String>(
                value: pagoPresupuesto.proveedoresId,
                icon: const Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.black),
                validator: (valor) {
                  if (valor != null && valor != '0') {
                    return null;
                  } else {
                    return 'Este campo es requerido.';
                  }
                },
                onChanged: (String newValue) {
                  setState(() {
                    pagoPresupuesto.proveedoresId = newValue;
                  });
                },
                items: temp),
          ],
        ),
      );
    } else {
      return const Text('Sin proveedores');
    }
  }

  _agregarPago() {
    if (_formKeyPago.currentState.validate()) {
      itemPago['tipoPresupuesto'] = widget.tipoPresupuesto;
      pagoPresupuesto.tipoPresupuesto = widget.tipoPresupuesto;
      pagosBloc.add(CrearPagosEvent(pagoPresupuesto));
    }
  }

  // mensaje

}

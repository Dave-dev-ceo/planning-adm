import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:planning/src/blocs/historialPagos/historialpagos_bloc.dart';
import 'package:planning/src/models/historialPagos/historial_pagos_model.dart';
import 'package:responsive_grid/responsive_grid.dart';

import 'package:planning/src/logic/historial_pagos/historial_pagos_logic.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class AgregarPagoDialog extends StatefulWidget {
  final String tipoPresupuesto;
  final bool isEdit;
  final HistorialPagosModel pagoModel;
  AgregarPagoDialog(
      {Key key,
      @required this.tipoPresupuesto,
      @required this.isEdit,
      @required this.pagoModel})
      : super(key: key);

  @override
  _AgregarPagoDialogState createState() => _AgregarPagoDialogState();
}

class _AgregarPagoDialogState extends State<AgregarPagoDialog> {
  HistorialPagosModel hitorialPagoModel;
  final _keyForm = GlobalKey<FormState>();
  FocusNode _conceptoNode;
  FocusNode _button;
  bool _isEdit = false;
  TextEditingController fechaEdit;

  HistorialPagosLogic logic = HistorialPagosLogic();

  @override
  void initState() {
    hitorialPagoModel = widget.pagoModel;
    _conceptoNode = FocusNode();
    _button = FocusNode();
    hitorialPagoModel.tipoPresupuesto = widget.tipoPresupuesto;
    _isEdit = widget.isEdit;
    if (_isEdit) {
      fechaEdit = TextEditingController(
          text:
              '${widget.pagoModel.fecha.day}/${widget.pagoModel.fecha.month}/${widget.pagoModel.fecha.year}');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar pago'),
      ),
      body: Form(
          key: _keyForm,
          child: Card(
            child: Column(
              children: [
                SizedBox(
                  height: 10.0,
                ),
                Center(
                  child: Text(
                    'Ingresar datos del pago',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                  width: size.width * 0.7,
                  child: ResponsiveGridRow(
                    children: [
                      ResponsiveGridCol(
                        md: 12,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TextFormField(
                            initialValue: hitorialPagoModel.concepto,
                            autofocus: true,
                            onFieldSubmitted: (value) {
                              FocusScope.of(context)
                                  .requestFocus(_conceptoNode);
                            },
                            decoration: InputDecoration(
                              hintText: 'Concepto',
                              border: OutlineInputBorder(),
                              labelText: 'Concepto',
                            ),
                            onChanged: (value) {
                              hitorialPagoModel.concepto = value;
                            },
                            validator: (value) {
                              if (value != null && value != '') {
                                return null;
                              } else {
                                return 'El concepto es requerido';
                              }
                            },
                          ),
                        ),
                      ),
                      ResponsiveGridCol(
                        md: 12,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TextFormField(
                            initialValue: _isEdit
                                ? hitorialPagoModel.pago.toString()
                                : '',
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9.]'))
                            ],
                            autofocus: true,
                            focusNode: _conceptoNode,
                            onFieldSubmitted: (value) {
                              _submit();
                            },
                            decoration: InputDecoration(
                              hintText: 'Pago',
                              border: OutlineInputBorder(),
                              labelText: 'Pago',
                            ),
                            onChanged: (value) {
                              hitorialPagoModel.pago = double.parse(value);
                            },
                            validator: (value) {
                              if (value != null && value != '') {
                                double temp = double.parse(value);
                                if (temp.runtimeType == double ||
                                    temp.runtimeType == int) {
                                  return null;
                                } else {
                                  return 'El formato no es valido';
                                }
                              } else {
                                return 'El concepto es requerido';
                              }
                            },
                          ),
                        ),
                      ),
                      if (_isEdit)
                        ResponsiveGridCol(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: TextFormField(
                              readOnly: true,
                              controller: fechaEdit,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Fecha',
                                labelText: 'Fecha',
                                prefixIcon: Icon(Icons.calendar_today_outlined),
                              ),
                              onTap: () async {
                                var picked = await showDatePicker(
                                  context: context,
                                  locale: const Locale("es", "ES"),
                                  initialDate:
                                      widget.pagoModel.fecha, // Refer step 1
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2025),
                                );

                                if (picked != null) {
                                  widget.pagoModel.fecha = picked;

                                  fechaEdit.text =
                                      '${widget.pagoModel.fecha.day}/${widget.pagoModel.fecha.month}/${widget.pagoModel.fecha.year}';
                                }
                              },
                            ),
                          ),
                        )
                    ],
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    focusNode: _button,
                    onPressed: _submit,
                    child: Text('Guardar'),
                  ),
                )
              ],
            ),
          )),
    );
  }

  void _submit() async {
    if (_keyForm.currentState.validate()) {
      final pagosBloc = context.read<HistorialPagosBloc>();
      if (!_isEdit) {
        final resp = await logic.agregarPagoEvento(hitorialPagoModel);

        if (resp == 'Ok') {
          context.read<HistorialPagosBloc>().add(MostrarHistorialPagosEvent());
          _mostrarMensaje(
              titulo: 'Se ha agregado el pago correctamente',
              color: Colors.green);
          Navigator.of(context).pop(true);
        } else {
          _mostrarMensaje(titulo: resp, color: Colors.red);
        }
      } else {
        final resp = await logic.editarPagoEvento(hitorialPagoModel);

        if (resp == 'Ok') {
          context.read<HistorialPagosBloc>().add(MostrarHistorialPagosEvent());

          _mostrarMensaje(
              titulo: 'Se ha editado el pago correctamente',
              color: Colors.green);
          Navigator.of(context).pop(true);
        } else {
          _mostrarMensaje(titulo: resp, color: Colors.red);
        }
      }
    } else {
      _mostrarMensaje(titulo: 'Los campos son requeridos', color: Colors.red);
    }
  }

  _mostrarMensaje({@required String titulo, @required Color color}) {
    final snackBar = SnackBar(
      content: Text(titulo),
      backgroundColor: color,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

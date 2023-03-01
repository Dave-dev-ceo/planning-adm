import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/blocs/Mesas/mesas_bloc.dart';

import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/models/mesa/mesas_model.dart';
import 'package:planning/src/ui/widgets/snackbar_widget/snackbar_widget.dart';

class CrearMesasDialog extends StatefulWidget {
  final int? lastnumMesas;

  const CrearMesasDialog({Key? key, this.lastnumMesas = 1}) : super(key: key);
  @override
  _CrearMesasDialogState createState() => _CrearMesasDialogState();
}

class _CrearMesasDialogState extends State<CrearMesasDialog> {
  final _keyCrearMesas = GlobalKey<FormState>();
  final numeroDeMesas = TextEditingController();
  final numeroDeSillas = TextEditingController();
  late int _lastNumMesas;
  bool isExpanded = true;
  List<TextEditingController> textEditcontrollers = [];
  List<MesaModel> listaMesas = [];
  int? idTipoMesa;

  List<Map<String, dynamic>> listTipoDeMesa = [
    {'name': 'Cuadrada', 'value': 1},
    {'name': 'Redonda', 'value': 2},
    {'name': 'Rectangular', 'value': 3},
    {'name': 'Ovalada', 'value': 4},
    {'name': 'Imperial', 'value': 5},
    {'name': 'En forma U', 'value': 6},
  ];

  @override
  void initState() {
    _lastNumMesas = widget.lastnumMesas! + 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text('Crear mesas'),
        ),
      ),
      body: SingleChildScrollView(
        child: BlocListener<MesasBloc, MesasState>(
          listener: (context, state) {
            if (state is CreatedMesasState) {
              if (state.response == 'Ok') {
                Navigator.of(context)
                    .pop(_lastNumMesas + (int.parse(numeroDeMesas.text) - 1));
                BlocProvider.of<MesasBloc>(context).add(MostrarMesasEvent());
                MostrarAlerta(
                    mensaje: 'Se han creado las mesas correctamente',
                    tipoMensaje: TipoMensaje.correcto);
              } else {
                MostrarAlerta(
                    mensaje: state.response, tipoMensaje: TipoMensaje.error);
              }
            }
          },
          child: Column(
            children: [
              formularioAsignarMesas(size),
              if (listaMesas.isNotEmpty) _saveDataMesas(),
              if (listaMesas.isNotEmpty) _buildFormMesas(size),
            ],
          ),
        ),
      ),
    );
  }

  Align _saveDataMesas() {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: ElevatedButton(
              onPressed: () async {
                await _submit();
              },
              child: const Text(
                'Guardar',
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
        ),
      ),
    );
  }

  _submit() async {
    final mesaBloc = BlocProvider.of<MesasBloc>(context);

    mesaBloc.add(CreateMesasEvent(listaMesas));
  }

  Widget formularioAsignarMesas(Size size) {
    const _padding = EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0);
    return Form(
      key: _keyCrearMesas,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: size.width * 0.8,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              children: [
                ExpansionPanelList(
                  animationDuration: const Duration(milliseconds: 1000),
                  expansionCallback: (int index, bool expanded) {
                    setState(() {
                      if (index == 0) {
                        isExpanded = !isExpanded;
                      } else {}
                    });
                  },
                  children: [
                    ExpansionPanel(
                        headerBuilder: (BuildContext context, bool expanded) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Datos de la mesa',
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            ),
                          );
                        },
                        body: Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButtonFormField(
                                decoration: InputDecoration(
                                    constraints: BoxConstraints(
                                        maxWidth: size.width * 0.2),
                                    prefixIcon: const Icon(Icons.table_chart),
                                    hintText: 'Tipo de mesa'),
                                items: listTipoDeMesa
                                    .map((m) => DropdownMenuItem(
                                          child: Text(m['name']),
                                          value: m['value'],
                                        ))
                                    .toList(),
                                onChanged: (dynamic value) {
                                  setState(() {
                                    idTipoMesa = value;
                                  });
                                },
                                validator: (dynamic value) {
                                  if (value == null) {
                                    return 'El tipo de mesa es necesario';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: _padding,
                              child: TextFormField(
                                controller: numeroDeMesas,
                                decoration: InputDecoration(
                                    constraints: BoxConstraints(
                                        maxWidth: size.width * 0.2),
                                    labelText: 'Número de mesas',
                                    border: const OutlineInputBorder()),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value == '') {
                                    return 'El número de mesas es requerido';
                                  } else {
                                    if (int.parse(value) <= 0) {
                                      return 'El número de mesas no es correcto';
                                    } else {
                                      return null;
                                    }
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: _padding,
                              child: TextFormField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                keyboardType: TextInputType.number,
                                controller: numeroDeSillas,
                                decoration: InputDecoration(
                                    constraints: BoxConstraints(
                                        maxWidth: size.width * 0.2),
                                    labelText: 'Número de sillas por mesa',
                                    border: const OutlineInputBorder()),
                                validator: (value) {
                                  if (value == null || value == '') {
                                    return 'El número de sillas es requerido';
                                  } else {
                                    if (int.parse(value) <= 0) {
                                      return 'El número de sillas no es correcto';
                                    } else {
                                      return null;
                                    }
                                  }
                                },
                              ),
                            ),
                            ConstrainedBox(
                              constraints:
                                  BoxConstraints(maxWidth: size.width * 0.4),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 15),
                                child: Center(
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        await _crearMesas();
                                      },
                                      child: const Text('Crear')),
                                ),
                              ),
                            )
                          ],
                        ),
                        isExpanded: isExpanded)
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormMesas(Size size) {
    Widget listaWidgetsMesas = ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: size.width * 0.6,
        ),
        child: Card(
            child: ListView.builder(
          shrinkWrap: true,
          itemCount: listaMesas.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: listaMesas.elementAt(index).descripcion,
                decoration: const InputDecoration(
                    labelText: 'Nombre de la mesa',
                    border: OutlineInputBorder()),
                onChanged: (value) {
                  listaMesas.elementAt(index).descripcion = value;
                },
              ),
            );
          },
        )));

    return listaWidgetsMesas;
  }

  _crearMesas() async {
    listaMesas.clear();

    int? idEvento = await SharedPreferencesT().getIdEvento();

    setState(() {});
    if (_keyCrearMesas.currentState!.validate()) {
      final numMesas = int.parse(numeroDeMesas.text);
      final numSilla = int.parse(numeroDeSillas.text);
      for (int i = 0; i < numMesas; i++) {
        MesaModel mesa = MesaModel(
          descripcion: 'Mesa ${_lastNumMesas + i}',
          idTipoDeMesa: idTipoMesa,
          numDeMesa: _lastNumMesas + i,
          dimension: numSilla,
          idEvento: idEvento,
        );
        listaMesas.add(mesa);
      }
    } else {}
  }
}

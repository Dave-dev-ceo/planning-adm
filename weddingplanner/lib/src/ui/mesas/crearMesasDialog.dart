import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingplanner/src/blocs/Mesas/mesas_bloc.dart';

import 'package:weddingplanner/src/models/item_model_preferences.dart';
import 'package:weddingplanner/src/models/mesa/mesas_model.dart';

class CrearMesasDialog extends StatefulWidget {
  @override
  _CrearMesasDialogState createState() => _CrearMesasDialogState();
}

class _CrearMesasDialogState extends State<CrearMesasDialog> {
  final _keyCrearMesas = GlobalKey<FormState>();
  final numeroDeMesas = TextEditingController();
  final numeroDeSillas = TextEditingController();
  bool isExpanded = true;
  List<TextEditingController> textEditcontrollers = [];
  List<MesaModel> listaMesas = [];
  int idTipoMesa;

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text('Asignar Mesas a los invitados'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            formularioAsignarMesas(size),
            if (listaMesas.isNotEmpty) _SaveDataMesas(),
            if (listaMesas.isNotEmpty) _buildFormMesas(size),
          ],
        ),
      ),
    );
  }

  Align _SaveDataMesas() {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: ElevatedButton(
              onPressed: () async {
                await _submit();
              },
              child: Text(
                'Guardar',
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
        ),
      ),
    );
  }

  _submit() async {
    final mesaBloc = BlocProvider.of<MesasBloc>(context);

    await mesaBloc.add(CreateMesasEvent(listaMesas));
    mesaBloc.stream.listen((state) {
      if (state is CreatedMesasState) {
        if (state.response == 'Ok') {
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.response),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
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
                  animationDuration: Duration(milliseconds: 1000),
                  expansionCallback: (int index, bool expanded) {
                    setState(() {
                      if (index == 0) {
                        isExpanded = !isExpanded;
                        print(isExpanded);
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
                                'Crear Mesas',
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
                                    prefixIcon: Icon(Icons.table_chart),
                                    hintText: 'Tipo de Mesa'),
                                items: listTipoDeMesa
                                    .map((m) => DropdownMenuItem(
                                          child: Text(m['name']),
                                          value: m['value'],
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    idTipoMesa = value;
                                  });
                                },
                                validator: (value) {
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
                                    labelText: 'Número de Mesas',
                                    border: OutlineInputBorder()),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value == '') {
                                    return 'El número de mesas es requerido';
                                  } else {
                                    if (int.parse(value) <= 0) {
                                      return 'Número de mesas no es correcto';
                                    } else {
                                      return null;
                                    }
                                  }
                                },
                                onChanged: (value) {
                                  if (value != null || value != '') {
                                    numeroDeMesas.text = value;
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
                                    border: OutlineInputBorder()),
                                validator: (value) {
                                  if (value == null || value == '') {
                                    return 'El número de sillas es requerido';
                                  } else {
                                    if (int.parse(value) <= 0) {
                                      return 'Número de sillas no es correcto';
                                    } else {
                                      return null;
                                    }
                                  }
                                },
                                onChanged: (value) {
                                  if (value != null || value != '') {
                                    numeroDeSillas.text = value;
                                  }
                                },
                              ),
                            ),
                            ConstrainedBox(
                              constraints:
                                  BoxConstraints(maxWidth: size.width * 0.4),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 15),
                                child: Center(
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        await _crearMesas();
                                      },
                                      child: Text('Crear')),
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
            return ExpansionTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: listaMesas.elementAt(index).descripcion,
                  decoration: InputDecoration(
                      labelText: 'Nombre de la mesa',
                      border: OutlineInputBorder()),
                  onChanged: (value) {
                    listaMesas.elementAt(index).descripcion = value;
                  },
                ),
              ),
              children: List.generate(
                  listaMesas.elementAt(index).dimension,
                  (index) => Padding(
                        padding: EdgeInsets.all(10.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Silla ${index + 1}',
                              border: OutlineInputBorder()),
                        ),
                      )),
            );
          },
        )));

    return listaWidgetsMesas;
  }

  _crearMesas() async {
    listaMesas.clear();

    int idEvento = await SharedPreferencesT().getIdEvento();

    setState(() {});
    if (_keyCrearMesas.currentState.validate()) {
      final numMesas = int.parse(numeroDeMesas.text);
      final numSilla = int.parse(numeroDeSillas.text);
      for (int i = 0; i < numMesas; i++) {
        MesaModel mesa = MesaModel(
          descripcion: 'Mesa ${i + 1}',
          idTipoDeMesa: idTipoMesa,
          numDeMesa: i + 1,
          dimension: numSilla,
          idEvento: idEvento,
        );
        listaMesas.add(mesa);
      }
    } else {
      print('Los Campos son ncesarios');
    }
  }
}

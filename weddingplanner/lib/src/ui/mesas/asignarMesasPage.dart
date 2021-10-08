import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AsignarMesasPage extends StatefulWidget {
  @override
  _AsignarMesasPageState createState() => _AsignarMesasPageState();
}

class _AsignarMesasPageState extends State<AsignarMesasPage> {
  final _keyCrearMesas = GlobalKey<FormState>();
  final numeroDeMesas = TextEditingController();
  final numeroDeSillas = TextEditingController();
  bool isExpanded = true;
  List<Map<String, dynamic>> listMesas = [];
  List<TextEditingController> textEditcontrollers = [];
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
            if (listMesas.isNotEmpty) _buildFormMesas(size),
            if (listMesas.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: ElevatedButton(
                      onPressed: () {
                        print('Guardando...');
                      },
                      child: Text(
                        'Guardar',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget formularioAsignarMesas(Size size) {
    const _padding = EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0);
    return Form(
      key: _keyCrearMesas,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: size.width * 0.6,
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
                              ),
                            ),
                            Padding(
                              padding: _padding,
                              child: TextFormField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
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
                                      onPressed: () {
                                        _crearMesas();
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
    final numMesas = int.parse(numeroDeMesas.text);
    final numSilla = int.parse(numeroDeSillas.text);

    List<Widget> listaWidgetSillas = [];

    // for (var i = 0; i < int.parse(numeroDeSillas.text); i++) {
    //   TextEditingController textEditCtrl = TextEditingController();
    //   textEditCtrl.text = 'Silla $i';
    //   listaWidgetSillas.add(Expanded(
    //     child: Padding(
    //       padding: const EdgeInsets.all(8.0),
    //       child: TextFormField(
    //         controller: textEditCtrl,
    //         decoration: InputDecoration(
    //             labelText: 'Silla $i',
    //             constraints: BoxConstraints(),
    //             border: OutlineInputBorder()),
    //       ),
    //     ),
    //   ));
    //   textEditcontrollers.add(textEditCtrl);
    // }

    Widget listaWidgetsMesas = ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: size.width * 0.6,
        ),
        child: Card(
            child: ListView.builder(
          shrinkWrap: true,
          itemCount: numMesas,
          itemBuilder: (context, index) {
            TextEditingController textEditCtrl =
                TextEditingController(text: 'Mesa ${index + 1}');

            return ExpansionTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: textEditCtrl,
                  decoration: InputDecoration(
                      labelText: 'Nombre de la mesa',
                      border: OutlineInputBorder()),
                ),
              ),
              children: List.generate(
                  numSilla,
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

  _crearMesas() {
    if (_keyCrearMesas.currentState.validate()) {
      List listmesas =
          List.generate(int.parse(numeroDeMesas.text), (index) => index);
      List listsillas =
          List.generate(int.parse(numeroDeSillas.text), (index) => null);

      listmesas.forEach((index) {
        Map<String, dynamic> mesa = {};
        mesa['nameofMesa'] = 'Mesa${index + 1}';
        mesa['sillas'] = listsillas;
        print(mesa['nameofMesa']);
        listMesas.add(mesa);
      });

      listMesas.forEach((element) {
        element.forEach((key, value) {
          print('$key == $value');
        });
      });
      setState(() {});
    } else {
      print('Los Campos son ncesarios');
    }
  }
}

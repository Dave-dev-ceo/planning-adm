import 'dart:math';

import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/mult_select_dialog.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:weddingplanner/src/models/item_model_servicios.dart';
import 'package:weddingplanner/src/ui/proveedores/servicios.dart';
import 'package:weddingplanner/src/ui/widgets/text_form_filed/text_form_filed.dart';

class Proveedores extends StatefulWidget {
  const Proveedores({Key key}) : super(key: key);
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => Proveedores(),
      );
  @override
  _ProveedoresState createState() => _ProveedoresState();
}

class _ProveedoresState extends State<Proveedores> {
  Map<String, dynamic> json = {
    'nombre': 'ffffffff',
    'descripcion': 'gfgfhfghfg',
  };

  //   int id_servicio;
  // String nombre;
  static List<ServiciosModel> _optItem = [
    ServiciosModel(id_servicio: 0, nombre: 'Servicio 1'),
    ServiciosModel(id_servicio: 0, nombre: 'Servicio 2'),
    ServiciosModel(id_servicio: 0, nombre: 'Servicio 3'),
    ServiciosModel(id_servicio: 0, nombre: 'Servicio 4')
  ];
  final _items = _optItem
      .map((animal) => MultiSelectItem<ServiciosModel>(animal, animal.nombre))
      .toList();
  List<ServiciosModel> _selectedAnimals = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: IndexedStack(
        index: _selectedIndex,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Card(
                  color: Colors.white,
                  elevation: 12,
                  shadowColor: Colors.black12,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: <Widget>[
                      Wrap(
                        alignment: WrapAlignment.center,
                        children: <Widget>[
                          TextFormFields(
                            icon: Icons.local_activity,
                            item: TextFormField(
                              decoration: new InputDecoration(
                                labelText: 'Nombre',
                              ),
                            ),
                            large: 400.0,
                            ancho: 80.0,
                          ),
                          TextFormFields(
                            icon: Icons.drive_file_rename_outline,
                            item: TextFormField(
                              decoration: new InputDecoration(
                                labelText: 'Descripción',
                              ),
                            ),
                            large: 400.0,
                            ancho: 80.0,
                          )
                        ],
                      ),
                      Wrap(
                        alignment: WrapAlignment.center,
                        children: <Widget>[
                          TextFormFields(
                              icon: Icons.select_all,
                              item: MultiSelectDialogField(
                                buttonText: Text('Servicios'),
                                title: Text('Servicios'),
                                items: _items,
                                initialValue: _selectedAnimals,
                                onConfirm: (values) {},
                              ),
                              large: 400.0,
                              ancho: 80.0),
                          TextFormFields(
                            icon: Icons.drive_file_rename_outline,
                            item: TextFormField(
                              decoration: new InputDecoration(
                                labelText: 'Descripción',
                              ),
                            ),
                            large: 400.0,
                            ancho: 80.0,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Servicios()
        ],
      )),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.attribution),
            label: 'Proveedores',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sell),
            label: 'Servicios',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int _selectedIndex = 0;
}

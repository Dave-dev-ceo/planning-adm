import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingplanner/src/blocs/proveedores/proveedor_bloc.dart';
import 'package:weddingplanner/src/blocs/servicios/bloc/servicios_bloc_dart_bloc.dart';
import 'package:weddingplanner/src/models/item_model_preferences.dart';
import 'package:weddingplanner/src/models/item_model_proveedores.dart';
import 'package:weddingplanner/src/models/item_model_servicios.dart';
import 'package:weddingplanner/src/ui/widgets/text_form_filed/text_form_filed.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class FullScreenDialogAgregarProveedorEvent extends StatefulWidget {
  final Map<String, dynamic> proveedor;
  const FullScreenDialogAgregarProveedorEvent(
      {Key key, @required this.proveedor})
      : super(key: key);

  @override
  _FullScreenDialogAgregarProveedorEvent createState() =>
      _FullScreenDialogAgregarProveedorEvent(proveedor);
}

class _FullScreenDialogAgregarProveedorEvent
    extends State<FullScreenDialogAgregarProveedorEvent> {
  final Map<String, dynamic> proveedor;
  _FullScreenDialogAgregarProveedorEvent(this.proveedor);
  SharedPreferencesT _sharedPreferences = new SharedPreferencesT();
  GlobalKey<FormState> keyForm = new GlobalKey();
  ItemModelProveedores itemProveedores;
  ProveedorBloc proveedorBloc;

  var _items;
  static List<ServiciosModel> _optItem = [];
  List<ServiciosModel> _selectedServicios = [];
  // Text para forms lista.
  TextEditingController nombreCtrl = new TextEditingController();
  TextEditingController descripcionCtrl = new TextEditingController();

  @override
  void initState() {
    proveedorBloc = BlocProvider.of<ProveedorBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Proveedor'),
        actions: [],
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(child: Container(
        child: BlocBuilder<ServiciosBloc, ServiciosState>(
            builder: (context, state) {
          if (state is LoadingServiciosState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is MostrarServiciosState) {
            this._items = [];
            _optItem = [];
            for (var opt in state.listServicios.results) {
              print(opt.nombre);
              _optItem.add(ServiciosModel(
                  id_servicio: opt.id_servicio, nombre: opt.nombre));
            }
            this._items = _optItem
                .map((servicio) =>
                    MultiSelectItem<ServiciosModel>(servicio, servicio.nombre))
                .toList();
            return _formInit();
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }),
      )),
    );
  }

  Widget _formInit() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Card(
            color: Colors.white,
            elevation: 12,
            shadowColor: Colors.black12,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: new Form(
                key: keyForm,
                child: Column(
                  children: <Widget>[
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: <Widget>[
                        TextFormFields(
                          icon: Icons.local_activity,
                          item: TextFormField(
                            controller: nombreCtrl,
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
                            controller: descripcionCtrl,
                            decoration: new InputDecoration(
                              labelText: 'Descripción',
                            ),
                          ),
                          large: 400.0,
                          ancho: 80.0,
                        ),
                        TextFormFields(
                          icon: Icons.select_all,
                          item: MultiSelectDialogField(
                            buttonText: Text('Servicios'),
                            title: Text('Servicios'),
                            confirmText: Text('Aceptar'),
                            cancelText: Text('Cancelar'),
                            items: _items,
                            initialValue: _selectedServicios,
                            onConfirm: (values) {
                              _selectedServicios = values;
                            },
                          ),
                          large: 400.0,
                          // ancho: 80.0
                        )
                      ],
                    ),
                    Ink(
                      padding: EdgeInsets.all(5),
                      width: 100.0,
                      decoration: const ShapeDecoration(
                        color: Colors.black,
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.save),
                        color: Colors.white,
                        onPressed: () async {
                          // keyForm.currentState.reset();
                          print(_selectedServicios.length);
                          if (_selectedServicios.length > 0) {
                            Navigator.of(context).pop();
                            Map<String, dynamic> json =
                                await _jsonAgregarProveedor(context);
                            await proveedorBloc.add(
                                CreateProveedorEvent(json, itemProveedores));
                            final snackBar = SnackBar(
                              content: Container(
                                height: 30,
                                child: Center(
                                  child: Text(
                                      'EL proveedor se agrego correctamente.'),
                                ),
                              ),
                              backgroundColor: Colors.green,
                            );
                            await ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            await ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                action: SnackBarAction(
                                  label: 'Action',
                                  onPressed: () {
                                    // Code to execute.
                                  },
                                ),
                                content: const Text(
                                    'Es necessario seleccionar al menos un servicio.'),
                                duration: const Duration(milliseconds: 2000),
                                width: 290.0, // Width of the SnackBar.
                                padding: const EdgeInsets.symmetric(
                                  horizontal:
                                      8.0, // Inner padding for SnackBar content.
                                ),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }

  // Agregar Lista.
  Future<Map<String, dynamic>> _jsonAgregarProveedor(
      BuildContext context) async {
    List datosServ = [];
    int id_planner = await _sharedPreferences.getIdPlanner();
    _selectedServicios.forEach((element) {
      datosServ.add([element.id_servicio, id_planner]);
    });

    Map<String, dynamic> json = {
      'nombre': nombreCtrl.text,
      'descripcion': descripcionCtrl.text,
      'servicios': datosServ
    };
    return json;
  }
}

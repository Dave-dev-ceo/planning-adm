// ignore_for_file: missing_required_param, no_logic_in_create_state

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/blocs/proveedores/proveedor_bloc.dart';
import 'package:planning/src/blocs/servicios/bloc/servicios_bloc_dart_bloc.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/models/item_model_proveedores.dart';
import 'package:planning/src/models/item_model_servicios.dart';
import 'package:planning/src/resources/config_conection.dart';
import 'package:planning/src/ui/widgets/snackbar_widget/snackbar_widget.dart';
import 'package:planning/src/ui/widgets/text_form_filed/text_form_filed.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

ConfigConection _configC = ConfigConection();
SharedPreferencesT _sharedPreferences = SharedPreferencesT();
Client client = Client();

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
  GlobalKey<FormState> keyForm = GlobalKey();
  ItemModelProveedores itemProveedores;
  ProveedorBloc proveedorBloc;

  List<MultiSelectItem<ServiciosModel>> _items;
  static List<ServiciosModel> _optItem = [];
  List<ServiciosModel> _selectedServicios = [];
  // Text para forms lista.
  TextEditingController nombreCtrl = TextEditingController();
  TextEditingController descripcionCtrl = TextEditingController();

  Future<List<Territorio>> peticionPaises;
  Future<List<Territorio>> peticionEstados;
  Future<List<Territorio>> peticionCiudades;

  int idPais;
  int idEstado;
  int idCiudad;

  @override
  void initState() {
    proveedorBloc = BlocProvider.of<ProveedorBloc>(context);
    peticionPaises = getPaises();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar proveedor'),
        actions: const [],
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(child:
          BlocBuilder<ServiciosBloc, ServiciosState>(builder: (context, state) {
        if (state is LoadingServiciosState) {
          return const Center(child: LoadingCustom());
        } else if (state is MostrarServiciosState) {
          _items = [];
          _optItem = [];
          for (var opt in state.listServicios.results) {
            _optItem.add(
                ServiciosModel(idServicio: opt.idServicio, nombre: opt.nombre));
          }
          _items = _optItem
              .map((servicio) =>
                  MultiSelectItem<ServiciosModel>(servicio, servicio.nombre))
              .toList();
          return _formInit();
        } else {
          return const Center(child: LoadingCustom());
        }
      })),
    );
  }

  Widget _formInit() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Card(
            color: Colors.white,
            elevation: 12,
            shadowColor: Colors.black12,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Form(
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
                            decoration: const InputDecoration(
                              labelText: 'Nombre',
                            ),
                          ),
                          large: 520.0,
                          ancho: 90.0,
                        ),
                        TextFormFields(
                          icon: Icons.drive_file_rename_outline,
                          item: TextFormField(
                            controller: descripcionCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Descripción',
                            ),
                          ),
                          large: 520.0,
                          ancho: 90.0,
                        ),
                        Expanded(
                          child: TextFormFields(
                            icon: Icons.select_all,
                            item: MultiSelectDialogField<ServiciosModel>(
                              chipDisplay: MultiSelectChipDisplay(),
                              buttonText: const Text('Servicios'),
                              title: const Text('Servicios'),
                              confirmText: const Text('Aceptar'),
                              cancelText: const Text('Cancelar'),
                              items: _items,
                              initialValue: _selectedServicios,
                              onConfirm: (values) {
                                _selectedServicios = values;
                              },
                            ),
                            large: 520.0,
                          ),
                        ),
                        TextFormFields(
                          icon: Icons.flag,
                          item: FutureBuilder(
                            future: peticionPaises,
                            builder: (context,
                                AsyncSnapshot<List<Territorio>> snapshot) {
                              if (snapshot.hasData) {
                                final paises = snapshot.data;
                                return DropdownButtonFormField<int>(
                                  isExpanded: true,
                                  onChanged: (value) => setState(() {
                                    if (idPais != value) idEstado = null;
                                    idPais = value;
                                    peticionEstados = getEstados(value);
                                  }),
                                  value: idPais,
                                  decoration: const InputDecoration(
                                      label: Text('País')),
                                  items: paises
                                      .map((p) => DropdownMenuItem<int>(
                                            child: Text(p.nombre),
                                            value: p.id,
                                          ))
                                      .toList(),
                                );
                              }

                              return const LinearProgressIndicator();
                            },
                          ),
                          large: 520.0,
                          ancho: 90.0,
                        ),
                        if (idPais != null)
                          TextFormFields(
                            icon: Icons.map,
                            item: FutureBuilder(
                              future: peticionEstados,
                              builder: (context,
                                  AsyncSnapshot<List<Territorio>> snapshot) {
                                if (snapshot.hasData) {
                                  final estados = snapshot.data;
                                  return DropdownButtonFormField<int>(
                                    isExpanded: true,
                                    value: idEstado,
                                    onChanged: (value) => setState(() {
                                      if (idEstado != value) idCiudad = null;
                                      idEstado = value;
                                      peticionCiudades = getCiudades(value);
                                    }),
                                    decoration: const InputDecoration(
                                        label: Text('Estado')),
                                    items: estados
                                        .map((e) => DropdownMenuItem(
                                              child: Text(e.nombre),
                                              value: e.id,
                                            ))
                                        .toList(),
                                  );
                                }
                                return const LinearProgressIndicator();
                              },
                            ),
                            large: 520.0,
                            ancho: 90.0,
                          ),
                        if (idEstado != null)
                          TextFormFields(
                            icon: Icons.location_city,
                            item: FutureBuilder(
                              future: peticionCiudades,
                              builder: (context,
                                  AsyncSnapshot<List<Territorio>> snapshot) {
                                if (snapshot.hasData) {
                                  final ciudades = snapshot.data;
                                  return DropdownButtonFormField<int>(
                                    isExpanded: true,
                                    value: idCiudad,
                                    onChanged: (value) => idCiudad = value,
                                    decoration: const InputDecoration(
                                        label: Text('Ciudad')),
                                    items: ciudades
                                        .map((c) => DropdownMenuItem(
                                              child: Text(c.nombre),
                                              value: c.id,
                                            ))
                                        .toList(),
                                  );
                                }
                                return const LinearProgressIndicator();
                              },
                            ),
                            large: 520.0,
                            ancho: 90.0,
                          ),
                      ],
                    ),
                    Ink(
                      padding: const EdgeInsets.all(5),
                      width: 100.0,
                      decoration: const ShapeDecoration(
                        color: Colors.black,
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.save),
                        color: Colors.white,
                        onPressed: () async {
                          if (idPais == null) {
                            return MostrarAlerta(
                                mensaje: 'Es necesario seleccionar un país.',
                                tipoMensaje: TipoMensaje.advertencia);
                          } else if (idEstado == null) {
                            return MostrarAlerta(
                                mensaje: 'Es necesario seleccionar un estado.',
                                tipoMensaje: TipoMensaje.advertencia);
                          } else if (idEstado == null) {
                            return MostrarAlerta(
                                mensaje: 'Es necesario seleccionar una ciudad.',
                                tipoMensaje: TipoMensaje.advertencia);
                          } else if (_selectedServicios.isEmpty) {
                            return MostrarAlerta(
                                mensaje:
                                    'Es necesario seleccionar al menos un servicio.',
                                tipoMensaje: TipoMensaje.advertencia);
                          }
                          Map<String, dynamic> json =
                              await _jsonAgregarProveedor(context);
                          proveedorBloc
                              .add(CreateProveedorEvent(json, itemProveedores));
                          MostrarAlerta(
                              mensaje: 'El proveedor se agrego correctamente.',
                              tipoMensaje: TipoMensaje.correcto);
                          Navigator.of(context).pop();
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
    int idPlanner = await _sharedPreferences.getIdPlanner();
    for (var element in _selectedServicios) {
      datosServ.add([element.idServicio, idPlanner]);
    }

    Map<String, dynamic> json = {
      'nombre': nombreCtrl.text,
      'descripcion': descripcionCtrl.text,
      'servicios': datosServ,
      'idCiudad': idCiudad,
    };
    return json;
  }
}

class Territorio {
  int id;
  String nombre;

  Territorio({this.id, this.nombre});

  Territorio.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nombre = json['name'];
}

Future<List<Territorio>> getPaises() async {
  String token = await _sharedPreferences.getToken();

  const endpoint = '/wedding/CIUDADES/getPaises';

  final headers = {
    HttpHeaders.authorizationHeader: token,
    'content-type': 'application/json',
    'accept': 'application/json'
  };

  final response = await client.post(
    Uri.parse(_configC.url + _configC.puerto + endpoint),
    headers: headers,
  );

  List<Territorio> paises = [];
  if (response.statusCode == 200) {
    paises = List<Territorio>.from(
        json.decode(response.body).map((e) => Territorio.fromJson(e)));
    return paises;
  }
  return paises;
}

Future<List<Territorio>> getEstados(int idPais) async {
  String token = await _sharedPreferences.getToken();

  const endpoint = '/wedding/CIUDADES/getEstados';

  final data = {'idPais': idPais};

  final headers = {
    HttpHeaders.authorizationHeader: token,
    'content-type': 'application/json',
    'accept': 'application/json'
  };

  final response = await client.post(
    Uri.parse(_configC.url + _configC.puerto + endpoint),
    body: json.encode(data),
    headers: headers,
  );

  List<Territorio> estados = [];
  if (response.statusCode == 200) {
    estados = List<Territorio>.from(
        json.decode(response.body).map((e) => Territorio.fromJson(e)));
    return estados;
  }
  return estados;
}

Future<List<Territorio>> getCiudades(int idEstado) async {
  String token = await _sharedPreferences.getToken();

  const endpoint = '/wedding/CIUDADES/getCiudades';

  final data = {'idEstado': idEstado};

  final headers = {
    HttpHeaders.authorizationHeader: token,
    'content-type': 'application/json',
    'accept': 'application/json'
  };

  final response = await client.post(
    Uri.parse(_configC.url + _configC.puerto + endpoint),
    body: json.encode(data),
    headers: headers,
  );

  List<Territorio> ciudades = [];
  if (response.statusCode == 200) {
    ciudades = List<Territorio>.from(
        json.decode(response.body).map((e) => Territorio.fromJson(e)));
    return ciudades;
  }
  return ciudades;
}

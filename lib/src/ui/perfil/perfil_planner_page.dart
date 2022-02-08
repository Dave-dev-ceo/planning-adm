// ignore_for_file: unused_field, unused_element

import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/blocs/perfil/perfil_bloc.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/models/perfil/perfil_planner_model.dart';
import 'package:planning/src/ui/widgets/snackbar_widget/snackbar_widget.dart';

class PerfilPlannerPage extends StatefulWidget {
  const PerfilPlannerPage({Key key}) : super(key: key);

  @override
  _PerfilPlannerPageState createState() => _PerfilPlannerPageState();
}

class _PerfilPlannerPageState extends State<PerfilPlannerPage> {
  final _formPlannerKey = GlobalKey<FormState>();
  final SharedPreferencesT _sharedPreferences = SharedPreferencesT();

  PerfilBloc perfilBloc;

  @override
  void initState() {
    perfilBloc = BlocProvider.of<PerfilBloc>(context);
    perfilBloc.add(PerfilPlannerEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar perfil planner'),
      ),
      body: BlocBuilder<PerfilBloc, PerfilState>(builder: (context, state) {
        if (state is PerfilPlannerState) {
          return buildPerfilPlanner(state.perfilPlanner);
        } else {
          return const Center(
            child: LoadingCustom(),
          );
        }
      }),
    );
  }

  Widget buildPerfilPlanner(PerfilPlannerModel data) {
    PerfilPlannerModel perfil = data;
    Uint8List image = base64Decode(perfil.logo);
    return Form(
      key: _formPlannerKey,
      child: Container(
        color: Colors.white,
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 15.0,
                ),
                Center(
                  child: Text(
                    'Datos del planner',
                    style: Theme.of(context).textTheme.headline5,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: perfil.nombreCompleto,
                    decoration: InputDecoration(
                      hintText: 'Nombre Completo',
                      labelText: 'Nombre',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    onChanged: (value) {
                      perfil.nombreCompleto = value;
                    },
                    validator: (value) {
                      if (value.isEmpty && value.length < 7) {
                        return 'Campo requerido con 8 caracteres.';
                      } else {
                        return null;
                      }
                    },
                    maxLength: 50,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: perfil.correo,
                    maxLength: 250,
                    decoration: InputDecoration(
                      hintText: 'Correo electrónico',
                      labelText: 'Correo electrónico',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    readOnly: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: perfil.telefono,
                    maxLength: 250,
                    decoration: InputDecoration(
                      hintText: 'Teléfono',
                      labelText: 'Teléfono',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    onChanged: (value) {
                      perfil.telefono = value;
                    },
                    validator: (value) {
                      if (_validaPhone(value)) {
                        return null;
                      } else {
                        return 'Es requerido un número de teléfono valido con 10 dígitos.';
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: perfil.nombreDeLaEmpresa,
                    maxLength: 250,
                    decoration: InputDecoration(
                      hintText: 'Nombre de la empresa',
                      labelText: 'Nombre de la empresa',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    onChanged: (value) {
                      perfil.nombreDeLaEmpresa = value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: perfil.direccion,
                    maxLength: 250,
                    decoration: InputDecoration(
                      hintText: 'Dirección',
                      labelText: 'Dirección',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    onChanged: (value) {
                      perfil.direccion = value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                          child: Container(
                        height: 100.0,
                        width: 100.0,
                        color: Colors.black,
                        child: perfil.logo == null
                            ? Image.asset('assets/user.png')
                            : Container(
                                width: 1100,
                                height: 900,
                                color: Colors.white,
                                child: Image.memory(
                                  image,
                                ),
                              ),
                      )),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ElevatedButton(
                          child: const Text('Agregar imagen'),
                          onPressed: () async {
                            perfil.logo = await _addImagePlanner();
                            image = base64Decode(perfil.logo);
                            setState(() {});
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: const Text('Guardar'),
                    onPressed: () async {
                      if (_formPlannerKey.currentState.validate()) {
                        perfilBloc.add(EditPerfilPlannerEvent(perfil));

                        perfilBloc.stream.listen((state) {
                          if (state is PerfilPlannerEditadoState) {
                            if (state.message == 'Ok') {
                              MostrarAlerta(
                                  mensaje:
                                      'Los Datos se editaron correctamente',
                                  tipoMensaje: TipoMensaje.correcto);
                            } else {
                              MostrarAlerta(
                                  mensaje: state.message,
                                  tipoMensaje: TipoMensaje.error);
                            }
                          }
                        });
                      }
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  bool _validaEmail(String txt) {
    bool temp = false;

    // expresion regular
    RegExp validaEmail = RegExp(
        r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");

    if (validaEmail.hasMatch(txt)) temp = true;

    return temp;
  }

  Future<String> _addImagePlanner() async {
    const extensiones = ['jpg', 'png', 'jpeg'];

    FilePickerResult pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      withData: true,
      allowedExtensions: extensiones,
      allowMultiple: false,
    );

    final bytes = pickedFile.files.single.bytes;
    return base64.encode(bytes);
  }

  bool _validaPhone(String txt) {
    bool temp = false;

    // exp regular
    RegExp validaPhone = RegExp(r"^[\d]{10,10}$");

    if (validaPhone.hasMatch(txt)) temp = true;

    return temp;
  }
}

// ignore_for_file: unused_import, unused_element

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:planning/src/animations/loading_animation.dart';

import 'package:planning/src/blocs/perfil/perfil_bloc.dart';
import 'package:planning/src/logic/login_logic.dart';
import 'package:planning/src/models/eventoModel/evento_resumen_model.dart';
import 'package:planning/src/models/item_model_perfil.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/resources/api_provider.dart';
import 'package:planning/src/ui/widgets/snackbar_widget/snackbar_widget.dart';
import 'package:planning/src/ui/widgets/text_form_filed/password_wplanner.dart';
import 'package:responsive_grid/responsive_grid.dart';

class Perfil extends StatefulWidget {
  const Perfil({Key key}) : super(key: key);

  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  // variables bloc
  PerfilBloc perfilBloc;
  ItemModelPerfil item;

  // variables de la classe
  final SharedPreferencesT _sharedPreferences = SharedPreferencesT();
  String portada = '';
  String claveRol = '';
  final _formKey = GlobalKey<FormState>();

  ApiProvider logicApi = ApiProvider();

  _Perfil perfil;
  bool _isInvolucrado = false;

  @override
  void initState() {
    super.initState();
    perfilBloc = BlocProvider.of<PerfilBloc>(context);
    perfilBloc.add(SelectPerfilEvent());
    checkIsInvolucrado();
    getPortadaImage();
  }

  getPortadaImage() async {
    portada = await _sharedPreferences.getPortada();
    claveRol = await _sharedPreferences.getClaveRol();
    setState(() {});
  }

  checkIsInvolucrado() async {
    final idInvolucrado = await SharedPreferencesT().getIdInvolucrado();

    if (idInvolucrado != null) {
      setState(() {
        _isInvolucrado = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Perfil del usuario'),
        ),
        body: BlocBuilder<PerfilBloc, PerfilState>(
          builder: (context, state) {
            if (state is PerfilInitial) {
              return const Center(
                child: LoadingCustom(),
              );
            } else if (state is PerfilLogging) {
              return const Center(
                child: LoadingCustom(),
              );
            } else if (state is PerfilSelect) {
              if (state.perfil != null) {
                if (item != state.perfil) {
                  item = state.perfil;
                  if (item != null) {
                    perfil = _Perfil(
                      names: state.perfil.perfil[0].nombreCompleto,
                      phone: state.perfil.perfil[0].telefono,
                      email: state.perfil.perfil[0].correo,
                      clave: '',
                      repit: '',
                      image: state.perfil.perfil[0].imagen,
                    );
                  }
                }
              } else {
                perfilBloc.add(SelectPerfilEvent());
                return const Center(child: LoadingCustom());
              }
              if (perfil != null) {
                return _showPerfil();
              } else {
                return const Center(child: Text('Sin datos'));
              }
            } else if (state is PerfilUpdate) {
              if (state.perfil.perfil != null) {
                perfil = _Perfil(
                  names: state.perfil.perfil[0].nombreCompleto,
                  phone: state.perfil.perfil[0].telefono,
                  email: state.perfil.perfil[0].correo,
                  clave: '',
                  repit: '',
                  image: state.perfil.perfil[0].imagen,
                );
              }
              return _showPerfil();
            } else {
              return const Center(
                child: LoadingCustom(),
              );
            }
          },
        )
        //_showPerfil(),
        );
  }

  _showPerfil() {
    return Form(
      key: _formKey,
      child: Container(
        color: Colors.white,
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: TextEditingController(text: perfil.names),
                    maxLength: 50,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person),
                      hintText: 'Nombre completo:',
                      labelText: 'Nombre',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty && value.length < 7) {
                        return 'Campo requerido con 8 caracteres';
                      }
                      return null;
                    },
                    onChanged: (valor) => perfil.names = valor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    readOnly: true,
                    controller: TextEditingController(text: perfil.email),
                    maxLength: 250,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email),
                      hintText: 'Correo electrónico:',
                      labelText: 'Correo electrónico',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    validator: (value) {
                      if (!_validaEmail(value)) {
                        return 'Es nesesario un correo electrónico valido';
                      }
                      return null;
                    },
                    onChanged: (valor) => perfil.email = valor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    // ignore: unnecessary_string_interpolations
                    controller: TextEditingController(text: '${perfil.phone}'),
                    maxLength: 10,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.phone),
                      hintText: 'Teléfono:',
                      labelText: 'Teléfono',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    validator: (value) {
                      if (!_validaPhone(value)) {
                        return 'Es requerido un número de teléfono valido con 10 dígitos';
                      }
                      return null;
                    },
                    onChanged: (valor) => perfil.phone = valor,
                  ),
                ),
                if (claveRol != 'INVO')
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                              child: SizedBox(
                            height: 100.0,
                            width: 100.0,
                            child: perfil.image == null
                                ? const FittedBox(
                                    fit: BoxFit.cover,
                                    child: ClipRect(
                                        child: FaIcon(FontAwesomeIcons.user)))
                                : Container(
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: MemoryImage(
                                              base64Decode(perfil.image)),
                                        )),
                                  ),
                          )),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: ElevatedButton(
                              child: const Text('Agregar imagen'),
                              onPressed: () => _addImage(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (context) =>
                                  const CambiarContrasenaDialog());
                        },
                        child: const Text('Cambiar contraseña')),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            child: const Text('Guardar'),
                            onPressed: () {
                              // It returns true if the form is valid, otherwise returns false
                              if (_formKey.currentState.validate()) {
                                // If the form is valid, display a Snackbar.
                                MostrarAlerta(
                                    mensaje: 'Guardando cambios',
                                    tipoMensaje: TipoMensaje.correcto);
                                _guardarPerfil();
                              }
                            },
                          )),
                    ],
                  ),
                ),
                if (claveRol == 'INVO') const Divider(),
                if (claveRol == 'INVO')
                  Center(
                    child: Text(
                      'Portada',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                if (claveRol == 'INVO')
                  Center(
                    child: GestureDetector(
                      onTap: changePortadaImage,
                      child: Tooltip(
                        message: 'Cambiar portada',
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                              height: 200,
                              width: 400,
                              child: (portada != '')
                                  ? Image.memory(
                                      base64Decode(portada),
                                      fit: BoxFit.cover,
                                    )
                                  : const Image(
                                      image: AssetImage(
                                        'portada.jpg',
                                      ),
                                      fit: BoxFit.cover,
                                    )),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // add image
  _addImage() async {
    const extensiones = ['jpg', 'png', 'jpeg'];

    FilePickerResult pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      withData: true,
      allowedExtensions: extensiones,
      allowMultiple: false,
    );

    if (pickedFile != null) {
      for (var archivo in pickedFile.files) {
        final kb = pickedFile.files.single.size / 1024;

        final mb = kb / 1024;
        if (mb < 4) {
          setState(() => perfil.image = base64.encode(archivo.bytes));
        } else {
          MostrarAlerta(
              mensaje: 'El archivo debe pesar menos de 4 megabytes',
              tipoMensaje: TipoMensaje.advertencia);
        }
      }
    }
  }

  changePortadaImage() async {
    const extensiones = ['jpg', 'png', 'jpeg'];

    FilePickerResult pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      withData: true,
      allowedExtensions: extensiones,
      allowMultiple: false,
    );

    if (pickedFile != null) {
      final file = pickedFile.files.single.bytes;
      String newPortada = base64Encode(file);
      final kb = pickedFile.files.single.size / 1024;

      final mb = kb / 1024;
      if (mb < 4) {
        setState(() {
          portada = newPortada;
        });

        final statusCode = await logicApi.updatePortadaEvento(newPortada);

        if (statusCode == 200) {
          _sharedPreferences.setPortada(newPortada);
          MostrarAlerta(
              mensaje: 'Se ha editado la foto de portada',
              tipoMensaje: TipoMensaje.correcto);
        } else {
          MostrarAlerta(
              mensaje: 'Ocurrió un error al subir la imagen',
              tipoMensaje: TipoMensaje.error);
        }
      } else {
        MostrarAlerta(
            mensaje: 'El archivo debe pesar menos de 4 megabytes',
            tipoMensaje: TipoMensaje.advertencia);
      }
    } else {
      MostrarAlerta(
          mensaje: 'No seleccionó una imagen',
          tipoMensaje: TipoMensaje.advertencia);
    }
  }

  // ini validaciones

  // valida cadena con mayusculas, minusculas, numeros, simbolos y de 8 caracteres
  bool _validaPsw(String txt) {
    bool temp = false;

    // filtros
    bool mayusculas = false;
    bool minusculas = false;
    bool numeros = false;
    bool simbolos = false;

    // expresiones regulares
    RegExp validaMayusculas = RegExp(r'[A-Z]');
    RegExp validaMinusculas = RegExp(r'[a-z]');
    RegExp validaNumeros = RegExp(r'[\d]');
    RegExp validaSimbolos = RegExp(r'[^A-Za-z\d]');

    // validaciones
    if (validaMayusculas.hasMatch(txt)) mayusculas = true;
    if (validaMinusculas.hasMatch(txt)) minusculas = true;
    if (validaNumeros.hasMatch(txt)) numeros = true;
    if (validaSimbolos.hasMatch(txt)) simbolos = true;

    if (txt.length > 7 && mayusculas && minusculas && numeros && simbolos) {
      temp = true;
    }

    return temp;
  }

  // valida email
  bool _validaEmail(String txt) {
    bool temp = false;

    // expresion regular
    RegExp validaEmail = RegExp(
        r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");

    if (validaEmail.hasMatch(txt)) temp = true;

    return temp;
  }

  // valida telefono
  bool _validaPhone(String txt) {
    bool temp = false;

    // exp regular
    RegExp validaPhone = RegExp(r"^[\d]{10,10}$");

    if (validaPhone.hasMatch(txt)) temp = true;

    return temp;
  }

  // fin validaciones

  // evento - guardar
  void _guardarPerfil() {
    perfilBloc.add(InsertPerfilEvent(perfil));
  }

  // reset
  void _checkSession() async {
    bool sesion = await _sharedPreferences.getSession();
    int involucrado = await _sharedPreferences.getIdInvolucrado();
    int idEvento = await _sharedPreferences.getIdEvento();
    String titulo = await _sharedPreferences.getEventoNombre();
    String image = await _sharedPreferences.getImagen();
    String portada = await _sharedPreferences.getPortada();
    String fechaEvento = await _sharedPreferences.getFechaEvento();

    Map data = {'name': perfil.names, 'imag': image};

    if (sesion) {
      if (involucrado == null) {
        Navigator.pushNamed(context, '/home', arguments: data);
      } else {
        Navigator.pushReplacementNamed(context, '/dashboardInvolucrado',
            arguments: EventoResumenModel(
              idEvento: idEvento,
              descripcion: titulo,
              nombreCompleto: perfil.names,
              boton: false,
              img: image,
              portada: portada,
              fechaEvento: DateTime.tryParse(fechaEvento).toLocal(),
            ));
      }
    }
  }
}

class _Perfil {
  String names;
  String email;
  String phone;
  String clave;
  String repit;
  String image;

  _Perfil(
      {this.names, this.email, this.phone, this.clave, this.repit, this.image});

  // solucion al enviar objetos al servidor
  Map<String, dynamic> toJson() => {
        'names': names,
        'email': email,
        'phone': phone,
        'clave': clave,
        'image': image
      };
}

class CambiarContrasenaDialog extends StatefulWidget {
  const CambiarContrasenaDialog({Key key}) : super(key: key);

  @override
  _CambiarContrasenaDialogState createState() =>
      _CambiarContrasenaDialogState();
}

class _CambiarContrasenaDialogState extends State<CambiarContrasenaDialog> {
  final _keyForm = GlobalKey<FormState>();
  String passwordValid;

  bool readOnly = false;
  final loginLogic = BackendLoginLogic();
  TextEditingController passwordUser = TextEditingController(text: '');
  TextEditingController newPassword = TextEditingController(text: '');
  TextEditingController repeatNewPassWord = TextEditingController(text: '');
  bool _isInvolucrado = false;
  @override
  void initState() {
    validatePassword();
    checkIsInvolucrado();
    super.initState();
  }

  checkIsInvolucrado() async {
    final idInvolucrado = await SharedPreferencesT().getIdInvolucrado();
    if (idInvolucrado != null) {
      setState(() {
        _isInvolucrado = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cambiar contraseña'),
      ),
      body: Center(
        child: Container(
          width: size.width,
          height: size.height,
          color: Colors.white,
          child: Form(
            key: _keyForm,
            child: Column(
              children: [
                const SizedBox(
                  height: 15.0,
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: size.width * 0.8),
                  child: ResponsiveGridRow(
                    children: [
                      ResponsiveGridCol(
                        md: 12,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: PasswordWplanner(
                            floatingText: 'Contraseña actual',
                            hintText: 'Contraseña actual',
                            controller: passwordUser,
                            inputStyle: const TextStyle(color: Colors.black),
                            hintStyle: const TextStyle(color: Colors.grey),
                            autoFocus: false,
                            hasFloatingPlaceholder: true,
                            prefixIcon: const Icon(Icons.password),
                            suffixIcon: const Icon(
                              Icons.remove_red_eye,
                              color: Colors.grey,
                            ),
                            color: Colors.black,
                            iconColor: Colors.grey,
                            iconColorSelect: Colors.black,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide:
                                    const BorderSide(color: Colors.black)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide:
                                    const BorderSide(color: Colors.black)),
                          ),
                        ),
                      ),
                      ResponsiveGridCol(
                        md: 12,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: PasswordWplanner(
                            controller: newPassword,
                            floatingText: 'Nueva contraseña',
                            hintText: 'Nueva contraseña',
                            inputStyle: const TextStyle(color: Colors.black),
                            hintStyle: const TextStyle(color: Colors.grey),
                            autoFocus: false,
                            errorMaxLines: 3,
                            hasFloatingPlaceholder: true,
                            prefixIcon: const Icon(Icons.password),
                            suffixIcon: const Icon(
                              Icons.remove_red_eye,
                              color: Colors.grey,
                            ),
                            color: Colors.black,
                            iconColor: Colors.grey,
                            iconColorSelect: Colors.black,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide:
                                    const BorderSide(color: Colors.black)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide:
                                    const BorderSide(color: Colors.black)),
                            validador: (value) {
                              if (!_validaPsw(value)) {
                                return 'Campo requerido con una minúscula, una mayúscula, un número y un minimo de 8 caracteres';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      ResponsiveGridCol(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: PasswordWplanner(
                            floatingText: 'Confirmar contraseña',
                            controller: repeatNewPassWord,
                            hintText: 'Confirmar contraseña',
                            inputStyle: const TextStyle(color: Colors.black),
                            hintStyle: const TextStyle(color: Colors.grey),
                            autoFocus: false,
                            hasFloatingPlaceholder: true,
                            prefixIcon: const Icon(Icons.password),
                            suffixIcon: const Icon(
                              Icons.remove_red_eye,
                              color: Colors.grey,
                            ),
                            color: Colors.black,
                            iconColor: Colors.grey,
                            iconColorSelect: Colors.black,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide:
                                    const BorderSide(color: Colors.black)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide:
                                    const BorderSide(color: Colors.black)),
                            validador: (value) {
                              if (value != newPassword.text) {
                                MostrarAlerta(
                                    mensaje: 'La contraseña no coincide',
                                    tipoMensaje: TipoMensaje.advertencia);
                                return 'Debe coincidir con la contraseña';
                              } else if (value.isEmpty) {
                                return 'Campo requerido.';
                              }
                              return null;
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (passwordValid == passwordUser.text) {
                      if (_keyForm.currentState.validate()) {
                        // Falta se para cambio de contraseñas invo / planner
                        String data;
                        if (_isInvolucrado) {
                          data = await loginLogic
                              .changePasswordInvolucrado(newPassword.text);
                        } else if (!_isInvolucrado) {
                          data =
                              await loginLogic.changePassword(newPassword.text);
                        }
                        if (data == 'Ok') {
                          MostrarAlerta(
                              mensaje: 'Se ha cambiado la contraseña',
                              tipoMensaje: TipoMensaje.correcto);
                          Navigator.of(context).pop();
                        } else {
                          MostrarAlerta(
                              mensaje: 'Ocurrió un error',
                              tipoMensaje: TipoMensaje.error);
                        }
                      } else {
                        MostrarAlerta(
                            mensaje: 'Los campos no coiciden o estan vacios',
                            tipoMensaje: TipoMensaje.advertencia);
                      }
                    } else {
                      MostrarAlerta(
                          mensaje: 'La contraseña es incorrecta',
                          tipoMensaje: TipoMensaje.error);
                    }
                  },
                  child: const Text('Guardar'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  validatePassword() async {
    final password = await loginLogic.getPassword();

    if (password != null) {
      setState(() {
        passwordValid = password;
      });
    }
  }

  bool _validaPsw(String txt) {
    bool temp = false;

    // filtros
    bool mayusculas = false;
    bool minusculas = false;
    bool numeros = false;

    // expresiones regulares
    RegExp validaMayusculas = RegExp(r'[A-Z]');
    RegExp validaMinusculas = RegExp(r'[a-z]');
    RegExp validaNumeros = RegExp(r'[\d]');

    // validaciones
    if (validaMayusculas.hasMatch(txt)) mayusculas = true;
    if (validaMinusculas.hasMatch(txt)) minusculas = true;
    if (validaNumeros.hasMatch(txt)) numeros = true;

    if (txt.length > 7 && mayusculas && minusculas && numeros) temp = true;

    return temp;
  }
}

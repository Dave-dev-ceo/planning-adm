// ignore_for_file: unused_import, unused_element

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

import 'package:planning/src/blocs/perfil/perfil_bloc.dart';
import 'package:planning/src/logic/login_logic.dart';
import 'package:planning/src/models/item_model_perfil.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/ui/widgets/text_form_filed/password_wplanner.dart';
import 'package:responsive_grid/responsive_grid.dart';

class Perfil extends StatefulWidget {
  Perfil({Key key}) : super(key: key);

  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  // variables bloc
  PerfilBloc perfilBloc;
  ItemModelPerfil item;

  // variables de la classe
  SharedPreferencesT _sharedPreferences = new SharedPreferencesT();
  final _formKey = GlobalKey<FormState>();

  _Perfil perfil;

  @override
  void initState() {
    super.initState();
    perfilBloc = BlocProvider.of<PerfilBloc>(context);
    perfilBloc.add(SelectPerfilEvent());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _checkSession();
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('Perfil del usuario'),
          ),
          body: BlocBuilder<PerfilBloc, PerfilState>(
            builder: (context, state) {
              if (state is PerfilInitial) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is PerfilLogging) {
                return Center(
                  child: CircularProgressIndicator(),
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
                  return Center(child: CircularProgressIndicator());
                }
                if (perfil != null) {
                  return _showPerfil();
                } else {
                  return Center(child: Text('Sin datos'));
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
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )
          //_showPerfil(),
          ),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: TextEditingController(text: '${perfil.names}'),
                    maxLength: 50,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
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
                        return 'Campo requerido con 8 caracteres.';
                      }
                      return null;
                    },
                    onChanged: (valor) => perfil.names = valor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: TextEditingController(text: '${perfil.email}'),
                    maxLength: 250,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
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
                        return 'Es nesesario correo electrónico valido.';
                      }
                      return null;
                    },
                    onChanged: (valor) => perfil.email = valor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: TextEditingController(text: '${perfil.phone}'),
                    maxLength: 10,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone),
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
                        return 'Es requerido un número de teléfono valido con 10 dígitos.';
                      }
                      return null;
                    },
                    onChanged: (valor) => perfil.phone = valor,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                          child: Container(
                        height: 100.0,
                        width: 100.0,
                        color: Colors.black,
                        child: perfil.image == null
                            ? Image.asset('assets/user.png')
                            : PhotoView(
                                tightMode: true,
                                backgroundDecoration:
                                    BoxDecoration(color: Colors.white),
                                imageProvider:
                                    MemoryImage(base64Decode(perfil.image)),
                              ),
                      )),
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: ElevatedButton(
                          child: Text('Agregar imagen'),
                          onPressed: () => _addImage(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                            onPressed: () async {
                              showDialog(
                                  context: context,
                                  builder: (context) =>
                                      CambiarContrasenaDialog());
                            },
                            child: Text('Cambiar contraseña')),
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
                    child: new ElevatedButton(
                      child: const Text('Guardar'),
                      onPressed: () {
                        // It returns true if the form is valid, otherwise returns false
                        if (_formKey.currentState.validate()) {
                          // If the form is valid, display a Snackbar.
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Guardando cambios.')));
                          _guardarPerfil();
                        }
                      },
                    )),
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
      allowedExtensions: extensiones,
      allowMultiple: false,
    );

    pickedFile.files.forEach((archivo) =>
        setState(() => perfil.image = base64.encode(archivo.bytes)));
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

    if (txt.length > 7 && mayusculas && minusculas && numeros && simbolos)
      temp = true;

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

    Map data = {'name': perfil.names, 'imag': image};

    if (sesion) {
      if (involucrado == null) {
        Navigator.pushNamed(context, '/home', arguments: data);
      } else {
        Navigator.pushNamed(context, '/eventos', arguments: {
          'idEvento': idEvento,
          'nEvento': titulo,
          'nombre': perfil.names,
          'boton': false,
          'imag': image
        });
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
  CambiarContrasenaDialog({Key key}) : super(key: key);

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

  @override
  void initState() {
    validatePassword();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Cambiar Contraseña'),
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
                SizedBox(
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
                            inputStyle: TextStyle(color: Colors.black),
                            hintStyle: TextStyle(color: Colors.grey),
                            autoFocus: false,
                            hasFloatingPlaceholder: true,
                            prefixIcon: Icon(Icons.password),
                            suffixIcon: Icon(
                              Icons.remove_red_eye,
                              color: Colors.grey,
                            ),
                            color: Colors.black,
                            iconColor: Colors.grey,
                            iconColorSelect: Colors.black,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(color: Colors.black)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(color: Colors.black)),
                          ),
                        ),
                      ),
                      ResponsiveGridCol(
                        md: 12,
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: PasswordWplanner(
                            controller: newPassword,
                            floatingText: 'Nueva contraseña',
                            hintText: 'Nueva contraseña',
                            inputStyle: TextStyle(color: Colors.black),
                            hintStyle: TextStyle(color: Colors.grey),
                            autoFocus: false,
                            hasFloatingPlaceholder: true,
                            prefixIcon: Icon(Icons.password),
                            suffixIcon: Icon(
                              Icons.remove_red_eye,
                              color: Colors.grey,
                            ),
                            color: Colors.black,
                            iconColor: Colors.grey,
                            iconColorSelect: Colors.black,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(color: Colors.black)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(color: Colors.black)),
                            validador: (value) {
                              if (!_validaPsw(value)) {
                                return 'Campo requerido con una minuscula, una mayúscula, un número y un minimo de 8 caracteres.';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      ResponsiveGridCol(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: PasswordWplanner(
                            floatingText: 'Confirmar contraseña',
                            controller: repeatNewPassWord,
                            hintText: 'Confirmar contraseña',
                            inputStyle: TextStyle(color: Colors.black),
                            hintStyle: TextStyle(color: Colors.grey),
                            autoFocus: false,
                            hasFloatingPlaceholder: true,
                            prefixIcon: Icon(Icons.password),
                            suffixIcon: Icon(
                              Icons.remove_red_eye,
                              color: Colors.grey,
                            ),
                            color: Colors.black,
                            iconColor: Colors.grey,
                            iconColorSelect: Colors.black,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(color: Colors.black)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(color: Colors.black)),
                            validador: (value) {
                              if (value != newPassword.text) {
                                _mostrarMensaje(
                                    'La contraseña no coincide', Colors.red);
                                return 'Debe coincidir con la contraseña.';
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
                SizedBox(
                  height: 10.0,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (passwordValid == passwordUser.text) {
                      if (_keyForm.currentState.validate()) {
                        final data =
                            await loginLogic.changePassword(newPassword.text);
                        if (data == 'Ok') {
                          _mostrarMensaje(
                              'Se ha cambiado la contraseña', Colors.green);
                          Navigator.of(context).pop();
                        } else {
                          _mostrarMensaje('Ocurrio un error', Colors.red);
                        }
                      } else {
                        _mostrarMensaje('Los campos no coiciden o estan vacios',
                            Colors.red);
                      }
                    } else {
                      _mostrarMensaje(
                          'La contraseña es incorrecta', Colors.red);
                    }
                  },
                  child: Text('Guardar'),
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

  void _mostrarMensaje(String descripcion, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(descripcion),
      backgroundColor: color,
      duration: Duration(seconds: 3),
    ));
  }
}

//import 'dart:js';

// ignore_for_file: no_logic_in_create_state

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:planning/src/resources/api_provider.dart';
import 'package:planning/src/ui/widgets/FullScreenDialog/full_screen_dialog_select_contacts.dart';

import 'package:planning/src/ui/widgets/call_to_action/call_to_action.dart';
import 'package:planning/src/ui/widgets/snackbar_widget/snackbar_widget.dart';

//import 'package:path/path.dart';
class CargarExcel extends StatefulWidget {
  final int id;

  const CargarExcel({Key key, this.id}) : super(key: key);
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => const CargarExcel(),
      );

  @override
  _CargarExcelState createState() => _CargarExcelState(id);
}

class _CargarExcelState extends State<CargarExcel> {
  ApiProvider api = ApiProvider();
  final int id;

  _CargarExcelState(this.id);
  _viewShowDialogExcel() {
    showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: const Text('Importación de excel'),
              content: const Text(
                  'Procedera a abrir su explorador de archivos para seleccionar un archivo excel, ¿Desea continuar?'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text(
                    'No',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                CupertinoDialogAction(
                  child: const Text('Sí'),
                  onPressed: () {
                    _readExcel();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  _readExcel() async {
    /// Use FilePicker to pick files in Flutter Web

    FilePickerResult pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      withData: true,
      allowedExtensions: ['xlsx'],
      allowMultiple: false,
    );

    /// file might be picked

    if (pickedFile != null) {
      var bytes = pickedFile.files.single.bytes;

      // bytes ??= File(pickedFile.files[0].path).readAsBytesSync();

      var excel = Excel.decodeBytes(bytes);
      bool bandera = true;
      for (var table in excel.tables.keys) {
        dynamic xx = excel.tables[table].rows;

        if (xx[0][0] == "NOMBRE" &&
            xx[0][1] == "EMAIL" &&
            xx[0][2] == "TELÉFONO") {
          for (var i = 1; i < xx.length; i++) {
            Map<String, String> json = {
              "nombre": xx[i][0],
              "email": xx[i][1],
              "telefono": xx[i][2].toString(),
              "id_evento": id.toString()
            };
            bool response = await api.createInvitados(json, context);
            if (response) {
            } else {
              bandera = false;
            }
          }
          if (bandera) {
            MostrarAlerta(
                mensaje: 'Se importó el archivo con éxito.',
                tipoMensaje: TipoMensaje.correcto);
          } else {
            MostrarAlerta(
                mensaje: 'Error: No se pudo realizar el registro.',
                tipoMensaje: TipoMensaje.error);
          }
        } else {
          MostrarAlerta(
              mensaje: 'Estructura incorrecta.',
              tipoMensaje: TipoMensaje.error);
        }
      }
    }
  }

  Future<PermissionStatus> _getPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  _viewContact() async {
    final PermissionStatus permissionStatus = await _getPermission();
    if (permissionStatus == PermissionStatus.granted) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FullScreenDialog(
                    id: id,
                  )));
    } else {
      //If permissions have been denied show standard cupertino alert dialog
      showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
                title: const Text('Permisos denegados'),
                content:
                    const Text('Por favor habilitar el acceso a contactos'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: const Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    //_ReadExcel();
    return SingleChildScrollView(
      child: SizedBox(
          width: double.infinity,
          child: Center(
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  'Estructura del excel',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                SizedBox(
                  width: 370,
                  height: 220,
                  child: Image.asset('assets/AreaExcelLista.png'),
                ),
                TextButton(
                  child: const Text('Descargar plantilla'),
                  style: TextButton.styleFrom(
                    primary: Colors.teal,
                  ),
                  onPressed: () {},
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    _viewShowDialogExcel();
                  },
                  child: const CallToAction('Importar Excel'),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    _viewContact();
                    /////////////
                  },
                  child: const CallToAction('Importar Contactos'),
                ),
              ],
            ),
          )),
    );
  }
}

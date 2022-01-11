import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:planning/src/logic/book_inspiracion_login.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/models/mesa/layout_mesa_model.dart';
import 'package:planning/src/utils/utils.dart' as utils;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BookInspiracion extends StatefulWidget {
  const BookInspiracion({Key key}) : super(key: key);

  @override
  _BookInspiracion createState() => _BookInspiracion();
}

class _BookInspiracion extends State<BookInspiracion> {
  final bookInspiracionService = ServiceBookInspiracionLogic();
  bool isInvolucrado = false;

  @override
  void initState() {
    bookInspiracionService.getBookInspiracion();
    checkIsInvolucrado();

    super.initState();
  }

  checkIsInvolucrado() async {
    final idInvolucrado = await SharedPreferencesT().getIdInvolucrado();

    if (idInvolucrado != null) {
      setState(() {
        isInvolucrado = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (isInvolucrado)
          ? AppBar(
              title: Text('Boook Inspiración'),
              centerTitle: true,
            )
          : null,
      body: StreamBuilder(
          stream: bookInspiracionService.layoutBookImagesStream,
          builder: (BuildContext context,
              AsyncSnapshot<List<LayoutBookModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              if (snapshot.data != null) {
                return _viewFile(snapshot.data);
              } else {
                return Align(
                  alignment: Alignment.center,
                  child: Center(
                    child: Text('No se encontraron datos'),
                  ),
                );
              }
            } else {
              return Align(
                alignment: Alignment.center,
                child: Center(
                  child: Text('No se encontraron datos'),
                ),
              );
            }
          }),
      floatingActionButton: SpeedDial(
        activeForegroundColor: Colors.blueGrey,
        icon: Icons.add,
        activeIcon: Icons.close,
        activeLabel: Text('Cerrar'),
        animatedIconTheme: IconThemeData(size: 22.0),
        curve: Curves.bounceIn,
        animationSpeed: 200,
        tooltip: 'Ver mas..',
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
              child: Icon(Icons.upload),
              label: 'Subir archivo',
              onTap: () async {
                FilePickerResult pickedFile =
                    await FilePicker.platform.pickFiles(
                  type: FileType.image,
                  allowMultiple: false,
                );
                if (pickedFile != null) {
                  var bytes = await pickedFile.files.first.bytes;
                  if (bytes == null) {
                    bytes = File(pickedFile.files.first.path).readAsBytesSync();
                  }
                  String _extension = pickedFile.files.first.extension;
                  String file64 = base64Encode(bytes);
                  bookInspiracionService
                      .createBookInspiracion(file64, _extension)
                      .then((value) async => {
                            if (value == 'Ok')
                              {
                                await bookInspiracionService
                                    .getBookInspiracion(),
                                _mostrarMensaje(
                                    'Se subio correctamente.', Colors.green)
                              }
                          });
                }
              }),
          SpeedDialChild(
              child: Icon(Icons.download),
              label: 'Descargar Archivo',
              onTap: () async {
                final datosBookIns =
                    await bookInspiracionService.downloadBookInspiracion();
                if (datosBookIns != null) {
                  utils.downloadFile(datosBookIns, 'Book-Inspiracion');
                }
              })
        ],
      ),
    );
  }

  Widget _viewFile(List<LayoutBookModel> layoutBookModel) {
    if (layoutBookModel.length <= 0) {
      return Center(
        child: Text('Sin datos'),
      );
    } else {
      return GridView.builder(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
          itemCount: layoutBookModel.length,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 500,
            mainAxisExtent: 300,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemBuilder: (BuildContext context, int index) {
            final bytes = base64Decode(layoutBookModel[index].file);
            return Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Image.memory(
                    bytes,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  decoration:
                      BoxDecoration(color: Colors.black.withOpacity(0.3)),
                  width: double.infinity,
                  height: 30.0,
                  child: FittedBox(
                    child: IconButton(
                      onPressed: () async {
                        bookInspiracionService
                            .deleteBookInspiracion(
                                layoutBookModel[index].idBookInspiracion)
                            .then((value) => {
                                  if (value)
                                    {
                                      _mostrarMensaje(
                                          'Se ha eliminado correctamente',
                                          Colors.green),
                                      bookInspiracionService
                                          .getBookInspiracion()
                                          .then((value) => setState(() {})),
                                    }
                                  else
                                    {
                                      _mostrarMensaje(
                                          'Ocurrio un error', Colors.red)
                                    }
                                });
                      },
                      icon: FaIcon(FontAwesomeIcons.trash, color: Colors.white),
                    ),
                  ),
                )
              ],
            );
          });
    }
  }

  _mostrarMensaje(String msj, Color color) {
    SnackBar snackBar = SnackBar(
      content: Text(msj),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

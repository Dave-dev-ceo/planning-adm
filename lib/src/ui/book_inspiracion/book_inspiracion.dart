import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:planning/src/logic/book_inspiracion_login.dart';
import 'package:planning/src/models/mesa/layout_mesa_model.dart';
import 'package:planning/src/utils/utils.dart';

class BookInspiracion extends StatefulWidget {
  const BookInspiracion({Key key}) : super(key: key);

  @override
  _BookInspiracion createState() => _BookInspiracion();
}

class _BookInspiracion extends State<BookInspiracion> {
  final bookInspiracionService = ServiceBookInspiracionLogic();

  @override
  void initState() {
    bookInspiracionService.getBookInspiracion();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                const extensiones = ['jpg', 'png', 'jpeg'];

                FilePickerResult pickedFile =
                    await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: extensiones,
                  allowMultiple: false,
                );
                if (pickedFile != null) {
                  final bytes = pickedFile.files.first.bytes;
                  String _extension = pickedFile.files.first.extension;
                  String file64 = base64Encode(bytes);
                  bookInspiracionService
                      .createBookInspiracion(file64, _extension)
                      .then((value) async => {
                            if (value == 'Ok')
                              {
                                await bookInspiracionService
                                    .getBookInspiracion()
                                    .then(
                                      (value) => setState(() {}),
                                    ),
                                _mostrarMensaje(
                                    'Se subio correctamente el PDF.',
                                    Colors.green)
                              }
                          });
                }
              }),
          SpeedDialChild(
              child: Icon(Icons.download),
              label: 'Descargar Archivo',
              onTap: () async {
                final datosBookIns =
                    await bookInspiracionService.getBookInspiracion();
                if (datosBookIns != null) {}
              })
        ],
      ),
    );
  }

  Widget _viewFile(List<LayoutBookModel> layoutBookModel) {
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
          return Center(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Image.memory(
                bytes,
                fit: BoxFit.cover,
              ),
            ),
          );
        });
  }

  _mostrarMensaje(String msj, Color color) {
    SnackBar snackBar = SnackBar(
      content: Text(msj),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

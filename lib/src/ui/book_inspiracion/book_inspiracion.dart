import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/logic/book_inspiracion_login.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/models/mesa/layout_mesa_model.dart';
import 'package:planning/src/ui/widgets/snackbar_widget/snackbar_widget.dart';
import 'package:planning/src/utils/utils.dart' as utils;

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
              title: const Text('Book Inspiration'),
              centerTitle: true,
            )
          : null,
      body: StreamBuilder(
          stream: bookInspiracionService.layoutBookImagesStream,
          builder: (BuildContext context,
              AsyncSnapshot<List<LayoutBookModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: LoadingCustom(),
              );
            }
            if (snapshot.hasData) {
              if (snapshot.data != null) {
                if (snapshot.data.isNotEmpty) {
                  return _viewFile(snapshot.data);
                } else {
                  return sinDatos();
                }
              } else {
                return sinDatos();
              }
            } else {
              return sinDatos();
            }
          }),
      floatingActionButton: SpeedDial(
        icon: Icons.more_vert,
        tooltip: 'Opciones',
        children: [
          SpeedDialChild(
              child: const Icon(Icons.upload),
              label: 'Subir archivo',
              onTap: () async {
                FilePickerResult pickedFile =
                    await FilePicker.platform.pickFiles(
                  type: FileType.image,
                  withData: true,
                  allowMultiple: false,
                );
                if (pickedFile != null) {
                  var bytes = pickedFile.files.first.bytes;
                  bytes ??= File(pickedFile.files.first.path).readAsBytesSync();
                  String _extension = pickedFile.files.first.extension;
                  String file64 = base64Encode(bytes);
                  bookInspiracionService
                      .createBookInspiracion(file64, _extension)
                      .then((value) async => {
                            if (value == 'Ok')
                              {
                                await bookInspiracionService
                                    .getBookInspiracion(),
                                MostrarAlerta(
                                    mensaje:
                                        'La imagen se agrego correctamente.',
                                    tipoMensaje: TipoMensaje.correcto)
                              }
                          });
                }
              }),
          SpeedDialChild(
              child: const Icon(Icons.download),
              label: 'Descargar Archivo',
              onTap: () async {
                final datosBookIns =
                    await bookInspiracionService.downloadBookInspiracion();
                if (datosBookIns != null) {
                  utils.downloadFile(datosBookIns, 'Book-Inspiration');
                }
              })
        ],
      ),
    );
  }

  Align sinDatos() {
    return const Align(
      alignment: Alignment.center,
      child: Center(
        child: Text('No se encontraron datos'),
      ),
    );
  }

  Widget _viewFile(List<LayoutBookModel> layoutBookModel) {
    return GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
        itemCount: layoutBookModel.length,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
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
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Image.memory(
                  bytes,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
                width: double.infinity,
                height: 30.0,
                child: FittedBox(
                  child: IconButton(
                    onPressed: () async => showDialog<void>(
                        context: context,
                        builder: (BuildContext context) => _eliminarArchivo(
                            layoutBookModel[index].idBookInspiracion)),
                    icon: const Icon(Icons.delete, color: Colors.white),
                  ),
                ),
              )
            ],
          );
        });
  }

  _eliminarArchivo(int idArchivo) {
    return AlertDialog(
      title: const Text('Eliminar Imagen'),
      content: const Text('¿Desea eliminar la imagen del Book de Inspiration?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancelar'),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            bookInspiracionService
                .deleteBookInspiracion(idArchivo)
                .then((value) => {
                      if (value)
                        {
                          MostrarAlerta(
                              mensaje:
                                  'La imagen se ha eliminado correctamente.',
                              tipoMensaje: TipoMensaje.correcto),
                          bookInspiracionService.getBookInspiracion().then(
                              (value) => {
                                    setState(() {}),
                                    Navigator.pop(context, 'Aceptar')
                                  }),
                        }
                      else
                        {
                          MostrarAlerta(
                              mensaje: 'No se pudo eliminar la imagen.',
                              tipoMensaje: TipoMensaje.error)
                        }
                    });
          },
          child: const Text('Aceptar'),
        ),
      ],
    );
  }
}

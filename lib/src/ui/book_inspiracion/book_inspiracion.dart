import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:planning/src/logic/book_inspiracion_login.dart';
import 'package:planning/src/models/mesa/layout_mesa_model.dart';
import 'package:planning/src/utils/utils.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class BookInspiracion extends StatefulWidget {
  const BookInspiracion({Key key}) : super(key: key);

  @override
  _BookInspiracion createState() => _BookInspiracion();
}

class _BookInspiracion extends State<BookInspiracion> {
  final bookInspiracionService = ServiceBookInspiracionLogic();

  PdfViewerController _pdfViewerController;
  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder(
                future: bookInspiracionService.getBookInspiracion(),
                builder: (BuildContext context,
                    AsyncSnapshot<LayoutBookModel> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.file != null) {
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
                },
              )
            ],
          ),
        ),
      ),
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
                const extensiones = ['jpg', 'png', 'jpeg', 'pdf'];

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
                      .then((value) => {
                            if (value == 'Ok')
                              {
                                setState(() {
                                  bookInspiracionService.getBookInspiracion();
                                }),
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
                if (datosBookIns != null) {
                  downloadFile(datosBookIns.file, 'Book Inspiración',
                      extensionFile: datosBookIns.mime.toString());
                }
              })
        ],
      ),
    );
  }

  Widget _viewFile(LayoutBookModel layoutMesa) {
    if (layoutMesa.mime == 'pdf') {
      final bytes = base64Decode(layoutMesa.file);
      return Center(
        child: Container(
          width: 500.0,
          height: MediaQuery.of(context).size.height,
          child: SfPdfViewer.memory(
            bytes,
            controller: _pdfViewerController,
            canShowScrollStatus: true,
            interactionMode: PdfInteractionMode.pan,
          ),
        ),
      );
    } else {
      final bytes = base64Decode(layoutMesa.file);
      final image = MemoryImage(bytes);
      return Center(
        child: Container(
          width: 500.0,
          height: MediaQuery.of(context).size.height,
          child: ClipRect(
            child: PhotoView(
              tightMode: true,
              backgroundDecoration: BoxDecoration(color: Colors.white),
              imageProvider: image,
            ),
          ),
        ),
      );
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

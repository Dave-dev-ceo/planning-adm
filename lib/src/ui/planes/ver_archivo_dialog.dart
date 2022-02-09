import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/logic/actividades_logic/archivo_actividad_logic.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class DialogArchivoActividad extends StatefulWidget {
  final int idActividad;
  const DialogArchivoActividad({Key key, @required this.idActividad})
      : super(key: key);

  @override
  State<DialogArchivoActividad> createState() => _DialogArchivoActividadState();
}

class _DialogArchivoActividadState extends State<DialogArchivoActividad> {
  final ArchivoActividadLogic logic = ArchivoActividadLogic();

  PdfViewerController _pdfViewerController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('ver Archivo Actividad'),
      ),
      body: FutureBuilder(
        future: logic.obtenerArchivoActividad(widget.idActividad),
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.hasData) {
            final bytes = base64Decode(snapshot.data['archivo']);
            if (snapshot.data['tipo_mime'] == 'pdf') {
              return Center(
                child: SizedBox(
                  width: 500,
                  height: MediaQuery.of(context).size.height.toDouble(),
                  child: SfPdfViewer.memory(
                    bytes,
                    controller: _pdfViewerController,
                    canShowScrollStatus: true,
                    interactionMode: PdfInteractionMode.pan,
                  ),
                ),
              );
            } else {
              final image = MemoryImage(bytes);

              return Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height.toDouble(),
                  width: 500,
                  child: PhotoView(
                    tightMode: true,
                    backgroundDecoration:
                        const BoxDecoration(color: Colors.white),
                    imageProvider: image,
                  ),
                ),
              );
            }
          }
          return const Center(
            child: LoadingCustom(),
          );
        },
      ),
    );
  }
}

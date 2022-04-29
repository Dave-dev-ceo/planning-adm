import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class DialogVerArchivoProspecto extends StatefulWidget {
  final String archivo;
  final String nombreArchivo;
  final String mime;
  const DialogVerArchivoProspecto(
      {Key key,
      @required this.archivo,
      @required this.mime,
      @required this.nombreArchivo})
      : super(key: key);

  @override
  State<DialogVerArchivoProspecto> createState() =>
      _DialogVerArchivoProspectoState();
}

class _DialogVerArchivoProspectoState extends State<DialogVerArchivoProspecto> {
  final _pdfViewerController = PdfViewerController();
  Uint8List bytes;

  @override
  void initState() {
    bytes = base64Decode(widget.archivo);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nombreArchivo),
      ),
      body: widget.mime == 'pdf'
          ? Center(
              child: SizedBox(
                width: 500.0,
                height: MediaQuery.of(context).size.height,
                child: SfPdfViewer.memory(
                  bytes,
                  controller: _pdfViewerController,
                  canShowScrollStatus: true,
                  interactionMode: PdfInteractionMode.pan,
                ),
              ),
            )
          : Center(
              child: SizedBox(
                width: 500.0,
                height: MediaQuery.of(context).size.height,
                child: ClipRect(
                  child: PhotoView(
                    tightMode: true,
                    backgroundDecoration:
                        const BoxDecoration(color: Colors.white),
                    imageProvider: MemoryImage(bytes),
                  ),
                ),
              ),
            ),
    );
  }
}

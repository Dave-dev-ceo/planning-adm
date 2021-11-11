import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:photo_view/photo_view.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:planning/src/blocs/proveedores/view_archivos/view_archivos_bloc.dart';

class FullScreenDialogViewFileEvent extends StatefulWidget {
  final Map<String, dynamic> archivo;
  const FullScreenDialogViewFileEvent({Key key, @required this.archivo})
      : super(key: key);
  @override
  _FullScreenDialogViewFileEvent createState() =>
      _FullScreenDialogViewFileEvent(archivo);
}

class _FullScreenDialogViewFileEvent
    extends State<FullScreenDialogViewFileEvent> {
  ViewArchivosBloc viewArchivoBloc;

  final Map<String, dynamic> archivo;
  _FullScreenDialogViewFileEvent(this.archivo);
  PdfViewerController _pdfViewerController;
  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    viewArchivoBloc = BlocProvider.of<ViewArchivosBloc>(context);
    viewArchivoBloc.add(FechtArchivoByIdEvent(archivo['id_archivo']));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(this.archivo['nombre']),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.keyboard_arrow_up,
                color: Colors.white,
              ),
              onPressed: () {
                _pdfViewerController.previousPage();
              },
            ),
            IconButton(
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
              ),
              onPressed: () {
                _pdfViewerController.nextPage();
              },
            )
          ],
          automaticallyImplyLeading: true,
        ),
        body: SingleChildScrollView(child: Container(
          child: BlocBuilder<ViewArchivosBloc, ViewArchivosState>(
            builder: (context, state) {
              if (state is MostrarArchivoByIdState) {
                return _buildVisor(state.detlistas.results[0].tipoMime,
                    state.detlistas.results[0].archivo);
              } else {
                return Container();
              }
            },
          ),
        )));
  }

  Widget _buildVisor(String mime, String fileBase64) {
    if (mime == 'application/pdf') {
      final bytes = base64Decode(fileBase64);
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
    } else if (mime == 'image/jpeg') {
      final bytes = base64Decode(fileBase64);
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
}

// ignore_for_file: no_logic_in_create_state, unnecessary_const

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ViewPdfContrato extends StatefulWidget {
  final Map<String, dynamic> data;
  const ViewPdfContrato({Key? key, required this.data}) : super(key: key);

  @override
  State<ViewPdfContrato> createState() => _ViewPdfContratoState(data);
}

class _ViewPdfContratoState extends State<ViewPdfContrato> {
  static const int _initialPage = 0;
  final Map<String, dynamic> data;
  int actualPageNumber = _initialPage, allPagesCount = 0;
  bool isSampleDoc = true;
  late PdfViewerController _pdfController;

  _ViewPdfContratoState(this.data);
  @override
  void initState() {
    if (data['tipo_mime'] == 'pdf' ||
        data['tipo_mime'] == null ||
        data['tipo_mime'] == '') {
      _pdfController = PdfViewerController(

          //document: PdfDocument.openAsset('assets/businesscard.pdf'),

          );

      super.initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Documento'),
        actions: data['tipo_mime'] == 'pdf' ||
                data['tipo_mime'] == null ||
                data['tipo_mime'] == ''
            ? <Widget>[
                IconButton(
                  icon: const Icon(Icons.navigate_before),
                  onPressed: () {
                    _pdfController.previousPage();

                    setState(() {
                      actualPageNumber = _pdfController.pageNumber;
                    });
                  },
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    '${_pdfController.pageNumber}/${_pdfController.pageCount}',
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.navigate_next),
                  onPressed: () {
                    _pdfController.nextPage();
                    setState(() {
                      actualPageNumber = _pdfController.pageNumber;
                    });
                  },
                ),
              ]
            : [],
      ),
      body: data['tipo_mime'] == 'pdf' ||
              data['tipo_mime'] == null ||
              data['tipo_mime'] == ''
          ? SfPdfViewer.memory(
              base64Decode(data['htmlPdf']),
              controller: _pdfController,
              onDocumentLoaded: (details) {
                setState(() {
                  allPagesCount = _pdfController.pageCount;
                  actualPageNumber = _pdfController.pageNumber;
                });
              },
            )
          : _buildImg(),
    );
  }

  Widget _buildImg() {
    final bytes = base64Decode(data['htmlPdf']);
    final image = MemoryImage(bytes);
    return Center(
      child: SizedBox(
        width: 500.0,
        height: MediaQuery.of(context).size.height,
        child: ClipRect(
          child: PhotoView(
            tightMode: true,
            backgroundDecoration: const BoxDecoration(color: Colors.white),
            imageProvider: image,
          ),
        ),
      ),
    );
  }
}

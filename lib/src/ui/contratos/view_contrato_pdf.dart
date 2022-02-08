// ignore_for_file: no_logic_in_create_state, unnecessary_const

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:planning/src/animations/loading_animation.dart';

class ViewPdfContrato extends StatefulWidget {
  final Map<String, dynamic> data;
  const ViewPdfContrato({Key key, this.data}) : super(key: key);

  @override
  _ViewPdfContratoState createState() => _ViewPdfContratoState(data);
}

class _ViewPdfContratoState extends State<ViewPdfContrato> {
  static const int _initialPage = 0;
  final Map<String, dynamic> data;
  int _actualPageNumber = _initialPage, _allPagesCount = 0;
  bool isSampleDoc = true;
  PdfController _pdfController;

  _ViewPdfContratoState(this.data);
  @override
  void initState() {
    if (data['tipo_mime'] == 'pdf' ||
        data['tipo_mime'] == null ||
        data['tipo_mime'] == '') {
      Uint8List _bytesData = const Base64Decoder().convert(data['htmlPdf']);
      _pdfController = PdfController(
        //document: PdfDocument.openAsset('assets/businesscard.pdf'),
        document: PdfDocument.openData(_bytesData),
        initialPage: _initialPage,
      );
      super.initState();
    }
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
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
                    _pdfController.previousPage(
                      curve: Curves.ease,
                      duration: const Duration(milliseconds: 100),
                    );
                  },
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    '$_actualPageNumber/$_allPagesCount',
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.navigate_next),
                  onPressed: () {
                    _pdfController.nextPage(
                      curve: Curves.ease,
                      duration: const Duration(milliseconds: 100),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    if (isSampleDoc) {
                      _pdfController.loadDocument(PdfDocument.openData(
                          const Base64Decoder().convert(data['htmlPdf'])));
                    } else {
                      _pdfController.loadDocument(PdfDocument.openData(
                          const Base64Decoder().convert(data['htmlPdf'])));
                    }
                    isSampleDoc = !isSampleDoc;
                  },
                )
              ]
            : [],
      ),
      body: data['tipo_mime'] == 'pdf' ||
              data['tipo_mime'] == null ||
              data['tipo_mime'] == ''
          ? PdfView(
              documentLoader: const Center(child: LoadingCustom()),
              pageLoader: const Center(child: const LoadingCustom()),
              controller: _pdfController,
              onDocumentLoaded: (document) {
                setState(() {
                  _allPagesCount = document.pagesCount;
                });
              },
              onPageChanged: (page) {
                setState(() {
                  _actualPageNumber = page;
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

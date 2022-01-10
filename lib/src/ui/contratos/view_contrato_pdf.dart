import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

class ViewPdfContrato extends StatefulWidget {
  final Map<String, dynamic> data;
  const ViewPdfContrato({Key key, this.data}) : super(key: key);

  @override
  _ViewPdfContratoState createState() => _ViewPdfContratoState(data);
}

class _ViewPdfContratoState extends State<ViewPdfContrato> {
  static final int _initialPage = 0;
  final Map<String, dynamic> data;
  int _actualPageNumber = _initialPage, _allPagesCount = 0;
  bool isSampleDoc = true;
  PdfController _pdfController;

  _ViewPdfContratoState(this.data);
  @override
  void initState() {
    Uint8List _bytesData = Base64Decoder().convert(this.data['htmlPdf']);
    _pdfController = PdfController(
      //document: PdfDocument.openAsset('assets/businesscard.pdf'),
      document: PdfDocument.openData(_bytesData),
      initialPage: _initialPage,
    );
    super.initState();
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
        title: Text('Contrato'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.navigate_before),
            onPressed: () {
              _pdfController.previousPage(
                curve: Curves.ease,
                duration: Duration(milliseconds: 100),
              );
            },
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              '$_actualPageNumber/$_allPagesCount',
              style: TextStyle(fontSize: 22),
            ),
          ),
          IconButton(
            icon: Icon(Icons.navigate_next),
            onPressed: () {
              _pdfController.nextPage(
                curve: Curves.ease,
                duration: Duration(milliseconds: 100),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              if (isSampleDoc) {
                _pdfController.loadDocument(PdfDocument.openData(
                    Base64Decoder().convert(this.data['htmlPdf'])));
              } else {
                _pdfController.loadDocument(PdfDocument.openData(
                    Base64Decoder().convert(this.data['htmlPdf'])));
              }
              isSampleDoc = !isSampleDoc;
            },
          )
        ],
      ),
      body: this.data['tipo_mime'] == 'pdf' ||
              this.data['tipo_mime'] == null ||
              this.data['tipo_mime'] == ''
          ? PdfView(
              documentLoader: Center(child: CircularProgressIndicator()),
              pageLoader: Center(child: CircularProgressIndicator()),
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
    final bytes = base64Decode(this.data['htmlPdf']);
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

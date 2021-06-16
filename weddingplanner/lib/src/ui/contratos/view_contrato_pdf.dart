
/*import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:weddingplanner/src/blocs/contratos/contratos_bloc.dart';

class ViewPdfContrato extends StatefulWidget {
  final String htmlPdf;
  const ViewPdfContrato({Key key, this.htmlPdf}) : super(key: key);

  @override
  _ViewPdfContratoState createState() => _ViewPdfContratoState(htmlPdf);
}

class _ViewPdfContratoState extends State<ViewPdfContrato> {
  static final int _initialPage = 1;
  final String htmlPdf;
  int _actualPageNumber = _initialPage, _allPagesCount = 0;
  bool isSampleDoc = true;
  PdfController _pdfController;
  ContratosBloc contratosBloc;

  _ViewPdfContratoState(this.htmlPdf);
  @override
  void initState() {
    contratosBloc = BlocProvider.of<ContratosBloc>(context);
    contratosBloc.add(FechtContratosPdfEvent({"machote": htmlPdf}));
    _pdfController = PdfController(
              document: PdfDocument.openFile(filePath)(),
              //document: PdfDocument.openAsset('assets/sample.pdf'),
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
                _pdfController
                    .loadDocument(PdfDocument.openAsset('assets/dummy.pdf'));
              } else {
                _pdfController
                    .loadDocument(PdfDocument.openAsset('assets/sample.pdf'));
              }
              isSampleDoc = !isSampleDoc;
            },
          )
        ],
      ),
      body: BlocBuilder<ContratosBloc, ContratosState>(
        builder: (context, state) {
          if (state is ContratosInitial) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is LoadingContratosPdfState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is MostrarContratosPdfState) {
            
            return PdfView(
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
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
*/
import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter/material.dart';
import 'package:weddingplanner/src/blocs/contratos/contratos_bloc.dart';

class ViewPdfContrato extends StatefulWidget {
  final String htmlPdf;
  const ViewPdfContrato({Key key, this.htmlPdf}) : super(key: key);

  @override
  _ViewPdfContratoState createState() => _ViewPdfContratoState(htmlPdf);
}

class _ViewPdfContratoState extends State<ViewPdfContrato> {
  final String htmlPdf;

  _ViewPdfContratoState(this.htmlPdf);
  ContratosBloc contratosBloc;
  @override
  void initState() {
    contratosBloc = BlocProvider.of<ContratosBloc>(context);
    contratosBloc.add(FechtContratosPdfEvent({"machote": htmlPdf}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contrato'),
      ),
      body: BlocBuilder<ContratosBloc, ContratosState>(
        builder: (context, state) {
          if (state is ContratosInitial) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is LoadingContratosPdfState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is MostrarContratosPdfState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    child: Text(
                      'Generar formato PDF',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => Colors.blue)),
                    onPressed: () {
                      _createPDF(state.contratos);
                    },
                  )
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<void> _createPDF(String contrato) async {
    //Create a PDF document

    PdfDocument document = PdfDocument.fromBase64String(contrato);
    //Uint8List base = Base64Decoder().convert(contrato);
    //document.fo
    //Add a page and draw text
    /*document.pages.add().graphics.drawString(
        'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 20),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(20, 60, 150, 30));*/
    //Save the document
    List<int> bytes = document.save();
    //Dispose the document
    document.dispose();
    //Download the output file
    AnchorElement(
        href:
            "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
      ..setAttribute("download", "output.pdf")
      ..click();
  }
}

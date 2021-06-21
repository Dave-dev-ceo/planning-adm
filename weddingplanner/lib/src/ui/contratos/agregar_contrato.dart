import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:weddingplanner/src/blocs/contratos/contratos_bloc.dart';
import 'package:weddingplanner/src/blocs/eventos/eventos_bloc.dart';
import 'package:weddingplanner/src/blocs/machotes/machotes_bloc.dart';
import 'package:weddingplanner/src/models/item_model_contratos.dart';
import 'package:weddingplanner/src/models/item_model_eventos.dart';
import 'package:weddingplanner/src/models/item_model_machotes.dart';

class AgregarContrato extends StatefulWidget {
  const AgregarContrato({Key key}) : super(key: key);
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => AgregarContrato(),
      );

  @override
  _AgregarContratoState createState() => _AgregarContratoState();
}

class _AgregarContratoState extends State<AgregarContrato> {
  MachotesBloc machotesBloc;
  ItemModelMachotes itemModelMC;
  EventosBloc eventosBloc;
  ItemModelEventos itemModelEV;
  ContratosBloc contratosBloc;
  ItemModelContratos itemModelCT;
  BuildContext _ingresando;
  String nombreDocumento = "output";
  @override
  void initState() {
    machotesBloc = BlocProvider.of<MachotesBloc>(context);
    machotesBloc.add(FechtMachotesEvent());
    eventosBloc = BlocProvider.of<EventosBloc>(context);
    eventosBloc.add(FechtEventosEvent());
    contratosBloc = BlocProvider.of<ContratosBloc>(context);
    super.initState();
  }

  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  /*Future<String> _insertEtiquetas(String html){
    eventosBloc.mapEventToState(event)
  }*/
  Future<void> _createPDF(String contrato) async {
    //Create a PDF document

    PdfDocument document = PdfDocument.fromBase64String(contrato);
    List<int> bytes = document.save();
    //Dispose the document
    document.dispose();
    //Download the output file
    AnchorElement(
        href:
            "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
      ..setAttribute("download", nombreDocumento+".pdf")
      ..click();
  }
  _dialogMSG(String title){
    Widget child = CircularProgressIndicator();
    showDialog(
      context: context,
      //barrierDismissible: false,
      builder: (BuildContext context) {
        _ingresando = context;
        return AlertDialog(
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
          content: child,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
        );
      });
  }

  _contectCont(ItemModelMachotes itemMC, int element) {
    return
        /*GestureDetector(
      onTap: () {
        String html = itemMC.results.elementAt(element).machote;
        
        Navigator.of(context).pushNamed('/addContratoPdf', arguments: html);
      },
      child:*/
        Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(20),
      elevation: 10,
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(15, 10, 25, 0),
            title: Container(alignment: Alignment.topLeft,
                height: 25,
                width: double.infinity,
                child: FittedBox(
                  child: Text(
              itemModelMC.results.elementAt(element).descripcion,
              style: TextStyle(fontSize: 20),
            ))),
            subtitle: Container(
                height: 80,
                //color: Colors.purple,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton.icon(
                              onPressed: () {
                                nombreDocumento = itemMC.results.elementAt(element).descripcion;
                                contratosBloc.add(FechtContratosPdfEvent({"machote": itemMC.results.elementAt(element).machote}));
                              },
                              icon: Icon(Icons.cloud_download_outlined),
                              label: Text('Descargar')),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton.icon(
                              onPressed: () {
                                nombreDocumento = itemMC.results.elementAt(element).descripcion;
                                contratosBloc.add(FechtContratosPdfViewEvent({"machote": itemMC.results.elementAt(element).machote}));
                              },
                              icon: Icon(Icons.remove_red_eye_rounded),
                              label: Text('Ver')),
                        ),
                      ],
                    ),
                  ],
                )),
            leading: Icon(Icons.event),
          ),
        ],
      ),
      //),
    );
  }

  _constructorLista(ItemModelMachotes modelMC) {
    return IndexedStack(
          index: _selectedIndex,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: ListView(
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  for (var i = 0; i < modelMC.results.length; i++)
                    if(modelMC.results.elementAt(i).clave == 'CT')
                      _contectCont(modelMC, i)
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: ListView(
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  for (var i = 0; i < modelMC.results.length; i++)
                    if(modelMC.results.elementAt(i).clave == 'RC')
                      _contectCont(modelMC, i)
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: ListView(
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  for (var i = 0; i < modelMC.results.length; i++)
                    if(modelMC.results.elementAt(i).clave == 'PG')
                      _contectCont(modelMC, i)
                ],
              ),
            ),
          ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: BlocListener<ContratosBloc, ContratosState>(
          listener: (context, state) {
            if (state is LoadingContratosPdfState) {
            return _dialogMSG('Descargando contrato');
          } else if (state is MostrarContratosPdfState) {
            Navigator.pop(_ingresando);
            _createPDF(state.contratos);  
          }else if(state is LoadingContratosPdfViewState){
            return _dialogMSG('Espere un momento');
          } else if(state is MostrarContratosPdfViewState){
            Navigator.pop(_ingresando);
            Navigator.pushNamed(context, '/viewContrato',arguments: state.contratos);
          }
          else {
            if(_ingresando != null){
              Navigator.pop(_ingresando);
            }
            
          }
          },
          child: BlocBuilder<MachotesBloc, MachotesState>(
            builder: (context, state) {
              if (state is LoadingMachotesState) {
                return Center(child: CircularProgressIndicator());
              } else if (state is MostrarMachotesState) {
                itemModelMC = state.machotes;
                return _constructorLista(state.machotes);
              } else if (state is ErrorListaMachotesState) {
                return Center(
                  child: Text(state.message),
                );
              } else {
                return Center(child: CircularProgressIndicator());
                //return _constructorLista(itemModelET);
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.gavel),
            label: 'Contratos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Recibos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.request_page),
            label: 'Pagos',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  int _selectedIndex = 0;
}
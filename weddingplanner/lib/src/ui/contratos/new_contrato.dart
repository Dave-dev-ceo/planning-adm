// imports flutter/dart
import 'dart:convert';
// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

// imports
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

// imports from wedding
import 'package:weddingplanner/src/blocs/contratos/bloc/contratos_bloc.dart';
import 'package:weddingplanner/src/blocs/contratos/bloc/ver_contratos_bloc.dart';

class NewContrato extends StatefulWidget {
  NewContrato({Key key}) : super(key: key);

  @override
  New_ContratoState createState() => New_ContratoState();
}

class New_ContratoState extends State<NewContrato> {
  // variables bloc
  ContratosDosBloc contratosBloc;
  VerContratosBloc verContratos;

  // vaiables clase
  int _selectedIndex = 0;
  List<Contratos> itemModel = [];

  @override
  void initState() {
    super.initState();
    contratosBloc = BlocProvider.of<ContratosDosBloc>(context);
    contratosBloc.add(ContratosSelect());
    verContratos = BlocProvider.of<VerContratosBloc>(context);
  }

  //_HomeState(this.idPlanner);
  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _myBloc(),
      bottomNavigationBar: _showNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _showButton(),
    );
  }

  // BLoC
  _myBloc() {
    return BlocListener<VerContratosBloc, VerContratosState>(
        listener: (context, state) {
      if (state is VerContratosLoggin) {
        return _dialogMSG('Espere un momento');
      } else if (state is VerContratosBorrar) {
        Navigator.pop(context);
        contratosBloc.add(ContratosSelect());
      } else if (state is VerContratosSubir) {
        Navigator.pop(context);
        contratosBloc.add(ContratosSelect());
        _mensaje('Se ha subido el documento.');
      } else if (state is VerContratosVer) {
        Navigator.pop(context);
        Navigator.pushNamed(context, '/viewContrato', arguments: state.archivo);
      } else if (state is DescargarContratoState) {
        Navigator.pop(context);
        _descargarFile(state.archivo, state.nombre);
      } else if (state is CrearContratoState) {
        Navigator.pop(context);
        contratosBloc.add(ContratosSelect());
      }
    }, child: BlocBuilder<ContratosDosBloc, ContratosState>(
            builder: (context, state) {
      if (state is ContratosInitial) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is ContratosLogging) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is SelectContratoState) {
        if (itemModel.length == 0) {
          itemModel = state.contrato.contrato
              .map((item) => Contratos(
                    idContrato: item.idContrato,
                    idMachote: item.idMachote,
                    description: item.descripcion,
                    original: item.original,
                    archivo: item.archivo,
                    clave: item.clavePlantilla,
                    valida: item.original != null ? true : false,
                  ))
              .toList();
        } else if (itemModel.length != state.contrato.contrato) {
          itemModel = state.contrato.contrato
              .map((item) => Contratos(
                    idContrato: item.idContrato,
                    idMachote: item.idMachote,
                    description: item.descripcion,
                    original: item.original,
                    archivo: item.archivo,
                    clave: item.clavePlantilla,
                    valida: item.original != null ? true : false,
                  ))
              .toList();
        }
        return _showContratos();
      } else {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    }));
  }

  // cointener => columna => listas x tipo
  _showContratos() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _itemsContratos(),
      ),
    );
  }

  // select lista
  _itemsContratos() {
    switch (_selectedIndex) {
      case 0:
        return _contratosItem();
      case 1:
        return _recibosItem();
      case 2:
        return _pagosItem();
      default:
        return _minutasItem();
    }
  }

  // ini items
  _contratosItem() {
    List<Widget> item = [];
    if (itemModel.length != 0) {
      itemModel.forEach((contrato) {
        if (contrato.clave == 'CT') {
          item.add(Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(20),
            elevation: 10,
            child: ListTile(
                contentPadding: EdgeInsets.all(20.0),
                leading: Icon(Icons.gavel),
                title: Text(contrato.description),
                subtitle: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton.icon(
                            icon: Icon(Icons.remove_red_eye_rounded),
                            label: Text('Ver'),
                            onPressed: () => _verOldFile(
                                contrato.idMachote, contrato.archivo),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton.icon(
                            icon: Icon(Icons.cloud_download_outlined),
                            label: Text('Descargar archivo'),
                            onPressed: () => _crearPDF(contrato.idMachote,
                                contrato.archivo, contrato.description),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton.icon(
                            icon: Icon(Icons.cloud_upload_outlined),
                            label: Text('Subir archivo'),
                            onPressed: () => _uploadFile(contrato.idContrato),
                          )
                        ],
                      ),
                    ),
                    contrato.valida
                        ? Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextButton.icon(
                                  icon: Icon(Icons.remove_red_eye_rounded),
                                  label: Text('Ver archivo subido'),
                                  onPressed: () =>
                                      _verNewFile(contrato.original),
                                )
                              ],
                            ),
                          )
                        : SizedBox()
                  ],
                ),
                trailing: GestureDetector(
                  child: Icon(
                    Icons.delete,
                    color: Colors.black,
                  ),
                  onTap: () => _borrarContratos(contrato.idContrato),
                )),
          ));
        }
      });
    }
    return item;
  }

  _recibosItem() {
    List<Widget> item = [];
    if (itemModel.length != 0) {
      itemModel.forEach((contrato) {
        if (contrato.clave == 'RC') {
          item.add(Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(20),
            elevation: 10,
            child: ListTile(
                contentPadding: EdgeInsets.all(20.0),
                leading: Icon(Icons.gavel),
                title: Text(contrato.description),
                subtitle: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton.icon(
                            icon: Icon(Icons.remove_red_eye_rounded),
                            label: Text('Ver'),
                            onPressed: () => _verOldFile(
                                contrato.idMachote, contrato.archivo),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton.icon(
                            icon: Icon(Icons.cloud_download_outlined),
                            label: Text('Descargar archivo'),
                            onPressed: () => _crearPDF(contrato.idMachote,
                                contrato.archivo, contrato.description),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton.icon(
                            icon: Icon(Icons.cloud_upload_outlined),
                            label: Text('Subir archivo'),
                            onPressed: () => _uploadFile(contrato.idContrato),
                          )
                        ],
                      ),
                    ),
                    contrato.valida
                        ? Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextButton.icon(
                                  icon: Icon(Icons.remove_red_eye_rounded),
                                  label: Text('Ver archivo subido'),
                                  onPressed: () =>
                                      _verNewFile(contrato.original),
                                )
                              ],
                            ),
                          )
                        : SizedBox()
                  ],
                ),
                trailing: GestureDetector(
                  child: Icon(
                    Icons.delete,
                    color: Colors.black,
                  ),
                  onTap: () => _borrarContratos(contrato.idContrato),
                )),
          ));
        }
      });
    }
    return item;
  }

  _pagosItem() {
    List<Widget> item = [];
    if (itemModel.length != 0) {
      itemModel.forEach((contrato) {
        if (contrato.clave == 'PG') {
          item.add(Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(20),
            elevation: 10,
            child: ListTile(
                contentPadding: EdgeInsets.all(20.0),
                leading: Icon(Icons.gavel),
                title: Text(contrato.description),
                subtitle: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton.icon(
                            icon: Icon(Icons.remove_red_eye_rounded),
                            label: Text('Ver'),
                            onPressed: () => _verOldFile(
                                contrato.idMachote, contrato.archivo),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton.icon(
                            icon: Icon(Icons.cloud_download_outlined),
                            label: Text('Descargar archivo'),
                            onPressed: () => _crearPDF(contrato.idMachote,
                                contrato.archivo, contrato.description),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton.icon(
                            icon: Icon(Icons.cloud_upload_outlined),
                            label: Text('Subir archivo'),
                            onPressed: () => _uploadFile(contrato.idContrato),
                          )
                        ],
                      ),
                    ),
                    contrato.valida
                        ? Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextButton.icon(
                                  icon: Icon(Icons.remove_red_eye_rounded),
                                  label: Text('Ver archivo subido'),
                                  onPressed: () =>
                                      _verNewFile(contrato.original),
                                )
                              ],
                            ),
                          )
                        : SizedBox()
                  ],
                ),
                trailing: GestureDetector(
                  child: Icon(
                    Icons.delete,
                    color: Colors.black,
                  ),
                  onTap: () => _borrarContratos(contrato.idContrato),
                )),
          ));
        }
      });
    }
    return item;
  }

  _minutasItem() {
    List<Widget> item = [];
    if (itemModel.length != 0) {
      itemModel.forEach((contrato) {
        if (contrato.clave == 'MT') {
          item.add(Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(20),
            elevation: 10,
            child: ListTile(
                contentPadding: EdgeInsets.all(20.0),
                leading: Icon(Icons.gavel),
                title: Text(contrato.description),
                subtitle: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton.icon(
                            icon: Icon(Icons.remove_red_eye_rounded),
                            label: Text('Ver'),
                            onPressed: () => _verOldFile(
                                contrato.idMachote, contrato.archivo),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton.icon(
                            icon: Icon(Icons.cloud_download_outlined),
                            label: Text('Descargar archivo'),
                            onPressed: () => _crearPDF(contrato.idMachote,
                                contrato.archivo, contrato.description),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton.icon(
                            icon: Icon(Icons.cloud_upload_outlined),
                            label: Text('Subir archivo'),
                            onPressed: () => _uploadFile(contrato.idContrato),
                          )
                        ],
                      ),
                    ),
                    contrato.valida
                        ? Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextButton.icon(
                                  icon: Icon(Icons.remove_red_eye_rounded),
                                  label: Text('Ver archivo subido'),
                                  onPressed: () =>
                                      _verNewFile(contrato.original),
                                )
                              ],
                            ),
                          )
                        : SizedBox()
                  ],
                ),
                trailing: GestureDetector(
                  child: Icon(
                    Icons.delete,
                    color: Colors.black,
                  ),
                  onTap: () => _borrarContratos(contrato.idContrato),
                )),
          ));
        }
      });
    }
    return item;
  }
  // fin items

  _showNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
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
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt),
          label: 'Minutas',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: (index) => setState(() => _selectedIndex = index),
    );
  }

  _showButton() {
    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      //backgroundColor: hexToColor('#fdf4e5'),
      backgroundColor: hexToColor('#fdf4e5'),
      foregroundColor: Colors.black,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      tooltip: 'Opciones',
      heroTag: 'Opciones',
      children: _childrenButtons(),
    );
  }

  _childrenButtons() {
    List<SpeedDialChild> temp = [];
    // 2do
    temp.add(SpeedDialChild(
        child: Icon(Icons.upload_file),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        onTap: _eventoUpload));
    // 1ro
    temp.add(SpeedDialChild(
        child: Icon(Icons.send_and_archive_sharp),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        onTap: _eventoAdd));
    return temp;
  }

  _eventoUpload() {
    switch (_selectedIndex) {
      case 0:
        _createContrato('CT');
        break;
      case 1:
        _createContrato('RC');
        break;
      case 2:
        _createContrato('PG');
        break;
      default:
        _createContrato('MT');
        break;
    }
  }

  _eventoAdd() {
    switch (_selectedIndex) {
      case 0:
        Navigator.pushNamed(context, '/addContratos',
            arguments: {'clave': 'CT'});
        break;
      case 1:
        Navigator.pushNamed(context, '/addContratos',
            arguments: {'clave': 'RC'});
        break;
      case 2:
        Navigator.pushNamed(context, '/addContratos',
            arguments: {'clave': 'PG'});
        break;
      default:
        Navigator.pushNamed(context, '/addContratos',
            arguments: {'clave': 'MT'});
        break;
    }
  }

  // ini eventos Cards
  _verOldFile(int id, String archivo) {
    if (id != 0) {
      verContratos.add(VerContrato(archivo));
    } else {
      _verNewFile(archivo);
    }
  }

  _uploadFile(int idContrato) async {
    const extensiones = ['pdf'];

    FilePickerResult pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: extensiones,
      allowMultiple: false,
    );

    if (pickedFile != null) {
      verContratos.add(
          SubirContrato(idContrato, base64.encode(pickedFile.files[0].bytes)));
    }
  }

  _verNewFile(String original) {
    // Navigator.pushNamed(context, '/viewContrato', arguments: original);
    verContratos.add(VerContratoSubido(original));
  }

  _borrarContratos(int idContrato) {
    _alertaBorrar(idContrato);
  }

  _crearPDF(int id, String contrato, String nombreDocumento) {
    if (id != 0) {
      verContratos.add(DescargarContrato(nombreDocumento, contrato));
    } else {
      _descargarFile(contrato, nombreDocumento);
    }
  }

  Future<void> _descargarFile(String contrato, String nombreDocumento) async {
    //Create a PDF document
    PdfDocument document = PdfDocument.fromBase64String(contrato);
    List<int> bytes = document.save();
    //Dispose the document
    document.dispose();
    //Download the output file
    if (kIsWeb) {
      // AnchorElement(
      //   href:
      //       "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
      // ..setAttribute("download", nombreDocumento + ".pdf")
      // ..click();
    } else {
      print("Error download");
    }
  }

  _createContrato(String clave) async {
    const extensiones = ['pdf'];

    FilePickerResult pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: extensiones,
      allowMultiple: false,
    );

    if (pickedFile != null) {
      verContratos.add(CrearContrato(
          (pickedFile.files[0].name).replaceAll(".pdf", ""),
          base64.encode(pickedFile.files[0].bytes),
          clave));
    }
  }
  // fin eventos Cards

  // ini mensajes
  Future<void> _mensaje(String txt) async {
    return await ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(txt),
    ));
  }

  _dialogMSG(String title) {
    Widget child = CircularProgressIndicator();
    showDialog(
        context: context,
        //barrierDismissible: false,
        builder: (BuildContext context) {
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

  Future<void> _alertaBorrar(int idContrato) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Estás por borrar un documento.'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                // Center(child: Text('La actividad: $Nombre')),
                // SizedBox(height: 15.0,),
                Center(child: Text('¿Deseas confirmar?')),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Confirmar'),
              onPressed: () {
                Navigator.of(context).pop();
                verContratos.add(BorrarContrato(idContrato));
                _mensaje('Contrato borrado');
              },
            ),
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  // fin mensajes

}

class Contratos {
  int idContrato;
  int idMachote;
  String description;
  String original;
  String archivo;
  String clave;
  bool valida;

  Contratos({
    this.idContrato,
    this.idMachote,
    this.description,
    this.original,
    this.archivo,
    this.clave,
    this.valida,
  });
}

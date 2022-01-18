// imports flutter/dart
// ignore_for_file: unused_local_variable

import 'dart:convert';
// import 'package:universal_html/html.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

// imports
import 'package:file_picker/file_picker.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/ui/widgets/snackbar_widget/snackbar_widget.dart';
import 'package:planning/src/utils/utils.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

// imports from wedding
import 'package:planning/src/blocs/contratos/bloc/contratos_bloc.dart';
import 'package:planning/src/blocs/contratos/bloc/ver_contratos_bloc.dart';

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

  // Variable involucrado
  bool isInvolucrado = false;

  GlobalKey<FormState> keyForm;

  List<Map<String, String>> radioB = [
    {"nombre": "Contratos", "clave": "CT", 'clave_t': 'CT_T'},
    {"nombre": "Recibos", "clave": "RC", 'clave_t': 'RC_T'},
    {"nombre": "Pagos", "clave": "PG", 'clave_t': 'PG_T'},
    {"nombre": "Minutas", "clave": "MT", 'clave_t': 'MT_T'},
    {"nombre": "Orden de pago", "clave": "OP", 'clave_t': 'OP_T'},
    {"nombre": "Autorizaciones", "clave": "AU", 'clave_t': 'AU_T'},
  ];

  int _grupoRadio = 0;
  Map _clave = {'clave': 'CT', 'clave_t': 'CT_T'};
  Size size;

  @override
  void initState() {
    super.initState();
    contratosBloc = BlocProvider.of<ContratosDosBloc>(context);
    contratosBloc.add(ContratosSelect());
    verContratos = BlocProvider.of<VerContratosBloc>(context);
    getIdInvolucrado();
  }

  void getIdInvolucrado() async {
    final _idInvolucrado = await SharedPreferencesT().getIdInvolucrado();

    if (_idInvolucrado != null) {
      setState(() {
        isInvolucrado = true;
      });
    }
  }

  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: (isInvolucrado)
          ? AppBar(
              title: Text('Documentos'),
              centerTitle: true,
            )
          : null,
      body: SingleChildScrollView(
        child: _myBloc(),
      ),
      // bottomNavigationBar: _showNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: !isInvolucrado ? _showButton() : null,
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
        MostrarAlerta(
            mensaje: 'Se ha subido el documento.',
            tipoMensaje: TipoMensaje.correcto);
      } else if (state is VerContratosVer) {
        Navigator.pop(context);
        var tipo_file = state.tipo_mime;
        if (state.archivo != null && state.archivo != '') {
          Navigator.pushNamed(context, '/viewContrato',
              arguments: {'htmlPdf': state.archivo, 'tipo_mime': tipo_file});
        } else {
          MostrarAlerta(
              mensaje: 'No se encuentra ningún archivo.',
              tipoMensaje: TipoMensaje.advertencia);
        }
      } else if (state is DescargarContratoState) {
        Navigator.pop(context);
        _descargarFile(state.archivo, state.nombre, state.extencion);
      } else if (state is CrearContratoState) {
        Navigator.pop(context);
        contratosBloc.add(ContratosSelect());
      } else if (state is DescargarArchivoSubidoState) {
        if (state.subido != null) {
          downloadFile(state.subido, state.nombre,
              extensionFile: state.tipo_mime);
        } else {
          MostrarAlerta(
              mensaje: 'No se encuentra ningún archivo para descargar.',
              tipoMensaje: TipoMensaje.advertencia);
        }
        Navigator.pop(context);
      } else if (state is VerContratoSubidoState) {
        if (state.subido != null) {
          Navigator.pushReplacementNamed(context, '/viewContrato', arguments: {
            'htmlPdf': state.subido,
            'tipo_mime': state.tipo_mime
          });
        } else {
          MostrarAlerta(
              mensaje: 'No se encuentra ningún archivo para descargar.',
              tipoMensaje: TipoMensaje.advertencia);
        }
      } else if (state is DescargarContratoSubidoState) {
        if (state.subido != null) {
          downloadFile(state.subido, state.nombre,
              extensionFile: state.tipo_mime);
        } else {
          MostrarAlerta(
              mensaje: 'No se encuentra ningún archivo para descargar.',
              tipoMensaje: TipoMensaje.advertencia);
        }
        Navigator.pop(context);
      }
    }, child: BlocBuilder<ContratosDosBloc, ContratosState>(
            builder: (context, state) {
      if (state is ContratosInitial) {
        return Center(
          child: LoadingCustom(),
        );
      } else if (state is ContratosLogging) {
        return Center(
          child: LoadingCustom(),
        );
      } else if (state is SelectContratoState) {
        if (itemModel.length == 0) {
          itemModel = state.contrato.contrato
              .map((item) => Contratos(
                  idContrato: item.idContrato,
                  idMachote: item.idMachote,
                  description: item.descripcion,
                  //original: item.original,
                  //archivo: item.archivo,
                  clave: item.clavePlantilla,
                  valida: true, // Hay que cambiar el valor.
                  //  valida: item.original != null ? true : false, // Hay que cambiar el valor.
                  tipo_doc: item.tipo_doc,
                  tipo_mime: item.tipo_mime,
                  tipo_mime_original: item.tipo_mime_original))
              .toList();
        } else if (itemModel.length != state.contrato.contrato) {
          itemModel = state.contrato.contrato
              .map((item) => Contratos(
                  idContrato: item.idContrato,
                  idMachote: item.idMachote,
                  description: item.descripcion,
                  // original: item.original,
                  // archivo: item.archivo,
                  clave: item.clavePlantilla,
                  valida: true, // Hay que cambiar el valor.
                  // valida: item.original != null ? true : false, // Hay que cambiar el valor.
                  tipo_doc: item.tipo_doc,
                  tipo_mime: item.tipo_mime,
                  tipo_mime_original: item.tipo_mime_original))
              .toList();
        }
        return RefreshIndicator(
            color: Colors.blue,
            onRefresh: () async {
              await contratosBloc.add(ContratosSelect());
            },
            child: _showContratos());
      } else {
        return Center(
          child: LoadingCustom(),
        );
      }
    }));
  }

  // cointener => columna => listas x tipo
  _showContratos() {
    return Container(
        padding: EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Card(
                    child: ExpansionTile(
                        title: Text(
                          'Contratos',
                          style: TextStyle(color: Colors.black),
                        ),
                        children: _contratosItem(),
                        trailing: Icon(
                          Icons.gavel,
                          color: Colors.black,
                        )),
                  ),
                  Card(
                    child: ExpansionTile(
                        title: Text('Recibos',
                            style: TextStyle(color: Colors.black)),
                        children: _recibosItem(),
                        trailing: Icon(
                          Icons.receipt,
                          color: Colors.black,
                        )),
                  ),
                  Card(
                    child: ExpansionTile(
                        title: Text('Pagos',
                            style: TextStyle(color: Colors.black)),
                        children: _pagosItem(),
                        trailing: Icon(
                          Icons.request_page,
                          color: Colors.black,
                        )),
                  ),
                  Card(
                    child: ExpansionTile(
                        title: Text('Minutas',
                            style: TextStyle(color: Colors.black)),
                        children: _minutasItem(),
                        trailing: Icon(
                          Icons.receipt,
                          color: Colors.black,
                        )),
                  ),
                  Card(
                    child: ExpansionTile(
                        title: Text('Orden de Pedido',
                            style: TextStyle(color: Colors.black)),
                        children: _ordenPagos(),
                        trailing: Icon(
                          Icons.list_alt,
                          color: Colors.black,
                        )),
                  ),
                  Card(
                    child: ExpansionTile(
                        title: Text('Autorizaciones',
                            style: TextStyle(color: Colors.black)),
                        children: _autorizaciones(),
                        trailing: Icon(
                          Icons.description_outlined,
                          color: Colors.black,
                        )),
                  ),
                ],
              )
            ],
          ),
        ));
  }

  // select lista
  //_itemsContratos() {
  //  switch (_selectedIndex) {
  //    case 0:
  //      return _contratosItem();
  //    case 1:
  //      return _recibosItem();
  //    case 2:
  //      return _pagosItem();
  //    case 3:
  //      return _minutasItem();
  //    case 4:
  //      return _ordenPagos();
  //    default:
  //      return _autorizaciones();
  //  }
  //}

  // ini items
  _contratosItem() {
    List<Widget> item = [];
    if (itemModel.length != 0) {
      itemModel.forEach((contrato) {
        if (contrato.clave == 'CT' || contrato.clave == 'CT_T') {
          item.add(Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(20),
            elevation: 10,
            child: (size.width > 650)
                ? buildWeb(contrato)
                : contratosMovil(contrato),
          ));
        }
      });
    }
    return item;
  }

  ListTile buildWeb(Contratos contrato) {
    return ListTile(
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
                      contrato.idMachote,
                      contrato.idContrato,
                      contrato.tipo_mime,
                      contrato.tipo_doc,
                      contrato.description),
                )
              ],
            ),
          ),
          !isInvolucrado && contrato.tipo_doc == 'html'
              ? Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton.icon(
                        icon: Icon(Icons.edit),
                        label: Text('Editar'),
                        onPressed: () {
                          Navigator.pushNamed(context, '/editarContratos',
                              arguments: {
                                'archivo': '',
                                'id_contrato': contrato.idContrato
                              }).then(
                              (value) => contratosBloc.add(ContratosSelect()));
                          setState(() {
                            contratosBloc.add(ContratosSelect());
                          });
                        },
                      )
                    ],
                  ),
                )
              : Text(''),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton.icon(
                  icon: Icon(Icons.cloud_download_outlined),
                  label: Text('Descargar'),
                  onPressed: () => _crearPDF(
                      contrato.idMachote,
                      contrato.idContrato,
                      contrato.description,
                      contrato.tipo_doc,
                      contrato.tipo_mime),
                )
              ],
            ),
          ),
          !isInvolucrado
              ? Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton.icon(
                        icon: Icon(Icons.cloud_upload_outlined),
                        label: Text('Subir Firmado'),
                        onPressed: () => _uploadFile(contrato.idContrato),
                      )
                    ],
                  ),
                )
              : Text(''),
          contrato.valida
              ? Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton.icon(
                        icon: Icon(Icons.remove_red_eye_rounded),
                        label: Text('Ver Firmado'),
                        onPressed: () => _verNewFile(contrato.idContrato,
                            contrato.tipo_mime_original, contrato.tipo_doc),
                      )
                    ],
                  ),
                )
              : SizedBox(),
          contrato.valida
              ? Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton.icon(
                          icon: Icon(Icons.cloud_download_outlined),
                          label: Text('Descarga Firmado.'),
                          onPressed: () => {
                                _descargaArchivoSubido(
                                    contrato.idContrato,
                                    contrato.tipo_mime_original,
                                    contrato.description)
                              }),
                    ],
                  ),
                )
              : SizedBox(),
        ],
      ),
      trailing: !isInvolucrado
          ? GestureDetector(
              child: Icon(
                Icons.delete,
                color: Colors.black,
              ),
              onTap: () => _borrarContratos(contrato.idContrato),
            )
          : Text(''),
    );
  }

  ExpansionTile contratosMovil(Contratos contrato) {
    return ExpansionTile(
      trailing: !isInvolucrado
          ? GestureDetector(
              child: Icon(
                Icons.delete,
                color: Colors.black,
              ),
              onTap: () => _borrarContratos(contrato.idContrato),
            )
          : Text(''),
      leading: Icon(
        Icons.gavel,
        color: Colors.black,
      ),
      title: Text(
        contrato.description,
        style: TextStyle(color: Colors.black),
        overflow: TextOverflow.ellipsis,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton.icon(
                    icon: Icon(Icons.remove_red_eye_rounded),
                    label: Text('Ver'),
                    onPressed: () => _verOldFile(
                        contrato.idMachote,
                        contrato.idContrato,
                        contrato.tipo_mime,
                        contrato.tipo_doc,
                        contrato.description),
                  )
                ],
              ),
              if (!isInvolucrado && contrato.tipo_doc == 'html')
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton.icon(
                      icon: Icon(Icons.edit),
                      label: Text('Editar'),
                      onPressed: () {
                        Navigator.pushNamed(context, '/editarContratos',
                            arguments: {
                              'archivo': '',
                              'id_contrato': contrato.idContrato
                            }).then(
                            (value) => contratosBloc.add(ContratosSelect()));
                        setState(() {
                          contratosBloc.add(ContratosSelect());
                        });
                      },
                    )
                  ],
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton.icon(
                    icon: Icon(Icons.cloud_download_outlined),
                    label: Text('Descargar'),
                    onPressed: () => _crearPDF(
                        contrato.idMachote,
                        contrato.idContrato,
                        contrato.description,
                        contrato.tipo_doc,
                        contrato.tipo_mime),
                  )
                ],
              ),
              if (!isInvolucrado)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton.icon(
                      icon: Icon(Icons.cloud_upload_outlined),
                      label: Text('Subir firmado'),
                      onPressed: () => _uploadFile(contrato.idContrato),
                    )
                  ],
                ),
              if (contrato.valida)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton.icon(
                      icon: Icon(Icons.remove_red_eye_rounded),
                      label: Text('Ver firmado'),
                      onPressed: () => _verNewFile(contrato.idContrato,
                          contrato.tipo_mime_original, contrato.tipo_doc),
                    )
                  ],
                ),
              if (contrato.valida)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton.icon(
                        icon: Icon(Icons.cloud_download_outlined),
                        label: Text(
                          'Descargar firmado',
                          overflow: TextOverflow.ellipsis,
                        ),
                        onPressed: () => {
                              _descargaArchivoSubido(
                                  contrato.idContrato,
                                  contrato.tipo_mime_original,
                                  contrato.description)
                            }),
                  ],
                ),
            ],
          ),
        )
      ],
    );
  }

  _recibosItem() {
    List<Widget> item = [];
    if (itemModel.length != 0) {
      itemModel.forEach((contrato) {
        if (contrato.clave == 'RC' || contrato.clave == 'RC_T') {
          item.add(Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(20),
            elevation: 10,
            child: (size.width > 650)
                ? buildWeb(contrato)
                : contratosMovil(contrato),
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
        if (contrato.clave == 'PG' || contrato.clave == 'PG_T') {
          item.add(Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(20),
            elevation: 10,
            child: (size.width > 650)
                ? buildWeb(contrato)
                : contratosMovil(contrato),
          ));
        }
      });
    }
    return item;
  }

  _ordenPagos() {
    List<Widget> item = [];
    if (itemModel.length != 0) {
      itemModel.forEach((contrato) {
        if (contrato.clave == 'OP' || contrato.clave == 'OP_T') {
          item.add(Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(20),
            elevation: 10,
            child: (size.width > 650)
                ? buildWeb(contrato)
                : contratosMovil(contrato),
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
        if (contrato.clave == 'MT' || contrato.clave == 'MT_T') {
          item.add(Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(20),
            elevation: 10,
            child: (size.width > 650)
                ? buildWeb(contrato)
                : contratosMovil(contrato),
          ));
        }
      });
    }
    return item;
  }

  _autorizaciones() {
    List<Widget> item = [];
    if (itemModel.length != 0) {
      itemModel.forEach((contrato) {
        if (contrato.clave == 'AU' || contrato.clave == 'AU_T') {
          item.add(Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(20),
            elevation: 10,
            child: (size.width > 650)
                ? buildWeb(contrato)
                : contratosMovil(contrato),
          ));
        }
      });
    }
    return item;
  }
  // fin items

  // _showNavigationBar() {
  //   return BottomNavigationBar(
  //     type: BottomNavigationBarType.fixed,
  //     items: [
  //       BottomNavigationBarItem(
  //         icon: Icon(Icons.gavel),
  //         label: 'Contratos',
  //       ),
  //       BottomNavigationBarItem(
  //         icon: Icon(Icons.receipt),
  //         label: 'Recibos',
  //       ),
  //       BottomNavigationBarItem(
  //         icon: Icon(Icons.request_page),
  //         label: 'Pagos',
  //       ),
  //       BottomNavigationBarItem(
  //         icon: Icon(Icons.receipt),
  //         label: 'Minutas',
  //       ),
  //       BottomNavigationBarItem(
  //         icon: Icon(Icons.list_alt),
  //         label: 'Orden de pedido',
  //       ),
  //       BottomNavigationBarItem(
  //         icon: Icon(Icons.description_outlined),
  //         label: 'Autorizaciones',
  //       ),
  //     ],
  //     currentIndex: _selectedIndex,
  //     onTap: (index) => setState(() => _selectedIndex = index),
  //   );
  // }

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
      heroTag: UniqueKey().toString(),
      children: _childrenButtons(),
    );
  }

  _childrenButtons() {
    List<SpeedDialChild> temp = [];
    temp.add(SpeedDialChild(
        child: Tooltip(
          child: Icon(Icons.upload_file),
          message: 'Subir firmado',
        ),
        label: 'Subir firmado',
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        onTap: _eventoUploadFile));
    // 1ro
    temp.add(SpeedDialChild(
        child: Tooltip(
            child: Icon(Icons.send_and_archive_sharp),
            message: 'Crear plantilla'),
        label: 'Crear plantilla',
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        onTap: () {
          _eventoAdd('html');
        }));
    return temp;
  }

  //_eventoUpload() {
  //  switch (_selectedIndex) {
  //    case 0:
  //      _createContrato('CT');
  //      break;
  //    case 1:
  //      _createContrato('RC');
  //      break;
  //    case 2:
  //      _createContrato('PG');
  //      break;
  //    case 3:
  //      _createContrato('MT');
  //      break;
  //    case 4:
  //      _createContrato('OP');
  //      break;
  //    default:
  //      _createContrato('AU');
  //      break;
  //  }
  //}

  Future<void> _eventoUploadFile() async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Subir firmado', textAlign: TextAlign.center),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Form(
                key: keyForm,
                child: SingleChildScrollView(
                  child: ListBody(
                    children: [
                      Column(
                        children: <Widget>[
                          for (int i = 0; i < radioB.length; i++)
                            ListTile(
                              title: Text(
                                radioB.elementAt(i)['nombre'],
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(color: Colors.black),
                              ),
                              leading: Radio(
                                value: i,
                                groupValue: _grupoRadio,
                                activeColor: Color(0xFF6200EE),
                                onChanged: (int value) {
                                  setState(() {
                                    _grupoRadio = value;
                                    _clave = {
                                      'clave': radioB.elementAt(i)['clave'],
                                      'clave_t': radioB.elementAt(i)['clave_t']
                                    };
                                  });
                                },
                              ),
                            ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            SizedBox(
              width: 5.0,
            ),
            TextButton(
              child: Text('Seleccionar Archivo'),
              onPressed: () async {
                _createContrato(_clave['clave'], 'file');
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _eventoAdd(String tipo_doc) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Crear plantilla', textAlign: TextAlign.center),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Form(
                key: keyForm,
                child: SingleChildScrollView(
                  child: ListBody(
                    children: [
                      Column(
                        children: <Widget>[
                          for (int i = 0; i < radioB.length; i++)
                            ListTile(
                              title: Text(
                                radioB.elementAt(i)['nombre'],
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(color: Colors.black),
                              ),
                              leading: Radio(
                                value: i,
                                groupValue: _grupoRadio,
                                activeColor: Color(0xFF6200EE),
                                onChanged: (int value) {
                                  setState(() {
                                    _grupoRadio = value;
                                    _clave = {
                                      'clave': radioB.elementAt(i)['clave'],
                                      'clave_t': radioB.elementAt(i)['clave_t'],
                                      'tipo_doc': tipo_doc,
                                      'tipo_mime': 'pdf'
                                    };
                                  });
                                },
                              ),
                            ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            SizedBox(
              width: 10.0,
            ),
            TextButton(
              child: Text('Guardar'),
              onPressed: () async {
                Navigator.pushReplacementNamed(context, '/addContratos',
                    arguments: _clave);
              },
            ),
          ],
        );
      },
      // switch (_selectedIndex) {
      //   case 0:
      //     Navigator.pushNamed(context, '/addContratos',
      //         arguments: {'clave': 'CT', 'clave_t': 'CT_T'});
      //     break;
      //   case 1:
      //     Navigator.pushNamed(context, '/addContratos',
      //         arguments: {'clave': 'RC', 'clave_t': 'RC_T'});
      //     break;
      //   case 2:
      //     Navigator.pushNamed(context, '/addContratos',
      //         arguments: {'clave': 'PG', 'clave_t': 'PG_T'});
      //     break;
      //   case 3:
      //     Navigator.pushNamed(context, '/addContratos',
      //         arguments: {'clave': 'MT', 'clave_t': 'MT_T'});
      //     break;
      //   case 4:
      //     Navigator.pushNamed(context, '/addContratos',
      //         arguments: {'clave': 'OP', 'clave_t': 'OP_T'});
      //     break;
      //   default:
      //     Navigator.pushNamed(context, '/addContratos',
      //         arguments: {'clave': 'AU', 'clave_t': 'AU_T'});
      //     break;
      // }
    );
  }

  // ini eventos Cards
  _verOldFile(int idMachote, int idContrato, String tipo_mime, String tipo_doc,
      String descripcion) {
    // if (idMachote != 0) {
    if (tipo_doc == 'html') {
      verContratos.add(VerContrato(idContrato, tipo_mime, tipo_doc));
    } else if (tipo_doc == 'file') {
      verContratos
          .add(VerContratoSubidoEvent(idContrato, tipo_mime, descripcion));
    }
  }

  _uploadFile(int idContrato) async {
    const extensiones = ['jpg', 'png', 'jpeg', 'pdf'];
    FilePickerResult pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: extensiones,
      allowMultiple: false,
    );

    if (pickedFile != null) {
      String _extension = pickedFile.files.first.extension;
      verContratos.add(SubirContrato(idContrato,
          base64.encode(pickedFile.files[0].bytes), 'html', _extension));
    }
  }

  _verNewFile(int id_contrato, String tipo_mime, String tipo_doc) {
    // Navigator.pushNamed(context, '/viewContrato', arguments: original);
    verContratos.add(VerContratoSubido(id_contrato, tipo_mime, tipo_doc));
  }

  _descargaArchivoSubido(int id_contrato, String tipo_mime, String nombre) {
    verContratos
        .add(DescargarArchivoSubidoEvent(id_contrato, tipo_mime, nombre));
  }

  _borrarContratos(int idContrato) {
    _alertaBorrar(idContrato);
  }

  _crearPDF(int id, int idContrato, String nombreDocumento, String tipo_doc,
      String extencion) {
    if (id != 0) {
      verContratos
          .add(DescargarContrato(nombreDocumento, idContrato, extencion));
    } else if (tipo_doc == 'file') {
      //_descargarFile(contrato, nombreDocumento, extencion);
      verContratos.add(
          DescargarContratoSubidoEvent(idContrato, extencion, nombreDocumento));
    }
  }

  Future<void> _descargarFile(
      String contrato, String nombreDocumento, String extencion) async {
    downloadFile(contrato, nombreDocumento, extensionFile: extencion);
  }

  _createContrato(String clave, String tipo_doc) async {
    const extensiones = ['jpg', 'png', 'jpeg', 'pdf'];

    FilePickerResult pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: extensiones,
      allowMultiple: false,
    );

    if (pickedFile != null) {
      String _extension = pickedFile.files.first.extension;
      verContratos.add(CrearContrato(
          (pickedFile.files[0].name).replaceAll(_extension.toString(), ""),
          base64.encode(pickedFile.files[0].bytes),
          clave,
          tipo_doc,
          _extension));
      Navigator.of(context).pop();
    }
  }
  // fin eventos Cards

  _dialogMSG(String title) {
    Widget child = LoadingCustom();
    showDialog(
        context: context,
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
          title: const Text('Estás por borrar un documentos.'),
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
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirmar'),
              onPressed: () {
                Navigator.of(context).pop();
                verContratos.add(BorrarContrato(idContrato));
                MostrarAlerta(
                    mensaje: 'Contrato Borrado.',
                    tipoMensaje: TipoMensaje.correcto);
              },
            ),
          ],
        );
      },
    );
  }
}

class Contratos {
  int idContrato;
  int idMachote;
  String description;
  // String original;
  // String archivo;
  String clave;
  bool valida;
  String tipo_doc;
  String tipo_mime;
  String tipo_mime_original;

  Contratos(
      {this.idContrato,
      this.idMachote,
      this.description,
      // this.original,
      // this.archivo,
      this.clave,
      this.valida,
      this.tipo_doc,
      this.tipo_mime,
      this.tipo_mime_original});
}

// imports flutter/dart
// ignore_for_file: unused_local_variable, void_checks

import 'dart:convert';
// import 'package:universal_html/html.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// imports
import 'package:file_picker/file_picker.dart';
import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/logic/add_contratos_logic.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/ui/widgets/snackbar_widget/snackbar_widget.dart';
import 'package:planning/src/utils/utils.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

// imports from wedding
import 'package:planning/src/blocs/contratos/bloc/contratos_bloc.dart';
import 'package:planning/src/blocs/contratos/bloc/ver_contratos_bloc.dart';

class NewContrato extends StatefulWidget {
  const NewContrato({Key key}) : super(key: key);

  @override
  NewContratoState createState() => NewContratoState();
}

class NewContratoState extends State<NewContrato> {
  // variables bloc
  ContratosDosBloc contratosBloc;
  VerContratosBloc verContratos;

  // vaiables clase
  List<Contratos> itemModel = [];

  // Variable involucrado
  bool isInvolucrado = false;
  bool desconectado = false;

  GlobalKey<FormState> keyForm;

  List<Map<String, String>> radioB = [
    {"nombre": "Contratos", "clave": "CT", 'clave_t': 'CT_T'},
    {"nombre": "Recibos", "clave": "RC", 'clave_t': 'RC_T'},
    {"nombre": "Pagos", "clave": "PG", 'clave_t': 'PG_T'},
    {"nombre": "Minutas", "clave": "MT", 'clave_t': 'MT_T'},
    {"nombre": "Orden de pedido", "clave": "OP", 'clave_t': 'OP_T'},
    {"nombre": "Autorizaciones", "clave": "AU", 'clave_t': 'AU_T'},
  ];

  int _grupoRadio = 0;
  Map _clave = {'clave': 'CT', 'clave_t': 'CT_T'};
  Size size;

  ConsultasAddContratosLogic logicDocumento = ConsultasAddContratosLogic();

  @override
  void initState() {
    super.initState();
    contratosBloc = BlocProvider.of<ContratosDosBloc>(context);
    contratosBloc.add(ContratosSelect());
    verContratos = BlocProvider.of<VerContratosBloc>(context);
    getIdInvolucrado();
    getModoSinConexion();
  }

  void getIdInvolucrado() async {
    final idInvolucrado = await SharedPreferencesT().getIdInvolucrado();

    if (idInvolucrado != null) {
      setState(() {
        isInvolucrado = true;
      });
    }
  }

  void getModoSinConexion() async {
    desconectado = await SharedPreferencesT().getModoConexion();
    setState(() {});
  }

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: (isInvolucrado)
          ? AppBar(
              title: const Text('Documentos'),
              centerTitle: true,
            )
          : null,
      body: SingleChildScrollView(
        child: _myBloc(),
      ),
      // bottomNavigationBar: _showNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton:
          !isInvolucrado && !desconectado ? _showButton() : null,
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
        Navigator.of(context, rootNavigator: true).pop();
        contratosBloc.add(ContratosSelect());
        MostrarAlerta(
            mensaje: 'Se ha subido el documento.',
            tipoMensaje: TipoMensaje.correcto);
      } else if (state is VerContratosVer) {
        Navigator.of(context, rootNavigator: true).pop();

        var tipoFile = state.tipoMime;
        if (state.archivo != null && state.archivo != '') {
          Navigator.pushNamed(context, '/viewContrato',
              arguments: {'htmlPdf': state.archivo, 'tipo_mime': tipoFile});
        } else {
          MostrarAlerta(
              mensaje: 'No se encuentra ningún archivo.',
              tipoMensaje: TipoMensaje.advertencia);
        }
      } else if (state is DescargarContratoState) {
        Navigator.of(context, rootNavigator: true).pop();

        _descargarFile(state.archivo, state.nombre, state.extencion);
      } else if (state is CrearContratoState) {
        Navigator.pop(context);
        contratosBloc.add(ContratosSelect());
      } else if (state is DescargarArchivoSubidoState) {
        if (state.subido != null) {
          downloadFile(state.subido, state.nombre,
              extensionFile: state.tipoMime);
        } else {
          MostrarAlerta(
              mensaje: 'No se encuentra ningún archivo para descargar.',
              tipoMensaje: TipoMensaje.advertencia);
        }
        Navigator.of(context, rootNavigator: true).pop();
      } else if (state is VerContratoSubidoState) {
        if (state.subido != null) {
          Navigator.pushReplacementNamed(context, '/viewContrato', arguments: {
            'htmlPdf': state.subido,
            'tipo_mime': state.tipoMime
          });
        } else {
          MostrarAlerta(
              mensaje: 'No se encuentra ningún archivo para descargar.',
              tipoMensaje: TipoMensaje.advertencia);
        }
      } else if (state is DescargarContratoSubidoState) {
        if (state.subido != null) {
          downloadFile(state.subido, state.nombre,
              extensionFile: state.tipoMime);
        } else {
          MostrarAlerta(
              mensaje: 'No se encuentra ningún archivo para descargar.',
              tipoMensaje: TipoMensaje.advertencia);
        }
        Navigator.of(context, rootNavigator: true).pop();
      }
    }, child: BlocBuilder<ContratosDosBloc, ContratosState>(
            builder: (context, state) {
      if (state is ContratosInitial) {
        return const Center(
          child: LoadingCustom(),
        );
      } else if (state is ContratosLogging) {
        return const Center(
          child: LoadingCustom(),
        );
      } else if (state is SelectContratoState) {
        if (itemModel.isEmpty) {
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
                  tipoDoc: item.tipoDoc,
                  tipoMime: item.tipoMime,
                  tipoMimeOriginal: item.tipoMimeOriginal))
              .toList();
        } else {
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
                  tipoDoc: item.tipoDoc,
                  tipoMime: item.tipoMime,
                  tipoMimeOriginal: item.tipoMimeOriginal))
              .toList();
        }
        return RefreshIndicator(
            color: Colors.blue,
            onRefresh: () async {
              contratosBloc.add(ContratosSelect());
            },
            child: _showContratos());
      } else {
        return const Center(
          child: LoadingCustom(),
        );
      }
    }));
  }

  // cointener => columna => listas x tipo
  _showContratos() {
    return Container(
        padding: const EdgeInsets.all(10.0),
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
                        title: const Text(
                          'Contratos',
                          style: TextStyle(color: Colors.black),
                        ),
                        children: _contratosItem(),
                        trailing: const Icon(
                          Icons.gavel,
                          color: Colors.black,
                        )),
                  ),
                  Card(
                    child: ExpansionTile(
                        title: const Text('Recibos',
                            style: TextStyle(color: Colors.black)),
                        children: _recibosItem(),
                        trailing: const Icon(
                          Icons.receipt,
                          color: Colors.black,
                        )),
                  ),
                  if (!isInvolucrado)
                    Card(
                      child: ExpansionTile(
                          title: const Text('Pagos',
                              style: TextStyle(color: Colors.black)),
                          children: _pagosItem(),
                          trailing: const Icon(
                            Icons.request_page,
                            color: Colors.black,
                          )),
                    ),
                  Card(
                    child: ExpansionTile(
                        title: const Text('Minutas',
                            style: TextStyle(color: Colors.black)),
                        children: _minutasItem(),
                        trailing: const Icon(
                          Icons.receipt,
                          color: Colors.black,
                        )),
                  ),
                  if (!isInvolucrado)
                    Card(
                      child: ExpansionTile(
                          title: const Text('Orden de pedido',
                              style: TextStyle(color: Colors.black)),
                          children: _ordenPagos(),
                          trailing: const Icon(
                            Icons.list_alt,
                            color: Colors.black,
                          )),
                    ),
                  Card(
                    child: ExpansionTile(
                        title: const Text('Autorizaciones',
                            style: TextStyle(color: Colors.black)),
                        children: _autorizaciones(),
                        trailing: const Icon(
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
    if (itemModel.isNotEmpty) {
      for (var contrato in itemModel) {
        if (contrato.clave == 'CT' || contrato.clave == 'CT_T') {
          item.add(Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(size.width > 650 ? 20 : 8),
            elevation: 10,
            child: (size.width > 650)
                ? buildWeb(contrato)
                : contratosMovil(contrato),
          ));
        }
      }
    }
    return item;
  }

  ListTile buildWeb(Contratos contrato) {
    return ListTile(
      contentPadding: const EdgeInsets.all(20.0),
      leading: !isInvolucrado
          ? GestureDetector(
              onTap: desconectado
                  ? null
                  : () {
                      _shodDialogEdit(
                          contrato.idContrato, contrato.description);
                    },
              child: const Icon(Icons.edit))
          : null,
      title: Text(contrato.description),
      subtitle: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.remove_red_eye_rounded),
                  label: const Text('Ver'),
                  onPressed: () => _verOldFile(
                      contrato.idMachote,
                      contrato.idContrato,
                      contrato.tipoMime,
                      contrato.tipoDoc,
                      contrato.description),
                )
              ],
            ),
          ),
          contrato.tipoDoc == 'html'
              ? Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton.icon(
                        icon: const Icon(Icons.edit),
                        label: const Text('Editar'),
                        onPressed: desconectado
                            ? null
                            : () {
                                Navigator.pushNamed(context, '/editarContratos',
                                    arguments: {
                                      'archivo': '',
                                      'id_contrato': contrato.idContrato
                                    }).then((value) =>
                                    contratosBloc.add(ContratosSelect()));
                                setState(() {
                                  contratosBloc.add(ContratosSelect());
                                });
                              },
                      )
                    ],
                  ),
                )
              : const Text(''),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.cloud_download_outlined),
                  label: const Text('Descargar'),
                  onPressed: () => _crearPDF(
                      contrato.idMachote,
                      contrato.idContrato,
                      contrato.description,
                      contrato.tipoDoc,
                      contrato.tipoMime),
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
                        icon: const Icon(Icons.cloud_upload_outlined),
                        label: const Text('Subir firmado'),
                        onPressed: desconectado
                            ? null
                            : () => _uploadFile(contrato.idContrato),
                      )
                    ],
                  ),
                )
              : const Text(''),
          contrato.valida
              ? Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton.icon(
                        icon: const Icon(Icons.remove_red_eye_rounded),
                        label: const Text('Ver firmado'),
                        onPressed: () {
                          _verNewFile(contrato.idContrato,
                              contrato.tipoMimeOriginal, contrato.tipoDoc);
                        },
                      )
                    ],
                  ),
                )
              : const SizedBox(),
          contrato.valida
              ? Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton.icon(
                          icon: const Icon(Icons.cloud_download_outlined),
                          label: const Text('Descarga firmado.'),
                          onPressed: () => {
                                _descargaArchivoSubido(
                                    contrato.idContrato,
                                    contrato.tipoMimeOriginal,
                                    contrato.description)
                              }),
                    ],
                  ),
                )
              : const SizedBox(),
        ],
      ),
      trailing: !isInvolucrado
          ? GestureDetector(
              child: Icon(
                Icons.delete,
                color: desconectado ? Colors.grey : Colors.black,
              ),
              onTap: desconectado
                  ? null
                  : () => _borrarContratos(contrato.idContrato),
            )
          : null,
    );
  }

  ExpansionTile contratosMovil(Contratos contrato) {
    return ExpansionTile(
      trailing: !isInvolucrado
          ? GestureDetector(
              child: Icon(
                Icons.delete,
                color: desconectado ? Colors.grey : Colors.black,
              ),
              onTap: desconectado
                  ? null
                  : () => _borrarContratos(contrato.idContrato),
            )
          : null,
      leading: !isInvolucrado
          ? GestureDetector(
              onTap: desconectado
                  ? null
                  : () {
                      _shodDialogEdit(
                          contrato.idContrato, contrato.description);
                    },
              child: const Icon(Icons.edit))
          : null,
      title: Text(
        contrato.description,
        style: const TextStyle(color: Colors.black),
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
                    icon: const Icon(Icons.remove_red_eye_rounded),
                    label: const Text('Ver'),
                    onPressed: () => _verOldFile(
                        contrato.idMachote,
                        contrato.idContrato,
                        contrato.tipoMime,
                        contrato.tipoDoc,
                        contrato.description),
                  )
                ],
              ),
              if (!isInvolucrado && contrato.tipoDoc == 'html')
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.edit),
                      label: const Text('Editar'),
                      onPressed: desconectado
                          ? null
                          : () {
                              Navigator.pushNamed(context, '/editarContratos',
                                  arguments: {
                                    'archivo': '',
                                    'id_contrato': contrato.idContrato
                                  }).then((value) =>
                                  contratosBloc.add(ContratosSelect()));
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
                    icon: const Icon(Icons.cloud_download_outlined),
                    label: const Text('Descargar'),
                    onPressed: () => _crearPDF(
                        contrato.idMachote,
                        contrato.idContrato,
                        contrato.description,
                        contrato.tipoDoc,
                        contrato.tipoMime),
                  )
                ],
              ),
              if (!isInvolucrado)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.cloud_upload_outlined),
                      label: const Text('Subir firmado'),
                      onPressed: desconectado
                          ? null
                          : () => _uploadFile(contrato.idContrato),
                    )
                  ],
                ),
              if (contrato.valida)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.remove_red_eye_rounded),
                      label: const Text('Ver firmado'),
                      onPressed: () => _verNewFile(contrato.idContrato,
                          contrato.tipoMimeOriginal, contrato.tipoDoc),
                    )
                  ],
                ),
              if (contrato.valida)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton.icon(
                        icon: const Icon(Icons.cloud_download_outlined),
                        label: const Text(
                          'Descargar firmado',
                          overflow: TextOverflow.ellipsis,
                        ),
                        onPressed: () => {
                              _descargaArchivoSubido(
                                  contrato.idContrato,
                                  contrato.tipoMimeOriginal,
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

  void _shodDialogEdit(int idDocumento, String descripcion) {
    final formkeyEditDocumento = GlobalKey<FormState>();
    String descripcionTemp = descripcion;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar documento'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
              key: formkeyEditDocumento,
              child: TextFormField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Descripción',
                    labelText: 'Descripción'),
                onChanged: (String value) {
                  descripcionTemp = value;
                },
                initialValue: descripcionTemp,
                validator: (String value) {
                  if (value != '') {
                    return null;
                  }
                  return 'El campo esta vacío';
                },
              ),
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              if (formkeyEditDocumento.currentState.validate()) {
                final data =
                    await logicDocumento.actualizarDescripcionDocumento(
                        idDocumento, descripcionTemp);

                if (data == 'Ok') {
                  if (mounted) {
                    Navigator.of(context, rootNavigator: true).pop();
                  }

                  MostrarAlerta(
                      mensaje: 'Se actulizó el nombre correctamente',
                      tipoMensaje: TipoMensaje.correcto);
                  contratosBloc.add(ContratosSelect());
                } else {
                  if (mounted) {
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                  MostrarAlerta(mensaje: data, tipoMensaje: TipoMensaje.error);
                }
              }
            },
            child: const Text('Aceptar'),
          )
        ],
      ),
    );
  }

  _recibosItem() {
    List<Widget> item = [];
    if (itemModel.isNotEmpty) {
      for (var contrato in itemModel) {
        if (contrato.clave == 'RC' || contrato.clave == 'RC_T') {
          item.add(Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(size.width > 650 ? 20 : 8),
            elevation: 10,
            child: (size.width > 650)
                ? buildWeb(contrato)
                : contratosMovil(contrato),
          ));
        }
      }
    }
    return item;
  }

  _pagosItem() {
    List<Widget> item = [];
    if (itemModel.isNotEmpty) {
      for (var contrato in itemModel) {
        if (contrato.clave == 'PG' || contrato.clave == 'PG_T') {
          item.add(Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(size.width > 650 ? 20 : 8),
            elevation: 10,
            child: (size.width > 650)
                ? buildWeb(contrato)
                : contratosMovil(contrato),
          ));
        }
      }
    }
    return item;
  }

  _ordenPagos() {
    List<Widget> item = [];
    if (itemModel.isNotEmpty) {
      for (var contrato in itemModel) {
        if (contrato.clave == 'OP' || contrato.clave == 'OP_T') {
          item.add(Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(size.width > 650 ? 20 : 8),
            elevation: 10,
            child: (size.width > 650)
                ? buildWeb(contrato)
                : contratosMovil(contrato),
          ));
        }
      }
    }
    return item;
  }

  _minutasItem() {
    List<Widget> item = [];
    if (itemModel.isNotEmpty) {
      for (var contrato in itemModel) {
        if (contrato.clave == 'MT' || contrato.clave == 'MT_T') {
          item.add(Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(size.width > 650 ? 20 : 8),
            elevation: 10,
            child: (size.width > 650)
                ? buildWeb(contrato)
                : contratosMovil(contrato),
          ));
        }
      }
    }
    return item;
  }

  _autorizaciones() {
    List<Widget> item = [];
    if (itemModel.isNotEmpty) {
      for (var contrato in itemModel) {
        if (contrato.clave == 'AU' || contrato.clave == 'AU_T') {
          item.add(Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(size.width > 650 ? 20 : 8),
            elevation: 10,
            child: (size.width > 650)
                ? buildWeb(contrato)
                : contratosMovil(contrato),
          ));
        }
      }
    }
    return item;
  }

  _showButton() {
    return SpeedDial(
      icon: Icons.more_vert,
      tooltip: 'Opciones',
      children: _childrenButtons(),
    );
  }

  _childrenButtons() {
    List<SpeedDialChild> temp = [];
    temp.add(SpeedDialChild(
        child: const Tooltip(
          message: 'Subir archivo',
          child: Icon(Icons.upload_file),
        ),
        label: 'Subir archivo',
        onTap: _eventoUploadFile));
    // 1ro
    temp.add(SpeedDialChild(
        child: const Tooltip(
            message: 'Crear plantilla',
            child: Icon(Icons.send_and_archive_sharp)),
        label: 'Crear plantilla',
        onTap: () {
          _eventoAdd('html');
        }));
    return temp;
  }

  Future<void> _eventoUploadFile() async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Subir firmado', textAlign: TextAlign.center),
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
                                activeColor: const Color(0xFF6200EE),
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
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
            const SizedBox(
              width: 5.0,
            ),
            TextButton(
              child: const Text('Seleccionar archivo'),
              onPressed: () async {
                _createContrato(_clave['clave'], 'file');
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _eventoAdd(String tipoDoc) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Crear plantilla', textAlign: TextAlign.center),
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
                                activeColor: const Color(0xFF6200EE),
                                onChanged: (int value) {
                                  setState(() {
                                    _grupoRadio = value;
                                    _clave = {
                                      'clave': radioB.elementAt(i)['clave'],
                                      'clave_t': radioB.elementAt(i)['clave_t'],
                                      'tipo_doc': tipoDoc,
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
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(
              width: 10.0,
            ),
            TextButton(
              child: const Text('Guardar'),
              onPressed: () async {
                Navigator.pushReplacementNamed(context, '/addContratos',
                    arguments: _clave);
              },
            ),
          ],
        );
      },
    );
  }

  // ini eventos Cards
  _verOldFile(int idMachote, int idContrato, String tipoMime, String tipoDoc,
      String descripcion) {
    // if (idMachote != 0) {
    if (tipoDoc == 'html') {
      verContratos.add(VerContrato(idContrato, tipoMime, tipoDoc));
    } else if (tipoDoc == 'file') {
      verContratos
          .add(VerContratoSubidoEvent(idContrato, tipoMime, descripcion));
    }
  }

  _uploadFile(int idContrato) async {
    const extensiones = ['jpg', 'png', 'jpeg', 'pdf'];
    FilePickerResult pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      withData: true,
      allowedExtensions: extensiones,
      allowMultiple: false,
    );

    if (pickedFile != null) {
      String extension = pickedFile.files.first.extension;
      verContratos.add(SubirContrato(idContrato,
          base64.encode(pickedFile.files[0].bytes), 'html', extension));
    }
  }

  _verNewFile(int idContrato, String tipoMime, String tipoDoc) {
    // Navigator.pushNamed(context, '/viewContrato', arguments: original);
    verContratos.add(VerContratoSubido(idContrato, tipoMime, tipoDoc));
  }

  _descargaArchivoSubido(int idContrato, String tipoMime, String nombre) {
    verContratos.add(DescargarArchivoSubidoEvent(idContrato, tipoMime, nombre));
  }

  _borrarContratos(int idContrato) {
    _alertaBorrar(idContrato);
  }

  _crearPDF(int id, int idContrato, String nombreDocumento, String tipoDoc,
      String extencion) {
    if (id != 0) {
      verContratos
          .add(DescargarContrato(nombreDocumento, idContrato, extencion));
    } else if (tipoDoc == 'file') {
      //_descargarFile(contrato, nombreDocumento, extencion);
      verContratos.add(
          DescargarContratoSubidoEvent(idContrato, extencion, nombreDocumento));
    }
  }

  Future<void> _descargarFile(
      String contrato, String nombreDocumento, String extencion) async {
    downloadFile(contrato, nombreDocumento, extensionFile: extencion);
  }

  _createContrato(String clave, String tipoDoc) async {
    const extensiones = ['jpg', 'png', 'jpeg', 'pdf'];

    FilePickerResult pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      withData: true,
      allowedExtensions: extensiones,
      allowMultiple: false,
    );

    if (pickedFile != null) {
      String extension = pickedFile.files.first.extension;
      verContratos.add(CrearContrato(
          (pickedFile.files[0].name).replaceAll(extension.toString(), ""),
          base64.encode(pickedFile.files[0].bytes),
          clave,
          tipoDoc,
          extension));
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }
  // fin eventos Cards

  _dialogMSG(String title) {
    Widget child = const LoadingCustom();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              title,
              textAlign: TextAlign.center,
            ),
            content: child,
            shape: const RoundedRectangleBorder(
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
              children: const <Widget>[
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
                Navigator.of(context, rootNavigator: true).pop();
                verContratos.add(BorrarContrato(idContrato));
                MostrarAlerta(
                    mensaje: 'Contrato borrado.',
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
  String tipoDoc;
  String tipoMime;
  String tipoMimeOriginal;

  Contratos(
      {this.idContrato,
      this.idMachote,
      this.description,
      // this.original,
      // this.archivo,
      this.clave,
      this.valida,
      this.tipoDoc,
      this.tipoMime,
      this.tipoMimeOriginal});
}

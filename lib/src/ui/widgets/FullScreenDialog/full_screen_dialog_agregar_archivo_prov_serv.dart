// ignore_for_file: unused_field, unused_local_variable, no_logic_in_create_state

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:planning/src/animations/loading_animation.dart';
// import 'package:planning/src/blocs/archivosEspeciales/archivosespeciales_bloc.dart';
import 'package:planning/src/blocs/proveedores/archivo_proveedor/bloc/archivo_proveedor_bloc.dart';
import 'package:planning/src/blocs/proveedores/archivos_especiales/archivos_especiales_bloc.dart';
// import 'package:planning/src/models/archivosEspeciales/archivo_especial_model.dart';
import 'package:planning/src/models/item_model_archivo_serv_prod.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/models/item_model_proveedores.dart';
import 'package:planning/src/ui/widgets/snackbar_widget/snackbar_widget.dart';
import 'package:planning/src/ui/widgets/text_form_filed/text_form_filed.dart';
import 'package:mime_type/mime_type.dart';
import 'package:url_launcher/url_launcher_string.dart';

class FullScreenDialogAgregarArchivoProvServEvent extends StatefulWidget {
  final Map<String, dynamic>? provsrv;
  final bool isServicio;
  const FullScreenDialogAgregarArchivoProvServEvent({
    Key? key,
    required this.provsrv,
    this.isServicio = false,
  }) : super(key: key);

  @override
  _FullScreenDialogAgregarArchivoProvServEvent createState() =>
      _FullScreenDialogAgregarArchivoProvServEvent(provsrv);
}

class _FullScreenDialogAgregarArchivoProvServEvent
    extends State<FullScreenDialogAgregarArchivoProvServEvent> {
  GlobalKey<FormState> keyForm = GlobalKey();
  GlobalKey<FormState> keyFormAE = GlobalKey();
  final _keyFormLink = GlobalKey<FormState>();
  final Map<String, dynamic>? provsrv;
  final _textcontrollerDes = TextEditingController();
  final _textControllerUrl = TextEditingController();
  bool _isExpanded = false;
  final String _fileBase64 = '';
  _FullScreenDialogAgregarArchivoProvServEvent(this.provsrv);
  TextEditingController descripcionCtrl = TextEditingController();
  TextEditingController descripcionCtrlAE = TextEditingController();
  late ArchivoProveedorBloc archivoProveedorBloc;
  late ArchivosEspecialesBloc archivoEspecialBloc;
  ItemModelProveedores? itemModelProveedores;

  String? descripcionLink;
  String? urlValue;
  int? idEvento;
  bool isInvolucrado = false;
  @override
  void initState() {
    archivoProveedorBloc = BlocProvider.of<ArchivoProveedorBloc>(context);
    archivoProveedorBloc.add(FechtArchivoProvServEvent(
        provsrv!['id_proveedor'], provsrv!['id_servicio'], false));
    checkIsEvent();
    checkisInvolucrado();
    super.initState();
  }

  checkisInvolucrado() async {
    final idInvolucrado = await SharedPreferencesT().getClaveRol();

    if (idInvolucrado == 'INVO') {
      setState(() {
        isInvolucrado = true;
      });
    }
  }

  checkIsEvent() async {
    if (provsrv!['isEvento']) {
      idEvento = await SharedPreferencesT().getIdEvento();
      archivoEspecialBloc = BlocProvider.of<ArchivosEspecialesBloc>(context);
      archivoEspecialBloc
          .add(FechtArchivoEspecialEvent(provsrv!['id_proveedor'], idEvento));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(provsrv!['nombre'].toString())),
      body: SingleChildScrollView(
          child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BlocBuilder<ArchivoProveedorBloc, ArchivoProveedorState>(
                builder: (context, state) {
              if (state is LoadingArchivoProveedorState) {
                return const Center(child: LoadingCustom());
              } else if (state is MostrarArchivoProvServState) {
                return _form(state.detlistas);
              } else {
                return const Center(child: LoadingCustom());
              }
            }),
            if (provsrv!['isEvento']) _archivosEspecilesWidget(),
          ],
        ),
      )),
    );
  }

  Widget _archivosEspecilesWidget() {
    return Column(
      children: [
        const Divider(
          color: Colors.grey,
        ),
        const SizedBox(
          height: 2.0,
        ),
        Text(
          'Archivos especiales',
          style: Theme.of(context).textTheme.headline5,
        ),
        if (widget.provsrv!['type'] == 0)
          Card(
            color: Colors.white,
            elevation: 12,
            shadowColor: Colors.black12,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                  key: keyFormAE,
                  child: Column(
                    children: <Widget>[
                      Wrap(
                        alignment: WrapAlignment.center,
                        children: <Widget>[
                          TextFormFields(
                            icon: Icons.drive_file_rename_outline,
                            item: TextFormField(
                              controller: descripcionCtrlAE,
                              decoration: const InputDecoration(
                                labelText: 'Descripción del archivo',
                              ),
                            ),
                            large: 400.0,
                            ancho: 80.0,
                          ),
                        ],
                      ),
                      Ink(
                        padding: const EdgeInsets.all(5),
                        width: 100.0,
                        decoration: const ShapeDecoration(
                          color: Colors.black,
                          shape: CircleBorder(),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            icon: const Icon(Icons.upload_file),
                            color: Colors.white,
                            onPressed: () async {
                              _selectFile(true);
                            },
                          ),
                        ),
                      )
                    ],
                  )),
            ),
          ),
        BlocBuilder<ArchivosEspecialesBloc, ArchivosEspecialesState>(
            builder: (context, state) {
          if (state is LoadingArchivoEspecialState) {
            return const Center(child: LoadingCustom());
          } else if (state is MostrarArchivoProvEventState) {
            return _formEspecial(state.detlistas);
          } else {
            return const Center(child: LoadingCustom());
          }
        }),
      ],
    );
  }

  _insertLink(int? idServicio) async {
    Map<String, dynamic> jsonLink = {};
    if (_keyFormLink.currentState!.validate()) {
      jsonLink = {
        'id_proveedor': provsrv!['id_proveedor'],
        'id_servicio': idServicio,
        'tipo_mime': 'url',
        'archivo': urlValue,
        'nombre': descripcionLink,
        'descripcion': descripcionLink
      };
      archivoProveedorBloc.add(CreateArchivoProvServEvent(
        jsonLink,
      ));
      _textcontrollerDes.clear();
      _textControllerUrl.clear();
    } else {}
  }

  _selectFile(bool isArchivoEspecial, [int? idServicio]) async {
    if (isArchivoEspecial && descripcionCtrlAE.text == '') {
      return MostrarAlerta(
          mensaje: 'Ingresa una descripción',
          tipoMensaje: TipoMensaje.advertencia);
    }
    if (!isArchivoEspecial && descripcionCtrl.text == '') {
      return MostrarAlerta(
          mensaje: 'Ingresa una descripción',
          tipoMensaje: TipoMensaje.advertencia);
    }
    const extensiones = ['pdf', 'jpg', 'png', 'jpeg'];
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      withData: true,
      allowedExtensions: extensiones,
      allowMultiple: false,
    );
    if (pickedFile != null) {
      if (!isArchivoEspecial) {
        List files = [];
        Map<String, dynamic> json = {};
        for (var f in pickedFile.files) {
          if (extensiones.contains(f.extension)) {
            var bytes = f.bytes;
            bytes ??= File(f.path!).readAsBytesSync();
            String fileBase64 = base64.encode(bytes);
            String? mimeType = mime(f.name.replaceAll(' ', ''));
            String fileName = f.name;
            // files
            json = {
              'id_proveedor': provsrv!['id_proveedor'],
              'id_servicio': idServicio,
              // 'tipo_mime': 'data:application/pdf;base64,',
              'tipo_mime': mimeType,
              'archivo': fileBase64,
              'nombre': fileName,
              'descripcion': descripcionCtrl.text
            };
          }
        }

        archivoProveedorBloc.add(CreateArchivoProvServEvent(json));
        descripcionCtrl.text = '';
        Navigator.of(context).pop();
      } else {
        Map<String, dynamic> json = {};
        for (var f in pickedFile.files) {
          if (extensiones.contains(f.extension)) {
            var bytes = f.bytes;
            bytes ??= File(f.path!).readAsBytesSync();
            String fileBase64 = base64.encode(bytes);
            String? mimeType = mime(f.name.replaceAll(' ', ''));
            String fileName = f.name;
            // files
            json = {
              'id_proveedor': provsrv!['id_proveedor'],
              'id_servicio': provsrv!['id_servicio'],
              'id_evento': idEvento,
              // 'tipo_mime': 'data:application/pdf;base64,',
              'tipo_mime': mimeType,
              'archivo': fileBase64,
              'nombre': fileName,
              'descripcion': descripcionCtrlAE.text
            };
          }
        }
        archivoEspecialBloc.add(CreateArchivoEspecialEvent(json));
        descripcionCtrlAE.text = '';
      }
    }
  }

  Widget _form(ItemModelArchivoProvServ moduleServicios) {
    return SizedBox(
        width: double.infinity,
        child: Column(children: <Widget>[
          const SizedBox(
            height: 2.0,
          ),
          Center(
            child: SingleChildScrollView(
                child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 650.0,
                          child: _list(moduleServicios, false),
                        ),
                        if (provsrv!['id_servicio'] != null)
                          SizedBox(
                            width: 650.0,
                            child: _list(moduleServicios, true),
                          ),
                      ],
                    ))),
          )
        ]));
  }

  Widget _formEspecial(ItemModelArchivoEspecial moduleServicios) {
    return SizedBox(
        width: double.infinity,
        child: Column(children: <Widget>[
          const SizedBox(
            height: 2.0,
          ),
          Center(
            child: SingleChildScrollView(
                child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 650.0,
                          child: _listEspecial(moduleServicios, false),
                        ),
                      ],
                    ))),
          )
        ]));
  }

  Widget _listEspecial(
      ItemModelArchivoEspecial moduleServicios, bool isServicio) {
    return Card(
        color: Colors.white,
        elevation: 12,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _createListItemsEspecial(moduleServicios, isServicio)));
  }

  Widget _list(ItemModelArchivoProvServ moduleServicios, bool isServicio) {
    return Card(
        color: Colors.white,
        elevation: 12,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _createListItems(moduleServicios, isServicio)));
  }

  List<Widget> _createListItemsEspecial(
      ItemModelArchivoEspecial item, bool isServicio) {
    // Creación de lista de Widget.
    List<Widget> lista = [];
    List<Widget> listaServicio = [];
    // Se agrega el titulo del card
    const tituloServicio = Text(
      'Archivos del servicio',
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: 24),
    );
    // final campos =
    const sizeSercicio = SizedBox(height: 20);
    listaServicio.add(tituloServicio);
    // lista.add(campos);
    listaServicio.add(sizeSercicio);
    for (var opt in item.results) {
      Icon _icon;
      if (opt.tipoMime == 'application/pdf') {
        _icon = const Icon(Icons.picture_as_pdf);
      } else if (opt.tipoMime == 'url') {
        _icon = const Icon(Icons.web);
      } else {
        _icon = const Icon(Icons.image);
      }

      final tempWidget = ListTile(
        title: Text(opt.nombre!),
        subtitle: Text(opt.descripcion!),
        trailing: Wrap(spacing: 12, children: <Widget>[
          if (!isInvolucrado)
            IconButton(
                onPressed: () => showDialog<void>(
                    context: context,
                    builder: (BuildContext context) =>
                        _eliminarArchivoListaEspecial(
                            opt.idArchivoEspecial, opt.idProveedor)),
                icon: const Icon(Icons.delete)),
          IconButton(
              // opt.tipoMime.toString() + opt.archivo.toString()
              onPressed: () {
                opt.tipoMime == 'url'
                    ? _launchInBrowser(opt.archivo!)
                    : Navigator.of(context).pushNamed('/viewArchivo',
                        arguments: {
                            'nombre': opt.nombre,
                            'id_archivo': opt.idArchivoEspecial,
                            'especial': true
                          });
              },
              icon: _icon),
        ]),
        onTap: () async {},
      );

      lista.add(tempWidget);
    }

    return lista;
  }

  List<Widget> _createListItems(
      ItemModelArchivoProvServ item, bool isServicio) {
    // Creación de lista de Widget.
    List<Widget> lista = [];
    List<Widget> listaServicio = [];
    // Se agrega el titulo del card
    final titulo = ListTile(
        trailing: isInvolucrado
            ? null
            : IconButton(
                tooltip: 'Agregar archivo del proveedor',
                onPressed: () {
                  _dialogoAgregarArchivo(null);
                },
                icon: const Icon(Icons.upload),
              ),
        title: const Text('Archivos del proveedor',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 24)));
    // final campos =
    const size = SizedBox(height: 20);
    lista.add(titulo);
    // lista.add(campos);
    lista.add(size);

    final tituloServicio = ListTile(
      trailing: isInvolucrado
          ? null
          : IconButton(
              tooltip: 'Agregar archivo del servicio',
              onPressed: () {
                _dialogoAgregarArchivo(provsrv!['id_servicio']);
              },
              icon: const Icon(Icons.upload),
            ),
      title: const Text(
        'Archivos del servicio',
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 24),
      ),
    );
    // final campos =
    const sizeSercicio = SizedBox(height: 20);
    listaServicio.add(tituloServicio);
    // lista.add(campos);
    listaServicio.add(sizeSercicio);
    for (var opt in item.results) {
      Icon _icon;
      if (opt.tipoMime == 'application/pdf') {
        _icon = const Icon(Icons.picture_as_pdf);
      } else if (opt.tipoMime == 'url') {
        _icon = const Icon(Icons.web);
      } else {
        _icon = const Icon(Icons.image);
      }

      final tempWidget = ListTile(
        title: Text(opt.nombre!),
        subtitle: Text(opt.descripcion!),
        trailing: Wrap(spacing: 12, children: <Widget>[
          if (!isInvolucrado)
            IconButton(
                onPressed: () => showDialog<void>(
                    context: context,
                    builder: (BuildContext context) => _eliminarArchivoLista(
                        opt.idArchivo, opt.idProveedor, opt.idServicio)),
                icon: const Icon(Icons.delete)),
          IconButton(
              // opt.tipoMime.toString() + opt.archivo.toString()
              onPressed: () {
                opt.tipoMime == 'url'
                    ? _launchInBrowser(opt.archivo!)
                    : Navigator.of(context).pushNamed('/viewArchivo',
                        arguments: {
                            'nombre': opt.nombre,
                            'id_archivo': opt.idArchivo,
                            'especial': false
                          });
              },
              icon: _icon),
        ]),
        onTap: () async {},
      );
      if (provsrv!['id_servicio'] != null) {
        if (opt.idServicio != provsrv!['id_servicio']) {
          if (opt.idServicio == null) {
            lista.add(tempWidget);
          }
        } else {
          listaServicio.add(tempWidget);
        }
      } else {
        if (opt.idServicio == null) {
          lista.add(tempWidget);
        }
      }
    }

    if (!isServicio) {
      return lista;
    } else {
      return listaServicio;
    }
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(
        url,
        webViewConfiguration: WebViewConfiguration(
          headers: <String, String>{'my_header_key': 'my_header_value'},
        ),
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  _eliminarArchivoLista(int? idArchivo, int? idProveedor, int? idServicio) {
    return AlertDialog(
      title: const Text('Eliminar'),
      content: const Text('¿Desea eliminar el elemento?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancelar'),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => {
            Navigator.pop(context, 'Aceptar'),
            archivoProveedorBloc.add(DeleteArchivoEvent(
                idArchivo,
                provsrv!['id_proveedor'],
                provsrv!['id_servicio'],
                widget.isServicio))
          },
          child: const Text('Aceptar'),
        ),
      ],
    );
  }

  _eliminarArchivoListaEspecial(int? idArchivo, int? idProveedor) {
    return AlertDialog(
      title: const Text('Eliminar'),
      content: const Text('¿Desea eliminar el elemento?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancelar'),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () async => {
            archivoEspecialBloc.add(DeleteArchivoEspecialEvent(
                idArchivo, provsrv!['id_proveedor'], idEvento)),
            Navigator.pop(context, 'Aceptar'),
          },
          child: const Text('Aceptar'),
        ),
      ],
    );
  }

  _dialogoAgregarArchivo([int? idServicio]) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: StatefulBuilder(builder: (context, innerState) {
          return SizedBox(
            height: 600,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (widget.provsrv!['type'] == 0)
                    Card(
                      color: Colors.white,
                      elevation: 12,
                      shadowColor: Colors.black12,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                            key: keyForm,
                            child: Column(
                              children: <Widget>[
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  children: <Widget>[
                                    TextFormFields(
                                      icon: Icons.drive_file_rename_outline,
                                      item: TextFormField(
                                        controller: descripcionCtrl,
                                        decoration: const InputDecoration(
                                          labelText: 'Descripción archivo',
                                        ),
                                      ),
                                      large: 400.0,
                                      ancho: 80.0,
                                    ),
                                  ],
                                ),
                                Ink(
                                  padding: const EdgeInsets.all(5),
                                  width: 100.0,
                                  decoration: const ShapeDecoration(
                                    color: Colors.black,
                                    shape: CircleBorder(),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: IconButton(
                                      icon: const Icon(Icons.upload_file),
                                      color: Colors.white,
                                      onPressed: () async {
                                        _selectFile(false, idServicio);
                                      },
                                    ),
                                  ),
                                )
                              ],
                            )),
                      ),
                    ),
                  if (widget.provsrv!['type'] == 0 &&
                      widget.provsrv!['prvEv'] == 2)
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: ExpansionPanelList(
                        animationDuration: const Duration(milliseconds: 1000),
                        expansionCallback: (int index, bool expanded) {
                          innerState(() {
                            if (index == 0) {
                              _isExpanded = !_isExpanded;
                            }
                          });
                        },
                        children: [
                          ExpansionPanel(
                            headerBuilder:
                                (BuildContext context, bool _isExpanded) {
                              return const Center(
                                child: Text(
                                  'Agregar link',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 23),
                                ),
                              );
                            },
                            isExpanded: _isExpanded,
                            body: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Form(
                                  key: _keyFormLink,
                                  child: Column(
                                    children: <Widget>[
                                      const SizedBox(
                                        height: 8.0,
                                      ),
                                      Wrap(
                                        direction: Axis.vertical,
                                        alignment: WrapAlignment.center,
                                        children: <Widget>[
                                          TextFormFields(
                                            icon:
                                                FontAwesomeIcons.featherPointed,
                                            item: TextFormField(
                                              controller: _textcontrollerDes,
                                              onChanged: (value) {
                                                descripcionLink = value;
                                              },
                                              validator: (value) {
                                                if (value == null ||
                                                    value == '') {
                                                  return 'El Campo es requerido';
                                                } else {
                                                  return null;
                                                }
                                              },
                                              decoration: const InputDecoration(
                                                labelText:
                                                    'Descripción del link',
                                              ),
                                            ),
                                            large: 400.0,
                                            ancho: 80.0,
                                          ),
                                          const SizedBox(
                                            height: 8.0,
                                          ),
                                          TextFormFields(
                                            icon: Icons.add_link_outlined,
                                            item: TextFormField(
                                              controller: _textControllerUrl,
                                              onChanged: (value) {
                                                urlValue = value;
                                              },
                                              validator: (value) {
                                                String patternUrl =
                                                    'https?://(?:www.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9].[^s]{2,}|www.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9].[^s]{2,}|https?://(?:www.|(?!www))[a-zA-Z0-9]+.[^s]{2,}|www.[a-zA-Z0-9]+.[^s]{2,}';
                                                RegExp regExp =
                                                    RegExp(patternUrl);

                                                if (value == null ||
                                                    value == '') {
                                                  return 'El campo es requerido';
                                                } else if (!regExp
                                                    .hasMatch(value)) {
                                                  return 'No es un dirección web válida';
                                                } else {
                                                  return null;
                                                }
                                              },
                                              decoration: const InputDecoration(
                                                labelText:
                                                    'Url o dirección web',
                                              ),
                                            ),
                                            large: 400.0,
                                            ancho: 80.0,
                                          ),
                                        ],
                                      ),
                                      Ink(
                                        padding: const EdgeInsets.all(5),
                                        width: 100.0,
                                        decoration: const ShapeDecoration(
                                          color: Colors.black,
                                          shape: CircleBorder(),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: IconButton(
                                            icon: const Icon(
                                                Icons.add_circle_outline),
                                            color: Colors.white,
                                            onPressed: () {
                                              _insertLink(idServicio);
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ignore_for_file: unused_field, unused_local_variable

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:planning/src/blocs/archivosEspeciales/archivosespeciales_bloc.dart';
import 'package:planning/src/blocs/proveedores/archivo_proveedor/bloc/archivo_proveedor_bloc.dart';
import 'package:planning/src/blocs/proveedores/archivos_especiales/archivos_especiales_bloc.dart';
// import 'package:planning/src/models/archivosEspeciales/archivo_especial_model.dart';
import 'package:planning/src/models/item_model_archivo_serv_prod.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/models/item_model_proveedores.dart';
import 'package:planning/src/ui/widgets/text_form_filed/text_form_filed.dart';
import 'package:mime_type/mime_type.dart';
import 'package:url_launcher/url_launcher.dart';

class FullScreenDialogAgregarArchivoProvServEvent extends StatefulWidget {
  final Map<String, dynamic> provsrv;
  final bool isServicio;
  const FullScreenDialogAgregarArchivoProvServEvent({
    Key key,
    @required this.provsrv,
    this.isServicio = false,
  }) : super(key: key);

  @override
  _FullScreenDialogAgregarArchivoProvServEvent createState() =>
      _FullScreenDialogAgregarArchivoProvServEvent(provsrv);
}

class _FullScreenDialogAgregarArchivoProvServEvent
    extends State<FullScreenDialogAgregarArchivoProvServEvent> {
  GlobalKey<FormState> keyForm = new GlobalKey();
  GlobalKey<FormState> keyFormAE = new GlobalKey();
  final _keyFormLink = GlobalKey<FormState>();
  final Map<String, dynamic> provsrv;
  final _textcontrollerDes = TextEditingController();
  final _textControllerUrl = TextEditingController();
  bool _isExpanded = false;
  String _fileBase64 = '';
  _FullScreenDialogAgregarArchivoProvServEvent(this.provsrv);
  TextEditingController descripcionCtrl = new TextEditingController();
  TextEditingController descripcionCtrlAE = new TextEditingController();
  ArchivoProveedorBloc archivoProveedorBloc;
  ArchivosEspecialesBloc archivoEspecialBloc;
  ItemModelProveedores itemModelProveedores;

  String descripcionLink;
  String urlValue;
  int idEvento;
  bool isInvolucrado = false;
  @override
  void initState() {
    archivoProveedorBloc = BlocProvider.of<ArchivoProveedorBloc>(context);
    archivoProveedorBloc.add(FechtArchivoProvServEvent(
        this.provsrv['id_proveedor'], this.provsrv['id_servicio'], false));
    checkIsEvent();
    checkisInvolucrado();
    super.initState();
  }

  checkisInvolucrado() async {
    final idInvolucrado = await SharedPreferencesT().getIdInvolucrado();

    if (idInvolucrado != null) {
      setState(() {
        isInvolucrado = true;
      });
    }
  }

  checkIsEvent() async {
    if (this.provsrv['isEvento']) {
      idEvento = await SharedPreferencesT().getIdEvento();
      archivoEspecialBloc = BlocProvider.of<ArchivosEspecialesBloc>(context);
      archivoEspecialBloc.add(
          FechtArchivoEspecialEvent(this.provsrv['id_proveedor'], idEvento));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(this.provsrv['nombre'].toString())),
      body: SingleChildScrollView(
          child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (widget.provsrv['type'] == 0)
              Card(
                color: Colors.white,
                elevation: 12,
                shadowColor: Colors.black12,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Form(
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
                                  decoration: new InputDecoration(
                                    labelText: 'Descripción archivo',
                                  ),
                                ),
                                large: 400.0,
                                ancho: 80.0,
                              ),
                            ],
                          ),
                          Ink(
                            padding: EdgeInsets.all(5),
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
                                  _selectFile(false);
                                },
                              ),
                            ),
                          )
                        ],
                      )),
                ),
              ),
            if (widget.provsrv['type'] == 0 && widget.provsrv['prvEv'] == 2)
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 500),
                child: ExpansionPanelList(
                  animationDuration: Duration(milliseconds: 1000),
                  expansionCallback: (int index, bool expanded) {
                    setState(() {
                      if (index == 0) {
                        _isExpanded = !_isExpanded;
                      }
                    });
                  },
                  children: [
                    ExpansionPanel(
                      headerBuilder: (BuildContext context, bool _isExpanded) {
                        return Center(
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
                                SizedBox(
                                  height: 8.0,
                                ),
                                Wrap(
                                  direction: Axis.vertical,
                                  alignment: WrapAlignment.center,
                                  children: <Widget>[
                                    TextFormFields(
                                      icon: Icons.add_link_outlined,
                                      item: TextFormField(
                                        controller: _textcontrollerDes,
                                        onChanged: (value) {
                                          descripcionLink = value;
                                        },
                                        validator: (value) {
                                          if (value == null || value == '') {
                                            return 'El Campo es requerido';
                                          } else {
                                            return null;
                                          }
                                        },
                                        decoration: new InputDecoration(
                                          labelText: 'Descripción del link',
                                        ),
                                      ),
                                      large: 400.0,
                                      ancho: 80.0,
                                    ),
                                    SizedBox(
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
                                              'https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]+\.[^\s]{2,}|www\.[a-zA-Z0-9]+\.[^\s]{2,}';
                                          RegExp regExp = RegExp(patternUrl);

                                          if (value == null || value == '') {
                                            return 'El Campo es requerido';
                                          } else if (!regExp.hasMatch(value)) {
                                            return 'No es un dirección web valida';
                                          } else {
                                            return null;
                                          }
                                        },
                                        decoration: new InputDecoration(
                                          labelText: 'Url o Dirección web',
                                        ),
                                      ),
                                      large: 400.0,
                                      ancho: 80.0,
                                    ),
                                  ],
                                ),
                                Ink(
                                  padding: EdgeInsets.all(5),
                                  width: 100.0,
                                  decoration: const ShapeDecoration(
                                    color: Colors.black,
                                    shape: CircleBorder(),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: IconButton(
                                      icon:
                                          const Icon(Icons.add_circle_outline),
                                      color: Colors.white,
                                      onPressed: () {
                                        _insertLink();
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
            BlocBuilder<ArchivoProveedorBloc, ArchivoProveedorState>(
                builder: (context, state) {
              if (state is LoadingArchivoProveedorState) {
                return Center(child: CircularProgressIndicator());
              } else if (state is MostrarArchivoProvServState) {
                return _form(state.detlistas);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
            if (this.provsrv['isEvento']) _archivosEspecilesWidget(),
          ],
        ),
      )),
    );
  }

  Widget _archivosEspecilesWidget() {
    return Column(
      children: [
        Divider(
          color: Colors.grey,
        ),
        SizedBox(
          height: 2.0,
        ),
        Text(
          'Archivos Especiales',
          style: Theme.of(context).textTheme.headline5,
        ),
        if (widget.provsrv['type'] == 0)
          Card(
            color: Colors.white,
            elevation: 12,
            shadowColor: Colors.black12,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Form(
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
                              decoration: new InputDecoration(
                                labelText: 'Descripción del archivo',
                              ),
                            ),
                            large: 400.0,
                            ancho: 80.0,
                          ),
                        ],
                      ),
                      Ink(
                        padding: EdgeInsets.all(5),
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
            return Center(child: CircularProgressIndicator());
          } else if (state is MostrarArchivoProvEventState) {
            return _formEspecial(state.detlistas);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }),
      ],
    );
  }

  _insertLink() async {
    Map<String, dynamic> jsonLink = {};
    if (_keyFormLink.currentState.validate()) {
      jsonLink = {
        'id_proveedor': this.provsrv['id_proveedor'],
        'id_servicio': this.provsrv['id_servicio'],
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

  _selectFile(bool isArchivoEspecial) async {
    const extensiones = ['pdf', 'jpg', 'png', 'jpeg'];
    FilePickerResult pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: extensiones,
      allowMultiple: false,
    );
    if (pickedFile != null) {
      if (!isArchivoEspecial) {
        List files = [];
        Map<String, dynamic> json = {};
        pickedFile.files.forEach((f) {
          if (extensiones.contains(f.extension)) {
            var bytes = f.bytes;
            if (bytes == null) {
              bytes = File(f.path).readAsBytesSync();
            }
            String fileBase64 = base64.encode(bytes);
            String mimeType = mime(f.name.replaceAll(' ', ''));
            String fileName = f.name;
            // files
            json = {
              'id_proveedor': this.provsrv['id_proveedor'],
              'id_servicio': this.provsrv['id_servicio'],
              // 'tipo_mime': 'data:application/pdf;base64,',
              'tipo_mime': mimeType,
              'archivo': fileBase64,
              'nombre': fileName,
              'descripcion': descripcionCtrl.text
            };
          }
        });

        archivoProveedorBloc.add(CreateArchivoProvServEvent(json));
        descripcionCtrl.text = '';
      } else {
        Map<String, dynamic> json = {};
        pickedFile.files.forEach((f) {
          if (extensiones.contains(f.extension)) {
            var bytes = f.bytes;
            if (bytes == null) {
              bytes = File(f.path).readAsBytesSync();
            }
            String fileBase64 = base64.encode(bytes);
            String mimeType = mime(f.name.replaceAll(' ', ''));
            String fileName = f.name;
            // files
            json = {
              'id_proveedor': this.provsrv['id_proveedor'],
              'id_servicio': this.provsrv['id_servicio'],
              'id_evento': idEvento,
              // 'tipo_mime': 'data:application/pdf;base64,',
              'tipo_mime': mimeType,
              'archivo': fileBase64,
              'nombre': fileName,
              'descripcion': descripcionCtrlAE.text
            };
          }
        });
        archivoEspecialBloc.add(CreateArchivoEspecialEvent(json));
        descripcionCtrlAE.text = '';
      }
    }
  }

  Widget _form(ItemModelArchivoProvServ moduleServicios) {
    return Container(
        width: double.infinity,
        child: Column(children: <Widget>[
          SizedBox(
            height: 2.0,
          ),
          Center(
            child: SingleChildScrollView(
                child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 650.0,
                          child: _list(moduleServicios, false),
                        ),
                        if (provsrv['id_servicio'] != null)
                          Container(
                            width: 650.0,
                            child: _list(moduleServicios, true),
                          ),
                      ],
                    ))),
          )
        ]));
  }

  Widget _formEspecial(ItemModelArchivoEspecial moduleServicios) {
    return Container(
        width: double.infinity,
        child: Column(children: <Widget>[
          SizedBox(
            height: 2.0,
          ),
          Center(
            child: SingleChildScrollView(
                child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
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
    final tituloServicio = Text('Archivos del servicio',
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 24));
    // final campos =
    final sizeSercicio = SizedBox(height: 20);
    listaServicio.add(tituloServicio);
    // lista.add(campos);
    listaServicio.add(sizeSercicio);
    for (var opt in item.results) {
      Icon _icon;
      if (opt.tipoMime == 'application/pdf') {
        _icon = Icon(Icons.picture_as_pdf);
      } else if (opt.tipoMime == 'url') {
        _icon = Icon(Icons.web);
      } else {
        _icon = Icon(Icons.image);
      }

      final tempWidget = ListTile(
        title: Text(opt.nombre),
        subtitle: Text(opt.descripcion),
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
                    ? _launchInBrowser(opt.archivo)
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
    final titulo = Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('Archivos del proveedor',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 24)));
    // final campos =
    final size = SizedBox(height: 20);
    lista.add(titulo);
    // lista.add(campos);
    lista.add(size);

    final tituloServicio = Text('Archivos del servicio',
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 24));
    // final campos =
    final sizeSercicio = SizedBox(height: 20);
    listaServicio.add(tituloServicio);
    // lista.add(campos);
    listaServicio.add(sizeSercicio);
    for (var opt in item.results) {
      Icon _icon;
      if (opt.tipoMime == 'application/pdf') {
        _icon = Icon(Icons.picture_as_pdf);
      } else if (opt.tipoMime == 'url') {
        _icon = Icon(Icons.web);
      } else {
        _icon = Icon(Icons.image);
      }

      final tempWidget = ListTile(
        title: Text(opt.nombre),
        subtitle: Text(opt.descripcion),
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
                    ? _launchInBrowser(opt.archivo)
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
      if (provsrv['id_servicio'] != null) {
        if (opt.idServicio != provsrv['id_servicio']) {
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
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  _eliminarArchivoLista(int idArchivo, int idProveedor, int idServicio) {
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
                this.provsrv['id_proveedor'],
                this.provsrv['id_servicio'],
                widget.isServicio))
          },
          child: const Text('Aceptar'),
        ),
      ],
    );
  }

  _eliminarArchivoListaEspecial(int idArchivo, int idProveedor) {
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
            await archivoEspecialBloc.add(DeleteArchivoEspecialEvent(
                idArchivo, this.provsrv['id_proveedor'], idEvento)),
            Navigator.pop(context, 'Aceptar'),
          },
          child: const Text('Aceptar'),
        ),
      ],
    );
  }
}

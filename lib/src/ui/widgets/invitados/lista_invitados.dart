// ignore_for_file: non_constant_identifier_names, no_logic_in_create_state

import 'dart:convert';
import 'dart:io';

import 'package:planning/src/animations/loading_animation.dart';
import 'package:planning/src/models/model_perfilado.dart';
import 'package:planning/src/ui/widgets/invitados/enviar_correo_invitados.dart';
import 'package:planning/src/ui/widgets/snackbar_widget/snackbar_widget.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:planning/src/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:planning/src/blocs/blocs.dart';
import 'package:planning/src/blocs/invitadosMesa/invitadosmesas_bloc.dart';
import 'package:planning/src/models/item_model_estatus_invitado.dart';
import 'package:planning/src/models/item_model_grupos.dart';
import 'package:planning/src/resources/api_provider.dart';
import 'package:planning/src/ui/asistencia/asistencia.dart';
import 'package:planning/src/ui/mesas/mesas_page.dart';
import '../../../animations/loading_overlay.dart';
import '../../../models/item_model_invitados.dart';

import 'package:planning/src/utils/utils.dart' as utils;

import '../../../models/item_model_preferences.dart';

class ListaInvitados extends StatefulWidget {
  final int idEvento;
  final String nameEvento;
  final bool WP_EVT_INV_CRT;
  final bool WP_EVT_INV_EDT;
  final bool WP_EVT_INV_ENV;
  final ItemModelPerfil permisos;

  const ListaInvitados({
    Key key,
    this.idEvento,
    this.WP_EVT_INV_CRT,
    this.WP_EVT_INV_EDT,
    this.WP_EVT_INV_ENV,
    this.nameEvento,
    this.permisos,
  }) : super(key: key);
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => const ListaInvitados(),
      );
  @override
  _ListaInvitadosState createState() => _ListaInvitadosState(
      idEvento, WP_EVT_INV_CRT, WP_EVT_INV_EDT, WP_EVT_INV_ENV);
}

class _ListaInvitadosState extends State<ListaInvitados>
    with TickerProviderStateMixin {
  ApiProvider api = ApiProvider();
  final TextStyle estiloTxt = const TextStyle(fontWeight: FontWeight.bold);
  final int idEvento;

  int currentIndex = 0;
  TabController _controller;

  final bool WP_EVT_INV_CRT;
  final bool WP_EVT_INV_EDT;
  final bool WP_EVT_INV_ENV;

  bool dialVisible = true;

  BuildContext _dialogContext;
  bool desconectado = false;

  TextEditingController controllerBuscar = TextEditingController();
  String _searchResult = '';
  List<dynamic> buscador = [];
  List<dynamic> todosLosInvitados = [];

  ProgressBar _sendingMsgProgressBar;

  @override
  void dispose() {
    _sendingMsgProgressBar.hide();
    super.dispose();
  }

  void showSendingProgressBar() {
    _sendingMsgProgressBar.show(context);
  }

  void hideSendingProgressBar() {
    _sendingMsgProgressBar.hide();
  }

  int tabs = 0;
  @override
  void initState() {
    _sendingMsgProgressBar = ProgressBar();
    _checkPermisos();

    _controller = TabController(length: tabs, vsync: this);
    _controller.addListener(() {
      setState(() {
        currentIndex = _controller.index;
      });
    });
    _checkIsDesconectado();
    super.initState();
  }

  _checkIsDesconectado() async {
    desconectado = await SharedPreferencesT().getModoConexion();
    setState(() {});
  }

  _checkPermisos() async {
    if (widget.permisos != null) {
      if (widget.permisos.pantallas.hasAcceso(clavePantalla: 'WP-EVT-INV')) {
        tabs += 1;
      }

      if (widget.permisos.pantallas.hasAcceso(clavePantalla: 'WP-EVT-ASI')) {
        tabs += 1;
      }

      if (widget.permisos.pantallas.hasAcceso(clavePantalla: 'WP-EVT-MDE')) {
        tabs += 1;
      }
    } else {
      tabs = 3;
    }
    setState(() {});
  }

  _ListaInvitadosState(this.idEvento, this.WP_EVT_INV_CRT, this.WP_EVT_INV_EDT,
      this.WP_EVT_INV_ENV);
  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  void setDialVisible(bool value) {
    setState(() {
      dialVisible = value;
    });
  }

  _viewShowDialogExcel() {
    showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: const Text('Importación de Excel'),
              content: Column(
                children: [
                  const Text(
                      'Procederá a abrir su explorador de archivos para seleccionar un archivo Excel. ¿Desea continuar?'),
                  TextButton(
                    style: TextButton.styleFrom(
                        primary: Colors.blue,
                        textStyle: const TextStyle(fontSize: 13.0)),
                    onPressed: () async {
                      ByteData bytes =
                          await rootBundle.load("assets/Plantilla.xlsx");
                      String base64 = base64Encode(bytes.buffer.asUint8List(
                          bytes.offsetInBytes, bytes.lengthInBytes));
                      utils.downloadFile(base64, 'Plantilla',
                          extensionFile: 'xlsx');
                    },
                    child: const Text('Descargar plantiila'),
                  ),
                ],
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text(
                    'No',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                CupertinoDialogAction(
                  child: const Text('Sí'),
                  onPressed: () async {
                    await _readExcel();
                  },
                ),
              ],
            ));
  }

  _readExcel() async {
    /// Use FilePicker to pick files in Flutter Web
    FilePickerResult pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      withData: true,
      allowedExtensions: ['xlsx'],
      allowMultiple: false,
    );

    /// file might be picked
    if (pickedFile != null) {
      Navigator.of(context).pop();

      showSendingProgressBar();
      var bytes = pickedFile.files.single.bytes;
      bytes ??= File(pickedFile.files[0].path).readAsBytesSync();

      var excel = Excel.decodeBytes(bytes);
      bool bandera = false;

      for (var table in excel.tables.keys) {
        var sheet = excel[table];
        if (sheet.row(0)[0].value == 'NOMBRE' &&
            sheet.row(0)[1].value == 'EMAIL' &&
            sheet.row(0)[2].value == 'TELÉFONO') {
          for (int row = 1; row < sheet.maxRows; row++) {
            Map<String, String> jsonExample = {
              'nombre': sheet.row(row)[0].value.toString(),
              'email': sheet.row(row)[1] != null
                  ? sheet.row(row)[1].value.toString()
                  : '',
              'telefono': sheet.row(row)[2] != null
                  ? sheet.row(row)[2].value.toString()
                  : '',
              'id_evento': idEvento.toString()
            };
            bool response = await api.createInvitados(jsonExample, context);
            bandera = response == true ? true : false;
          }
        } else {
          MostrarAlerta(
              mensaje: 'Estructura del excel incorrecta',
              tipoMensaje: TipoMensaje.error);
        }
      }
      if (bandera) {
        blocInvitados.fetchAllInvitados(context);
        MostrarAlerta(
            mensaje: 'Se importó el archivo con éxito',
            tipoMensaje: TipoMensaje.correcto);
      } else {
        MostrarAlerta(
            mensaje: 'Error: No se pudo realizar el registro',
            tipoMensaje: TipoMensaje.advertencia);
      }
      hideSendingProgressBar();
    }
  }

  Future<PermissionStatus> _getPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted ||
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  _viewContact() async {
    final PermissionStatus permissionStatus = await _getPermission();
    if (permissionStatus == PermissionStatus.granted) {
      //Navigator.push(
      //  context, MaterialPageRoute(builder: (context) => FullScreenDialog(id: idEvento,)));

      final result = await Navigator.of(context)
          .pushNamed('/addContactos', arguments: idEvento);
      if (result == null || result == "" || result == false || result == 0) {
        _ListaInvitadosState(
                idEvento, WP_EVT_INV_CRT, WP_EVT_INV_EDT, WP_EVT_INV_ENV)
            .listaInvitados(context);
      }
    } else {
      //If permissions have been denied show standard cupertino alert dialog
      showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
                title: const Text('Permisos denegados'),
                content: const Text('Por favor, otorgar el acceso a contactos'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: const Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ));
    }
  }

  SpeedDial buildSpeedDial(double pHz) {
    return SpeedDial(
      icon: Icons.more_vert,
      tooltip: 'Opciones',
      children: armarBotonesAcciones(),
    );
  }

  List<SpeedDialChild> armarBotonesAcciones() {
    List<SpeedDialChild> temp = [];

    if (WP_EVT_INV_CRT) {
      temp.add(SpeedDialChild(
        foregroundColor: Colors.black,
        child: const Tooltip(
          child: Icon(Icons.person_add),
          message: "Agregar invitado",
        ),
        backgroundColor: hexToColor("#fdf4e5"),
        onTap: () async {
          final result = await Navigator.of(context)
              .pushNamed('/addInvitados', arguments: idEvento);
          if (result == null ||
              result == "" ||
              result == false ||
              result == 0) {
            _ListaInvitadosState(
                    idEvento, WP_EVT_INV_CRT, WP_EVT_INV_EDT, WP_EVT_INV_ENV)
                .listaInvitados(context);
          }
        },
      ));

      temp.add(SpeedDialChild(
        foregroundColor: Colors.black,
        child: const Tooltip(
          child: Icon(Icons.table_chart_outlined),
          message: "Importar Excel",
        ),
        backgroundColor: hexToColor("#fdf4e5"),
        //label: 'Importar excel',
        //labelStyle: TextStyle(fontSize: 14.0),
        onTap: () => _viewShowDialogExcel(),
      ));
      temp.add(SpeedDialChild(
        foregroundColor: Colors.black,
        child: const Tooltip(
          child: Icon(Icons.import_contacts_rounded),
          message: "Importar contactos",
        ),
        backgroundColor: hexToColor("#fdf4e5"),
        //label: 'Importar contactos',
        //labelStyle: TextStyle(fontSize: 14.0),
        onTap: () => _viewContact(),
      ));
      temp.add(SpeedDialChild(
        foregroundColor: Colors.black,
        child: const Tooltip(
          child: Icon(Icons.download),
          message: "Descargar PDF",
        ),
        backgroundColor: hexToColor("#fdf4e5"),
        //label: 'Importar contactos',
        //labelStyle: TextStyle(fontSize: 14.0),
        onTap: downloadPDFListaInvitados,
      ));
    }
    if (WP_EVT_INV_ENV) {
      temp.add(SpeedDialChild(
        foregroundColor: Colors.black,
        child: const Tooltip(
          child: Icon(Icons.send_and_archive_sharp),
          message: "Enviar QR a invitados",
        ),
        backgroundColor: hexToColor("#fdf4e5"),
        onTap: () async {
          dialogoEnvioCorreos();
          //Función comentada que enviaba a todos los contactos
          // _dialogSpinner('Enviando QR...');
          // Map<String, dynamic> response =
          //     await api.enviarInvitacionesPorEvento();
          // Navigator.pop(_dialogContext);
          // MostrarAlerta(
          //     mensaje: response['msg'],
          //     tipoMensaje: response['enviado']
          //         ? TipoMensaje.correcto
          //         : TipoMensaje.error);
        },
      ));
    }
    return temp;
  }

  dialogoEnvioCorreos() {
    showDialog(
      context: context,
      builder: (context) => EnviarCorreoInvitados(todosLosInvitados),
    );
  }

  alertaLlamada() {
    showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: const Text('Permisos denegados'),
              content: const Text('Por favor habilitar el acceso a contactos'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text('OK'),
                  onPressed: () => openAppSettings(),
                )
              ],
            ));
  }

  listaInvitados(BuildContext cont) {
    ///bloc.dispose();
    blocInvitados.fetchAllInvitados(cont);
    return RefreshIndicator(
      color: Colors.blue,
      onRefresh: () async {
        await blocInvitados.fetchAllInvitados(context);
      },
      child: StreamBuilder(
        stream: blocInvitados.allInvitados,
        builder: (context, AsyncSnapshot<ItemModelInvitados> snapshot) {
          if (snapshot.hasData) {
            return buildList(snapshot, context);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return const Center(child: LoadingCustom());
        },
      ),
    );
  }

  List<Widget> pantallas() {
    List<Widget> pantallas = [];

    if (widget.permisos != null) {
      if (widget.permisos.pantallas.hasAcceso(clavePantalla: 'WP-EVT-INV'))
        pantallas.add(listaInvitados(context));
      if (widget.permisos.pantallas.hasAcceso(clavePantalla: 'WP-EVT-ASI'))
        pantallas.add(const Asistencia());
      if (widget.permisos.pantallas.hasAcceso(clavePantalla: 'WP-EVT-MDE'))
        pantallas.add(MesasPage(nameEvento: widget.nameEvento));
    } else {
      pantallas = [
        listaInvitados(context),
        const Asistencia(),
        MesasPage(nameEvento: widget.nameEvento)
      ];
    }

    return pantallas;
  }

  List<Tab> buildTabs() {
    List<Tab> tabs = [];
    if (widget.permisos != null) {
      if (widget.permisos.pantallas.hasAcceso(clavePantalla: 'WP-EVT-INV')) {
        tabs.add(const Tab(
          icon: Icon(Icons.people),
          text: 'Lista de Invitados',
        ));
      }
      if (widget.permisos.pantallas.hasAcceso(clavePantalla: 'WP-EVT-ASI')) {
        tabs.add(const Tab(
          icon: Icon(Icons.accessibility),
          text: 'Asistió al evento',
        ));
      }
      if (widget.permisos.pantallas.hasAcceso(clavePantalla: 'WP-EVT-MDE')) {
        tabs.add(const Tab(
          icon: Icon(Icons.contact_mail_sharp),
          text: 'Mesas',
        ));
      }
    } else {
      tabs = [
        const Tab(
          icon: Icon(Icons.people),
          text: 'Lista de Invitados',
        ),
        const Tab(
          icon: Icon(Icons.accessibility),
          text: 'Asistió al evento',
        ),
        const Tab(
          icon: Icon(Icons.contact_mail_sharp),
          text: 'Mesas',
        )
      ];
    }

    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> listWidget = pantallas();

    double pHz = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Invitados'),
        bottom: tabs == 1
            ? null
            : TabBar(
                indicatorColor: Colors.black,
                controller: _controller,
                tabs: buildTabs(),
              ),
      ),

      body: TabBarView(
        controller: _controller,
        children: listWidget,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton:
          currentIndex == 0 && !desconectado ? buildSpeedDial(pHz) : null,
      /*floatingActionButton: FloatingActionButton(
        onPressed: () async{
          //Navigator.of(context).pushNamed('/addInvitados', arguments: idEvento);
          final result = await Navigator.of(context).pushNamed('/addInvitados',arguments: idEvento); 
          if(result==null || result=="" || result == false || result == 0){
            _ListaInvitadosState(idEvento).listaInvitados(context);
          }
        },
        child: const Icon(Icons.person_add),
        
        backgroundColor: hexToColor('#fdf4e5'),
      ),*/
      //floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
    );
  }

  _dialogSpinner(String title) {
    Widget child = const LoadingCustom();
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          _dialogContext = context;
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

  Widget buildList(
      AsyncSnapshot<ItemModelInvitados> snapshot, BuildContext context) {
    final size = MediaQuery.of(context).size;
    final datos = snapshot.data;

    todosLosInvitados = snapshot.data.results;
    if (_searchResult == '') {
      buscador = snapshot.data.results;
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.search),
            title: TextField(
              controller: controllerBuscar,
              decoration: const InputDecoration(
                  hintText: 'Buscar...', border: InputBorder.none),
              onChanged: (value) async {
                setState(() {
                  _searchResult = value;
                  if (_searchResult == '') {
                    buscador = snapshot.data.results;
                  }
                  buscador = snapshot.data.results
                      .where((element) => element.nombre
                          .toLowerCase()
                          .contains(value.toLowerCase()))
                      .toList();
                });
              },
            ),
            trailing: IconButton(
                icon: const Icon(Icons.cancel),
                onPressed: () {
                  setState(() {
                    controllerBuscar.clear();
                    _searchResult = '';
                  });
                }),
            autofocus: false,
          ),
        ),
        PaginatedDataTable(
          header: size.width >= 560
              ? Row(
                  children: [
                    Text('Invitados: ${datos.invitados}'),
                    const Spacer(),
                    Text('Acompañantes: ${datos.acompanantes}'),
                    const Spacer(),
                    Text('Total: ${datos.invitados + datos.acompanantes}')
                  ],
                )
              : SizedBox(
                  height: 150.0,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                          child: Text(
                        'Invitados: ${datos.invitados}',
                      )),
                      Expanded(
                          child: Text('Acompañantes: ${datos.acompanantes}')),
                      Expanded(
                          child: Text(
                              'Total: ${datos.invitados + datos.acompanantes}'))
                    ],
                  ),
                ),
          rowsPerPage: 8,
          showCheckboxColumn: false,
          columns: [
            DataColumn(label: Text('Nombre', style: estiloTxt)),
            DataColumn(
                label: Center(child: Text('Teléfono', style: estiloTxt))),
            DataColumn(label: Text('Grupo', style: estiloTxt)),
            DataColumn(label: Text('Asistencia', style: estiloTxt)),
            DataColumn(label: Text('Acción', style: estiloTxt)),
          ],
          source: _DataSource(buscador, context, idEvento, WP_EVT_INV_CRT,
              WP_EVT_INV_EDT, WP_EVT_INV_ENV, desconectado),
        ),
        const SizedBox(
          height: 35.0,
        ),
      ],
    );
  }

  void downloadPDFListaInvitados() async {
    final data = await api.downloadPDFInvitados();

    if (data != null) {
      downloadFile(data, 'Lista-Invitados');
    }
  }
}

class _Row {
  _Row(this.valueId, this.valueA, this.valueB, this.valueC, this.valueD,
      this.valueE);
  final int valueId;
  final String valueA;
  final String valueB;
  final String valueC;
  final String valueD;
  final String valueE;
  bool selected = false;
}

class _DataSource extends DataTableSource {
  BuildContext _cont;
  final int idEvento;
  final bool WP_EVT_INV_CRT;
  final bool WP_EVT_INV_EDT;
  final bool WP_EVT_INV_ENV;
  final bool desconectado;

  ItemModelGrupos _grupos;
  ItemModelEstatusInvitado _estatus;
  String _grupoSelect = "0";
  String _estatusSelect = "0";
  ApiProvider api = ApiProvider();

  _DataSource(context, BuildContext cont, this.idEvento, this.WP_EVT_INV_CRT,
      this.WP_EVT_INV_EDT, this.WP_EVT_INV_ENV, this.desconectado) {
    _rows = <_Row>[];
    for (int i = 0; i < context.length; i++) {
      _rows.add(_Row(
          context[i].idInvitado,
          context[i].nombre,
          context[i].telefono,
          context[i].grupo ?? 'Sin grupo',
          context[i].asistencia ?? 'Sin estatus',
          context[i].telefono));
    }
    _cont = cont;
  }

  Future<void> _showMyDialogLlamada(String numero) async {
    return showDialog<void>(
      context: _cont,
      //barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Teléfono', textAlign: TextAlign.center),
          content: Container(
            margin: const EdgeInsets.all(10.0),
            width: 400.0,
            height: 140.0,
            child: Column(
              children: <Widget>[
                Card(
                  child: ListTile(
                    title: Text('Se llamará al número $numero'),
                    trailing: const Icon(Icons.phone),
                    onTap: () async {
                      launch('tel://$numero');
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                      title: const Text('Abrir WhatsApp',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              // fontSize: 20,
                              color: Colors.green)),
                      trailing: const FaIcon(FontAwesomeIcons.whatsapp),
                      onTap: () async {
                        launch('http://wa.me/521$numero');
                      }),
                )
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
            // SizedBox(
            //   width: 10.0,
            // ),
            // TextButton(
            //   child: Text('Confirmar'),
            //   onPressed: () async {
            //     launch('tel://$numero');
            //     Navigator.of(context).pop();
            //   },
            // ),
          ],
        );
      },
    );
  }

  Future<void> _showMyDialogWhatsApp(String numero, idInvitado) async {
    return showDialog<void>(
        context: _cont,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('Eliminar invitado'),
              content: // RichText(
                  RichText(
                text: const TextSpan(
                  text: '¿Desara eliminar el invitado? ',
                  style: TextStyle(color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(
                        text:
                            '¡Se eliminarán los acompañantes relacionados al invitado!',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                    // TextSpan(text: ' world!'),
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
                const SizedBox(
                  width: 10.0,
                ),
                TextButton(
                  child: const Text('Aceptar'),
                  onPressed: () async {
                    Map<String, dynamic> json = {'id_invitado': idInvitado};
                    int response = await api.deleteInvitados(json);
                    if (response == 0) {
                      await blocInvitados.fetchAllInvitados(context);
                    }
                    Navigator.of(context).pop();
                  },
                )
              ]);
        });
  }

  /*_viewShowDialog(String numero){
      showDialog(
          context: _cont,
          builder: (BuildContext context) => CupertinoAlertDialog(
                title: Text('Llamada'),
                content: Text('Se llamará al numero $numero'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('Cancelar',style: TextStyle(color: Colors.red),),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoDialogAction(
                    child: Text('Confirmar'),
                    onPressed: () {
                      launch('tel://$numero');
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ));
  }*/
  _updateEstatus(int idInvitado) async {
    Map<String, String> json = {
      "id_invitado": idInvitado.toString(),
      "id_estatus_invitado": _estatusSelect.toString()
    };

    bool response = await api.updateEstatusInvitado(json, _cont);
    if (response) {
      _ListaInvitadosState(
              idEvento, WP_EVT_INV_CRT, WP_EVT_INV_EDT, WP_EVT_INV_ENV)
          .listaInvitados(_cont);
    } else {
      MostrarAlerta(
          mensaje: 'Error al actualizar el estatus.',
          tipoMensaje: TipoMensaje.error);
    }
  }

  _viewShowDialogEditar(int idInvitado) async {
    final resultE = await Navigator.of(_cont)
        .pushNamed('/editInvitado', arguments: idInvitado);
    if (resultE == null || resultE == "" || resultE == false || resultE == 0) {
      _ListaInvitadosState(
              idEvento, WP_EVT_INV_CRT, WP_EVT_INV_EDT, WP_EVT_INV_ENV)
          .listaInvitados(_cont);
    }
  }

  _listaGruposEvento(int idInvitado) async {
    _grupos = await api.fetchGruposList(_cont);
    /*for (var data in _grupos.results) {
    }*/
    _showMyDialogGrupo(idInvitado);
  }

  _listaEstatusEvento(int idInvitado) async {
    _estatus = await api.fetchEstatusList(_cont);
    /*for (var data in _grupos.results) {
    }*/
    await _showMyDialog(idInvitado);
    //_viewShowDialogEstatus(idInvitado);
  }

  Future<void> _showMyDialogGrupo(int idInvitado) async {
    return showDialog<void>(
      context: _cont,
      //barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Seleccionar estatus', textAlign: TextAlign.center),
          content: SizedBox(
            height: 120,
            child: //Column(
                //children: [
                CupertinoPicker(
                    itemExtent: 32.0,
                    onSelectedItemChanged: (value) {
                      _grupoSelect =
                          _grupos.results.elementAt(value).idGrupo.toString();
                    },
                    children: <Widget>[
                  //for (var i = 0; i < _grupos.results.length; i++)
                  for (var data in _grupos.results)
                    if (data.nombreGrupo != "Nuevo grupo")
                      Text(data.nombreGrupo),
                ]),
            // _listaGrupos(),
            // ],
            //),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            const SizedBox(
              width: 10.0,
            ),
            TextButton(
              child: const Text('Confirmar'),
              onPressed: () async {
                await _updateGrupo(idInvitado);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _updateGrupo(int idInvitado) async {
    bool response;
    Map<String, String> json = {
      "id_invitado": idInvitado.toString(),
      "id_grupo": _grupoSelect
    };
    response = await api.updateGrupoInvitado(json, _cont);
    if (response) {
      _ListaInvitadosState(
              idEvento, WP_EVT_INV_CRT, WP_EVT_INV_EDT, WP_EVT_INV_ENV)
          .listaInvitados(_cont);
    } else {
      MostrarAlerta(
          mensaje: 'Error al actualizar el grupo',
          tipoMensaje: TipoMensaje.error);
    }
  }

  Future<void> _showMyDialog(int idInvitado) async {
    return showDialog<void>(
      context: _cont,
      //barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Seleccionar estatus', textAlign: TextAlign.center),
          content: SizedBox(
            height: 120,
            child: //Column(
                //children: [
                CupertinoPicker(
                    itemExtent: 32.0,
                    onSelectedItemChanged: (value) {
                      _estatusSelect = _estatus.results
                          .elementAt(value)
                          .idEstatusInvitado
                          .toString();
                    },
                    children: <Widget>[
                  //for (var i = 0; i < _grupos.results.length; i++)
                  if (_estatus.results != null)
                    for (var data in _estatus.results) Text(data.descripcion)
                  else
                    (const Text('Sin datos')),
                ]),
            // _listaGrupos(),
            // ],
            //),
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
              child: const Text('Confirmar'),
              onPressed: () async {
                await _updateEstatus(idInvitado);
                BlocProvider.of<InvitadosMesasBloc>(context)
                    .add(MostrarInvitadosMesasEvent());
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  List<_Row> _rows;

  int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= _rows.length) return null;
    final row = _rows[index];
    return DataRow.byIndex(
      index: index,
      selected: row.selected,
      onSelectChanged: (value) {
        if (row.selected != value) {
          _selectedCount += value ? 1 : -1;
          assert(_selectedCount >= 0);
          row.selected = value;
        }
      },
      cells: [
        DataCell(
          Text(row.valueA),
          onTap: desconectado
              ? null
              : () {
                  _viewShowDialogEditar(row.valueId);
                },
        ),
        DataCell(Text(row.valueB), onTap: () async {
          await _showMyDialogLlamada(row.valueB);
        }),
        DataCell(
          Text(row.valueC),
          onTap: desconectado
              ? null
              : () {
                  _listaGruposEvento(row.valueId);
                },
        ),
        DataCell(
          Text(row.valueD),
          onTap: desconectado
              ? null
              : () {
                  _listaEstatusEvento(row.valueId);
                },
        ),
        DataCell(
          Icon(
            Icons.delete,
            color: desconectado ? Colors.grey : Colors.black,
          ),
          onTap: desconectado
              ? null
              : () {
                  _showMyDialogWhatsApp(row.valueE, row.valueId);
                },
        )
        //DataCell(Icon(Icons.edit)),
        //DataCell(Icon(Icons.delete)),
      ],
    );
  }

  @override
  int get rowCount => _rows.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}

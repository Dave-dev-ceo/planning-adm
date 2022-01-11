import 'dart:io';

import 'package:universal_html/html.dart' as html hide Text;
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
import 'package:planning/src/ui/mesas/mesasPage.dart';
import '../../../models/item_model_invitados.dart';

class ListaInvitados extends StatefulWidget {
  final int idEvento;
  final String nameEvento;
  final bool WP_EVT_INV_CRT;
  final bool WP_EVT_INV_EDT;
  final bool WP_EVT_INV_ENV;

  const ListaInvitados(
      {Key key,
      this.idEvento,
      this.WP_EVT_INV_CRT,
      this.WP_EVT_INV_EDT,
      this.WP_EVT_INV_ENV,
      this.nameEvento})
      : super(key: key);
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => ListaInvitados(),
      );
  @override
  _ListaInvitadosState createState() => _ListaInvitadosState(
      idEvento, WP_EVT_INV_CRT, WP_EVT_INV_EDT, WP_EVT_INV_ENV);
}

class _ListaInvitadosState extends State<ListaInvitados>
    with TickerProviderStateMixin {
  ApiProvider api = new ApiProvider();
  final TextStyle estiloTxt = TextStyle(fontWeight: FontWeight.bold);
  final int idEvento;

  int currentIndex = 0;
  TabController _controller;

  final bool WP_EVT_INV_CRT;
  final bool WP_EVT_INV_EDT;
  final bool WP_EVT_INV_ENV;

  bool dialVisible = true;

  BuildContext _dialogContext;

  TextEditingController controllerBuscar = TextEditingController();
  String _searchResult = '';
  List<dynamic> buscador = [];
  @override
  void initState() {
    _controller = TabController(length: 3, vsync: this);
    _controller.addListener(() {
      setState(() {
        currentIndex = _controller.index;
      });
    });
    super.initState();
  }

  _ListaInvitadosState(this.idEvento, this.WP_EVT_INV_CRT, this.WP_EVT_INV_EDT,
      this.WP_EVT_INV_ENV);
  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
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
              title: Text('Importación de excel'),
              content: Column(
                children: [
                  Text(
                      'Procedera a abrir su explorador de archivos para seleccionar un archivo excel,¿Desea continuar?'),
                  TextButton(
                    style: TextButton.styleFrom(
                        primary: Colors.blue,
                        textStyle: TextStyle(fontSize: 13.0)),
                    onPressed: () async {
                      ByteData bytes =
                          await rootBundle.load("assets/Plantilla.xlsx");
                      ;
                      final blob = html.Blob([bytes]);
                      final url = html.Url.createObjectUrlFromBlob(blob);

                      final anchor =
                          html.document.createElement('a') as html.AnchorElement
                            ..href = url
                            ..style.display = 'none'
                            ..download = 'Plantilla.xlsx';
                      html.document.body.children.add(anchor);
                      anchor.click();
                      html.document.body.children.remove(anchor);
                      html.Url.revokeObjectUrl(url);
                    },
                    child: Text('Descargar plantiila'),
                  ),
                ],
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text(
                    'No',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                CupertinoDialogAction(
                  child: Text('Sí'),
                  onPressed: () async {
                    await _readExcel();
                    await Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  _readExcel() async {
    /// Use FilePicker to pick files in Flutter Web
    FilePickerResult pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      allowMultiple: false,
    );

    /// file might be picked
    if (pickedFile != null) {
      var bytes = pickedFile.files.single.bytes;
      if (bytes == null) {
        bytes = File(pickedFile.files[0].path).readAsBytesSync();
        print('error');
      }

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
              'email': sheet.row(row)[1].value.toString(),
              'telefono': sheet.row(row)[2].value.toString(),
              'id_evento': idEvento.toString()
            };
            bool response = await api.createInvitados(jsonExample, context);
            bandera = response == true ? true : false;
          }
        } else {
          final snackBar = SnackBar(
            content: Container(
              height: 30,
              child: Center(
                child: Text('Estructura del excel es incorrecta.'),
              ),
              //color: Colors.red,
            ),
            backgroundColor: Colors.red,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
      if (bandera) {
        blocInvitados.fetchAllInvitados(context);
        final snackBar = SnackBar(
          content: Container(
            height: 30,
            child: Center(
              child: Text('Se importó el archivo con éxito.'),
            ),
            //color: Colors.red,
          ),
          backgroundColor: Colors.green,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        final snackBar = SnackBar(
          content: Container(
            height: 30,
            child: Center(
              child: Text('Error: No se pudo realizar el registro.'),
            ),
            //color: Colors.red,
          ),
          backgroundColor: Colors.orange,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      print('El file is null');
    }
  }

  Future<PermissionStatus> _getPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
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
                title: Text('Permisos denegados'),
                content: Text('Por favor habilitar el acceso a contactos'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ));
    }
  }

  SpeedDial buildSpeedDial(double pHz) {
    return SpeedDial(
      /// both default to 16
      icon: Icons.add,
      activeIcon: Icons.close_rounded,
      buttonSize: 56.0,
      visible: true,

      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      tooltip: 'Opciones',
      heroTag: UniqueKey().toString(),
      backgroundColor: Colors.black,
      foregroundColor: Colors.black,
      elevation: 12.0,
      shape: CircleBorder(),

      // orientation: SpeedDialOrientation.Up,
      // childMarginBottom: 2,
      // childMarginTop: 2,
      gradientBoxShape: BoxShape.circle,
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [hexToColor("#fdf4e5"), hexToColor("#fdf4e5")],
      ),
      children: armarBotonesAcciones(),
    );
  }

  List<SpeedDialChild> armarBotonesAcciones() {
    List<SpeedDialChild> temp = [];
    if (WP_EVT_INV_CRT) {
      temp.add(SpeedDialChild(
        foregroundColor: Colors.black,
        child: Tooltip(
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
        onLongPress: () => print('FIRST CHILD LONG PRESS'),
      ));

      temp.add(SpeedDialChild(
        foregroundColor: Colors.black,
        child: Tooltip(
          child: Icon(Icons.table_chart_outlined),
          message: "Importar excel",
        ),
        backgroundColor: hexToColor("#fdf4e5"),
        //label: 'Importar excel',
        //labelStyle: TextStyle(fontSize: 14.0),
        onTap: () => _viewShowDialogExcel(),
        onLongPress: () => print('SECOND CHILD LONG PRESS'),
      ));
      temp.add(SpeedDialChild(
        foregroundColor: Colors.black,
        child: Tooltip(
          child: Icon(Icons.import_contacts_rounded),
          message: "Importar contactos",
        ),
        backgroundColor: hexToColor("#fdf4e5"),
        //label: 'Importar contactos',
        //labelStyle: TextStyle(fontSize: 14.0),
        onTap: () => _viewContact(),
        onLongPress: () => print('THIRD CHILD LONG PRESS'),
      ));
      temp.add(SpeedDialChild(
        foregroundColor: Colors.black,
        child: Tooltip(
          child: Icon(Icons.download),
          message: "Descargar PDF",
        ),
        backgroundColor: hexToColor("#fdf4e5"),
        //label: 'Importar contactos',
        //labelStyle: TextStyle(fontSize: 14.0),
        onTap: downloadPDFListaInvitados,
        onLongPress: () => print('FOUR CHILD LONG PRESS'),
      ));
    }
    if (WP_EVT_INV_ENV) {
      temp.add(SpeedDialChild(
        foregroundColor: Colors.black,
        child: Tooltip(
          child: Icon(Icons.send_and_archive_sharp),
          message: "Enviar QR a invitados",
        ),
        backgroundColor: hexToColor("#fdf4e5"),
        onTap: () async {
          _dialogSpinner('Enviando QR...');
          Map<String, dynamic> response =
              await api.enviarInvitacionesPorEvento();
          Navigator.pop(_dialogContext);
          SnackBar sb = SnackBar(
            content: Container(
              height: 30,
              child: Center(
                child: Text(response['msg']),
              ),
              //color: Colors.red,
            ),
            backgroundColor: Colors.green,
          );
          ScaffoldMessenger.of(context).showSnackBar(sb);
        },
      ));
    }
    return temp;
  }

  alertaLlamada() {
    showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text('Permisos denegados'),
              content: Text('Por favor habilitar el acceso a contactos'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('OK'),
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
            return buildList(snapshot);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> listWidget = [
      listaInvitados(context),
      Asistencia(),
      MesasPage(nameEvento: widget.nameEvento),
    ];

    double pHz = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Invitados'),
        bottom: TabBar(
          controller: _controller,
          tabs: [
            Tab(
              icon: Icon(Icons.people),
              text: 'Lista de Invitados',
            ),
            Tab(
              icon: Icon(Icons.accessibility),
              text: 'Asistencia',
            ),
            Tab(
              icon: Icon(Icons.contact_mail_sharp),
              text: 'Mesas',
            ),
          ],
        ),
      ),

      body: TabBarView(
        controller: _controller,
        children: listWidget,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: currentIndex == 0 ? buildSpeedDial(pHz) : null,
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
    Widget child = CircularProgressIndicator();
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
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
          );
        });
  }

  Widget buildList(AsyncSnapshot<ItemModelInvitados> snapshot) {
    if (_searchResult == '') {
      buscador = snapshot.data.results;
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: new Icon(Icons.search),
            title: new TextField(
              controller: controllerBuscar,
              decoration: new InputDecoration(
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
            trailing: new IconButton(
                icon: Icon(Icons.cancel),
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
          header: Text('Invitados'),
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
              WP_EVT_INV_EDT, WP_EVT_INV_ENV),
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

  ItemModelGrupos _grupos;
  ItemModelEstatusInvitado _estatus;
  String _grupoSelect = "0";
  String _estatusSelect = "0";
  ApiProvider api = new ApiProvider();

  _DataSource(context, BuildContext cont, this.idEvento, this.WP_EVT_INV_CRT,
      this.WP_EVT_INV_EDT, this.WP_EVT_INV_ENV) {
    _rows = <_Row>[];
    for (int i = 0; i < context.length; i++) {
      _rows.add(_Row(
          context[i].idInvitado,
          context[i].nombre,
          context[i].telefono,
          context[i].grupo == null ? 'Sin grupo' : context[i].grupo,
          context[i].asistencia == null ? 'Sin estatus' : context[i].asistencia,
          context[i].telefono));
    }
    _cont = cont;
  }
  _msgSnackBar(String error, Color color) {
    final snackBar = SnackBar(
      content: Container(
        height: 30,
        child: Center(
          child: Text(error),
        ),
        //color: Colors.red,
      ),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(_cont).showSnackBar(snackBar);
  }

  Future<void> _showMyDialogLlamada(String numero) async {
    return showDialog<void>(
      context: _cont,
      //barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Teléfono', textAlign: TextAlign.center),
          content: Container(
            margin: const EdgeInsets.all(10.0),
            width: 400.0,
            height: 140.0,
            child: Column(
              children: <Widget>[
                Card(
                  child: ListTile(
                    title: Text('Se llamara al número $numero'),
                    trailing: Icon(Icons.phone),
                    onTap: () async {
                      launch('tel://$numero');
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                      title: Text('Abrir WhatsApp',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              // fontSize: 20,
                              color: Colors.green)),
                      trailing: FaIcon(FontAwesomeIcons.whatsapp),
                      onTap: () async {
                        launch('http://wa.me/521' + numero);
                      }),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
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
              title: Text('Eliminar Invitado'),
              content: // RichText(
                  RichText(
                text: TextSpan(
                  text: '¿Desara eliminar el invitado? ',
                  children: const <TextSpan>[
                    TextSpan(
                        text:
                            '!Se eliminarán los acompañantes relacionados al invitado!',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    // TextSpan(text: ' world!'),
                  ],
                ),
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
                  child: Text('Aceptar'),
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
                content: Text('Se llamara al numero $numero'),
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
      _msgSnackBar("Error al actualizar el estatus", Colors.red);
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

  /*_listaGrupos(int idInvitado) {
    ///bloc.dispose();
    blocGrupos.fetchAllGrupos(_cont);
    return StreamBuilder(
      stream: blocGrupos.allGrupos,
      builder: (context, AsyncSnapshot<ItemModelGrupos> snapshot) {
        if (snapshot.hasData) {
          //_mySelection = ((snapshot.data.results.length - 1).toString());

          return null;
          //_viewShowDialogGrupo(idInvitado, snapshot.data);
          //return _dataGrupo(snapshot.data);
          //
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }*/

  /*_dataGrupo(ItemModelGrupos grupos) {

    /*List<Text> lT;
    for(int i = 0; i < grupos.results.length; i++){
      Text(grupos.results.elementAt(i).nombreGrupo);
      lT.
    }
    
    return lT;*/
    return ListView.builder(
        itemCount: grupos.results.length,
        //padding: const EdgeInsets.only(top: 10),
        itemBuilder: (BuildContext context, int index) {
          return Container(
              child: Center(
                  child: Text(grupos.results.elementAt(index).nombreGrupo)));
        });
  }*/

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
          title: Text('Seleccionar estatus', textAlign: TextAlign.center),
          content: Container(
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
              child: Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            SizedBox(
              width: 10.0,
            ),
            TextButton(
              child: Text('Confirmar'),
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

  /*_viewShowDialogGrupo(int idInvitado){
     
      //
      showDialog(
          context: _cont,
          builder: (BuildContext context) => CupertinoAlertDialog(
                //title: Text('Seleccionar Grupo'),
                content: Container(
                    height: 120,
                    child: //Column(
                      //children: [
                        CupertinoPicker(
                          itemExtent: 32.0, 
                          
                          onSelectedItemChanged: (value){
                            
                            _grupoSelect = _grupos.results.elementAt(value).idGrupo.toString();
                           
                          }, 
                          children: <Widget>[
                            //for (var i = 0; i < _grupos.results.length; i++) 
                            for(var data in _grupos.results) if(data.nombreGrupo!="Nuevo grupo") Text(data.nombreGrupo),
                            ]),
                           // _listaGrupos(),
                     // ],
                    //),
                  ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('Cancelar',style: TextStyle(color: Colors.red),),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoDialogAction(
                    child: Text('Confirmar'),
                    onPressed: () async{
                      await _updateGrupo(idInvitado);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ));
  }*/
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
      _msgSnackBar("Error al actualizar el grupo", Colors.red);
    }
  }

  Future<void> _showMyDialog(int idInvitado) async {
    return showDialog<void>(
      context: _cont,
      //barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Seleccionar estatus', textAlign: TextAlign.center),
          content: Container(
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
                    (Text('Sin datos')),
                ]),
            // _listaGrupos(),
            // ],
            //),
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
              child: Text('Confirmar'),
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

  /* _viewShowDialogEstatus(int idInvitado) {
    showDialog(
        context: _cont,
        builder: (BuildContext context) => CupertinoAlertDialog(
              //title: Text('Seleccionar Grupo'),
              content: Container(
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
                        for (var data in _estatus.results)
                          Text(data.descripcion)
                      else
                        (Text('Sin datos')),
                    ]),
                // _listaGrupos(),
                // ],
                //),
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                CupertinoDialogAction(
                  child: Text('Confirmar'),
                  onPressed: () async {
                    await _updateEstatus(idInvitado);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
    /*showDialog(
          context: _cont,
          builder: (BuildContext context) => CupertinoAlertDialog(
                //title: Text('Llamada'),
                //content: Text('Se llamara al numero $numero'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('Confirmado'),
                    onPressed: () {
                      _updateEstatus(idInvitado, 1);
                      Navigator.of(context).pop();
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text('Sin Confirmar'),
                    onPressed: () {
                      _updateEstatus(idInvitado, 2);
                      Navigator.of(context).pop();
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text('No Asiste'),
                    onPressed: () {
                      _updateEstatus(idInvitado, 3);
                      
                      Navigator.of(context).pop();
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text('Cerrar',style: TextStyle(color: Colors.red),),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ));*/
  }*/

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
        DataCell(Text(row.valueA), onTap: () {
          _viewShowDialogEditar(row.valueId);
        }),
        DataCell(Text(row.valueB), onTap: () async {
          await _showMyDialogLlamada(row.valueB);
        }),
        DataCell(Text(row.valueC), onTap: () {
          _listaGruposEvento(row.valueId);
        }),
        DataCell(
          Text(row.valueD),
          onTap: () {
            _listaEstatusEvento(row.valueId);
          },
        ),
        DataCell(
          Icon(Icons.delete),
          onTap: () {
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

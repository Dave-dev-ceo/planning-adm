import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weddingplanner/src/blocs/blocs.dart';
import 'package:weddingplanner/src/models/item_model_estatus_invitado.dart';
import 'package:weddingplanner/src/models/item_model_grupos.dart';
import 'package:weddingplanner/src/resources/api_provider.dart';
import '../../../models/item_model_invitados.dart';
import 'package:url_launcher/url_launcher.dart';

class ListaInvitados extends StatefulWidget {
  final int idEvento;

  const ListaInvitados({Key key, this.idEvento}) : super(key: key);
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => ListaInvitados(),
      );
  @override
  _ListaInvitadosState createState() => _ListaInvitadosState(idEvento);
}

class _ListaInvitadosState extends State<ListaInvitados> {
  ApiProvider api = new ApiProvider();
  final TextStyle estiloTxt = TextStyle(fontWeight: FontWeight.bold);
  final int idEvento;
  bool dialVisible = true;
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
              content: Text('Procedera a abrir su explorador de archivos para seleccionar un archivo excel,¿Desea continuar?'),
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
                  onPressed: () {
                    _readExcel();
                    Navigator.of(context).pop();
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
      }

      var excel = Excel.decodeBytes(bytes);
      bool bandera = true;
      for (var table in excel.tables.keys) {
        //print(table); //sheet Name
        //print(excel.tables[table].maxCols);
        //print(excel.tables[table].maxRows);
        dynamic xx = excel.tables[table].rows;
        if (xx[0][0] == "NOMBRE" && xx[0][1] == "EMAIL" && xx[0][2] == "TELÉFONO") {
          for (var i = 1; i < xx.length; i++) {
            Map<String, String> json = {"nombre": xx[i][0], "telefono": xx[i][2].toString(), "email": xx[i][1], "id_evento": idEvento.toString()};
            bool response = await api.createInvitados(json, context);
            if (response) {
            } else {
              bandera = false;
            }
          }
          if (bandera) {
            final snackBar = SnackBar(
              content: Container(
                height: 30,
                child: Center(
                  child: Text('Se importo el archivo con éxito'),
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
                  child: Text('Error: No se pudo realizar el registro'),
                ),
                //color: Colors.red,
              ),
              backgroundColor: Colors.red,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        } else {
          final snackBar = SnackBar(
            content: Container(
              height: 30,
              child: Center(
                child: Text('Estructura incorrecta'),
              ),
              //color: Colors.red,
            ),
            backgroundColor: Colors.red,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
    }
  }

  Future<PermissionStatus> _getPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted && permission != PermissionStatus.permanentlyDenied) {
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

      final result = await Navigator.of(context).pushNamed('/addContactos', arguments: idEvento);
      if (result == null || result == "" || result == false || result == 0) {
        _ListaInvitadosState(idEvento).listaInvitados(context);
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

      marginEnd: pHz - 100,
      marginBottom: 20,

      icon: Icons.add,
      activeIcon: Icons.close_rounded,
      buttonSize: 56.0,
      visible: true,

      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      //onOpen: () => print('OPENING DIAL'),
      //onClose: () => print('DIAL CLOSED'),
      tooltip: 'Opciones',
      heroTag: 'Opciones',
      backgroundColor: Colors.white,
      foregroundColor: Colors.white,
      elevation: 8.0,
      shape: CircleBorder(),

      // orientation: SpeedDialOrientation.Up,
      // childMarginBottom: 2,
      // childMarginTop: 2,
      gradientBoxShape: BoxShape.circle,
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [hexToColor("#880B55"), hexToColor("#880B55")],
      ),
      children: [
        SpeedDialChild(
          foregroundColor: Colors.white,
          child: Tooltip(
            child: Icon(Icons.person_add),
            message: "Agregar invitado",
          ),
          backgroundColor: hexToColor("#880B55"),
          onTap: () async {
            final result = await Navigator.of(context).pushNamed('/addInvitados', arguments: idEvento);
            if (result == null || result == "" || result == false || result == 0) {
              _ListaInvitadosState(idEvento).listaInvitados(context);
            }
          },
          onLongPress: () => print('FIRST CHILD LONG PRESS'),
        ),
        SpeedDialChild(
          foregroundColor: Colors.white,
          child: Tooltip(
            child: Icon(Icons.table_chart_outlined),
            message: "Importar excel",
          ),
          backgroundColor: hexToColor("#880B55"),
          //label: 'Importar excel',
          //labelStyle: TextStyle(fontSize: 14.0),
          onTap: () => _viewShowDialogExcel(),
          onLongPress: () => print('SECOND CHILD LONG PRESS'),
        ),
        SpeedDialChild(
          foregroundColor: Colors.white,
          child: Tooltip(
            child: Icon(Icons.import_contacts_rounded),
            message: "Importar contactos",
          ),
          backgroundColor: hexToColor("#880B55"),
          //label: 'Importar contactos',
          //labelStyle: TextStyle(fontSize: 14.0),
          onTap: () => _viewContact(),
          onLongPress: () => print('THIRD CHILD LONG PRESS'),
        ),
        SpeedDialChild(
          foregroundColor: Colors.white,
          child: Tooltip(
            child: Icon(Icons.qr_code_outlined),
            message: "Escáner Código QR",
          ),
          backgroundColor: hexToColor("#880B55"),
          onTap: () async {
            final result = await Navigator.of(context).pushNamed('/lectorQr');
          },
        ),
      ],
    );
  }

  _ListaInvitadosState(this.idEvento);
  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
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
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ));
  }

  listaInvitados(BuildContext cont) {
    ///bloc.dispose();
    blocInvitados.fetchAllInvitados(cont);
    return StreamBuilder(
      stream: blocInvitados.allInvitados,
      builder: (context, AsyncSnapshot<ItemModelInvitados> snapshot) {
        if (snapshot.hasData) {
          return buildList(snapshot);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double pHz = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Center(
          child: listaInvitados(context),
        ),
      ),
      floatingActionButton: buildSpeedDial(pHz),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () async{
          //Navigator.of(context).pushNamed('/addInvitados', arguments: idEvento);
          final result = await Navigator.of(context).pushNamed('/addInvitados',arguments: idEvento); 
          if(result==null || result=="" || result == false || result == 0){
            //print("add "+result.toString());
            _ListaInvitadosState(idEvento).listaInvitados(context);
          }
        },
        child: const Icon(Icons.person_add),
        
        backgroundColor: hexToColor('#880B55'),
      ),*/
      //floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
    );
  }

  Widget buildList(AsyncSnapshot<ItemModelInvitados> snapshot) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        PaginatedDataTable(
          header: Text('Invitados'),
          rowsPerPage: 8,
          showCheckboxColumn: false,
          columns: [
            DataColumn(label: Text('Nombre', style: estiloTxt)),
            DataColumn(label: Text('Telefono', style: estiloTxt)),
            DataColumn(label: Text('Grupo', style: estiloTxt)),
            DataColumn(label: Text('Asistencia', style: estiloTxt)),
            //DataColumn(label: Text('', style:estiloTxt),),
            //DataColumn(label: Text('', style:estiloTxt)),
          ],
          source: _DataSource(snapshot.data.results, context, idEvento),
        ),
      ],
    );
  }
}

class _Row {
  _Row(
    this.valueId,
    this.valueA,
    this.valueB,
    this.valueC,
    this.valueD,
  );
  final int valueId;
  final String valueA;
  final String valueB;
  final String valueC;
  final String valueD;

  bool selected = false;
}

class _DataSource extends DataTableSource {
  BuildContext _cont;
  final int idEvento;
  ItemModelGrupos _grupos;
  ItemModelEstatusInvitado _estatus;
  String _grupoSelect = "0";
  String _estatusSelect = "0";
  ApiProvider api = new ApiProvider();
  _DataSource(context, BuildContext cont, this.idEvento) {
    _rows = <_Row>[];
    for (int i = 0; i < context.length; i++) {
      _rows.add(_Row(context[i].idInvitado, context[i].nombre, context[i].telefono, (context[i].grupo == null ? 'Sin grupo' : context[i].grupo),
          context[i].asistencia == null ? 'Sin estatus' : context[i].asistencia));
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
          title: Text('Llamada', textAlign: TextAlign.center),
          content: Text('Se llamara al número $numero'),
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
                launch('tel://$numero');
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
    Map<String, String> json = {"id_invitado": idInvitado.toString(), "id_estatus_invitado": _estatusSelect.toString()};

    bool response = await api.updateEstatusInvitado(json, _cont);
    if (response) {
      _ListaInvitadosState(idEvento).listaInvitados(_cont);
      //print("actualizado");
    } else {
      _msgSnackBar("Error al actualizar el estatus", Colors.red);
    }
  }

  _viewShowDialogEditar(int idInvitado) async {
    final resultE = await Navigator.of(_cont).pushNamed('/editInvitado', arguments: idInvitado);
    if (resultE == null || resultE == "" || resultE == false || resultE == 0) {
      //print("edit " + resultE.toString());
      _ListaInvitadosState(idEvento).listaInvitados(_cont);
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
          print('sacha');
          return null;
          //_viewShowDialogGrupo(idInvitado, snapshot.data);
          //return _dataGrupo(snapshot.data);
          //print(snapshot.data);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }*/

  /*_dataGrupo(ItemModelGrupos grupos) {
    print(grupos.results.length);
    /*List<Text> lT;
    for(int i = 0; i < grupos.results.length; i++){
      print(grupos.results.elementAt(i).nombreGrupo);
      Text(grupos.results.elementAt(i).nombreGrupo);
      lT.
    }
    
    return lT;*/
    return ListView.builder(
        itemCount: grupos.results.length,
        //padding: const EdgeInsets.only(top: 10),
        itemBuilder: (BuildContext context, int index) {
          print(grupos.results.elementAt(index).nombreGrupo);
          return Container(
              child: Center(
                  child: Text(grupos.results.elementAt(index).nombreGrupo)));
        });
  }*/

  _listaGruposEvento(int idInvitado) async {
    _grupos = await api.fetchGruposList(_cont);
    /*for (var data in _grupos.results) {
      print(data.nombreGrupo);
    }*/
    _showMyDialogGrupo(idInvitado);
  }

  _listaEstatusEvento(int idInvitado) async {
    _estatus = await api.fetchEstatusList(_cont);
    /*for (var data in _grupos.results) {
      print(data.nombreGrupo);
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
                      _grupoSelect = _grupos.results.elementAt(value).idGrupo.toString();
                      print(_grupoSelect);
                    },
                    children: <Widget>[
                  //for (var i = 0; i < _grupos.results.length; i++)
                  for (var data in _grupos.results)
                    if (data.nombreGrupo != "Nuevo grupo") Text(data.nombreGrupo),
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
     
      //print('ola');
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
                            print(_grupoSelect);
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
    Map<String, String> json = {"id_invitado": idInvitado.toString(), "id_grupo": _grupoSelect};
    response = await api.updateGrupoInvitado(json, _cont);
    if (response) {
      _ListaInvitadosState(idEvento).listaInvitados(_cont);
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
                      _estatusSelect = _estatus.results.elementAt(value).idEstatusInvitado.toString();
                      print(_grupoSelect);
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
                          print(_grupoSelect);
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
          print(value);
          _selectedCount += value ? 1 : -1;
          assert(_selectedCount >= 0);
          row.selected = value;
          //notifyListeners();
        }
      },
      cells: [
        //DataCell(Text(row.valueId.toString())),
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

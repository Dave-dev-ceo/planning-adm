// imports flutter/dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';

// bloc
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';
import 'package:planning/src/blocs/autorizacion/autorizacion_bloc.dart';

// model
import 'package:planning/src/models/item_model_autorizacion.dart';
import 'package:planning/src/models/item_model_preferences.dart';

class GaleriaEvidencia extends StatefulWidget {
  final Map map;
  GaleriaEvidencia({Key key, @required this.map}) : super(key: key);

  @override
  _GaleriaEvidenciaState createState() => _GaleriaEvidenciaState();
}

class _GaleriaEvidenciaState extends State<GaleriaEvidencia> {
  // variables bloc
  AutorizacionBloc autorizacionBloc;

  // variables model
  ItemModelAutorizacion itemModelAutorizacion;

  // variabls clase
  List<Evidencia> _listaEvidencia = [];

  // Variable involucrado
  bool isInvolucrado = false;

  @override
  void initState() {
    super.initState();
    autorizacionBloc = BlocProvider.of<AutorizacionBloc>(context);
    autorizacionBloc.add(SelectEvidenciaEvent(widget.map['id']));
    getIdInvolucrado();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        autorizacionBloc.add(SelectAutorizacionEvent());
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Galeria de ${widget.map['name']}'),
        ),
        body: _buildBloc(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
            heroTag: UniqueKey(),
            child: Icon(Icons.add),
            onPressed: () {
              if (!isInvolucrado) {
                _addImage(widget.map['id']);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Permisos Insuficientes.')),
                );
              }
            }),
      ),
    );
  }

  void getIdInvolucrado() async {
    final _idInvolucrado = await SharedPreferencesT().getIdInvolucrado();

    if (_idInvolucrado != null) {
      isInvolucrado = true;
    }
  }

  // bloc cargamos la consulta
  _buildBloc() {
    return BlocBuilder<AutorizacionBloc, AutorizacionState>(
      builder: (context, state) {
        // state ini
        if (state is AutorizacionInitialState)
          return Center(
            child: CircularProgressIndicator(),
          );
        // state log
        else if (state is AutorizacionLodingState)
          return Center(
            child: CircularProgressIndicator(),
          );
        else if (state is SelectEvidenciaState) {
          if (state.evidencia != null) {
            if (itemModelAutorizacion != state.evidencia) {
              itemModelAutorizacion = state.evidencia;
              if (itemModelAutorizacion != null) {
                _listaEvidencia = _copyModel(itemModelAutorizacion);
              }
            }
            return _crearGaleria(itemModelAutorizacion);
          } else {
            return Center(child: Text('Sin datos'));
          }
        }
        // not knowing
        else
          return Center(
            child: CircularProgressIndicator(),
          );
      },
    );
  }

  // cremos vista de galeria
  _crearGaleria(ItemModelAutorizacion item) {
    return GridView.count(
      restorationId: 'grid_view_demo_grid_offset',
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      padding: const EdgeInsets.all(8),
      childAspectRatio: 1,
      children: _creaLista(),
    );
  }

  // creamos lista
  List<Widget> _creaLista() {
    List<Widget> temp = [];

    _listaEvidencia.forEach((evidencia) {
      final bytes = base64Decode(evidencia.archivo);
      final image = MemoryImage(bytes);

      temp.add(GridTile(
        header: Material(
          color: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(4)),
          ),
          clipBehavior: Clip.antiAlias,
          child: GridTileBar(
            backgroundColor: Colors.black45,
            title: Row(
              children: [
                Expanded(
                  flex: 9,
                  child: evidencia.valida
                      ? Text('${evidencia.nombre}')
                      : TextFormField(
                          controller: TextEditingController(
                              text: '${evidencia.nombre}'),
                          decoration: InputDecoration(
                            hintText: 'Descripción',
                          ),
                          onChanged: (valor) {
                            evidencia.nombre = valor;
                          },
                        ),
                ),
                !isInvolucrado
                    ? Expanded(
                        flex: 1,
                        child: evidencia.valida
                            ? GestureDetector(
                                child: Icon(Icons.edit),
                                onTap: () {
                                  setState(() {
                                    evidencia.valida = !evidencia.valida;
                                  });
                                },
                              )
                            : GestureDetector(
                                child: Icon(Icons.save),
                                onTap: () {
                                  setState(() {
                                    evidencia.valida = !evidencia.valida;
                                  });
                                  autorizacionBloc.add(UpdateEvidenciaEvent(
                                      evidencia.idEvidencia,
                                      widget.map['id'],
                                      evidencia.nombre));
                                },
                              ),
                      )
                    : Text(''),
              ],
            ),
            // subtitle: GestureDetector(
            //   child: Icon(Icons.edit),
            // ),
          ),
        ),
        footer: Material(
          color: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(4)),
          ),
          clipBehavior: Clip.antiAlias,
          child: !isInvolucrado
              ? GridTileBar(
                  backgroundColor: Colors.black45,
                  // title: _GridTitleText(photo.title),
                  subtitle: GestureDetector(
                    child: Icon(Icons.delete),
                    onTap: () => _borrarImage(evidencia.idEvidencia),
                  ),
                )
              : Text(''),
        ),
        child: PhotoView(
          tightMode: true,
          backgroundDecoration: BoxDecoration(color: Colors.white),
          imageProvider: image,
        ),
      ));
    });

    return temp;
  }

  // mensaje
  Future<void> _mensaje(String txt) async {
    return await ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(txt),
    ));
  }

  /** EVENTOS **/

  // add image
  _addImage(int id) async {
    List<Evidencia> temp = [];
    Map mapTemp = Map();

    const extensiones = ['jpg', 'png', 'jpeg'];

    FilePickerResult pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: extensiones,
      allowMultiple: true,
    );

    pickedFile.files.forEach((archivo) {
      temp.add(Evidencia(
          idEvidencia: temp.length + 1,
          archivo: base64.encode(archivo.bytes),
          nombre: '${archivo.name}',
          tipo: archivo.extension));
    });

    if (temp.length > 0) {
      mapTemp = {'id_autorizacion': widget.map['id'], 'lista': temp};
      autorizacionBloc.add(CrearImagenEvent(mapTemp));
      _mensaje('Imagen agregada.');
    }
  }

  // delete image
  _borrarImage(int idEvidencia) {
    autorizacionBloc.add(DeleteEvidenciaEvent(idEvidencia, widget.map['id']));
    _mensaje('Imagen borrada.');
  }

  List<Evidencia> _copyModel(ItemModelAutorizacion item) {
    List<Evidencia> temp = [];

    item.autorizacion.forEach((evidencia) {
      temp.add(Evidencia(
        idEvidencia: evidencia.idEvidencia,
        nombre: evidencia.nombre,
        archivo: evidencia.archivo,
        valida: true,
      ));
    });

    return temp;
  }
}

class Evidencia {
  int idEvidencia;
  String archivo;
  String nombre;
  String tipo;
  bool valida;

  Evidencia({
    this.idEvidencia,
    this.archivo,
    this.nombre,
    this.tipo,
    this.valida,
  });

  // solucion al enviar objetos al servidor
  Map<String, dynamic> toJson() => {
        'id_evidencia': idEvidencia,
        'archivo': archivo,
        'nombre': nombre,
        'tipo': tipo,
      };
}

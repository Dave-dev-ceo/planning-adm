// imports flutter/dart
import 'package:flutter/material.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';

// wedding
import 'package:planning/src/ui/widgets/text_form_filed/text_form_filed.dart';

// bloc
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/blocs/autorizacion/autorizacion_bloc.dart';

// model
import 'package:planning/src/models/item_model_autorizacion.dart';

class AutorizacionLista extends StatefulWidget {
  AutorizacionLista({Key key}) : super(key: key);

  @override
  _AutorizacionListaState createState() => _AutorizacionListaState();
}

class _AutorizacionListaState extends State<AutorizacionLista> {
  // variables bloc
  AutorizacionBloc autorizacionBloc;

  // variables model
  ItemModelAutorizacion itemModelAutorizacion;

  // variables crear
  Map _autorizacion = Map();
  List<Evidencia> _archivos = [];
  bool validaDescripcion = true;

  // variables editar
  List<Autorizacion> _listAutorizacion;

  // Variable involucrado
  bool isInvolucrado = false;

  @override
  void initState() {
    super.initState();
    autorizacionBloc = BlocProvider.of<AutorizacionBloc>(context);
    autorizacionBloc.add(SelectAutorizacionEvent());
    getIdInvolucrado();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBloc(),
    );
  }

  void getIdInvolucrado() async {
    final _idInvolucrado = await SharedPreferencesT().getIdInvolucrado();

    if (_idInvolucrado != null) {
      isInvolucrado = true;
    }
  }

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
        else if (state is AutorizacionSelectState) {
          if (state.autorizacion != null) {
            if (itemModelAutorizacion != state.autorizacion) {
              itemModelAutorizacion = state.autorizacion;
              if (itemModelAutorizacion != null) {
                _listAutorizacion = _copyModel(itemModelAutorizacion);
              }
            }
            return _crearStickyHeader(itemModelAutorizacion);
          } else {
            return Center(child: Text('Sin datos'));
          }
        } else if (state is AutorizacionCreateState) {
          // limpiamos variables
          _autorizacion['descripcion'] = '';
          _archivos.clear();

          autorizacionBloc.add(SelectAutorizacionEvent());

          return _crearStickyHeader(state.autorizacion);
        }
        // not knowing
        else
          return Center(
            child: CircularProgressIndicator(),
          );
      },
    );
  }

  // stickyheader
  _crearStickyHeader(ItemModelAutorizacion item) {
    return RefreshIndicator(
      color: Colors.blue,
      onRefresh: () async {
        await autorizacionBloc.add(SelectAutorizacionEvent());
      },
      child: Container(
        padding: EdgeInsets.all(20.0),
        color: Colors.white,
        child: ListView(
          children: [
            Column(
              children: [
                StickyHeader(
                  header: Card(
                    elevation: 5,
                    color: Colors.white,
                    child: ExpansionTile(
                        title: _header('Autorizaciones', 20.0),
                        leading: null,
                        trailing: Icon(Icons.add),
                        backgroundColor: Colors.white,
                        children: !isInvolucrado
                            ? [
                                _content(),
                              ]
                            : [],
                        initiallyExpanded: false),
                  ),
                  content: _listaAutorizaciones(item),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // header
  _header(String txt, double padding) {
    return Container(
      padding: EdgeInsets.all(padding),
      width: double.infinity,
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            txt,
            style: TextStyle(fontSize: 20.0),
          ),
        ],
      ),
    );
  }

  // form add autorizacion
  _content() {
    return Container(
      padding: EdgeInsets.all(30.0),
      width: double.infinity,
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              TextFormFields(
                icon: Icons.local_activity,
                large: 400.0,
                ancho: 80.0,
                item: TextFormField(
                  controller: TextEditingController(
                      text: _autorizacion['descripcion'] == null
                          ? ''
                          : _autorizacion['descripcion']),
                  decoration: InputDecoration(
                      labelText: 'Descripción',
                      errorText: validaDescripcion
                          ? null
                          : 'La descripción no puede estar vacia.'),
                  onChanged: (valor) {
                    _autorizacion['descripcion'] = valor;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 3),
                child: Container(
                  child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 10,
                      child: ListTile(
                        leading: Icon(Icons.photo_library),
                        title: Text('Selecciona una foto'),
                        onTap: () => _addFilesView(),
                      )),
                  width: 400.0,
                  height: 80.0,
                ),
              ),
              _showFilesView(),
            ],
          ),
          _botonSave()
        ],
      ),
    );
  }

  // vista donde se agregan las imagenes
  _showFilesView() {
    List<Widget> temp = [];

    // ciclo para conseguir los archivos
    _archivos.forEach((archivo) {
      temp.add(Padding(
        padding: EdgeInsets.only(right: 100.0, left: 100.0),
        child: ListTile(
          leading: Icon(Icons.image),
          title: Text('${archivo.nombre}'),
          trailing: GestureDetector(
            child: Icon(Icons.delete),
            onTap: () => _removeFilesView(archivo.idEvidencia),
          ),
        ),
      ));
    });

    Column archivos = Column(
      children: temp,
    );

    return temp.length > 0 ? archivos : SizedBox();
  }

  // boton para agregar autorizacion
  _botonSave() {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: !isInvolucrado
          ? Container(
              decoration: const ShapeDecoration(
                color: Colors.black,
                shape: CircleBorder(),
              ),
              child: Ink(
                decoration: const ShapeDecoration(
                  color: Colors.black,
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  icon: Icon(Icons.save),
                  color: Colors.white,
                  onPressed: () => _addAutorizacion(),
                ),
              ))
          : Text(''),
    );
  }

  // mensaje
  Future<void> _mensaje(String txt) async {
    return await ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(txt),
    ));
  }

  // creamos lista con la copia del model
  List<Autorizacion> _copyModel(ItemModelAutorizacion item) {
    List<Autorizacion> temp = [];

    item.autorizacion.forEach((autorizacion) {
      temp.add(Autorizacion(
        idAutorizacion: autorizacion.idAutorizacion,
        descripcion: autorizacion.descripcionAutorizacion,
        validacion: true,
        comentario: autorizacion.comentario,
      ));
    });

    return temp;
  }

  // creamos tabla
  _listaAutorizaciones(ItemModelAutorizacion item) {
    List<ListTile> temp = [];

    if (!_listAutorizacion.isEmpty)
      _listAutorizacion.forEach((autorizacion) {
        temp.add(ListTile(
          leading: Icon(Icons.apps_outlined),
          title: Row(
            children: [
              Expanded(
                flex: 9,
                child: autorizacion.validacion
                    ? GestureDetector(
                        child: Text('${autorizacion.descripcion}'),
                        onTap: () => _showImagenes(autorizacion.idAutorizacion,
                            autorizacion.descripcion),
                      )
                    : TextFormField(
                        controller: TextEditingController(
                            text: '${autorizacion.descripcion}'),
                        decoration: InputDecoration(labelText: 'Descripción'),
                        onChanged: (valor) {
                          autorizacion.descripcion = valor;
                        },
                      ),
              ),
              !isInvolucrado
                  ? Expanded(
                      flex: 1,
                      child: GestureDetector(
                        child: Icon(Icons.edit),
                        onTap: () =>
                            _editAutorizacion(autorizacion.idAutorizacion),
                      ))
                  : Text(''),
              !isInvolucrado
                  ? Expanded(
                      flex: 1,
                      child: GestureDetector(
                        child: Icon(Icons.delete),
                        onTap: () =>
                            _deleteAutorizacion(autorizacion.idAutorizacion),
                      ))
                  : Text(''),
            ],
          ),
          subtitle: autorizacion.validacion
              ? GestureDetector(child: Text('${autorizacion.comentario}'))
              : TextFormField(
                  controller:
                      TextEditingController(text: '${autorizacion.comentario}'),
                  decoration: InputDecoration(labelText: 'Comentario'),
                  onChanged: (valor) {
                    autorizacion.comentario = valor;
                  },
                ),
          trailing: null,
        ));
      });

    if (item.autorizacion.isEmpty)
      return Center(
        child: Container(
          padding: EdgeInsets.only(top: 40.0),
          child: Text('Sin datos'),
        ),
      );
    else
      return Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 30.0),
        child: Column(children: temp),
      );
  }

  /** Eventos **/

  // add files
  _addFilesView() async {
    const extensiones = ['jpg', 'png', 'jpeg'];

    FilePickerResult pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: extensiones,
      allowMultiple: true,
    );

    pickedFile.files.forEach((archivo) {
      setState(() {
        _archivos.add(Evidencia(
            idEvidencia: _archivos.length + 1,
            archivo: base64.encode(archivo.bytes),
            nombre: '${archivo.name}',
            tipo: archivo.extension));
      });
    });
  }

  // remove files
  _removeFilesView(int id) {
    setState(() {
      _archivos.removeWhere((archivo) => archivo.idEvidencia == id);
    });
  }

  // guardar autorizacion
  _addAutorizacion() {
    RegExp exp = RegExp(r"(\w+)");
    setState(() {
      if (_autorizacion['descripcion'] != null) {
        Iterable<RegExpMatch> matches =
            exp.allMatches(_autorizacion['descripcion']);
        if (matches.isEmpty)
          validaDescripcion = false;
        else {
          validaDescripcion = true;
          _sendAutorizacion();
        }
      } else
        validaDescripcion = false;
    });
  }

  // enviar al servidor la data
  void _sendAutorizacion() {
    _autorizacion['lista'] = _archivos;
    autorizacionBloc.add(CrearAutorizacionEvent(_autorizacion));
    _mensaje('Autorización agregada.');
  }

  // vamos a la vista con las imagenes
  void _showImagenes(int idAutorizacion, String txt) {
    Map send = {'id': idAutorizacion, 'name': txt};
    Navigator.of(context).pushNamed('/galeriaEvidencia', arguments: send);
  }

  void _editAutorizacion(int idAutorizacion) {
    _listAutorizacion.forEach((autorizacion) {
      if (idAutorizacion == autorizacion.idAutorizacion) {
        setState(() {
          autorizacion.validacion = !autorizacion.validacion;
        });

        if (autorizacion.validacion) {
          autorizacionBloc.add(UpdateAutorizacionEvent(idAutorizacion,
              autorizacion.descripcion, autorizacion.comentario));
          _mensaje('Autorizacion actualizada.');
        }
      }
    });
  }

  void _deleteAutorizacion(int idAutorizacion) {
    autorizacionBloc.add(DeleteAutorizacionEvent(idAutorizacion));
    _mensaje('Autorizacion eliminada.');
  }
}

class Autorizacion {
  int idAutorizacion;
  String descripcion;
  bool validacion;
  String comentario;

  Autorizacion({
    this.idAutorizacion,
    this.descripcion,
    this.validacion,
    this.comentario,
  });
}

class Evidencia {
  int idEvidencia;
  String archivo;
  String nombre;
  String tipo;

  Evidencia({this.idEvidencia, this.archivo, this.nombre, this.tipo});

  // solucion al enviar objetos al servidor
  Map<String, dynamic> toJson() => {
        'id_evidencia': idEvidencia,
        'archivo': archivo,
        'nombre': nombre,
        'tipo': tipo,
      };
}

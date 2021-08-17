// imports flutter/dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';

// bloc
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';
import 'package:weddingplanner/src/blocs/autorizacion/autorizacion_bloc.dart';

// model
import 'package:weddingplanner/src/models/item_model_autorizacion.dart';

class GaleriaEvidencia extends StatefulWidget {
  final int id;
  GaleriaEvidencia({Key key, @required this.id}) : super(key: key);

  @override
  _GaleriaEvidenciaState createState() => _GaleriaEvidenciaState();
}

class _GaleriaEvidenciaState extends State<GaleriaEvidencia> {
  // variables bloc
  AutorizacionBloc autorizacionBloc;

  // variables model
  ItemModelAutorizacion itemModelAutorizacion;

  @override
  void initState() {
    super.initState();
    autorizacionBloc = BlocProvider.of<AutorizacionBloc>(context);
    autorizacionBloc.add(SelectEvidenciaEvent(widget.id));
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
          title: Text('Galeria de Evidencias'),
        ),
        body: _buildBloc(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _addImage(widget.id),
        ),
      ),
    );
  }

  // bloc cargamos la consulta
  _buildBloc() {
    return BlocBuilder<AutorizacionBloc, AutorizacionState>(
      builder: (context, state) {
        // state ini
        if(state is AutorizacionInitialState)
          return Center(child: CircularProgressIndicator(),);
        // state log
        else if(state is AutorizacionLodingState)
          return Center(child: CircularProgressIndicator(),);
        else if(state is SelectEvidenciaState) {
          if(state.evidencia != null) {
            itemModelAutorizacion = state.evidencia;
            return _crearGaleria(itemModelAutorizacion);
          } else {
            return Center(child: Text('Sin datos'));
          }
        }
        // not knowing
        else
          return Center(child: CircularProgressIndicator(),);
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
      children: _creaLista(item),
    );
  }

  // creamos lista
  List<Widget> _creaLista(ItemModelAutorizacion item) {
    List<Widget> temp = [];

    item.autorizacion.forEach((evidencia) {
      final bytes = base64Decode(evidencia.archivo);
      final image = MemoryImage(bytes);

      temp.add(
        GridTile(
          footer: Material(
            color: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(4)),
            ),
            clipBehavior: Clip.antiAlias,
            child: GridTileBar(
              backgroundColor: Colors.black45,  
              // title: _GridTitleText(photo.title),
              subtitle: GestureDetector(
                child: Icon(Icons.delete),
                onTap: () => _borrarImage(evidencia.idEvidencia),
              ),
            ),
          ),
          child:  PhotoView(
            tightMode: true,
            backgroundDecoration: BoxDecoration(color: Colors.white),
            imageProvider: image,
          ),
        )
      );
    });

    return temp;
  }

  // mensaje
  Future<void> _mensaje(String txt) async {
    return await ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(txt),
      )
    );
  }

  /** EVENTOS **/

  // add image
  _addImage(int id) async {
    print('add image');
    List<Evidencia> temp = [];
    Map mapTemp = Map();

    const extensiones = ['jpg','png','jpeg'];

    FilePickerResult pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: extensiones,
      allowMultiple: true,
    );

    pickedFile.files.forEach((archivo) {
      temp.add(
        Evidencia(
          idEvidencia: temp.length + 1,
          archivo: base64.encode(archivo.bytes),
          nombre: '${archivo.name}',
          tipo: archivo.extension
        )
      );
    });

    if(temp.length > 0) {
      mapTemp = {
        'id_autorizacion':widget.id,
        'lista':temp
      };
      autorizacionBloc.add(CrearImagenEvent(mapTemp));
      _mensaje('Imagen agregada.');
    }
    
  }

  // delete image
  _borrarImage(int idEvidencia) {
    autorizacionBloc.add(DeleteEvidenciaEvent(idEvidencia,widget.id));
    _mensaje('Imagen borrada.');
  }
}

class Evidencia {
  int idEvidencia;
  String archivo;
  String nombre;
  String tipo;

  Evidencia({
    this.idEvidencia,
    this.archivo,
    this.nombre,
    this.tipo
  });

  // solucion al enviar objetos al servidor
  Map<String, dynamic> toJson() =>{
    'id_evidencia':idEvidencia,
    'archivo':archivo,
    'nombre':nombre,
    'tipo':tipo,
  };
}
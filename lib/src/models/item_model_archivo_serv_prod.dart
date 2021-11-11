class ItemModelArchivoProvServ {
  List<ArchivoProvServ> _results = [];
  ItemModelArchivoProvServ.fromJson(List<dynamic> parsedJson) {
    try {
      List<ArchivoProvServ> temp = [];
      for (int i = 0; i < parsedJson.length; i++) {
        ArchivoProvServ result = ArchivoProvServ(parsedJson[i]);
        temp.add(result);
      }
      _results = temp;
    } catch (e) {}
  }
  List<ArchivoProvServ> get results => _results;
}

class ArchivoProvServ {
  int _id_archivo;
  int _id_proveedor;
  int _id_servicio;
  String _tipo_mime;
  String _nombre;
  String _descripcion;
  String _archivo;

  ArchivoProvServ(datos) {
    _id_archivo = datos['id_archivo'];
    _id_proveedor = datos['id_proveedor'];
    _id_servicio = datos['id_servicio'];
    _tipo_mime = datos['tipo_mime'];
    _nombre = datos['nombre'];
    _descripcion = datos['descripcion'];
    _archivo = datos['archivo'];
  }

  int get idArchivo => _id_archivo;
  int get idProveedor => _id_proveedor;
  int get idServicio => _id_servicio;
  String get tipoMime => _tipo_mime;
  String get nombre => _nombre;
  String get descripcion => _descripcion;
  String get archivo => _archivo;
}

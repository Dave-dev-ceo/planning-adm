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

class ItemModelArchivoEspecial {
  List<ArchivoEspecial> _results = [];
  ItemModelArchivoEspecial.fromJson(List<dynamic> parsedJson) {
    try {
      List<ArchivoEspecial> temp = [];
      for (int i = 0; i < parsedJson.length; i++) {
        ArchivoEspecial result = ArchivoEspecial(parsedJson[i]);
        temp.add(result);
      }
      _results = temp;
    } catch (e) {}
  }
  List<ArchivoEspecial> get results => _results;
}

class ArchivoEspecial {
  int _id_archivo_especial;
  int _id_proveedor;
  int _id_evento;
  String _tipo_mime;
  String _nombre;
  String _descripcion;
  String _archivo;

  ArchivoEspecial(datos) {
    _id_archivo_especial = datos['id_archivo_especial'];
    _id_proveedor = datos['id_proveedor'];
    _id_evento = datos['id_evento'];
    _tipo_mime = datos['tipo_mime'];
    _nombre = datos['nombre'];
    _descripcion = datos['descripcion'];
    _archivo = datos['archivo'];
  }

  int get idArchivoEspecial => _id_archivo_especial;
  int get idProveedor => _id_proveedor;
  int get idEvento => _id_evento;
  String get tipoMime => _tipo_mime;
  String get nombre => _nombre;
  String get descripcion => _descripcion;
  String get archivo => _archivo;
}

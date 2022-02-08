import 'package:flutter/foundation.dart';

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
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
  List<ArchivoProvServ> get results => _results;
}

class ArchivoProvServ {
  int _idArchivo;
  int _idProveedor;
  int _idServicio;
  String _tipoMime;
  String _nombre;
  String _descripcion;
  String _archivo;

  ArchivoProvServ(datos) {
    _idArchivo = datos['id_archivo'];
    _idProveedor = datos['id_proveedor'];
    _idServicio = datos['id_servicio'];
    _tipoMime = datos['tipo_mime'];
    _nombre = datos['nombre'];
    _descripcion = datos['descripcion'];
    _archivo = datos['archivo'];
  }

  int get idArchivo => _idArchivo;
  int get idProveedor => _idProveedor;
  int get idServicio => _idServicio;
  String get tipoMime => _tipoMime;
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
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
  List<ArchivoEspecial> get results => _results;
}

class ArchivoEspecial {
  int _idArchivoEspecial;
  int _idProveedor;
  int _idEvento;
  String _tipoMime;
  String _nombre;
  String _descripcion;
  String _archivo;

  ArchivoEspecial(datos) {
    _idArchivoEspecial = datos['id_archivo_especial'];
    _idProveedor = datos['id_proveedor'];
    _idEvento = datos['id_evento'];
    _tipoMime = datos['tipo_mime'];
    _nombre = datos['nombre'];
    _descripcion = datos['descripcion'];
    _archivo = datos['archivo'];
  }

  int get idArchivoEspecial => _idArchivoEspecial;
  int get idProveedor => _idProveedor;
  int get idEvento => _idEvento;
  String get tipoMime => _tipoMime;
  String get nombre => _nombre;
  String get descripcion => _descripcion;
  String get archivo => _archivo;
}

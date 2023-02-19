import 'package:flutter/foundation.dart';

class ItemModelDetalleListas {
  List<DetalleListas> _results = [];
  ItemModelDetalleListas.fromJson(List<dynamic> parsedJson) {
    try {
      List<DetalleListas> temp = [];
      for (int i = 0; i < parsedJson.length; i++) {
        DetalleListas result = DetalleListas(parsedJson[i]);
        temp.add(result);
      }
      _results = temp;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
  List<DetalleListas> get results => _results;
}

class DetalleListas {
  int? _idLista;
  int? _idDetalleLista;
  int? _cantidad;
  String? _nombre;
  String? _descripcion;

  DetalleListas(datos) {
    _idLista = datos['id_lista'];
    _idDetalleLista = datos['id_lista_detalle'];
    _cantidad = int.parse(datos['cantidad']);
    _nombre = datos['nombre'];
    _descripcion = datos['descripcion'];
  }

  set setNombre(String data) {
    _nombre = data;
  }

  set setDescripcion(String data) {
    _descripcion = data;
  }

  int? get idLista => _idLista;
  int? get idDetalleLista => _idDetalleLista;
  int? get cantidad => _cantidad;
  String? get nombre => _nombre;
  String? get descripcion => _descripcion;
}

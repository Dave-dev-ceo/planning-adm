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
    } catch (e) {}
  }
  List<DetalleListas> get results => _results;
}

class DetalleListas {
  int _cantidad;
  String _nombre;
  String _descripcion;

  DetalleListas(datos) {
    _cantidad = datos['cantidad'];
    _nombre = datos['nombre'];
    _descripcion = datos['descripcion'];
  }
  set addCantidad(int data) {
    _cantidad = data;
  }

  set setNombre(String data) {
    _nombre = data;
  }

  set setDescripcion(String data) {
    _descripcion = data;
  }

  int get cantidad => _cantidad;
  String get nombre => _nombre;
  String get descripcion => _descripcion;
}

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
  int _id_lista;
  int _id_detalle_lista;
  int _cantidad;
  String _nombre;
  String _descripcion;

  DetalleListas(datos) {
    _id_lista = datos['id_lista'];
    _id_detalle_lista = datos['id_lista_detalle'];
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

  int get id_lista => _id_lista;
  int get id_detalle_lista => _id_detalle_lista;
  int get cantidad => _cantidad;
  String get nombre => _nombre;
  String get descripcion => _descripcion;
}

class ItemModelListas {
  List<Listas> _results = [];
  // ItemModelArticulosRecibir(this._results);
  ItemModelListas.fromJson(List<dynamic> parsedJson) {
    try {
      print('parsedJson');
      print(parsedJson);
      print(parsedJson.length);
      List<Listas> temp = [];
      for (int i = 0; i < parsedJson.length; i++) {
        print('result');
        print(parsedJson);
        Listas result = Listas(parsedJson[i]);
        print('result --> ');
        print(result);
        temp.add(result);
      }
      _results = temp;
    } catch (e) {}
  }
  List<Listas> get results => _results;
}

class Listas {
  String _clave;
  String _nombre;
  String _descripcion;

  Listas(datos) {
    _clave = datos['clave'];
    _nombre = datos['nombre'];
    _descripcion = datos['descripcion'];
  }
  set addDescripcion(String data) {
    _descripcion = data;
  }

  set addActividad(String data) {
    _clave = data;
  }

  String get clave => _clave;
  String get nombre => _nombre;
  String get descripcion => _descripcion;
}

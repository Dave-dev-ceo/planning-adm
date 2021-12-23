class ItemModelListas {
  List<Listas> _results = [];
  ItemModelListas.fromJson(List<dynamic> parsedJson) {
    try {
      List<Listas> temp = [];
      for (int i = 0; i < parsedJson.length; i++) {
        Listas result = Listas(parsedJson[i]);
        temp.add(result);
      }
      _results = temp;
    } catch (e) {}
  }
  List<Listas> get results => _results;
}

class Listas {
  int _idLista;
  String _nombre;
  String _descripcion;

  Listas(datos) {
    _idLista = datos['id_lista'];
    _nombre = datos['nombre'];
    _descripcion = datos['descripcion'];
  }

  set addIdLista(int data) {
    _idLista = data;
  }

  set addNombre(String data) {
    _nombre = data;
  }

  set addDescripcion(String data) {
    _descripcion = data;
  }

  int get idLista => _idLista;
  String get nombre => _nombre;
  String get descripcion => _descripcion;
}

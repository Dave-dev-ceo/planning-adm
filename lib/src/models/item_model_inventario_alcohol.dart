class ItemModelInventarioAlcohol {
  List<InvAlcohol> _results = [];

  ItemModelInventarioAlcohol.fromJson(List<dynamic> parsedJson) {
    List<InvAlcohol> temp = [];
    InvAlcohol dat = InvAlcohol({
      "id_inventario_alcohol": 0,
      "cantidad": 0,
      "mililitros": 0,
      "descripcion": "Sin datos"
    });
    temp.add(dat);
    for (int i = 0; i < parsedJson.length; i++) {
      InvAlcohol result = InvAlcohol(parsedJson[i]);
      temp.add(result);
    }
    _results = temp;
  }
  List<InvAlcohol> get results => _results;
}

class InvAlcohol {
  String _descripcion;
  int _idInventarioAlcohol;
  int _cantidad;
  int _mililitros;

  InvAlcohol(datos) {
    _cantidad = datos['cantidad'];
    _mililitros = datos['mililitros'];
    _descripcion = datos['descripcion'];
    _idInventarioAlcohol = datos['id_inventario_alcohol'];
  }
  set addCantidad(int data) {
    _cantidad = data;
  }

  set addMililitros(int data) {
    _mililitros = data;
  }

  set addDescripcion(String data) {
    _descripcion = data;
  }

  int get cantidad => _cantidad;
  int get mililitros => _mililitros;
  String get descripcion => _descripcion;
  int get idInventarioAlcohol => _idInventarioAlcohol;
}

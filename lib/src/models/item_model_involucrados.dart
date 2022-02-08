class ItemModelInvolucrados {
  List<_Involucrados> _involucrados = []; // lista

  // constructor
  ItemModelInvolucrados(this._involucrados);

  // llenamos la lista
  ItemModelInvolucrados.fromJson(List<dynamic> pardedJson) {
    List<_Involucrados> temp = []; // lista temp

    // extramos los datos | llenamos lista - metodo forEach
    for (var data in pardedJson) {
      temp.add(_Involucrados(data));
    }

    _involucrados = temp;
  }

  // data
  List<_Involucrados> get contrato => _involucrados;
}

class _Involucrados {
  // variables
  int _idInvolucrado;
  String _nombreCompleto;
  String _email;
  String _telefono;

  // constructor
  _Involucrados(consulta) {
    _idInvolucrado = consulta['id_involucrado'];
    _nombreCompleto = consulta['nombre_completo'];
    _email = consulta['correo'];
    _telefono = consulta['telefono'];
  }

  // ini getters
  int get idInvolucrado => _idInvolucrado;
  String get nombreCompleto => _nombreCompleto;
  String get email => _email;
  String get telefono => _telefono;

  // ini setters
  set idMachote(value) => _idInvolucrado;
  set descripcion(value) => _nombreCompleto;
  set machote(value) => _email;
  set archivo(value) => _telefono;
}

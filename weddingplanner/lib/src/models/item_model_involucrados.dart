class ItemModelInvolucrados {
  List<_Involucrados> _involucrados = []; // lista

  // constructor
  ItemModelInvolucrados(this._involucrados);

  // llenamos la lista
  ItemModelInvolucrados.fromJson(List<dynamic> pardedJson) {
    List<_Involucrados> temp = []; // lista temp

    // extramos los datos | llenamos lista - metodo forEach
    pardedJson.forEach((data) {
      temp.add(_Involucrados(data));
    });

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
    _email = consulta['email'];
    _telefono = consulta['telefono'];
  }

  // ini getters
  int get idInvolucrado => this._idInvolucrado;
  String get nombreCompleto => this._nombreCompleto;
  String get email => this._email;
  String get telefono => this._telefono;

  // ini setters
  set idMachote(value) => this._idInvolucrado;
  set descripcion(value) => this._nombreCompleto;
  set machote(value) => this._email;
  set archivo(value) => this._telefono;
}

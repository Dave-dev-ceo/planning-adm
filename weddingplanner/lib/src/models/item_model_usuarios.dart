class ItemModelUsuarios {
  List<_Result> _results = [];

  ItemModelUsuarios.fromJson(List<dynamic> parsedJson) {
    // _results = parsedJson.map((res) {
    //   return _Result(res);
    // });

    List<_Result> temp = [];

    for (int i = 0; i < parsedJson.length; i++) {
      _Result result = _Result(parsedJson[i]);
      temp.add(result);
    }
    _results = temp;
  }

  List<_Result> get results => _results;
}

class _Result {
  int _idUsuario;
  String _correo;
  bool _admin;
  String _nombreCompleto;
  String _telefono;
  String _creado;
  String _modificado;
  String _creadoPor;
  String _modificadoPor;

  _Result(result) {
    _idUsuario = result['id_usuario'];
    _correo = result['correo'];
    _admin = result['admin'];
    _nombreCompleto = result['nombre_completo'];
    _telefono = result['telefono'];
    _creado = result['creado'].toString();
    _modificado = result['modificado'].toString();
    _creadoPor = result['creado_por'];
    _modificadoPor = result['modificado_por'];
  }

  int get id_usuario => this._idUsuario;

  set id_usuario(int value) => this._idUsuario = value;

  String get correo => this._correo;

  set correo(value) => this._correo = value;

  bool get admin => this._admin;

  set admin(value) => this._admin = value;

  String get nombre_completo => this._nombreCompleto;

  set nombre_completo(value) => this._nombreCompleto = value;

  String get telefono => this._telefono;

  set telefono(value) => this._telefono = value;

  String get creado => this._creado;

  set creado(value) => this._creado = value;

  String get modificado => this._modificado;

  set modificado(value) => this._modificado = value;

  String get creado_por => this._creadoPor;

  set creado_por(value) => this._creadoPor = value;

  String get modificado_por => this._modificadoPor;

  set modificado_por(value) => this._modificadoPor = value;
}

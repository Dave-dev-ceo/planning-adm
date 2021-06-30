class ItemModelUsuarios {
  List<_Result> _results = [];

  ItemModelUsuarios(this._results);

  ItemModelUsuarios.fromJson(List<dynamic> parsedJson) {
    List<_Result> temp = [];

    for (int i = 0; i < parsedJson.length; i++) {
      _Result result = _Result(parsedJson[i]);
      temp.add(result);
    }
    _results = temp;
  }

  ItemModelUsuarios copy() {
    List<_Result> temp = [];
    for (int i = 0; i < _results.length; i++) {
      _Result result = _Result.fromModel(_results[i]);
      temp.add(result);
    }
    return new ItemModelUsuarios(temp);
  }

  ItemModelUsuarios copyWith(ItemModelUsuarios obj) {
    List<_Result> temp = [];

    for (int i = 0; i < obj.results.length; i++) {
      _Result result = _Result.fromModel(obj.results[i]);
      temp.add(result);
    }
  }

  List<_Result> get results => _results;
}

class ItemModelUsuario {
  _Result _result;

  ItemModelUsuario(this._result);

  ItemModelUsuario.fromJson(List<dynamic> parsedJson) {
    _Result temp = _Result(parsedJson[0]);

    _result = temp;
  }

  ItemModelUsuario copy() {
    return new ItemModelUsuario(_result);
  }

  ItemModelUsuario copyWith(ItemModelUsuarios obj) {
    _Result result = _Result.fromModel(obj);
    return ItemModelUsuario(result);
  }

  _Result get result => _result;
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

  _Result.fromModel(dataObj) {
    _idUsuario = dataObj._idUsuario;
    _correo = dataObj._correo;
    _admin = dataObj._admin;
    _nombreCompleto = dataObj._nombreCompleto;
    _telefono = dataObj._telefono;
    _creado = dataObj._creado;
    _modificado = dataObj._modificado;
    _creadoPor = dataObj._creadoPor;
    _modificadoPor = dataObj._modificadoPor;
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

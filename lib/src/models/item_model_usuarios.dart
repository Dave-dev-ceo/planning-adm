// ignore_for_file: missing_return

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
    return ItemModelUsuarios(temp);
  }

  ItemModelUsuarios copyWith(ItemModelUsuarios obj) {
    List<_Result> temp = [];

    for (int i = 0; i < obj.usuarios.length; i++) {
      _Result result = _Result.fromModel(obj.usuarios[i]);
      temp.add(result);
    }
    return ItemModelUsuarios(temp);
  }

  List<_Result> get usuarios => _results;
}

class ItemModelUsuario {
  _Result? _result;

  ItemModelUsuario(this._result);

  ItemModelUsuario.fromJson(List<dynamic> parsedJson) {
    _Result temp = _Result(parsedJson[0]);

    _result = temp;
  }

  ItemModelUsuario copy() {
    return ItemModelUsuario(_result);
  }

  ItemModelUsuario copyWith(ItemModelUsuarios obj) {
    _Result result = _Result.fromModel(obj);
    return ItemModelUsuario(result);
  }

  _Result? get result => _result;
}

class _Result {
  int? _idUsuario;
  String? _correo;
  bool? _admin;
  String? _nombreCompleto;
  String? _telefono;
  String? _estatus;
  String? _creado;
  String? _modificado;
  String? _creadoPor;
  String? _modificadoPor;
  int? _idRol;
  String? _nombreRol;

  _Result(result) {
    _idUsuario = result['id_usuario'];
    _correo = result['correo'];
    _admin = result['admin'];
    _nombreCompleto = result['nombre_completo'];
    _telefono = result['telefono'];
    _estatus = result['estatus'];
    _creado = result['creado'].toString();
    _modificado = result['modificado'].toString();
    _creadoPor = result['creado_por'];
    _modificadoPor = result['modificado_por'];
    _idRol = result['id_rol'];
    _nombreRol = result['nombre_rol'];
  }

  _Result.fromModel(dataObj) {
    _idUsuario = dataObj._idUsuario;
    _correo = dataObj._correo;
    _admin = dataObj._admin;
    _nombreCompleto = dataObj._nombreCompleto;
    _telefono = dataObj._telefono;
    _estatus = dataObj._estatus;
    _creado = dataObj._creado;
    _modificado = dataObj._modificado;
    _creadoPor = dataObj._creadoPor;
    _modificadoPor = dataObj._modificadoPor;
    _idRol = dataObj._idRol;
    _nombreRol = dataObj._nombreRol;
  }

  int? get idUsuario => _idUsuario;

  String? get correo => _correo;

  bool? get admin => _admin;

  String? get nombreCompleto => _nombreCompleto;

  String? get telefono => _telefono;

  String? get estatus => _estatus;

  String? get creado => _creado;

  String? get modificado => _modificado;

  String? get creadoPor => _creadoPor;

  String? get modificadoPor => _modificadoPor;

  int? get idRol => _idRol;

  String? get nombreRol => _nombreRol;
}

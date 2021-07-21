class ItemModelRoles {
  List<_Rol> _results = [];

  ItemModelRoles(this._results);

  ItemModelRoles.fromJson(List<dynamic> parsedJson) {
    List<_Rol> temp = [];

    for (int i = 0; i < parsedJson.length; i++) {
      _Rol result = _Rol(parsedJson[i]);
      temp.add(result);
    }
    _results = temp;
  }

  ItemModelRoles copy() {
    List<_Rol> temp = [];
    for (int i = 0; i < _results.length; i++) {
      _Rol result = _Rol.fromModel(_results[i]);
      temp.add(result);
    }
    return new ItemModelRoles(temp);
  }

  ItemModelRoles copyWith(ItemModelRoles obj) {
    List<_Rol> temp = [];

    for (int i = 0; i < obj.roles.length; i++) {
      _Rol result = _Rol.fromModel(obj.roles[i]);
      temp.add(result);
    }
  }

  List<_Rol> get roles => _results;
}

class ItemModelRol {
  _Rol _result;

  ItemModelRol(this._result);

  ItemModelRol.fromJson(List<dynamic> parsedJson) {
    _Rol temp = _Rol(parsedJson[0]);

    _result = temp;
  }

  ItemModelRol copy() {
    return new ItemModelRol(_result);
  }

  ItemModelRol copyWith(ItemModelRol obj) {
    _Rol result = _Rol.fromModel(obj);
    return ItemModelRol(result);
  }

  _Rol get result => _result;
}

class _Rol {
  int _idRol;
  String _claveRol;
  String _nombreRol;
  int _idPlanner;
  String _estatus;
  String _creado;
  String _modificado;
  int _creadoPor;
  int _modificadoPor;

  String _agregadoPor;
  String _editadoPor;

  _Rol(result) {
    _idRol = int.parse(result['id_rol']);
    _claveRol = result['clave_rol'];
    _nombreRol = result['nombre_rol'];
    _idPlanner = result['id_planner'];
    _estatus = result['estatus'];
    _creado = result['creado'].toString();
    _modificado = result['modificado'].toString();
    _creadoPor = result['creado_por'];
    _modificadoPor = result['modificado_por'];
    _agregadoPor = result['agregado_por'];
    _editadoPor = result['editado_por'];
  }

  _Rol.fromModel(dataObj) {
    _idRol = dataObj._idRol;
    _claveRol = dataObj._claveRol;
    _nombreRol = dataObj._nombreRol;
    _idPlanner = dataObj._idPlanner;
    _estatus = dataObj._estatus;
    _creado = dataObj._creado;
    _modificado = dataObj._modificado;
    _creadoPor = dataObj._creadoPor;
    _modificadoPor = dataObj._modificadoPor;
    _agregadoPor = dataObj._agregadoPor;
    _editadoPor = dataObj._editadoPor;
  }

  int get id_rol => this._idRol;

  String get clave_rol => this._claveRol;

  String get nombre_rol => this._nombreRol;

  int get id_planner => this._idPlanner;

  String get estatus => this._estatus;

  String get creado => this._creado;

  String get modificado => this._modificado;

  int get creado_por => this._creadoPor;

  int get modificado_por => this._modificadoPor;

  String get agregado_por => this._agregadoPor;

  String get editado_por => this._editadoPor;
}

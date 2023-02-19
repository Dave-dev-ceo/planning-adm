// ignore_for_file: missing_return

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
    return ItemModelRoles(temp);
  }

  ItemModelRoles copyWith(ItemModelRoles obj) {
    List<_Rol> temp = [];

    for (int i = 0; i < obj.roles.length; i++) {
      _Rol result = _Rol.fromModel(obj.roles[i]);
      temp.add(result);
    }
    return ItemModelRoles(temp);
  }

  List<_Rol> get roles => _results;
}

class ItemModelRol {
  _Rol? _result;

  ItemModelRol(this._result);

  ItemModelRol.fromJson(dynamic parsedJson) {
    _Rol temp = _Rol(parsedJson);

    _result = temp;
  }

  ItemModelRol copy() {
    return ItemModelRol(_result);
  }

  ItemModelRol copyWith(ItemModelRol obj) {
    _Rol result = _Rol.fromModel(obj);
    return ItemModelRol(result);
  }

  _Rol? get result => _result;
}

class _Rol {
  int? _idRol;
  String? _claveRol;
  String? _nombreRol;
  int? _idPlanner;
  String? _estatus;
  String? _creado;
  String? _modificado;
  int? _creadoPor;
  int? _modificadoPor;

  String? _agregadoPor;
  String? _editadoPor;

  bool? _editable;

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
    _editable = result['editable'];
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
    _editable = dataObj._editable;
  }

  int? get idRol => _idRol;

  String? get claveRol => _claveRol;

  String? get nombreRol => _nombreRol;

  int? get idPlanner => _idPlanner;

  String? get estatus => _estatus;

  String? get creado => _creado;

  String? get modificado => _modificado;

  int? get creadoPor => _creadoPor;

  int? get modificadoPor => _modificadoPor;

  String? get agregadoPor => _agregadoPor;

  String? get editadoPor => _editadoPor;

  bool? get editable => _editable;
}

class Itemr {
  Itemr(
      {this.claveSeccion,
      this.idSeccion,
      this.nombreSeccion,
      this.selected,
      this.pantallas,
      this.isExpanded = true,
      this.posicion});

  String? claveSeccion;
  String? idSeccion;
  String? nombreSeccion;
  bool? selected;
  List<ItemPantalla>? pantallas;
  bool isExpanded;
  int? posicion;
}

class ItemPantalla {
  ItemPantalla(
      {this.clavePantalla,
      this.idPantalla,
      this.nombrePantalla,
      this.seleccion});
  String? clavePantalla;
  int? idPantalla;
  String? nombrePantalla;
  bool? seleccion;
}

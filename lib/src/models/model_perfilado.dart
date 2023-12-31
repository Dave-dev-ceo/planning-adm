class ItemModelSecciones {
  List<_Seccion> _secciones = [];

  ItemModelSecciones(this._secciones);

  ItemModelSecciones.fromJson(List<dynamic> parsedJson) {
    List<_Seccion> temp = [];

    for (int i = 0; i < parsedJson.length; i++) {
      _Seccion result = _Seccion(parsedJson[i]);
      temp.add(result);
    }
    _secciones = temp;
  }

  ItemModelSecciones copy() {
    List<_Seccion> temp = [];
    for (int i = 0; i < _secciones.length; i++) {
      _Seccion result = _Seccion.fromModel(_secciones[i]);
      temp.add(result);
    }
    return ItemModelSecciones(temp);
  }

  bool? hasAcceso({String? claveSeccion}) {
    bool? acceso = false;
    for (var sec in _secciones) {
      if (sec.claveSeccion == claveSeccion) {
        acceso = sec.acceso;
      }
    }
    return acceso;
  }

  List<_Seccion> get secciones => _secciones;
}

class _Seccion {
  String? _claveSeccion;
  bool? _acceso;

  _Seccion(data) {
    _claveSeccion = data['clave_seccion'];
    _acceso = data['acceso'];
  }

  _Seccion.fromModel(dataObj) {
    _claveSeccion = dataObj.claveSeccion;
    _acceso = dataObj.acceso;
  }

  String? get claveSeccion => _claveSeccion;
  bool? get acceso => _acceso;
  set acceso(bool? acceso) => _acceso = acceso;
}

// ----------------------------

class ItemModelPantallas {
  List<_Pantalla> _pantallas = [];

  ItemModelPantallas(this._pantallas);

  ItemModelPantallas.fromJson(List<dynamic> parsedJson) {
    List<_Pantalla> temp = [];
    for (int i = 0; i < parsedJson.length; i++) {
      _Pantalla result = _Pantalla(parsedJson[i]);
      temp.add(result);
    }
    _pantallas = temp;
  }

  ItemModelPantallas copy() {
    List<_Pantalla> temp = [];
    for (int i = 0; i < _pantallas.length; i++) {
      _Pantalla result = _Pantalla.fromModel(_pantallas[i]);
      temp.add(result);
    }
    return ItemModelPantallas(temp);
  }

  bool? hasAcceso({String? clavePantalla}) {
    bool? acceso = false;
    for (var pan in _pantallas) {
      if (pan.clavePantalla == clavePantalla) {
        acceso = pan.acceso;
      }
    }
    return acceso;
  }

  List<_Pantalla> get secciones => _pantallas;
}

class _Pantalla {
  int? _idSeccion;
  String? _clavePantalla;
  bool? _acceso;

  _Pantalla(data) {
    _idSeccion = data['id_seccion'];
    _clavePantalla = data['clave_pantalla'];
    _acceso = data['acceso'];
  }

  _Pantalla.fromModel(dataObj) {
    _idSeccion = dataObj._idPantalla;
    _clavePantalla = dataObj._clavePantalla;
    _acceso = dataObj._acceso;
  }

  int? get idSeccion => _idSeccion;
  String? get clavePantalla => _clavePantalla;
  bool? get acceso => _acceso;
  set acceso(bool? acceso) => _acceso = acceso;
}

class ItemModelPerfil {
  ItemModelSecciones _secciones;
  ItemModelPantallas _pantallas;

  ItemModelPerfil(this._secciones, this._pantallas);

  ItemModelSecciones get secciones => _secciones;

  ItemModelPantallas get pantallas => _pantallas;

}

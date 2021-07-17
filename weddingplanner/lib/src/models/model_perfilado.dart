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
    return new ItemModelSecciones(temp);
  }

  bool hasAcceso({String claveSeccion}) {
    bool acceso = false;
    _secciones.forEach((sec) {
      if (sec.claveSeccion == claveSeccion) {
        acceso = sec.acceso;
      }
    });
    return acceso;
  }

  List<_Seccion> get secciones => _secciones;
}

class _Seccion {
  String _claveSeccion;
  bool _acceso;

  _Seccion(data) {
    _claveSeccion = data['clave_seccion'];
    _acceso = data['acceso'];
  }

  _Seccion.fromModel(dataObj) {
    _claveSeccion = dataObj.claveSeccion;
    _acceso = dataObj.acceso;
  }

  String get claveSeccion => _claveSeccion;
  bool get acceso => _acceso;
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
    return new ItemModelPantallas(temp);
  }

  bool hasAcceso({String clavePantalla}) {
    bool acceso = false;
    _pantallas.forEach((pan) {
      if (pan.clavePantalla == clavePantalla) {
        acceso = pan.acceso;
      }
    });
    return acceso;
  }

  List<_Pantalla> get secciones => _pantallas;
}

class _Pantalla {
  String _clavePantalla;
  bool _acceso;

  _Pantalla(data) {
    _clavePantalla = data['clave_pantalla'];
    _acceso = data['acceso'];
  }

  _Pantalla.fromModel(dataObj) {
    _clavePantalla = dataObj.clavePantalla;
    _acceso = dataObj.acceso;
  }

  String get clavePantalla => _clavePantalla;
  bool get acceso => _acceso;
}

class ItemModelPerfil {
  ItemModelSecciones _secciones;
  ItemModelPantallas _pantallas;

  ItemModelPerfil(this._secciones, this._pantallas);

  ItemModelSecciones get secciones => _secciones;

  ItemModelPantallas get pantallas => _pantallas;
}

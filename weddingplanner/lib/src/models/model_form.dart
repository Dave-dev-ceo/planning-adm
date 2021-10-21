class ItemModelFormRol {
  List<SeccionRol> _form;

  ItemModelFormRol(this._form);

  ItemModelFormRol.fromJson(List<dynamic> parsedJson) {
    List<SeccionRol> temp = [];
    for (int i = 0; i < parsedJson.length; i++) {
      SeccionRol result = SeccionRol(parsedJson[i]);
      temp.add(result);
    }
    _form = temp;
  }

  ItemModelFormRol copy() {
    return new ItemModelFormRol(_form);
  }

  List<SeccionRol> get form => _form;

  String toJsonStr() => _listToJson().toString();

  _listToJson() {
    List<String> temp = [];
    for (var sec in _form) {
      temp.add(sec.toJsonStr().toString());
    }
    return temp;
  }
}

class SeccionRol {
  int _idSeccion;
  String _claveSeccion;
  String _nombreSeccion;
  bool _selected;
  List<PantallaRol> _pantallasSeccion;

  SeccionRol(json) {
    _idSeccion = int.parse(json['id_seccion']);
    _claveSeccion = json['clave_seccion'];
    _nombreSeccion = json['nombre_seccion'];
    _selected = json['selected'];
    List<PantallaRol> temp = [];
    if (json['pantallas'].length == 0) {
      _pantallasSeccion = null;
    } else {
      for (int i = 0; i < json['pantallas'].length; i++) {
        PantallaRol result = PantallaRol(json['pantallas'][i]);
        temp.add(result);
      }
      _pantallasSeccion = temp;
    }
  }

  SeccionRol.fromModel(dataObj) {
    _idSeccion = dataObj._id_seccion;
    _claveSeccion = dataObj._id_seccion;
    _nombreSeccion = dataObj._id_seccion;
    _pantallasSeccion = dataObj._pantallasSeccion;
    _selected = dataObj._selected;
  }

  Map<String, dynamic> toJson() => {
        'id_seccion': _idSeccion,
        'clave_seccion': _claveSeccion,
        'nombre_seccion': _nombreSeccion,
        'pantallas': _listToJsonStr(),
        'selected': _selected
      };

  Map<String, dynamic> toJsonStr() => {
        '"id_seccion"': _idSeccion,
        '"clave_seccion"': '"$_claveSeccion"',
        '"nombre_seccion"': '"$_nombreSeccion"',
        '"pantallas"': _listToJsonStr(),
        '"selected"': _selected
      };

  _listToJsonStr() {
    List<String> temp = [];
    if (_pantallasSeccion != null) {
      for (var pan in _pantallasSeccion) {
        temp.add(pan.toJsonStr().toString());
      }
      return temp.toString();
    } else {
      return null;
    }
  }

  int get id_seccion => this._idSeccion;

  String get clave_seccion => this._claveSeccion;

  String get nombre_seccion => this._nombreSeccion;

  bool get selected => this._selected;

  set selected(value) => this._selected = value;

  List<PantallaRol> get pantallas => this._pantallasSeccion;
}

class PantallaRol {
  int _idPantalla;
  String _clavePantalla;
  String _nombrePantalla;
  bool _selected;

  PantallaRol(result) {
    if (result['id_pantalla'].runtimeType == String)
      _idPantalla = int.parse(result['id_pantalla']);
    if (result['id_pantalla'].runtimeType == int)
      _idPantalla = result['id_pantalla'];
    _clavePantalla = result['clave_pantalla'];
    _nombrePantalla = result['nombre_pantalla'];
    _selected = result['selected'];
  }

  PantallaRol.fromModel(dataObj) {
    _idPantalla = dataObj._idPantalla;
    _clavePantalla = dataObj._clavePantalla;
    _nombrePantalla = dataObj._nombrePantalla;
    _selected = dataObj._selected;
  }

  Map<String, dynamic> toJson() => {
        'id_pantalla': _idPantalla,
        'clave_pantalla': _clavePantalla,
        'nombre_pantalla': _nombrePantalla,
        'selected': _selected
      };

  Map<String, dynamic> toJsonStr() => {
        '"id_pantalla"': _idPantalla,
        '"clave_pantalla"': '"$_clavePantalla"',
        '"nombre_pantalla"': '"$_nombrePantalla"',
        '"selected"': _selected
      };

  int get id_pantalla => this._idPantalla;

  String get clave_pantalla => this._clavePantalla;

  String get nombre_pantalla => this._nombrePantalla;

  bool get selected => this._selected;

  set selected(value) => this._selected = value;
}

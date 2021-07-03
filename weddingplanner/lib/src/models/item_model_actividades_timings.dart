class ItemModelActividadesTimings {
  List<_Result> _results = [];

  ItemModelActividadesTimings(this._results);

  ItemModelActividadesTimings.fromJson(List<dynamic> parsedJson) {
    List<_Result> temp = [];
    if(parsedJson.length > 0){
      _Result dat =
        _Result({"id_actividad_timing": 0, "nombre_actividad": "Seleccionar predecesor"});
      temp.add(dat);
    }
    for (int i = 0; i < parsedJson.length; i++) {
      _Result result = _Result(parsedJson[i]);
      temp.add(result);
    }
    _results = temp;
  }

  ItemModelActividadesTimings copy() {
    List<_Result> temp = [];

    for (int i = 0; i < _results.length; i++) {
      _Result result = _Result.fromModel(_results[i]);
      temp.add(result);
    }

    return new ItemModelActividadesTimings(temp);
  }

ItemModelActividadesTimings copyWith(ItemModelActividadesTimings obj) {
    List<_Result> temp = [];

    for (int i = 0; i < obj.results.length; i++) {
      _Result result = _Result.fromModel(obj.results[i]);
      temp.add(result);
    }
  }

  List<_Result> get results => _results;
}

class _Result {
  int _idActividad;
  String _nombreActividad;
  String _descripcion;
  bool _visibleInvolucrados;
  String _dias;
  int _predecesor;
  int _idTipoTimig;

  _Result(result) {
    _idActividad = result['id_actividad_timing'];
    _nombreActividad = result['nombre_actividad'];
    _descripcion = result['descripcion'];
    _visibleInvolucrados = result['visible_involucrados'];
    _dias = result['dias'];
    _predecesor = result['predecesor'];
    _idTipoTimig = result['id_tipo_timing'];
  }

  _Result.fromModel(dataObj) {
    _idActividad = dataObj._idActividad;
    _nombreActividad = dataObj._nombreActividad;
    _descripcion = dataObj._descripcion;
    _visibleInvolucrados = dataObj._visibleInvolucrados;
    _dias = dataObj._dias;
    _predecesor = dataObj._predecesor;
  }
  int get idActividad => this._idActividad;
  String get nombreActividad => this._nombreActividad;
  String get descripcion => this._descripcion;
  bool get visibleInvolucrados => this._visibleInvolucrados;
  String get dias => this._dias;
  int get predecesor => this._predecesor;
  int get idTipoTimig => this._idTipoTimig;
  
  set addidActividad(int value) => this._idActividad = value;
  set addnombreActividad(String value) => this._nombreActividad = value;
  set adddescripcion(String value) => this._descripcion = value;
  set addvisibleInvolucrados(bool value) => this._visibleInvolucrados = value;
  set adddias(String value) => this._dias = value;
  set addpredecesor(int value) => this._predecesor = value;
  set addidTipoTimig(int value) => this._idTipoTimig = value;
}

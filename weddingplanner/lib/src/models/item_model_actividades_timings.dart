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

  ItemModelActividadesTimings.fromJsonEvento(List<dynamic> parsedJson) {
    List<_Result> temp = [];
    
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
  bool _addActividad;
  DateTime _fechaInicio;
  
  /* nuevas */
  int _idEventoTiming;
  String _nombreEventoTarea;
  int _idEventoActividad;
  String _nombreEventoActividad;
  bool _isCheck;
  bool _isExpanded;
  DateTime _fechaInicioActividad;
  DateTime _fechaInicioEvento;
  DateTime _fechaFinalEvento;
  int _dia;


  _Result(result) {
    _idActividad = result['id_actividad_timing'];
    _nombreActividad = result['nombre_actividad'];
    _descripcion = result['descripcion'];
    _visibleInvolucrados = result['visible_involucrados'];
    _dias = result['dias'].toString();
    _predecesor = result['predecesor'];
    _idTipoTimig = result['id_tipo_timing'];
    _addActividad = result['estatus_calendar'];
    _fechaInicio = DateTime.now();
    /* nuevas */
    _idEventoTiming = result['id_evento_timing'];
    _nombreEventoTarea = result['nombre_timing'];
    _idEventoActividad = result['id_evento_actividad'];
    _nombreEventoActividad = result['nombre'];
    _isCheck = false;
    _isExpanded = false;
    _fechaInicioActividad = DateTime.parse(result['fecha_inicio_actividad']);
    _fechaInicioEvento = DateTime.parse(result['fecha_inicio_evento']);
    _fechaFinalEvento = DateTime.parse(result['fecha_final_evento']);
    _dia = result['dias'];
  }

  _Result.fromModel(dataObj) {
    _idActividad = dataObj._idActividad;
    _nombreActividad = dataObj._nombreActividad;
    _descripcion = dataObj._descripcion;
    _visibleInvolucrados = dataObj._visibleInvolucrados;
    _dias = dataObj._dias;
    _predecesor = dataObj._predecesor;
    _addActividad = false;
    _fechaInicio = DateTime.now();
    /* nuevas */
    _idEventoTiming = dataObj._idEventoTiming;
    _nombreEventoTarea = dataObj._nombreEventoTarea;
    _idEventoActividad = dataObj._idEventoActividad;
    _nombreEventoActividad = dataObj._nombreEventoActividad;
    _isCheck = false;
    _isExpanded = false;
    _fechaInicioActividad = dataObj._fechaInicioActividad;
    _fechaInicioEvento = dataObj._fechaInicioEvento;
    _fechaFinalEvento = dataObj._fechaFinalEvento;
    _dia = int.parse(dataObj._dias);
  }

  int get idActividad => this._idActividad;
  String get nombreActividad => this._nombreActividad;
  String get descripcion => this._descripcion;
  bool get visibleInvolucrados => this._visibleInvolucrados;
  String get dias => this._dias;
  int get predecesor => this._predecesor;
  int get idTipoTimig => this._idTipoTimig;
  bool get addActividad => this._addActividad;
  DateTime get fechaInicio => this._fechaInicio;
  /* nuevas */
  int get idEventoTiming => this._idEventoTiming;
  String get nombreEventoTarea => this._nombreEventoTarea;
  int get idEventoActividad => this._idEventoActividad;
  String get nombreEventoActividad => this._nombreEventoActividad;
  bool get isCheck => this._isCheck;
  bool get isExpanded => this._isExpanded;
  DateTime get fechaInicioActividad => this._fechaInicioActividad;
  DateTime get fechaInicioEvento => this._fechaInicioEvento;
  DateTime get fechaFinalEvento => this._fechaFinalEvento;
  int get dia => this._dia;
  
  set addidActividad(int value) => this._idActividad = value;
  set addnombreActividad(String value) => this._nombreActividad = value;
  set adddescripcion(String value) => this._descripcion = value;
  set addvisibleInvolucrados(bool value) => this._visibleInvolucrados = value;
  set adddias(String value) => this._dias = value;
  set addpredecesor(int value) => this._predecesor = value;
  set addidTipoTimig(int value) => this._idTipoTimig = value;
  set addActividad(bool value) => this._addActividad = value;
  set fechaInicio(DateTime value) => this._fechaInicio;
  /* nuevas */
  set idEventoTiming(int value) => this._idEventoTiming;
  set nombreEventoTarea(String value) => this._nombreEventoTarea;
  set idEventoActividad(int value) => this._idEventoActividad;
  set nombreEventoActividad(String value) => this._nombreEventoActividad;
  set isCheck(bool value) => this._isCheck;
  set isExpanded(bool value) => this._isExpanded;
  set fechaInicioActividad(DateTime value) => this._fechaInicioActividad;
  set fechaInicioEvento(DateTime value) => this._fechaInicioEvento;
  set fechaFinalEvento(DateTime value) => this._fechaFinalEvento;
  set dia(int value) => this._dia;
}

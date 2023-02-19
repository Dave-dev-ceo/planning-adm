// ignore_for_file: missing_return, unnecessary_getters_setters, duplicate_ignore

class ItemModelActividadesTimings {
  List<_Result> _results = [];

  ItemModelActividadesTimings(this._results);

  ItemModelActividadesTimings.fromJson(List<dynamic> parsedJson) {
    List<_Result> temp = [];
    if (parsedJson.isNotEmpty) {
      _Result dat = _Result({
        "id_actividad_timing": 0,
        "nombre_actividad": "Seleccionar predecesor"
      });
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

    return ItemModelActividadesTimings(temp);
  }

  ItemModelActividadesTimings copyWith(ItemModelActividadesTimings obj) {
    List<_Result> temp = [];

    for (int i = 0; i < obj.results.length; i++) {
      _Result result = _Result.fromModel(obj.results[i]);
      temp.add(result);
    }

    return ItemModelActividadesTimings(temp);
  }

  List<_Result> get results => _results;
}

class _Result {
  int? _idActividad;
  String? _nombreActividad;
  String? _descripcion;
  bool? _visibleInvolucrados;
  bool? _haveFile;
  String? _dias;
  int? _predecesor;
  int? _idTipoTimig;
  bool? _addActividad;
  DateTime? _fechaInicio;
  int? _tiempoAntes;

  /* nuevas */
  int? _idEventoTiming;
  String? _nombreEventoTarea;
  int? _idEventoActividad;
  String? _nombreEventoActividad;
  bool? _isCheck;
  bool? _isExpanded;
  DateTime? _fechaInicioActividad;
  DateTime? _fechaInicioEvento;
  DateTime? _fechaFinalEvento;
  int? _dia;

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
    _haveFile = result['hasfile'];
    _tiempoAntes = result['tiempo_antes'];

    /* nuevas */
    _idEventoTiming = result['id_evento_timing'];
    _nombreEventoTarea = result['nombre_timing'];
    _idEventoActividad = result['id_evento_actividad'];
    _nombreEventoActividad = result['nombre'];
    _isCheck = false;
    _isExpanded = false;
    if (result['fecha_inicio_actividad'] != null) {
      _fechaInicioActividad = DateTime.parse(result['fecha_inicio_actividad']);
    }
    if (result['fecha_inicio_evento'] != null) {
      _fechaInicioEvento = DateTime.parse(result['fecha_inicio_evento']);
    }
    if (result['fecha_final_evento'] != null) {
      _fechaFinalEvento = DateTime.parse(result['fecha_final_evento']);
    }
    if (result['dias'] != null) {
      if (result['dias'].runtimeType == String) {
        _dia = int.parse(result['dias']);
      } else {
        _dia = result['dias'];
      }
    }
  }

  _Result.fromModel(dataObj) {
    _idActividad = dataObj._idActividad;
    _nombreActividad = dataObj._nombreActividad;
    _descripcion = dataObj._descripcion;
    _visibleInvolucrados = dataObj._visibleInvolucrados;
    _dias = dataObj._dias;
    _predecesor = dataObj._predecesor;
    _addActividad = dataObj._addActividad;
    _fechaInicio = dataObj._fechaInicio;
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
    _tiempoAntes = dataObj._tiempoAntes;
  }

  int? get idActividad => _idActividad;
  String? get nombreActividad => _nombreActividad;
  String? get descripcion => _descripcion;
  bool? get visibleInvolucrados => _visibleInvolucrados;
  String? get dias => _dias;
  int? get predecesor => _predecesor;
  int? get idTipoTimig => _idTipoTimig;
  // ignore: unnecessary_getters_setters
  bool? get addActividad => _addActividad;
  DateTime? get fechaInicio => _fechaInicio;
  /* nuevas */
  int? get idEventoTiming => _idEventoTiming;
  String? get nombreEventoTarea => _nombreEventoTarea;
  int? get idEventoActividad => _idEventoActividad;
  String? get nombreEventoActividad => _nombreEventoActividad;
  bool? get isCheck => _isCheck;
  bool? get isExpanded => _isExpanded;
  DateTime? get fechaInicioActividad => _fechaInicioActividad;
  DateTime? get fechaInicioEvento => _fechaInicioEvento;
  DateTime? get fechaFinalEvento => _fechaFinalEvento;
  int? get dia => _dia;
  bool? get haveFile => _haveFile;
  int? get tiempoAntes => _tiempoAntes;

  set addidActividad(int value) => _idActividad = value;
  set addnombreActividad(String value) => _nombreActividad = value;
  set adddescripcion(String value) => _descripcion = value;
  set addvisibleInvolucrados(bool value) => _visibleInvolucrados = value;
  set adddias(String value) => _dias = value;
  set addpredecesor(int value) => _predecesor = value;
  set addidTipoTimig(int value) => _idTipoTimig = value;
  set addActividad(bool? value) => _addActividad = value;
  set fechaInicio(DateTime? value) => _fechaInicio;
  /* nuevas */
  set idEventoTiming(int? value) => _idEventoTiming;
  set nombreEventoTarea(String? value) => _nombreEventoTarea;
  set idEventoActividad(int? value) => _idEventoActividad;
  set nombreEventoActividad(String? value) => _nombreEventoActividad;
  set isCheck(bool? value) => _isCheck;
  set isExpanded(bool? value) => _isExpanded;
  set fechaInicioActividad(DateTime? value) => _fechaInicioActividad;
  set fechaInicioEvento(DateTime? value) => _fechaInicioEvento;
  set fechaFinalEvento(DateTime? value) => _fechaFinalEvento;
  set dia(int? value) => _dia;
  set haveFile(bool? value) => _haveFile = value;
  set tiempoAntes(int? value) => _tiempoAntes = value;
}

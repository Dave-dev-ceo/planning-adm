// ignore_for_file: missing_return, unnecessary_getters_setters

class ItemModelTimings {
  List<_Result> _results = [];

  ItemModelTimings(this._results);

  ItemModelTimings.fromJson(List<dynamic> parsedJson) {
    List<_Result> temp = [];

    for (int i = 0; i < parsedJson.length; i++) {
      _Result result = _Result(parsedJson[i]);
      temp.add(result);
    }
    _results = temp;
  }

  ItemModelTimings copy() {
    List<_Result> temp = [];

    for (int i = 0; i < _results.length; i++) {
      _Result result = _Result.fromModel(_results[i]);
      temp.add(result);
    }

    return ItemModelTimings(temp);
  }

  ItemModelTimings copyWith(ItemModelTimings obj) {
    List<_Result> temp = [];

    for (int i = 0; i < obj.results.length; i++) {
      _Result result = _Result.fromModel(obj.results[i]);
      temp.add(result);
    }

    return ItemModelTimings(temp);
  }

  List<_Result> get results => _results;
}

class _Result {
  int? _idTiming;
  String? _nombreTiming;
  int? _idEventoTiming;
  String? _estatus;
  DateTime? _fechaInicio;

  _Result(result) {
    _idTiming = result['id_tipo_timing'];
    _nombreTiming = result['nombre_timing'];
    _idEventoTiming = result['id_evento_timing'];
    _estatus = result['estatus'];
    if (result['fecha_inicio'] != null) {
      _fechaInicio = DateTime.parse(result['fecha_inicio']);
    }
  }

  _Result.fromModel(dataObj) {
    _idTiming = dataObj._idTiming;
    _nombreTiming = dataObj._nombreTiming;
    _idEventoTiming = dataObj._idEventoTiming;
    _fechaInicio = dataObj._fechaInicio;
    _estatus = dataObj._estatus;
  }

  int? get idTiming => _idTiming;
  String? get nombreTiming => _nombreTiming;
  int? get idEventoTiming => _idEventoTiming;
  DateTime? get fechaInicio => _fechaInicio;
  String? get estatus => _estatus;

  set idTiming(int? value) => _idTiming = value;
  set nombreTiming(value) => _nombreTiming = value;
  set idEventoTiming(int? value) => _idEventoTiming = value;
  set estatus(String? value) => _estatus = value;
  set fechaInicio(DateTime? value) => _fechaInicio = value;
}

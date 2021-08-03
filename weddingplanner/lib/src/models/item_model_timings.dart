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

    return new ItemModelTimings(temp);
  }

  ItemModelTimings copyWith(ItemModelTimings obj) {
    List<_Result> temp = [];

    for (int i = 0; i < obj.results.length; i++) {
      _Result result = _Result.fromModel(obj.results[i]);
      temp.add(result);
    }
  }

  List<_Result> get results => _results;
}

class _Result {
  int _idTiming;
  String _nombreTiming;
  int _idEventoTiming;
  DateTime _fechaInicio;

  _Result(result) {
    _idTiming = result['id_tipo_timing'];
    _nombreTiming = result['nombre_timing'];
    _idEventoTiming = result['id_evento_timing'];
    if(result['fecha_inicio'] != null)
      _fechaInicio = DateTime.parse(result['fecha_inicio']);
  }

  _Result.fromModel(dataObj) {
    _idTiming = dataObj._idTiming;
    _nombreTiming = dataObj._nombreTiming;
    _idEventoTiming = dataObj._idEventoTiming;
    _fechaInicio = dataObj._fechaInicio;
  }

  int get id_timing => this._idTiming;
  String get nombre_timing => this._nombreTiming;
  int get idEventoTiming => this._idEventoTiming;
  DateTime get fechaInicio => this._fechaInicio;

  set id_timing(int value) => this._idTiming = value;
  set nombre_timing(value) => this._nombreTiming = value;
  set idEventoTiming(int value) => this._idEventoTiming = value;
  set fechaInicio(DateTime value) => this._fechaInicio = value;
}

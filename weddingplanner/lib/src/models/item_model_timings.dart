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

  _Result(result) {
    _idTiming = result['id_tipo_timing'];
    _nombreTiming = result['nombre_timing'];
  }

  _Result.fromModel(dataObj) {
    _idTiming = dataObj._idTiming;
    _nombreTiming = dataObj._nombreTiming;
  }

  int get id_timing => this._idTiming;

  set id_timing(int value) => this._idTiming = value;

  String get nombre_timing => this._nombreTiming;

  set nombre_timing(value) => this._nombreTiming = value;
}
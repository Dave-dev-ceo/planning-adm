class ItemModelAsistencia {
  List<_Result> _results = [];

  ItemModelAsistencia(this._results);

  ItemModelAsistencia.fromJson(List<dynamic> parsedJson) {
    List<_Result> temp = [];

    for (int i = 0; i < parsedJson.length; i++) {
      _Result result = _Result(parsedJson[i]);
      temp.add(result);
    }
    _results = temp;
  }

  ItemModelAsistencia copy() {
    List<_Result> temp = [];
    for (int i = 0; i < _results.length; i++) {
      _Result result = _Result.fromModel(_results[i]);
      temp.add(result);
    }
    return new ItemModelAsistencia(temp);
  }

  ItemModelAsistencia copyWith(ItemModelAsistencia obj) {
    List<_Result> temp = [];

    for (int i = 0; i < obj.asistencias.length; i++) {
      _Result result = _Result.fromModel(obj.asistencias[i]);
      temp.add(result);
    }
  }

  List<_Result> get asistencias => _results;
}

class _Result {
  String _nombreCompleto;

  _Result(result) {
    _nombreCompleto = result['nombre_completo'];
  }

  _Result.fromModel(dataObj) {
    _nombreCompleto = dataObj._nombreCompleto;
  }

  String get nombre_completo => this._nombreCompleto;

  set nombre_completo(value) => this._nombreCompleto = value;
}

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
  String _idInvitado;
  String _nombreCompleto;
  String _mesa;
  String _grupo;
  String _asistencia;

  _Result(result) {
    _idInvitado = result['id_invitado'].toString();
    _nombreCompleto = result['nombre'];
    _mesa = result['mesa'];
    _grupo = result['grupo'];
    _asistencia = result['asistencia'].toString();
  }

  _Result.fromModel(dataObj) {
    _nombreCompleto = dataObj._nombreCompleto;
  }

  String get id_invitado => this._idInvitado;

  set id_invitado(value) => this._idInvitado = value;

  String get nombre => this._nombreCompleto;

  set nombre(value) => this._nombreCompleto = value;

  String get mesa => this._mesa;

  set mesa(value) => this._mesa = value;

  String get grupo => this._grupo;

  set grupo(value) => this._grupo = value;

  String get asistencia => this._asistencia;

  set asistencia(value) => this._asistencia = value;
}

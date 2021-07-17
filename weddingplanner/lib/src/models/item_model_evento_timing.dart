class ItemModelEventoTiming {
  List<_Result> _results = [];

  ItemModelEventoTiming(this._results);

  ItemModelEventoTiming.fromJson(List<dynamic> parsedJson) {
    List<_Result> temp = [];

    for (int i = 0; i < parsedJson.length; i++) {
      _Result result = _Result(parsedJson[i]);
      temp.add(result);
    }
    _results = temp;
  }

  ItemModelEventoTiming copy() {
    List<_Result> temp = [];
    for (int i = 0; i < _results.length; i++) {
      _Result result = _Result.fromModel(_results[i]);
      temp.add(result);
    }
    return new ItemModelEventoTiming(temp);
  }

  ItemModelEventoTiming copyWith(ItemModelEventoTiming obj) {
    List<_Result> temp = [];

    for (int i = 0; i < obj.actividades.length; i++) {
      _Result result = _Result.fromModel(obj.actividades[i]);
      temp.add(result);
    }
  }

  List<_Result> get actividades => _results;
}

class _Result {
  int _idInvitado;
  String _nombreCompleto;
  String _mesa;
  String _grupo;
  bool _asistencia;

  _Result(result) {
    _idInvitado = result['id_invitado'];
    _nombreCompleto = result['nombre'];
    _mesa = result['mesa'];
    _grupo = result['grupo'];
    _asistencia = result['asistencia'];
  }

  _Result.fromModel(dataObj) {
    _idInvitado = dataObj._idInvitado;
    _nombreCompleto = dataObj._nombreCompleto;
    _mesa = dataObj._mesa;
    _grupo = dataObj._grupo;
    _asistencia = dataObj._asistencia;
  }

  int get id_invitado => this._idInvitado;

  set id_invitado(value) => this._idInvitado = value;

  String get nombre => this._nombreCompleto;

  set nombre(value) => this._nombreCompleto = value;

  String get mesa => this._mesa;

  set mesa(value) => this._mesa = value;

  String get grupo => this._grupo;

  set grupo(value) => this._grupo = value;

  bool get asistencia => this._asistencia;

  set asistencia(value) => this._asistencia = value;
}

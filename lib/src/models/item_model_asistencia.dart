// ignore_for_file: missing_return

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
    return ItemModelAsistencia(temp);
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
  int _idInvitado;
  String _nombreCompleto;
  String _nombreAcompanante;
  String _mesa;
  String _grupo;
  bool _asistencia;

  _Result(result) {
    _idInvitado = result['id_invitado'];
    _nombreCompleto = result['nombre'];
    _nombreAcompanante = result['acompanante'];
    _mesa = result['mesa'];
    _grupo = result['grupo'];
    _asistencia = result['asistencia'];
  }

  _Result.fromModel(dataObj) {
    _idInvitado = dataObj._idInvitado;
    _nombreCompleto = dataObj._nombreCompleto;
    _nombreAcompanante = dataObj._nombreAcompanante;
    _mesa = dataObj._mesa;
    _grupo = dataObj._grupo;
    _asistencia = dataObj._asistencia;
  }

  int get idInvitado => _idInvitado;

  set idInvitado(value) => _idInvitado = value;

  String get nombre => _nombreCompleto;

  set nombre(value) => _nombreCompleto = value;

  String get acompanante => _nombreAcompanante;

  set acompanante(value) => _nombreAcompanante = value;

  String get mesa => _mesa;

  set mesa(value) => _mesa = value;

  String get grupo => _grupo;

  set grupo(value) => _grupo = value;

  bool get asistencia => _asistencia;

  set asistencia(value) => _asistencia = value;
}

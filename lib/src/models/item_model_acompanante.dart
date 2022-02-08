// ignore_for_file: unnecessary_getters_setters

class ItemModelAcompanante {
  List<_ItemModelAcompanante> _results = [];

  ItemModelAcompanante.fromJson(List<dynamic> parsedJson) {
    List<_ItemModelAcompanante> temp = [];
    for (int i = 0; i < parsedJson.length; i++) {
      _ItemModelAcompanante result = _ItemModelAcompanante(parsedJson[i]);
      temp.add(result);
    }
    _results = temp;
  }
  List<_ItemModelAcompanante> get results => _results;
}

class _ItemModelAcompanante {
  int _idAcompanante;
  String _nombre;
  String _edad;
  int _idEvento;
  int _idInvitado;
  int _idPlanner;
  String _alimentacion;
  String _alergias;
  String _asistenciaEspecial;

  _ItemModelAcompanante(result) {
    _idAcompanante = result['id_acompanante'];
    _nombre = result['nombre'];
    _edad = result['edad'];
    _idEvento = result['id_evento'];
    _idInvitado = result['id_invitado'];
    _idPlanner = result['id_planner'];
    _alimentacion = result['alimentacion'];
    _alergias = result['alergias'];
    _asistenciaEspecial = result['asistencia_especial'];
  }
  int get idAcompanne => _idAcompanante;
  String get nombre => _nombre;
  String get edad => _edad;
  int get idEvento => _idEvento;
  int get idInvitado => _idInvitado;
  int get idPlanner => _idPlanner;
  String get alimentacion => _alimentacion;
  String get alergias => _alergias;
  String get asistenciaEspecial => _asistenciaEspecial;

  set idAcompanne(int idAcompanante) {
    _idAcompanante = idAcompanante;
  }

  set nombre(String nombre) {
    _nombre = nombre;
  }

  set edad(String edad) {
    _edad = edad;
  }

  set alimentacion(String alimentacion) {
    _alimentacion = alimentacion;
  }

  set alergias(String alergias) {
    _alergias = alergias;
  }

  set asistenciaEspecial(String asistenciaEspecial) {
    _asistenciaEspecial = asistenciaEspecial;
  }
}

class ItemModelInvitados {
  List<_Result> _results = [];
  int acompanantes = 0;
  int invitados = 0;

  ItemModelInvitados.fromJson(List<dynamic> parsedJson) {
    List<_Result> temp = [];
    for (int i = 0; i < parsedJson.length; i++) {
      _Result result = _Result(parsedJson[i]);
      acompanantes += result.acompanantes!;
      invitados++;
      temp.add(result);
    }
    _results = temp;
  }
  List<_Result> get results => _results;
}

class _Result {
  int? _idInvitado;
  String? _nombre;
  String? _telefono;
  String? _grupo;
  String? _asistencia;
  String? _correo;
  String? _codigoPais;
  int? _acompanantes;

  _Result(result) {
    _idInvitado = result['id_invitado'];
    _nombre = result['nombre'];
    _telefono = result['telefono'];
    _grupo = result['grupo'];
    _asistencia = result['descripcion'];
    _correo = result['correo'];
    _acompanantes = int.parse(result['acompanantes']);
    _codigoPais = result['codigo_pais'];
  }
  int? get idInvitado => _idInvitado;
  String? get nombre => _nombre;
  String? get telefono => _telefono;
  String? get grupo => _grupo;
  String? get asistencia => _asistencia;
  String? get correo => _correo;
  int? get acompanantes => _acompanantes;
  String? get codigoPais => _codigoPais;
}

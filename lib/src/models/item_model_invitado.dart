class ItemModelInvitado {
  int _idInvitado;
  String _nombre;
  String _telefono;
  int _grupo;
  int _asistencia;
  String _email;
  String _genero;
  String _edad;
  String _menu;
  int _idMesa;
  String _alimentacion;
  String _alergias;
  String _asistenciaEspecial;
  String _otros;
  bool _estatusInvitacion;
  String _qr;
  int _numAcomp;

  ItemModelInvitado.fromJson(Map<dynamic, dynamic> parsedJson) {
    _idInvitado = parsedJson['id_invitado'];
    _nombre = parsedJson['nombre'];
    _telefono = parsedJson['telefono'];
    _grupo = parsedJson['grupo'];
    _asistencia = parsedJson['descripcion'];
    _email = parsedJson['email'];
    _genero = parsedJson['genero'];
    _edad = parsedJson['edad'];
    _menu = parsedJson['menu'];
    _idMesa = parsedJson['id_mesa'];
    _estatusInvitacion = parsedJson['estatus_invitacion'];
    _alimentacion = parsedJson['alimentacion'];
    _alergias = parsedJson['alergias'];
    _asistenciaEspecial = parsedJson['asistencia_especial'];
    _qr = parsedJson.containsKey('qr') ? parsedJson['qr'] : '';
    _numAcomp = parsedJson['numero_acompanante'];
    _otros = parsedJson['otros'];
  }

  int get idInvitado => _idInvitado;
  String get nombre => _nombre;
  String get telefono => _telefono;
  int get grupo => _grupo;
  int get asistencia => _asistencia;
  String get email => _email;
  String get genero => _genero;
  String get edad => _edad;
  String get menu => _menu;
  int get idMesa => _idMesa;
  String get alimentacion => _alimentacion;
  String get alergias => _alergias;
  String get asistenciaEspecial => _asistenciaEspecial;
  bool get estatusInvitacion => _estatusInvitacion;
  String get codigoQr => _qr;
  int get numbAcomp => _numAcomp;
  String get otros => _otros;
}

class ItemModelInvitado {
  int _idInvitado;
  String _nombre;
  String _telefono;
  int _grupo;
  String _asistencia;
  String _email;
  String _genero;
  String _edad;
  String _menu;
  int _idMesa;
  bool _estatusInvitacion;

  ItemModelInvitado.fromJson(List<dynamic> parsedJson){
    _idInvitado = parsedJson[0]['id_invitado'];
    _nombre = parsedJson[0]['nombre'];
    _telefono = parsedJson[0]['telefono'];
    _grupo = parsedJson[0]['grupo'];
    _asistencia = parsedJson[0]['descripcion'];
    _email = parsedJson[0]['email'];
    _genero = parsedJson[0]['genero'];
    _edad = parsedJson[0]['edad'];
    _menu = parsedJson[0]['menu'];
    _idMesa = parsedJson[0]['id_mesa'];
    _estatusInvitacion = parsedJson[0]['estatus_invitacion'];

  }
  int get idInvitado=>_idInvitado;
  String get nombre=>_nombre;
  String get telefono=>_telefono;
  int get grupo=>_grupo;
  String get asistencia=>_asistencia;
  String get email=>_email;
  String get genero=>_genero;
  String get edad=>_edad;
  String get menu=>_menu;
  int get idMesa=>_idMesa;
  bool get estatusInvitacion=>_estatusInvitacion;
}

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

  ItemModelInvitado.fromJson(Map<dynamic,dynamic> parsedJson){
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

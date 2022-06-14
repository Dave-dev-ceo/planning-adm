import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesT {
  SharedPreferences _sharedPreferences;

  setNombre(String nombre) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setString('nombre', nombre);
  }

  getNombre() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.getString('nombre');
  }

  setIdPlanner(int idPlanner) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setInt('idPlanner', idPlanner);
  }

  getIdPlanner() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.getInt('idPlanner');
  }

  // ini permisos involucrado
  setIdInvolucrado(int idInvolucrado) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setInt('idInvolucrado', idInvolucrado);
  }

  getIdInvolucrado() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.getInt('idInvolucrado');
  }

  setEventoNombre(String json) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.setString('eventoNombre', json);
  }

  getEventoNombre() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.getString('eventoNombre');
  }

  setPermisoBoton(bool json) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.setBool('permisoBoton', json);
  }

  getPermisoBoton() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.getBool('permisoBoton');
  }
  // fin permisos involucrado

  // inicio fecha involucrado

  setFechaEvento(String json) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.setString('fechaEvento', json);
  }

  getFechaEvento() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.getString('fechaEvento');
  }
  // fin fecha involucrado

  // ini perfil
  setImagen(String json) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.setString('imagen', json);
  }

  getImagen() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.getString('imagen');
  }

  setPortada(String json) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.setString('portada', json);
  }

  getPortada() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.getString('portada');
  }
  // fin perfil

  setIdUsuario(int idUsuario) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setInt('idUsuario', idUsuario);
  }

  getIdUsuario() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.getInt('idUsuario');
  }

  setIdEvento(int idEvento) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setInt('idEvento', idEvento);
  }

  getIdEvento() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.getInt('idEvento');
  }

  setPermisos(String json) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.setString('permisos', json);
  }

  getPermisos() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.getString('permisos');
  }

  setToken(String token) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setString('token', token);
  }

  getToken() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.getString('token');
  }

  setSesion(bool session) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.setBool('session', session);
  }

  getSession() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.getBool('session') ?? false;
  }

  setLogic(bool logic) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.setBool('logic', logic);
  }

  getLogic() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.getBool('logic') ?? false;
  }

  setJsonData(List<String> json) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.setStringList('dataWPlanner', json);
  }

  getJsonData() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.getStringList('dataWPlanner');
  }

  setCorreo(String correo) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('correo', correo);
  }

  Future<String> getCorreo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('correo');
  }

  setClaveRol(String claveRol) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('claveRol', claveRol);
  }

  Future<String> getClaveRol() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('claveRol');
  }

  clear() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    Set<dynamic> keyPreferens = _sharedPreferences.getKeys();

    for (var key in keyPreferens) {
      if (key == 'correo') {
        continue;
      }
      await _sharedPreferences.remove(key);
    }
  }
}

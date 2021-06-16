import 'package:shared_preferences/shared_preferences.dart';
class SharedPreferencesT{
  SharedPreferences _sharedPreferences;

  setIdPlanner(int idPlanner) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setInt('idPlanner', idPlanner);
  }

  getIdPlanner() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.getInt('idPlanner');
  }

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
    return _sharedPreferences.getBool('session') == null ? false:_sharedPreferences.getBool('session');
  }

  setLogic(bool logic) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.setBool('logic', logic);
  }

  getLogic() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.getBool('logic') == null ? false:_sharedPreferences.getBool('logic');
  }

  setJsonData(List<String> json) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.setStringList('dataWPlanner', json);
  }

  getJsonData() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.getStringList('dataWPlanner');
  }

  clear() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.clear();
  }
}
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
  clear() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.clear();
  }
}
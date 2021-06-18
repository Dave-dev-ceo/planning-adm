import 'dart:convert';
import 'package:http/http.dart' show Client;
import 'package:weddingplanner/src/models/item_model_preferences.dart';
import 'package:weddingplanner/src/resources/config_conection.dart';

abstract class LoginLogic {
  Future<int> login(String correo, String password);
  Future<String> logout();
}

class LoginException implements Exception {}

class BackendLoginLogic implements LoginLogic {
  ConfigConection confiC = new ConfigConection();
  SharedPreferencesT _sharedPreferences = new SharedPreferencesT();
  Client client = Client();
  @override
  Future<int> login(String correo, String password) async {
    final response = await client.post(
        Uri.parse(confiC.url+confiC.puerto+"/wedding/ACCESO/loginPlanner"),
        //Uri.http('localhost:3005', 'wedding/ACCESO/loginPlanner'),
        body: {"correo": correo, "contrasena": password});
    if (response.statusCode == 200) {
      Map<dynamic, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setIdPlanner(data['usuario']['id_planner']);
      await _sharedPreferences.setIdUsuario(data['usuario']['id_usuario']);
      await _sharedPreferences.setLogic(data['usuario']['admin']);
      await _sharedPreferences.setToken(data['token']);
      await _sharedPreferences.setSesion(true);
      List<String> dataJsonWPlanner = [data['usuario']['id_planner'].toString(),data['usuario']['id_usuario'].toString(),data['usuario']['admin'].toString(),data['token']];
      await _sharedPreferences.setJsonData(dataJsonWPlanner);
      return 0;
    } else if (response.statusCode == 403) {
      throw LoginException();
    } else {
      throw LoginException();
    }
  }

  @override
  Future<String> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }
}

class SimpleLoginLogic extends LoginLogic {
  @override
  Future<int> login(String correo, String password) async {
    await Future.delayed(Duration(seconds: 2));

    if (correo != "demo@demo.com" || password != "1234") {
      throw LoginException();
    }
    return 0;
  }

  @override
  Future<String> logout() async {
    return "";
  }
}

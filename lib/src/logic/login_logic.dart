import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' show Client;
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/resources/config_conection.dart';

abstract class LoginLogic {
  Future<Map<dynamic, dynamic>> login(String correo, String password);
  Future<String> logout();
  Future<String> getPassword();
  Future<String> changePassword(String newPassword);
}

class LoginException implements Exception {}

class BackendLoginLogic implements LoginLogic {
  ConfigConection confiC = new ConfigConection();
  SharedPreferencesT _sharedPreferences = new SharedPreferencesT();
  Client client = Client();
  @override
  Future<Map<dynamic, dynamic>> login(String correo, String password) async {
    final response = await client.post(
        Uri.parse(confiC.url + confiC.puerto + "/wedding/ACCESO/loginPlanner"),
        //Uri.http('localhost:3005', 'wedding/ACCESO/loginPlanner'),
        body: {"correo": correo, "contrasena": password});
    if (response.statusCode == 200) {
      Map<dynamic, dynamic> data = json.decode(response.body);
      if (data['usuario']['id_involucrado'] == 'null') {
        await _sharedPreferences.setIdPlanner(data['usuario']['id_planner']);
        await _sharedPreferences.setIdUsuario(data['usuario']['id_usuario']);
        await _sharedPreferences.setLogic(data['usuario']['admin']);
        await _sharedPreferences.setToken(data['token']);
        await _sharedPreferences.setNombre(data['usuario']['nombre_completo']);
        await _sharedPreferences.setImagen(
            data['usuario']['imagen'] == null ? '' : data['usuario']['imagen']);
        await _sharedPreferences.setSesion(true);
        await _sharedPreferences.setPermisoBoton(true);
        List<String> dataJsonWPlanner = [
          data['usuario']['id_planner'].toString(),
          data['usuario']['id_usuario'].toString(),
          data['usuario']['admin'].toString(),
          data['token']
        ];
        await _sharedPreferences.setJsonData(dataJsonWPlanner);
        await _sharedPreferences.setPermisos(json.encode(data['permisos']));
      } else {
        await _sharedPreferences.setIdPlanner(data['usuario']['id_planner']);
        await _sharedPreferences.setIdUsuario(data['usuario']['id_usuario']);
        await _sharedPreferences.setLogic(data['usuario']['admin']);
        await _sharedPreferences.setToken(data['token']);
        await _sharedPreferences.setNombre(data['usuario']['nombre_completo']);
        await _sharedPreferences.setSesion(true);
        await _sharedPreferences.setIdEvento(data['usuario']['id_evento']);
        await _sharedPreferences
            .setIdInvolucrado(data['usuario']['id_involucrado']);
        await _sharedPreferences
            .setEventoNombre(data['usuario']['descripcion']);
        await _sharedPreferences.setImagen(
            data['usuario']['imagen'] == null ? '' : data['usuario']['imagen']);
        await _sharedPreferences.setPermisoBoton(true);
        List<String> dataJsonWPlanner = [
          data['usuario']['id_planner'].toString(),
          data['usuario']['id_usuario'].toString(),
          data['usuario']['admin'].toString(),
          data['token']
        ];
        await _sharedPreferences.setJsonData(dataJsonWPlanner);
        await _sharedPreferences.setPermisos(json.encode(data['permisos']));
      }

      return data;
    } else if (response.statusCode == 403) {
      throw LoginException();
    } else {
      throw LoginException();
    }
  }

  @override
  Future<String> logout() {
    throw UnimplementedError();
  }

  @override
  Future<String> getPassword() async {
    String token = await _sharedPreferences.getToken();
    int idUsuario = await _sharedPreferences.getIdUsuario();

    const endpoint = '/wedding/ACCESO/getPassWord';

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token
    };

    final data = {
      'idUsuario': idUsuario,
    };

    final resp = await client.post(
      Uri.parse(confiC.url + confiC.puerto + endpoint),
      body: json.encode(data),
      headers: headers,
    );

    if (resp.statusCode == 200) {
      return json.decode(resp.body)['contrasena'];
    } else {
      return null;
    }
  }

  @override
  Future<String> changePassword(String newPassword) async {
    String token = await _sharedPreferences.getToken();
    int idUsuario = await _sharedPreferences.getIdUsuario();

    const endpoint = '/wedding/ACCESO/changePassword';

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token
    };

    final data = {
      'idUsuario': idUsuario,
      'contrasena': newPassword,
    };

    final resp = await client.post(
      Uri.parse(confiC.url + confiC.puerto + endpoint),
      body: json.encode(data),
      headers: headers,
    );

    if (resp.statusCode == 200) {
      return 'Ok';
    } else {
      return resp.body;
    }
  }
}

// class SimpleLoginLogic extends LoginLogic {
//   @override
//   Future<String> login(String correo, String password) async {
//     await Future.delayed(Duration(seconds: 2));

//     if (correo != "demo@demo.com" || password != "1234") {
//       throw LoginException();
//     }
//     return '';
//   }

//   @override
//   Future<String> logout() async {
//     return "";
//   }
// }
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
  Future<String> changePasswordInvolucrado(String newPassword);
  Future<String> recoverPassword(String correo);
  Future<bool> validarTokenPassword(String token);
  Future<int> changePasswordAnRecover(String newPassword, String token);
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
        await _sharedPreferences.setPortada(data['usuario']['portada'] == null
            ? ''
            : data['usuario']['portada']);
        await _sharedPreferences
            .setFechaEvento(data['usuario']['fecha_evento']);
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
    int idInvolucrado = await _sharedPreferences.getIdInvolucrado();

    const endpoint = '/wedding/ACCESO/getPassWord';

    Map<String, dynamic> data;
    if (idInvolucrado != null) {
      data = {
        'idInvolucrado': idInvolucrado,
      };
    } else {
      data = {
        'idUsuario': idUsuario,
      };
    }

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token
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
    int idPlanner = await _sharedPreferences.getIdPlanner();

    Map<String, dynamic> data;
    if (idPlanner != null) {
      data = {
        'idInvolucrado': idPlanner,
        'contrasena': newPassword,
      };
    } else {
      data = {
        'idUsuario': idUsuario,
        'contrasena': newPassword,
      };
    }

    const endpoint = '/wedding/ACCESO/changePassword';

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token
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

  @override
  Future<String> changePasswordInvolucrado(String newPassword) async {
    String token = await _sharedPreferences.getToken();
    int idUsuario = await _sharedPreferences.getIdUsuario();
    int idInvolucrado = await _sharedPreferences.getIdInvolucrado();

    Map<String, dynamic> data;
    if (idInvolucrado != null) {
      data = {
        'idInvolucrado': idInvolucrado,
        'contrasena': newPassword,
      };
    } else {
      data = {
        'idUsuario': idUsuario,
        'contrasena': newPassword,
      };
    }

    const endpoint = '/wedding/ACCESO/changePasswordInvolucrado';

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token
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

  @override
  Future<String> recoverPassword(String correo) async {
    const endpoint = '/wedding/ACCESO/recoverPassword';
    final data = {'correo': correo};

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final resp = await client.post(
      Uri.parse(confiC.url + confiC.puerto + endpoint),
      body: json.encode(data),
      headers: headers,
    );

    if (resp.statusCode == 200) {
      return 'Ok';
    } else if (resp.statusCode == 203) {
      return 'NotFound';
    } else {
      return 'Ocurrio un error';
    }
  }

  @override
  Future<bool> validarTokenPassword(String token) async {
    const endpoint = '/wedding/ACCESO/validarTokenRecoverPassword';
    final data = {'token': token};

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final resp = await client.post(
      Uri.parse(confiC.url + confiC.puerto + endpoint),
      body: json.encode(data),
      headers: headers,
    );

    print(resp);

    if (resp.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<int> changePasswordAnRecover(String newPassword, String token) async {
    const endpoint = '/wedding/ACCESO/changeAndRecoverPassword';
    final data = {
      'token': token,
      'password': newPassword,
    };

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final resp = await client.post(
      Uri.parse(confiC.url + confiC.puerto + endpoint),
      body: json.encode(data),
      headers: headers,
    );

    return resp.statusCode;
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

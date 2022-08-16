import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' show Client;
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/resources/config_conection.dart';

abstract class EliminarCuentaLogic {
  Future<dynamic> eliminarCuenta(String password);
}

class EliminarCuentaException implements Exception {}

class BackendEliminarCuentaLogic implements EliminarCuentaLogic {
  ConfigConection confiC = ConfigConection();
  final SharedPreferencesT _sharedPreferences = SharedPreferencesT();
  Client client = Client();

  @override
  Future<dynamic> eliminarCuenta(String password) async {
    String token = await _sharedPreferences.getToken();
    int idUsuario = await _sharedPreferences.getIdUsuario();
    int idPlanner = await _sharedPreferences.getIdPlanner();

    Map<String, dynamic> data = {
      'idPlanner': idPlanner,
      'contrasena': password,
      'idUsuario': idUsuario,
    };

    const endpoint = '/wedding/ELIMINARCUENTA/eliminarCuenta';

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token,
    };

    final resp = await client.post(
      Uri.parse(confiC.url + confiC.puerto + endpoint),
      body: json.encode(data),
      headers: headers,
    );

    if (resp.statusCode == 200) {
      return resp.body;
    } else {
      return 'Error';
    }
  }
}

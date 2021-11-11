import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' show Client;
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/models/model_perfilado.dart';
import 'package:planning/src/resources/config_conection.dart';

abstract class PermisosLogic {
  Future<ItemModelPerfil> obtenerPermisosUsuario();
}

class PermisosException implements Exception {}

class TokenPermisosException implements Exception {}

class PerfiladoLogic implements PermisosLogic {
  SharedPreferencesT _sharedPreferences = new SharedPreferencesT();
  ConfigConection confiC = new ConfigConection();
  Client client = Client();

  PerfiladoLogic();

  @override
  Future<ItemModelPerfil> obtenerPermisosUsuario() async {
    String idUsuario = (await _sharedPreferences.getIdUsuario()).toString();
    String token = await _sharedPreferences.getToken();

    final response = await client.post(
        Uri.parse(confiC.url +
            confiC.puerto +
            '/wedding/USUARIOS/obtenerPermisosUsuario'),
        body: {'id_usuario': idUsuario.toString()},
        headers: {HttpHeaders.authorizationHeader: token});

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      ItemModelSecciones secciones =
          ItemModelSecciones.fromJson(data['secciones']);
      ItemModelPantallas pantallas =
          ItemModelPantallas.fromJson(data['pantallas']);
      return new ItemModelPerfil(secciones, pantallas);
    } else if (response.statusCode == 401) {
      throw TokenPermisosException();
    } else {
      throw PermisosException();
    }
  }
}

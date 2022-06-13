import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/models/model_perfilado.dart';
import 'package:planning/src/resources/config_conection.dart';

abstract class PermisosLogic {
  Future<ItemModelPerfil> obtenerPermisosUsuario();
}

class PermisosException implements Exception {}

class TokenPermisosException implements Exception {}

class PaypalSubscriptionException implements Exception {}

class PerfiladoLogic implements PermisosLogic {
  final SharedPreferencesT _sharedPreferences = SharedPreferencesT();
  ConfigConection confiC = ConfigConection();

  PerfiladoLogic();

  @override
  Future<ItemModelPerfil> obtenerPermisosUsuario() async {
    String idUsuario = (await _sharedPreferences.getIdUsuario()).toString();
    String token = await _sharedPreferences.getToken();

    final response = await http.post(
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
      return ItemModelPerfil(secciones, pantallas);
    } else if (response.statusCode == 400) {
      throw PaypalSubscriptionException();
    } else if (response.statusCode == 401) {
      throw TokenPermisosException();
    } else {
      throw PermisosException();
    }
  }
}

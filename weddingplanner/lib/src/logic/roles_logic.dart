import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' show Client;
import 'package:weddingplanner/src/models/item_model_preferences.dart';
import 'package:weddingplanner/src/models/model_perfilado.dart';
import 'package:weddingplanner/src/models/model_roles.dart';
import 'package:weddingplanner/src/resources/config_conection.dart';

abstract class RolesLogic {
  Future<ItemModelRoles> obtenerRolesPorPlanner();
}

class RolesException implements Exception {}

class TokenRolesException implements Exception {}

class RolesPlannerLogic implements RolesLogic {
  SharedPreferencesT _sharedPreferences = new SharedPreferencesT();
  ConfigConection confiC = new ConfigConection();
  Client client = Client();

  RolesPlannerLogic();

  @override
  Future<ItemModelRoles> obtenerRolesPorPlanner() async {
    String idPlanner = (await _sharedPreferences.getIdPlanner()).toString();
    String token = await _sharedPreferences.getToken();

    final response = await client.post(
        Uri.parse(confiC.url +
            confiC.puerto +
            '/wedding/ROLES/obtenerRolesPorPlanner'),
        body: {'id_planner': idPlanner.toString()},
        headers: {HttpHeaders.authorizationHeader: token});

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return new ItemModelRoles.fromJson(data['roles']);
    } else if (response.statusCode == 401) {
      throw TokenRolesException();
    } else {
      throw RolesException();
    }
  }
}

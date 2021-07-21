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

// ROLES

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

// ROL

class CrearRolException implements Exception {}

class EliminarRolException implements Exception {}

class EditarRolException implements Exception {}

class MostrarRolException implements Exception {}

class TokenRolException implements Exception {}

abstract class RolLogic {
  Future<ItemModelRol> crearRol(Map<String, dynamic> dataRol);
  Future<ItemModelRol> editarRol(Map<String, dynamic> dataRol);
  Future<bool> eliminarRol(String idRol);
}

class RolCrud extends RolLogic {
  SharedPreferencesT _sharedPreferences = new SharedPreferencesT();

  ConfigConection confiC = new ConfigConection();

  Client client = Client();
  @override
  Future<ItemModelRol> crearRol(Map<String, dynamic> dataRol) async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idUsuario = await _sharedPreferences.getIdUsuario();
    String token = await _sharedPreferences.getToken();

    final response = await client.post(
        Uri.parse(confiC.url +
            confiC.puerto +
            '/wedding/USUARIOS/crearRolParaPlanner'),
        body: {
          'id_planner': idPlanner.toString(),
          'id_usuario': idUsuario.toString(),
          'rol': jsonEncode(dataRol)
        },
        headers: {
          HttpHeaders.authorizationHeader: token
        });

    if (response.statusCode == 201) {
      // If the call to the server was successful, parse the JSON
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return ItemModelRol.fromJson(data['data']);
    } else if (response.statusCode == 401) {
      return null;
    } else {
      throw CrearRolException();
    }
  }

  @override
  Future<ItemModelRol> editarRol(Map<String, dynamic> dataRol) async {
    int idUsuario = await _sharedPreferences.getIdUsuario();
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();

    final response = await client.post(
        Uri.parse(confiC.url +
            confiC.puerto +
            '/wedding/USUARIOS/editarRolParaPlanner'),
        body: {
          'id_planner': idPlanner.toString(),
          'id_usuario': idUsuario.toString(),
          'rol': jsonEncode(dataRol)
        },
        headers: {
          HttpHeaders.authorizationHeader: token
        });

    if (response.statusCode == 201) {
      // If the call to the server was successful, parse the JSON
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return ItemModelRol.fromJson(data['data']);
    } else if (response.statusCode == 401) {
      return null;
    } else {
      throw CrearRolException();
    }
  }

  @override
  Future<bool> eliminarRol(String idRol) async {
    String token = await _sharedPreferences.getToken();

    final response = await client.post(
        Uri.parse(
            confiC.url + confiC.puerto + '/wedding/USUARIOS/eliminarUsuario'),
        body: {'id_rol': idRol.toString()},
        headers: {HttpHeaders.authorizationHeader: token});

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return !data['codigo'];
    } else if (response.statusCode == 401) {
      return null;
    } else {
      throw EliminarRolException();
    }
  }
}

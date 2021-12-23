import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' show Client;
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/models/model_form.dart';
import 'package:planning/src/models/model_roles.dart';
import 'package:planning/src/resources/config_conection.dart';

abstract class RolesLogic {
  Future<ItemModelRoles> obtenerRolesPorPlanner();
  Future<ItemModelRoles> obtenerRolesSelect();
}

// ROLES

class RolesException implements Exception {}

class RolesPlannerException implements Exception {}

class TokenRolesException implements Exception {}

class RolesPlannerLogic implements RolesLogic {
  SharedPreferencesT _sharedPreferences = new SharedPreferencesT();
  ConfigConection confiC = new ConfigConection();
  Client client = Client();

  RolesPlannerLogic();

  @override
  Future<ItemModelRoles> obtenerRolesPorPlanner() async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
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
      throw RolesPlannerException();
    }
  }

  @override
  Future<ItemModelRoles> obtenerRolesSelect() async {
    String idPlanner = (await _sharedPreferences.getIdPlanner()).toString();
    String token = await _sharedPreferences.getToken();

    final response = await client.post(
        Uri.parse(
            confiC.url + confiC.puerto + '/wedding/ROLES/obtenerRolesSelect'),
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
        Uri.parse(
            confiC.url + confiC.puerto + '/wedding/ROLES/crearRolPlanner'),
        body: {
          'id_planner': idPlanner.toString(),
          'id_usuario': idUsuario.toString(),
          'rol': dataRol.toString()
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
      throw TokenRolException();
    } else {
      throw CrearRolException();
    }
  }

  @override
  Future<ItemModelRol> editarRol(Map<String, dynamic> dataRol) async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idUsuario = await _sharedPreferences.getIdUsuario();
    String token = await _sharedPreferences.getToken();

    final response = await client.post(
        Uri.parse(
            confiC.url + confiC.puerto + '/wedding/ROLES/editarRolPlanner'),
        body: {
          'id_planner': idPlanner.toString(),
          'id_usuario': idUsuario.toString(),
          'rol': dataRol.toString()
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
      throw TokenRolException();
    } else {
      throw EditarRolException();
    }
  }

  @override
  Future<bool> eliminarRol(String idRol) async {
    String token = await _sharedPreferences.getToken();

    final response = await client.post(
        Uri.parse(confiC.url + confiC.puerto + '/wedding/ROLES/eliminarRol'),
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

class ObtenerFormRolException implements Exception {}

class TokenFormRolException implements Exception {}

abstract class RolFormLogic {
  Future<ItemModelFormRol> obtenerRolesForm({String idRol = '-1'});
}

class FormRolLogic implements RolFormLogic {
  SharedPreferencesT _sharedPreferences = new SharedPreferencesT();
  ConfigConection confiC = new ConfigConection();
  Client client = Client();

  FormRolLogic();

  @override
  Future<ItemModelFormRol> obtenerRolesForm({String idRol = '-1'}) async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();

    final response = await client.post(
        Uri.parse(
            confiC.url + confiC.puerto + '/wedding/ROLES/obtenerRolesForm'),
        body: {'id_planner': idPlanner.toString(), 'id_rol': idRol.toString()},
        headers: {HttpHeaders.authorizationHeader: token});

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return new ItemModelFormRol.fromJson(data['result']);
    } else if (response.statusCode == 401) {
      throw TokenFormRolException();
    } else {
      throw RolesPlannerException();
    }
  }
}

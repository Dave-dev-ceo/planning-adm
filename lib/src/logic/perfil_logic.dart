// imports from flutter/dart
import 'package:http/http.dart' show Client;
import 'package:planning/src/models/perfil/perfil_planner_model.dart';
import 'dart:io';
import 'dart:convert';

// imports from wedding
import 'package:planning/src/resources/config_conection.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/models/item_model_perfil.dart';

// clase abstracta con los metodos
abstract class PerfilLogic {
  Future<ItemModelPerfil> selectPerfil();
  Future<bool> insertPerfil(Object perfil);
  Future<PerfilPlannerModel> getPerfilPlanner();
  Future<String> editPerfilPlanner(PerfilPlannerModel perfilPlanner);
}

// class exiende - van las consultas
class ConsultasPerfilLogic extends PerfilLogic {
  // variables de configuracion
  final SharedPreferencesT _sharedPreferences = SharedPreferencesT();
  ConfigConection confiC = ConfigConection();
  Client client = Client();

  @override
  Future<ItemModelPerfil> selectPerfil() async {
    // variables
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idUsuario = await _sharedPreferences.getIdUsuario();
    int idInvolucrado = await _sharedPreferences.getIdInvolucrado();
    String token = await _sharedPreferences.getToken();

    // map
    Map data = {
      'id_usuario': idUsuario.toString(),
      'id_involucrado': idInvolucrado.toString()
    };

    // pedido al servidor
    final response = await client.post(
        Uri.parse('${confiC.url}${confiC.puerto}/wedding/PERFIL/selectPerfil'),
        body: {'id_planner': idPlanner.toString(), 'perfil': jsonEncode(data)},
        // body: data,
        headers: {HttpHeaders.authorizationHeader: token});

    // filtro
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      await _sharedPreferences.setImagen(data['data'][0]['imagen'] ?? '');
      return ItemModelPerfil.fromJson(data['data']);
    } else if (response.statusCode == 401) {
      throw TokenException();
    } else {
      throw AutorizacionException();
    }
  }

  @override
  Future<bool> insertPerfil(Object perfil) async {
    // variables
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idUsuario = await _sharedPreferences.getIdUsuario();
    int idInvolucrado = await _sharedPreferences.getIdInvolucrado();
    String token = await _sharedPreferences.getToken();

    // map
    Map data = {
      'id_usuario': idUsuario.toString(),
      'id_involucrado': idInvolucrado.toString(),
      'data': perfil
    };

    // pedido al servidor
    final response = await client.post(
        Uri.parse('${confiC.url}${confiC.puerto}/wedding/PERFIL/insertPerfil'),
        body: {'id_planner': idPlanner.toString(), 'perfil': jsonEncode(data)},
        // body: data,
        headers: {HttpHeaders.authorizationHeader: token});

    // filtro
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return true;
    } else if (response.statusCode == 401) {
      throw TokenException();
    } else {
      throw AutorizacionException();
    }
  }

  @override
  Future<PerfilPlannerModel> getPerfilPlanner() async {
    String token = await _sharedPreferences.getToken();
    int idPlanner = await _sharedPreferences.getIdPlanner();

    const endpoint = '/wedding/PLANNER/obtenerPerfilPlanner';

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token
    };

    final data = {
      'idPlanner': idPlanner,
    };

    final resp = await client.post(
      Uri.parse(confiC.url + confiC.puerto + endpoint),
      body: json.encode(data),
      headers: headers,
    );

    if (resp.statusCode == 200) {
      return PerfilPlannerModel.fromJson(json.decode(resp.body));
    } else {
      return null;
    }
  }

  @override
  Future<String> editPerfilPlanner(PerfilPlannerModel perfilPlanner) async {
    String token = await _sharedPreferences.getToken();
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idUsuario = await _sharedPreferences.getIdUsuario();

    const endpoint = '/wedding/PLANNER/editarPerfilPlanner';

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token
    };

    final data = {
      'idPlanner': idPlanner,
      'nombreCompleto': perfilPlanner.nombreCompleto,
      'correo': perfilPlanner.correo,
      'telefono': perfilPlanner.telefono,
      'nombreEmpresa': perfilPlanner.nombreDeLaEmpresa,
      'logo': perfilPlanner.logo,
      'direccion': perfilPlanner.direccion,
      'idUsuario': idUsuario,
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

// clases para manejar errores
class AutorizacionException implements Exception {}

class TokenException implements Exception {}

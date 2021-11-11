// imports from flutter/dart
import 'package:http/http.dart' show Client;
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
}

// class exiende - van las consultas
class ConsultasPerfilLogic extends PerfilLogic {
  // variables de configuracion
  SharedPreferencesT _sharedPreferences = new SharedPreferencesT();
  ConfigConection confiC = new ConfigConection();
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
        Uri.parse(confiC.url + confiC.puerto + '/wedding/PERFIL/selectPerfil'),
        body: {'id_planner': idPlanner.toString(), 'perfil': jsonEncode(data)},
        // body: data,
        headers: {HttpHeaders.authorizationHeader: token});

    // filtro
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      await _sharedPreferences.setImagen(
          data['data'][0]['imagen'] == null ? '' : data['data'][0]['imagen']);
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
        Uri.parse(confiC.url + confiC.puerto + '/wedding/PERFIL/insertPerfil'),
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
}

// clases para manejar errores
class AutorizacionException implements Exception {}

class TokenException implements Exception {}

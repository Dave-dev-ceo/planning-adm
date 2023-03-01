// imports flutter/dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' show Client;
import 'package:planning/src/resources/config_conection.dart';

import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/models/item_model_involucrados.dart';

abstract class Involucrados {
  Future<ItemModelInvolucrados> selectInvolucrado();
  Future<bool> insertInvolucrados(objectinvolucrado);
}

class ConsultasInvolucradosLogic extends Involucrados {
  // variables configuracion
  final SharedPreferencesT _sharedPreferences = SharedPreferencesT();
  ConfigConection confiC = ConfigConection();
  Client client = Client();

  @override
  Future<ItemModelInvolucrados> selectInvolucrado() async {
    // variables
    int? idPlanner = await _sharedPreferences.getIdPlanner();
    int? idEvento = await _sharedPreferences.getIdEvento();
    String? token = await _sharedPreferences.getToken();

    // pedido al servidor
    final response = await client.post(
        Uri.parse(
            '${confiC.url}${confiC.puerto}/wedding/INVOLUCRADOS/obtenerInvolucrados'),
        body: {
          'id_planner': idPlanner.toString(),
          'id_evento': idEvento.toString()
        },
        headers: {
          HttpHeaders.authorizationHeader: token ?? ''
        });

    // filtro
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return ItemModelInvolucrados.fromJson(data['data']);
    } else if (response.statusCode == 401) {
      throw TokenException();
    } else {
      throw AutorizacionException();
    }
  }

  @override
  Future<bool> insertInvolucrados(objectinvolucrado) async {
    // variables
    int? idPlanner = await _sharedPreferences.getIdPlanner();
    int? idEvento = await _sharedPreferences.getIdEvento();
    String? token = await _sharedPreferences.getToken();

    // pedido al servidor
    final response = await client.post(
        Uri.parse(
            '${confiC.url}${confiC.puerto}/wedding/INVOLUCRADOS/insertInvolucrados'),
        body: {
          'id_evento': idEvento.toString(),
          'id_planner': idPlanner.toString(),
          'involucrado': jsonEncode(objectinvolucrado)
        },
        headers: {
          HttpHeaders.authorizationHeader: token ?? ''
        });

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

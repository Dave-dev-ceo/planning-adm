import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:planning/src/models/item_model_listas.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/resources/config_conection.dart';

abstract class ListasLogic {
  Future<ItemModelListas> fetchListas();
  Future<int> deleteLista(Map<String, dynamic> data);
  Future<int> deleteActividadesRecibir(int idActividad);
  Future<String?> downloadPDFListas();
  // Future<ItemModelArticulosRecibir> fetchArticulosRecibirIdPlanner();
}

class ListasException implements Exception {}

class TokenException implements Exception {}

class CreateListasException implements Exception {}

class DeleteArticulosRecibirException implements Exception {}

class FetchListaLogic extends ListasLogic {
  final SharedPreferencesT _sharedPreferences = SharedPreferencesT();
  ConfigConection configC = ConfigConection();
  Client client = Client();

  @override
  // ignore: missing_return
  Future<ItemModelListas> fetchListas() async {
    try {
      int idPlanner = await _sharedPreferences.getIdPlanner();
      int idEvento = await _sharedPreferences.getIdEvento();
      String token = await _sharedPreferences.getToken();
      final response = await client.get(
          Uri.parse(
              '${configC.url}${configC.puerto}/wedding/LISTAS/obtenerListaPorPlanner/$idPlanner/$idEvento'),
          headers: {HttpHeaders.authorizationHeader: token});

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        await _sharedPreferences.setToken(data['token']);
        return ItemModelListas.fromJson(data["data"]);
      } else if (response.statusCode == 401) {
        throw TokenException();
      } else {
        throw ListasException();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw ListasException();
    }
  }

  @override
  Future<int> deleteLista(Map<String, dynamic> data) async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idEvento = await _sharedPreferences.getIdEvento();
    data['id_planner'] = idPlanner.toString();
    data['id_evento'] = idEvento.toString();
    String token = await _sharedPreferences.getToken();
    final response = await client.post(
        Uri.parse('${configC.url}${configC.puerto}/wedding/LISTAS/deleteLista'),
        body: {
          'id_lista': data['id_lista'].toString(),
          'id_planner': data['id_planner'].toString(),
          'id_evento': data['id_evento'].toString()
        },
        headers: {
          HttpHeaders.authorizationHeader: token
        });
    if (response.statusCode == 200) {
      Map<String, dynamic> res = json.decode(response.body);
      await _sharedPreferences.setToken(res['token']);
      return 0;
    } else if (response.statusCode == 401) {
      throw TokenException();
    } else {
      throw CreateListasException();
    }
  }

  Future<bool> updateArticulosRecibir(Map<String, dynamic> data) async {
    if (data['descripcion'] != null && data['descripcion'] != '') {
      return true;
    } else {
      throw CreateListasException();
    }
  }

  @override
  Future<int> deleteActividadesRecibir(int idActividad) async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();
    // ignore: unused_local_variable
    int idUsuario = await _sharedPreferences.getIdUsuario();

    final response = await client.post(
        Uri.parse('${configC.url}${configC.puerto}'),
        body: {"id": idPlanner.toString()},
        headers: {HttpHeaders.authorizationHeader: token});

    if (response.statusCode == 201) {
      Map<String, dynamic> responseEvento = json.decode(response.body);
      await _sharedPreferences.setToken(responseEvento['token']);
      return 0;
    } else if (response.statusCode == 401) {
      throw TokenException();
    } else {
      throw CreateListasException();
    }
  }

  @override
  Future<String?> downloadPDFListas() async {
    String token = await _sharedPreferences.getToken();
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idEvento = await _sharedPreferences.getIdEvento();

    const endpoint = '/wedding/LISTAS/downloadPDFListas';

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token
    };

    final data = {
      'idPlanner': idPlanner,
      'idEvento': idEvento,
    };

    final resp = await client.post(
      Uri.parse(configC.url! + configC.puerto! + endpoint),
      body: json.encode(data),
      headers: headers,
    );

    if (resp.statusCode == 200) {
      return json.decode(resp.body)['pdf'];
    } else {
      return null;
    }
  }
}

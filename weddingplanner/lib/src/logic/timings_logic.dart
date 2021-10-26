import 'dart:convert';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:weddingplanner/src/models/item_model_preferences.dart';
import 'package:http/http.dart' show Client;
import 'package:weddingplanner/src/models/item_model_timings.dart';
import 'package:weddingplanner/src/resources/config_conection.dart';

abstract class TimingsLogic {
  Future<ItemModelTimings> fetchTimingsPorPlanner();
  Future<int> createTiming(Map<String, dynamic> dataTiming);
  Future<void> deleteTiming(idTiming);
}

class ListaTimingsException implements Exception {}

class TokenException implements Exception {}

class CreateTimingException implements Exception {}

class FetchListaTimingsLogic extends TimingsLogic {
  SharedPreferencesT _sharedPreferences = new SharedPreferencesT();

  ConfigConection confiC = new ConfigConection();
  Client client = Client();

  @override
  Future<ItemModelTimings> fetchTimingsPorPlanner() async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();

    final response = await client.post(
        Uri.parse(confiC.url +
            confiC.puerto +
            '/wedding/TIMINGS/obtenerTimingsPorPlanner'),
        body: {'id_planner': idPlanner.toString()},
        headers: {HttpHeaders.authorizationHeader: token});

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return ItemModelTimings.fromJson(data['data']);
    } else if (response.statusCode == 401) {
      return null;
    } else {
      throw ListaTimingsException;
    }
  }

  @override
  Future<int> createTiming(Map<String, dynamic> dataTiming) async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();
    int idUsuario = await _sharedPreferences.getIdUsuario();
    dataTiming['id_planner'] = idPlanner.toString();
    dataTiming['id_usuario'] = idUsuario.toString();
    final response = await client.post(
        Uri.parse(
            confiC.url + confiC.puerto + '/wedding/TIMINGS/createTimings'),
        body: dataTiming,
        headers: {HttpHeaders.authorizationHeader: token});

    if (response.statusCode == 201) {
      Map<String, dynamic> responseEvento = json.decode(response.body);
      await _sharedPreferences.setToken(responseEvento['token']);
      return 0;
    } else if (response.statusCode == 401) {
      throw TokenException();
    } else {
      throw CreateTimingException();
    }
  }

  @override
  Future<void> deleteTiming(idTiming) async {
    String token = await _sharedPreferences.getToken();
    int idPlanner = await _sharedPreferences.getIdPlanner();

    final endpoint = 'wedding/';

    final data = {
      'idTiming': idTiming,
      'idPlanner': idPlanner,
    };

    final headers = {
      HttpHeaders.authorizationHeader: token,
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };

    final response = await client.post(
        Uri.parse(confiC.url + confiC.puerto + '/' + endpoint),
        body: json.encode(data),
        headers: headers);

    if (response == 4000) {
      throw TokenException();
    } else {
      throw CreateTimingException();
    }
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:planning/src/models/item_model_preferences.dart';
import 'package:http/http.dart' show Client;
import 'package:planning/src/models/item_model_timings.dart';
import 'package:planning/src/resources/config_conection.dart';

abstract class TimingsLogic {
  Future<ItemModelTimings?> fetchTimingsPorPlanner(String estatus);
  Future<int> createTiming(Map<String, dynamic> dataTiming);
  Future<String> updateTiming(int? idTiming, String? name, String? estatus);
  Future<String?> downloadPDFTiming();
  Future<bool> deleteTimingPlanner(int? idTipoTiming);
}

class ListaTimingsException implements Exception {}

class TokenException implements Exception {}

class CreateTimingException implements Exception {}

class FetchListaTimingsLogic extends TimingsLogic {
  final SharedPreferencesT _sharedPreferences = SharedPreferencesT();

  ConfigConection confiC = ConfigConection();
  Client client = Client();

  @override
  Future<ItemModelTimings?> fetchTimingsPorPlanner(String estatus) async {
    int? idPlanner = await _sharedPreferences.getIdPlanner();
    String? token = await _sharedPreferences.getToken();

    final response = await client.post(
        Uri.parse(
            '${confiC.url}${confiC.puerto}/wedding/TIMINGS/obtenerTimingsPorPlanner'),
        body: {'id_planner': idPlanner.toString(), 'estatus': estatus},
        headers: {HttpHeaders.authorizationHeader: token ?? ''});

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
    int? idPlanner = await _sharedPreferences.getIdPlanner();
    String? token = await _sharedPreferences.getToken();
    int? idUsuario = await _sharedPreferences.getIdUsuario();
    dataTiming['id_planner'] = idPlanner.toString();
    dataTiming['id_usuario'] = idUsuario.toString();
    final response = await client.post(
        Uri.parse(
            '${confiC.url}${confiC.puerto}/wedding/TIMINGS/createTimings'),
        body: dataTiming,
        headers: {HttpHeaders.authorizationHeader: token ?? ''});

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
  Future<String> updateTiming(
      int? idTiming, String? name, String? estatus) async {
    String? token = await _sharedPreferences.getToken();
    int? idPlanner = await _sharedPreferences.getIdPlanner();

    const endpoint = '/wedding/TIMINGS/updateTimings';

    final data = {
      'idTiming': idTiming,
      'nombre': name,
      'estatus': estatus,
      'idPlanner': idPlanner,
    };

    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token ?? '',
    };

    final response = await client.post(
      Uri.parse(confiC.url! + confiC.puerto! + endpoint),
      body: json.encode(data),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return 'Ok';
    } else {
      return response.body;
    }
  }

  @override
  Future<String?> downloadPDFTiming() async {
    String? token = await _sharedPreferences.getToken();
    int? idPlanner = await _sharedPreferences.getIdPlanner();

    const endpoint = '/wedding/TIMINGS/downloadPDFTiming';

    final data = {
      'idPlanner': idPlanner,
    };

    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token ?? '',
    };
    final response = await client.post(
      Uri.parse(confiC.url! + confiC.puerto! + endpoint),
      body: json.encode(data),
      headers: headers,
    );
    if (response.statusCode == 200) {
      // await _sharedPreferences.setToken(json.decode(response.body)['token']);

      return json.decode(response.body)['pdf'];
    } else {
      return null;
    }
  }

  @override
  Future<bool> deleteTimingPlanner(int? idTipoTiming) async {
    String? token = await _sharedPreferences.getToken();
    int? idPlanner = await _sharedPreferences.getIdPlanner();

    const endpoint = '/wedding/TIMINGS/deleteTimingPlanner';

    final data = {
      'idPlanner': idPlanner,
      'idTipoTiming': idTipoTiming,
    };

    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token ?? '',
    };
    final response = await client.post(
      Uri.parse(confiC.url! + confiC.puerto! + endpoint),
      body: json.encode(data),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}

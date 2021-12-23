import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' show Client;

import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/resources/config_conection.dart';

import 'package:planning/src/models/item_model_asistencia.dart';

abstract class AsistenciaLogic {
  Future<ItemModelAsistencia> fetchAsistenciaPorPlanner();
  Future<int> saveAsistencia(int idInvitado, bool asistencia);
  Future<String> downloadPDFAsistencia();
}

class ListaAsistenciaException implements Exception {}

class TokenException implements Exception {}

class FetchListaAsistenciaLogic extends AsistenciaLogic {
  SharedPreferencesT _sharedPreferences = new SharedPreferencesT();
  ConfigConection confiC = new ConfigConection();
  Client client = Client();

  @override
  Future<ItemModelAsistencia> fetchAsistenciaPorPlanner() async {
    // implement fetchAsistenciaPorPlanner
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idEvento = await _sharedPreferences.getIdEvento();
    String token = await _sharedPreferences.getToken();

    final response = await client.post(
        Uri.parse(confiC.url +
            confiC.puerto +
            '/wedding/ASISTENCIA/obtenerAsistenciasPorPlanner'),
        body: {
          'id_planner': idPlanner.toString(),
          'id_evento': idEvento.toString()
        },
        headers: {
          HttpHeaders.authorizationHeader: token
        });

    print({response});

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return ItemModelAsistencia.fromJson(data['data']);
    } else if (response.statusCode == 401) {
      return null;
    } else {
      throw ListaAsistenciaException;
    }
  }

  Future<int> saveAsistencia(int idInvitado, bool asistencia) async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();

    await client.post(
        Uri.parse(confiC.url +
            confiC.puerto +
            '/wedding/ASISTENCIA/saveAsistenciasPorPlanner'),
        body: {
          'id_invitado': idInvitado.toString(),
          'asistencia': asistencia.toString(),
          'id_planner': idPlanner.toString()
        },
        headers: {
          HttpHeaders.authorizationHeader: token
        });
    return 0;
  }

  @override
  Future<String> downloadPDFAsistencia() async {
    String token = await _sharedPreferences.getToken();
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idEvento = await _sharedPreferences.getIdEvento();

    const endpoint = '/wedding/ASISTENCIA/downloadPDFAsistencia';

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
      Uri.parse(confiC.url + confiC.puerto + endpoint),
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

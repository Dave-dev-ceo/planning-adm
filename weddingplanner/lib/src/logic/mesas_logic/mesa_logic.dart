import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' show Client;

import 'package:weddingplanner/src/logic/estatus_logic.dart';
import 'package:weddingplanner/src/models/item_model_preferences.dart';
import 'package:weddingplanner/src/models/mesa/mesas_model.dart';
import 'package:weddingplanner/src/resources/config_conection.dart';

abstract class MesasLogic {
  Future<List<MesaModel>> getAsignadasMesas();
  Future<List<MesaModel>> getMesas();
  Future<String> createMesas(List<MesaModel> listaMesasToAdd);
}

class MesasAsignadasException implements Exception {}

class MesasException implements Exception {}

class ServiceMesasLogic extends MesasLogic {
  SharedPreferencesT _sharedPreferences = SharedPreferencesT();
  ConfigConection confiC = ConfigConection();
  Client client = Client();

  @override
  Future<List<MesaModel>> getAsignadasMesas() async {
    int idEvento = await _sharedPreferences.getIdEvento();
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idUsuario = await _sharedPreferences.getIdUsuario();
    String token = await _sharedPreferences.getToken();
    final endpoint = 'wedding/EVENTOS/getMesasAsignadas';
    final response = await client
        .post(Uri.parse(confiC.url + confiC.puerto + '/' + endpoint), body: {
      'idEvento': idEvento.toString(),
      'idPlanner': idPlanner.toString(),
      'idUsuario': idUsuario.toString()
    }, headers: {
      HttpHeaders.authorizationHeader: token
    });

    if (response.statusCode == 200) {
      await _sharedPreferences.setToken(json.decode(response.body)['token']);
      return List<MesaModel>.from(json
          .decode(response.body)['data']
          .map((data) => MesaModel.fromJson(data)));
    } else if (response.statusCode == 401) {
      await _sharedPreferences.clear();
      throw TokenException();
    } else {
      throw MesasAsignadasException();
    }
  }

  @override
  Future<String> createMesas(List<MesaModel> listasMesasToAdd) async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();

    final endpoint = 'wedding/MESAS/createMesas';

    final data = {
      'idPlanner': idPlanner,
      'mesas': listasMesasToAdd.map((e) => e.toJson()).toList(),
    };

    final response = await client.post(
        Uri.parse(confiC.url + confiC.puerto + '/' + endpoint),
        body: jsonEncode(data),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          HttpHeaders.authorizationHeader: token
        });

    if (response.statusCode == 200) {
      await _sharedPreferences.setToken(json.decode(response.body)['token']);
      return 'Ok';
    } else {
      return response.body;
    }
  }

  @override
  Future<List<MesaModel>> getMesas() async {
    int idEvento = await _sharedPreferences.getIdEvento();
    String token = await _sharedPreferences.getToken();

    final endpoint = 'wedding/MESAS/obtenerMesas';

    final data = {
      'idEvento': idEvento,
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

    if (response.statusCode == 200) {
      return List<MesaModel>.from(
          json.decode(response.body).map((data) => MesaModel.fromJson(data)));
    } else if (response.statusCode == 401) {
      await _sharedPreferences.clear();
      throw TokenException();
    } else {
      throw MesasException();
    }
  }
}

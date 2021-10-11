import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' show Client;

import 'package:weddingplanner/src/logic/estatus_logic.dart';
import 'package:weddingplanner/src/models/item_model_preferences.dart';
import 'package:weddingplanner/src/models/mesa/mesas_model.dart';
import 'package:weddingplanner/src/resources/config_conection.dart';

abstract class MesasAsignadasLogic {
  Future<List<MesasModel>> getMesasAsignadas();
}

class MesasAsignadasException implements Exception {}

class ServiceMesasAsignadasLogic extends MesasAsignadasLogic {
  SharedPreferencesT _sharedPreferences = SharedPreferencesT();
  ConfigConection confiC = ConfigConection();
  Client client = Client();

  @override
  Future<List<MesasModel>> getMesasAsignadas() async {
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
      return List<MesasModel>.from(json
          .decode(response.body)['data']
          .map((data) => MesasModel.fromJson(data)));
    } else if (response.statusCode == 401) {
      await _sharedPreferences.clear();
      throw TokenException();
    } else {
      throw MesasAsignadasException();
    }
  }
}

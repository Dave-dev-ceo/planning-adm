import 'dart:convert';
import 'dart:io';

import 'package:planning/src/models/Planes/planes_model.dart';
import 'package:planning/src/models/eventosModel/eventos_dashboard_model.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/resources/config_conection.dart';
import 'package:http/http.dart' show Client;

class DashboardLogic {
  SharedPreferencesT _sharedPreferences = SharedPreferencesT();
  ConfigConection confiC = ConfigConection();
  Client client = Client();

  Future<List<DashboardEventoModel>> getAllFechasEventos(
      DateTime startDate, DateTime endDate) async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();
    List<DashboardEventoModel> listaFechaEventos = [];

    final endpoint = '/wedding/DASHBOARD/getFechasEventos';

    final data = {
      'idPlanner': idPlanner,
      'fechaInicio': startDate.toString(),
      'fechaFin': endDate.toString(),
    };

    final headers = {
      HttpHeaders.authorizationHeader: token,
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    final response = await client.post(
      Uri.parse(confiC.url + confiC.puerto + endpoint),
      headers: headers,
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      listaFechaEventos = List<DashboardEventoModel>.from(json
          .decode(response.body)
          .map((f) => DashboardEventoModel.fromJson(f)));
      return listaFechaEventos;
    } else {
      throw DashboardException;
    }
  }

  Future<List<EventoActividadModel>> getAllActivitiesPlanner(
      DateTime startDate, DateTime endDate) async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();
    List<EventoActividadModel> listaActividades = [];

    final endpoint = '/wedding/DASHBOARD/getAllActividadesPlanner';

    final data = {
      'idPlanner': idPlanner,
      'fechaInicio': startDate.toString(),
      'fechaFin': endDate.toString(),
    };

    final headers = {
      HttpHeaders.authorizationHeader: token,
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    final response = await client.post(
      Uri.parse(confiC.url + confiC.puerto + endpoint),
      headers: headers,
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      ('Entre');
      listaActividades = List<EventoActividadModel>.from(json
          .decode(response.body)
          .map((f) => EventoActividadModel.fromJson(f)));

      listaActividades.forEach((element) {
        (element.toJson());
      });
      return listaActividades;
    } else {
      throw DashboardException;
    }
  }
}

class DashboardException implements Exception {}

import 'dart:convert';
import 'dart:io';

import 'package:planning/src/models/Planes/planes_model.dart';
import 'package:planning/src/models/eventosModel/eventos_dashboard_model.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/resources/config_conection.dart';
import 'package:http/http.dart' as http;

class DashboardLogic {
  final SharedPreferencesT _sharedPreferences = SharedPreferencesT();
  ConfigConection confiC = ConfigConection();

  Future<List<DashboardEventoModel>> getAllFechasEventos(
      DateTime startDate, DateTime endDate) async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();
    List<DashboardEventoModel> listaFechaEventos = [];

    const endpoint = '/wedding/DASHBOARD/getFechasEventos';

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

    final response = await http.post(
      Uri.parse(confiC.url! + confiC.puerto! + endpoint),
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

    const endpoint = '/wedding/DASHBOARD/getAllActividadesPlanner';

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

    final response = await http.post(
      Uri.parse(confiC.url! + confiC.puerto! + endpoint),
      headers: headers,
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      ('Entre');
      listaActividades = List<EventoActividadModel>.from(json
          .decode(response.body)
          .map((f) => EventoActividadModel.fromJson(f)));

      return listaActividades;
    } else {
      throw DashboardException;
    }
  }
}

class DashboardException implements Exception {}

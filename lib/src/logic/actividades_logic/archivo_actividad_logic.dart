import 'dart:convert';
import 'dart:io';

import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/resources/config_conection.dart';
import 'package:http/http.dart' as http;

class ArchivoActividadLogic {
  final SharedPreferencesT _preferencesT = SharedPreferencesT();
  final ConfigConection _configConection = ConfigConection();

  Future<Map<String, dynamic>?> obtenerArchivoActividad(
      int? idActividad, bool isPlanner) async {
    String? token = await _preferencesT.getToken();
    String endpoint;

    endpoint = '/wedding/PLANES/obtenerArchivoActividad';

    if (isPlanner) {
      endpoint = '/wedding/ACTIVIDADESTIMINGS/obtenerArchivActividadPlaner';
    }

    final data = {'idActividad': idActividad};

    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token ?? ''
    };

    final response = await http.post(
      Uri.parse(_configConection.url! + _configConection.puerto! + endpoint),
      body: json.encode(data),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  Future<String> uploadArchivoActividad(
      int idActividad, String archivo, String tipoMime) async {
    String? token = await _preferencesT.getToken();
    const endpoint = '/wedding/PLANES/uploadArchivoActividad';

    final data = {
      'idActividad': idActividad,
      'archivo': archivo,
      'tipoMime': tipoMime,
    };

    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token ?? ''
    };

    final response = await http.post(
      Uri.parse(_configConection.url! + _configConection.puerto! + endpoint),
      body: json.encode(data),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return 'Ok';
    } else {
      return response.body;
    }
  }
}

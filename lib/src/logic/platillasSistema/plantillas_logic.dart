import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:planning/src/models/PlantillaSistema/plantiila_sistema_model.dart';
import 'package:planning/src/models/item_model_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:planning/src/resources/config_conection.dart';

class PlantillasLogic {
  final _sharedPreferencesT = SharedPreferencesT();
  final _config = ConfigConection();

  Future<List<PlantillaSistemaModel>> obtenerPlantillas() async {
    String token = await _sharedPreferencesT.getToken();

    const endpoint = '/wedding/PLANNER/obtenerPlantillasSistema';

    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token
    };

    final response = await http.post(
      Uri.parse(_config.url + _config.puerto + endpoint),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return plantillaSistemaModelFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<PlantillaSistemaModel> obtenerPantillaById(int idPlantilla) async {
    String token = await _sharedPreferencesT.getToken();

    const endpoint = '/wedding/PLANNER/obtenerPlantillasSistemaById';

    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token
    };

    final body = {
      'idPlantilla': idPlantilla,
    };

    try {
      final response = await http.post(
        Uri.parse(_config.url + _config.puerto + endpoint),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        return plantillaSistemaModelFromData(response.body);
      } else {
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  Future<bool> editarPlantilla(PlantillaSistemaModel plantilla) async {
    String token = await _sharedPreferencesT.getToken();

    const endpoint = '/wedding/PLANNER/updatePlantillaSistema';

    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token
    };

    final body = {
      'idPlantilla': plantilla.idPlantilla,
      'plantilla': plantilla.plantilla
    };

    try {
      final response = await http.post(
        Uri.parse(_config.url + _config.puerto + endpoint),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<bool> insertPlantilla(PlantillaSistemaModel plantilla) async {
    String token = await _sharedPreferencesT.getToken();

    const endpoint = '/wedding/PLANNER/insertPlantilla';

    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token
    };

    final body = {
      'clave': plantilla.clavePlantilla,
      'descripcion': plantilla.descripcion,
    };

    try {
      final response = await http.post(
        Uri.parse(_config.url + _config.puerto + endpoint),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<bool> editDescripcionPlantilla(PlantillaSistemaModel plantilla) async {
    String token = await _sharedPreferencesT.getToken();

    const endpoint = '/wedding/PLANNER/editDescripcionPlantilla';

    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token
    };

    final body = {
      'idPlantilla': plantilla.idPlantilla,
      'descripcion': plantilla.descripcion,
    };

    try {
      final response = await http.post(
        Uri.parse(_config.url + _config.puerto + endpoint),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<bool> deletePlantillaSistema(int idPlantilla) async {
    String token = await _sharedPreferencesT.getToken();

    const endpoint = '/wedding/PLANNER/deletePlantillaSistema';

    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token
    };

    final body = {
      'idPlantilla': idPlantilla,
    };

    try {
      final response = await http.post(
        Uri.parse(_config.url + _config.puerto + endpoint),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }
}

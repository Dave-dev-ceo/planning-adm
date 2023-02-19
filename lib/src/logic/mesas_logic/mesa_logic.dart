import 'dart:convert';
import 'dart:io';

import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;

import 'package:planning/src/logic/estatus_logic.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/models/mesa/mesas_model.dart';
import 'package:planning/src/resources/config_conection.dart';

abstract class MesasLogic {
  Future<List<MesaModel>> getAsignadasMesas();
  Future<List<MesaModel>> getMesas();
  Future<String> createMesas(List<MesaModel> listaMesasToAdd);
  Future<bool> updateMesa(MesaModel editToMesa);
  Future<String> createLayout(String fileBase64, String extension);
  Future<String> deleteMesa(int idMesa);
}

class MesasAsignadasException implements Exception {}

class MesasException implements Exception {}

class ServiceMesasLogic extends MesasLogic {
  final SharedPreferencesT _sharedPreferences = SharedPreferencesT();
  ConfigConection confiC = ConfigConection();

  @override
  Future<List<MesaModel>> getAsignadasMesas() async {
    int idEvento = await _sharedPreferences.getIdEvento();
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idUsuario = await _sharedPreferences.getIdUsuario();
    String token = await _sharedPreferences.getToken();
    const endpoint = 'wedding/EVENTOS/getMesasAsignadas';
    final response = await http
        .post(Uri.parse('${confiC.url}${confiC.puerto}/$endpoint'), body: {
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
  Future<String> createMesas(List<MesaModel> listaMesasToAdd) async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();

    const endpoint = 'wedding/MESAS/createMesas';

    final data = {
      'idPlanner': idPlanner,
      'mesas': listaMesasToAdd.map((e) => e.toJson()).toList(),
    };

    final response = await http.post(
        Uri.parse('${confiC.url}${confiC.puerto}/$endpoint'),
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
    bool desconectado = await _sharedPreferences.getModoConexion();
    int idEvento = await _sharedPreferences.getIdEvento();
    if (desconectado) {
      if (!Hive.isBoxOpen('mesas')) {
        await Hive.openBox<dynamic>('mesas');
      }
      final boxMesas = Hive.box<dynamic>('mesas');
      final listaMesas =
          boxMesas.values.where((m) => m['id_evento'] == idEvento);
      return List<MesaModel>.from(listaMesas
          .map((data) => MesaModel.fromJson(Map<String, dynamic>.from(data))));
    } else {
      String token = await _sharedPreferences.getToken();

      const endpoint = 'wedding/MESAS/obtenerMesas';

      final data = {
        'idEvento': idEvento,
      };

      final headers = {
        HttpHeaders.authorizationHeader: token,
        'Content-type': 'application/json',
        'Accept': 'application/json'
      };

      final response = await http.post(
          Uri.parse('${confiC.url}${confiC.puerto}/$endpoint'),
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

  @override
  Future<bool> updateMesa(MesaModel editToMesa) async {
    String token = await SharedPreferencesT().getToken();

    const endpoint = 'wedding/MESAS/updateMesa';

    final data = {
      'descripcion': editToMesa.descripcion,
      'idMesa': editToMesa.idMesa,
      'idTipoMesa': editToMesa.idTipoDeMesa,
    };

    final headers = {
      HttpHeaders.authorizationHeader: token,
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };

    final response = await http.post(
        Uri.parse('${confiC.url}${confiC.puerto}/$endpoint'),
        body: json.encode(data),
        headers: headers);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<String> createLayout(String fileBase64, String? extension) async {
    String token = await _sharedPreferences.getToken();
    int idEvento = await _sharedPreferences.getIdEvento();

    final data = {
      'idEvento': idEvento,
      'file': fileBase64,
      'mime': extension,
    };

    const endpoint = 'wedding/MESAS/uploadLayout';

    final headers = {
      HttpHeaders.authorizationHeader: token,
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };

    final response = await http.post(
      Uri.parse('${confiC.url}${confiC.puerto}/$endpoint'),
      body: json.encode(data),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return 'Ok';
    } else {
      return 'Ocurrio un error';
    }
  }

  @override
  Future<String> deleteMesa(int? idMesa) async {
    String token = await _sharedPreferences.getToken();
    int idEvento = await _sharedPreferences.getIdEvento();

    final data = {
      'idEvento': idEvento,
      'idMesa': idMesa,
    };

    const endpoint = 'wedding/MESAS/deleteMesa';

    final headers = {
      HttpHeaders.authorizationHeader: token,
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };

    final response = await http.post(
      Uri.parse('${confiC.url}${confiC.puerto}/$endpoint'),
      body: json.encode(data),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return 'Ok';
    } else {
      return 'Ocurrio un error';
    }
  }
}

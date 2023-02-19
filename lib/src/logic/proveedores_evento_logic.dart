import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/models/item_model_proveedores_evento.dart';
import 'package:planning/src/resources/config_conection.dart';

abstract class LogicProveedoresEvento {
  Future<ItemModelProveedoresEvento> fetchProveedorEvento();
  Future<int> createProveedorEvento(Map<String, dynamic> data);
  updateProveedorEvento(Map data);
  Future<String?> downloadPDFProveedoresEvento();
}

class ProveedoresException implements Exception {}

class TokenException implements Exception {}

class FetchProveedoresEventoLogic extends LogicProveedoresEvento {
  final SharedPreferencesT _sharedPreferences = SharedPreferencesT();
  ConfigConection configC = ConfigConection();
  Client client = Client();

  @override
  // ignore: missing_return
  Future<ItemModelProveedoresEvento> fetchProveedorEvento() async {
    try {
      // var checkInvolucrado;

      int idPlanner = await _sharedPreferences.getIdPlanner();
      String token = await _sharedPreferences.getToken();
      var checkInvolucrado = await _sharedPreferences.getIdInvolucrado();
      if (checkInvolucrado == null) {
        checkInvolucrado = '1';
      } else {
        checkInvolucrado = '0';
      }
      final response = await client.get(
          Uri.parse(
              '${configC.url}${configC.puerto}/wedding/PROVEEDORES/obtenerProveedoresEvento/$idPlanner/$checkInvolucrado'),
          headers: {HttpHeaders.authorizationHeader: token});

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        await _sharedPreferences.setToken(data['token']);
        return ItemModelProveedoresEvento.fromJson(data['data']);
      } else if (response.statusCode == 401) {
        throw TokenException();
      } else {
        throw ProveedoresException();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw ProveedoresException();
    }
  }

  @override
  // ignore: missing_return
  Future<int> createProveedorEvento(Map<String, dynamic> data) async {
    if (data['id_servicio'] != 0 && data['id_proveedor'] != 0) {
      int idPlanner = await _sharedPreferences.getIdPlanner();
      int idEvento = await _sharedPreferences.getIdEvento();
      int idUsuario = await _sharedPreferences.getIdUsuario();
      data['observacion'] = '';
      data['id_servicio'] = data['id_servicio'].toString();
      data['id_proveedor'] = data['id_proveedor'].toString();
      data['id_evento'] = idEvento.toString();
      data['id_planner'] = idPlanner.toString();
      data['creado_por'] = idUsuario.toString();
      data['modificado_por'] = idUsuario.toString();
      String token = await _sharedPreferences.getToken();
      final response = await client.post(
          Uri.parse(
              '${configC.url}${configC.puerto}/wedding/PROVEEDORES/insertProveedoresEvento'),
          body: data,
          headers: {HttpHeaders.authorizationHeader: token});
      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        await _sharedPreferences.setToken(res['token']);
        return 0;
      } else if (response.statusCode == 401) {
        throw TokenException();
      } else {
        throw ProveedoresException();
      }
    }
    throw ProveedoresException();
  }

  // ignore: missing_return
  Future<int> deleteProveedorEvento(Map<String, dynamic> data) async {
    if (data['id_servicio'] != 0 && data['id_proveedor'] != 0) {
      int idPlanner = await _sharedPreferences.getIdPlanner();
      int idEvento = await _sharedPreferences.getIdEvento();
      data['id_servicio'] = data['id_servicio'].toString();
      data['id_proveedor'] = data['id_proveedor'].toString();
      data['id_evento'] = idEvento.toString();
      data['id_planner'] = idPlanner.toString();

      String token = await _sharedPreferences.getToken();
      final response = await client.post(
          Uri.parse(
              '${configC.url}${configC.puerto}/wedding/PROVEEDORES/deleteProveedoresEvento'),
          body: data,
          headers: {HttpHeaders.authorizationHeader: token});
      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        await _sharedPreferences.setToken(res['token']);
        return 0;
      } else if (response.statusCode == 401) {
        throw TokenException();
      } else {
        throw ProveedoresException();
      }
    }
    throw ProveedoresException();
  }

  @override
  updateProveedorEvento(Map data) async {
    // variables
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idEvento = await _sharedPreferences.getIdEvento();
    String token = await _sharedPreferences.getToken();

    data['id_planner'] = idPlanner.toString();
    data['id_evento'] = idEvento.toString();

    final response = await client.post(
        Uri.parse(
            '${configC.url}${configC.puerto}/wedding/PROVEEDORES/updateProveedorEvento'),
        body: data,
        headers: {HttpHeaders.authorizationHeader: token});

    // filtro
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
    } else if (response.statusCode == 401) {
      throw TokenException();
    } else {
      throw ProveedoresException();
    }
  }

  @override
  Future<String?> downloadPDFProveedoresEvento() async {
    String token = await _sharedPreferences.getToken();
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idEvento = await _sharedPreferences.getIdEvento();

    const endpoint = '/wedding/PROVEEDORES/downloadPDFProveedoresEvento';

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
      Uri.parse(configC.url! + configC.puerto! + endpoint),
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

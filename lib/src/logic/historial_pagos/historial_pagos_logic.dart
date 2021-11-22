import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' show Client;
import 'package:planning/src/models/historialPagos/historial_pagos_model.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/resources/config_conection.dart';

class HistorialPagosLogic {
  SharedPreferencesT _sharedPreferences = SharedPreferencesT();
  ConfigConection confiC = ConfigConection();
  Client client = Client();

  Future<List<HistorialPagosModel>> getPagosByEvent() async {
    int idEvento = await _sharedPreferences.getIdEvento();
    String token = await _sharedPreferences.getToken();

    final endpoint = 'wedding/PAGOS/getPagosByEvento';

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
      return List<HistorialPagosModel>.from(json
              .decode(response.body)
              .map((p) => HistorialPagosModel.fromJson(p))).toList() ??
          [];
    } else {
      throw PagosException();
    }
  }

  Future<String> agregarPagoEvento(HistorialPagosModel pagos) async {
    int idEvento = await _sharedPreferences.getIdEvento();
    String token = await _sharedPreferences.getToken();

    final endpoint = 'wedding/PAGOS/agregarPagosByEvento';

    final data = {
      'idEvento': idEvento,
      'pago': pagos.pago,
      'tipoPresupuesto': pagos.tipoPresupuesto,
      'concepto': pagos.concepto,
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
      return 'Ok';
    } else {
      return response.body;
    }
  }

  Future<String> editarPagoEvento(HistorialPagosModel pagos) async {
    int idEvento = await _sharedPreferences.getIdEvento();
    String token = await _sharedPreferences.getToken();

    final endpoint = 'wedding/PAGOS/editarHistorialPagoByEvento';

    final data = {
      'idEvento': idEvento,
      'idPago': pagos.idPago,
      'pago': pagos.pago,
      'concepto': pagos.concepto,
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
      return 'Ok';
    } else {
      return response.body;
    }
  }

  Future<String> eliminarPagoEvento(int idPago) async {
    int idEvento = await _sharedPreferences.getIdEvento();
    String token = await _sharedPreferences.getToken();

    final endpoint = 'wedding/PAGOS/eliminarPagoByEvento';

    final data = {
      'idEvento': idEvento,
      'idPago': idPago,
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
      return 'Ok';
    } else {
      return response.body;
    }
  }
}

class PagosException implements Exception {}

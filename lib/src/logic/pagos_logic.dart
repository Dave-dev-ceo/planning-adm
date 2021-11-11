// imports from flutter/dart
import 'package:http/http.dart' show Client;
import 'dart:io';
import 'dart:convert';

// imports from wedding
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/resources/config_conection.dart';

// import model
import 'package:planning/src/models/item_model_pagos.dart';

abstract class PagosLogic {
  Future<bool> insertPagos(Map pago);
  Future<ItemModelPagos> selectPagos();
  Future<bool> updatePagos(Map pago);
  Future<bool> deletePagos(int id);
  Future<ItemModelPagos> selectProveedor();
  Future<ItemModelPagos> selectServicios();
  Future<ItemModelPagos> selectPagosId(int id);
}

// consultas
class ConsultasPagosLogic extends PagosLogic {
  // variables de configuracion
  SharedPreferencesT _sharedPreferences = new SharedPreferencesT();
  ConfigConection confiC = new ConfigConection();
  Client client = Client();

  @override
  Future<bool> insertPagos(Map pago) async {
    // variables
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idEvento = await _sharedPreferences.getIdEvento();
    String token = await _sharedPreferences.getToken();

    pago['id_planner'] = idPlanner.toString();
    pago['id_evento'] = idEvento.toString();

    final response = await client.post(
        Uri.parse(confiC.url + confiC.puerto + '/wedding/PAGOS/insertPagos'),
        body: pago,
        headers: {HttpHeaders.authorizationHeader: token});

    // filtro
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return true;
    } else if (response.statusCode == 401) {
      throw TokenException();
    } else {
      throw AutorizacionException();
    }
  }

  @override
  Future<ItemModelPagos> selectPagos() async {
    // variables
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idEvento = await _sharedPreferences.getIdEvento();
    String token = await _sharedPreferences.getToken();

    final response = await client.post(
        Uri.parse(confiC.url + confiC.puerto + '/wedding/PAGOS/selectPagos'),
        body: {
          'id_planner': idPlanner.toString(),
          'id_evento': idEvento.toString()
        },
        headers: {
          HttpHeaders.authorizationHeader: token
        });

    // filtro
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return ItemModelPagos.fromJson(data['data']);
    } else if (response.statusCode == 401) {
      throw TokenException();
    } else {
      throw AutorizacionException();
    }
  }

  @override
  Future<bool> updatePagos(Map pago) async {
    // variables
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();

    pago['id_planner'] = idPlanner.toString();

    final response = await client.post(
        Uri.parse(confiC.url + confiC.puerto + '/wedding/PAGOS/updatePagos'),
        body: pago,
        headers: {HttpHeaders.authorizationHeader: token});

    // filtro
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return true;
    } else if (response.statusCode == 401) {
      throw TokenException();
    } else {
      throw AutorizacionException();
    }
  }

  @override
  Future<bool> deletePagos(int id) async {
    // variables
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();

    final response = await client.post(
        Uri.parse(confiC.url + confiC.puerto + '/wedding/PAGOS/deletePagos'),
        body: {
          'id_planner': idPlanner.toString(),
          'id_concepto': id.toString()
        },
        headers: {
          HttpHeaders.authorizationHeader: token
        });

    // filtro
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return true;
    } else if (response.statusCode == 401) {
      throw TokenException();
    } else {
      throw AutorizacionException();
    }
  }

  @override
  Future<ItemModelPagos> selectProveedor() async {
    // variables
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();

    final response = await client.post(
        Uri.parse(
            confiC.url + confiC.puerto + '/wedding/PAGOS/selectProveedor'),
        body: {'id_planner': idPlanner.toString()},
        headers: {HttpHeaders.authorizationHeader: token});

    // filtro
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return ItemModelPagos.fromJson(data['data']);
    } else if (response.statusCode == 401) {
      throw TokenException();
    } else {
      throw AutorizacionException();
    }
  }

  @override
  Future<ItemModelPagos> selectServicios() async {
    // variables
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();

    final response = await client.post(
        Uri.parse(
            confiC.url + confiC.puerto + '/wedding/PAGOS/selectServicios'),
        body: {'id_planner': idPlanner.toString()},
        headers: {HttpHeaders.authorizationHeader: token});

    // filtro
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return ItemModelPagos.fromJson(data['data']);
    } else if (response.statusCode == 401) {
      throw TokenException();
    } else {
      throw AutorizacionException();
    }
  }

  @override
  Future<ItemModelPagos> selectPagosId(int id) async {
    // variables
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();

    final response = await client.post(
        Uri.parse(confiC.url + confiC.puerto + '/wedding/PAGOS/selectPagosId'),
        body: {
          'id_planner': idPlanner.toString(),
          'id_concepto': id.toString()
        },
        headers: {
          HttpHeaders.authorizationHeader: token
        });

    // filtro
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return ItemModelPagos.fromJson(data['data']);
    } else if (response.statusCode == 401) {
      throw TokenException();
    } else {
      throw AutorizacionException();
    }
  }
}

// clases para manejar errores
class AutorizacionException implements Exception {}

class TokenException implements Exception {}

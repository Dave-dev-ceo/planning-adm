// imports from flutter/dart
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:planning/src/models/historialPagos/historial_pagos_model.dart';
import 'dart:io';
import 'dart:convert';

// imports from wedding
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/resources/config_conection.dart';

// import model
import 'package:planning/src/models/item_model_pagos.dart';

abstract class PagosLogic {
  Future<bool> insertPagos(Map<String, dynamic> pago);
  Future<Map<String, dynamic>> selectPagos();
  Future<bool> updatePagos(Map pago);
  Future<bool> deletePagos(int? id);
  Future<ItemModelPagos> selectProveedor();
  Future<ItemModelPagos> selectServicios();
  Future<ItemModelPagos> selectPagosId(int? id);
  Future<String?> downlooadPagosEvento(String tipoPresupuesto);
  Future<Map<String, dynamic>?> obtenerResumenPagos();
}

// consultas
class ConsultasPagosLogic extends PagosLogic {
  // variables de configuracion
  final SharedPreferencesT _sharedPreferences = SharedPreferencesT();
  ConfigConection confiC = ConfigConection();

  @override
  Future<bool> insertPagos(Map<String, dynamic> pago) async {
    // variables
    int? idPlanner = await _sharedPreferences.getIdPlanner();
    int? idEvento = await _sharedPreferences.getIdEvento();
    int? idUsuario = await _sharedPreferences.getIdUsuario();
    String? token = await _sharedPreferences.getToken();

    pago['id_planner'] = idPlanner;
    pago['id_evento'] = idEvento;
    pago['idUsuario'] = idUsuario;

    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token ?? ''
    };

    final response = await http.post(
      Uri.parse('${confiC.url}${confiC.puerto}/wedding/PAGOS/insertPagos'),
      body: json.encode(pago),
      headers: headers,
    );

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
  Future<Map<String, dynamic>> selectPagos() async {
    // variables
    int? idPlanner = await _sharedPreferences.getIdPlanner();
    int? idEvento = await _sharedPreferences.getIdEvento();
    String? token = await _sharedPreferences.getToken();

    final response = await http.post(
        Uri.parse('${confiC.url}${confiC.puerto}/wedding/PAGOS/selectPagos'),
        body: {
          'id_planner': idPlanner.toString(),
          'id_evento': idEvento.toString()
        },
        headers: {
          HttpHeaders.authorizationHeader: token ?? ''
        });

    // filtro
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      ItemModelPagos presupuestos =
          ItemModelPagos.fromJson(data['data']['presupuestos']);
      List<HistorialPagosModel> historialPagos = List<HistorialPagosModel>.from(
          data['data']['pagos'].map((p) => HistorialPagosModel.fromJson(p)));
      Map<String, dynamic> datos = {};
      datos['presupuestos'] = presupuestos;
      datos['pagos'] = historialPagos;

      return datos;
    } else if (response.statusCode == 401) {
      throw TokenException();
    } else {
      throw AutorizacionException();
    }
  }

  @override
  Future<bool> updatePagos(Map pago) async {
    // variables
    int? idPlanner = await _sharedPreferences.getIdPlanner();
    String? token = await _sharedPreferences.getToken();

    pago['id_planner'] = idPlanner.toString();

    final response = await http.post(
        Uri.parse('${confiC.url}${confiC.puerto}/wedding/PAGOS/updatePagos'),
        body: pago,
        headers: {HttpHeaders.authorizationHeader: token ?? ''});

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
  Future<bool> deletePagos(int? id) async {
    // variables
    int? idPlanner = await _sharedPreferences.getIdPlanner();
    String? token = await _sharedPreferences.getToken();

    final response = await http.post(
        Uri.parse('${confiC.url}${confiC.puerto}/wedding/PAGOS/deletePagos'),
        body: {
          'id_planner': idPlanner.toString(),
          'id_concepto': id.toString()
        },
        headers: {
          HttpHeaders.authorizationHeader: token ?? ''
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
    int? idPlanner = await _sharedPreferences.getIdPlanner();
    String? token = await _sharedPreferences.getToken();

    final response = await http.post(
        Uri.parse(
            '${confiC.url}${confiC.puerto}/wedding/PAGOS/selectProveedor'),
        body: {'id_planner': idPlanner.toString()},
        headers: {HttpHeaders.authorizationHeader: token ?? ''});

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
    int? idPlanner = await _sharedPreferences.getIdPlanner();
    String? token = await _sharedPreferences.getToken();

    final response = await http.post(
        Uri.parse(
            '${confiC.url}${confiC.puerto}/wedding/PAGOS/selectServicios'),
        body: {'id_planner': idPlanner.toString()},
        headers: {HttpHeaders.authorizationHeader: token ?? ''});

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
  Future<ItemModelPagos> selectPagosId(int? id) async {
    // variables
    int? idPlanner = await _sharedPreferences.getIdPlanner();
    String? token = await _sharedPreferences.getToken();

    final response = await http.post(
        Uri.parse('${confiC.url}${confiC.puerto}/wedding/PAGOS/selectPagosId'),
        body: {
          'id_planner': idPlanner.toString(),
          'id_concepto': id.toString()
        },
        headers: {
          HttpHeaders.authorizationHeader: token ?? ''
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
  Future<String?> downlooadPagosEvento(String tipoPresupuesto) async {
    String? token = await _sharedPreferences.getToken();
    int? idPlanner = await _sharedPreferences.getIdPlanner();
    int? idEvento = await _sharedPreferences.getIdEvento();

    const endpoint = '/wedding/PAGOS/downlooadPagosEvento';

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token ?? ''
    };

    final data = {
      'idPlanner': idPlanner,
      'idEvento': idEvento,
      'tipoPresupuesto': tipoPresupuesto
    };

    final resp = await http.post(
      Uri.parse(confiC.url! + confiC.puerto! + endpoint),
      body: json.encode(data),
      headers: headers,
    );

    if (resp.statusCode == 200) {
      return json.decode(resp.body)['pdf'];
    } else {
      return null;
    }
  }

  @override
  Future<Map<String, dynamic>?> obtenerResumenPagos() async {
    String? token = await _sharedPreferences.getToken();
    int? idEvento = await _sharedPreferences.getIdEvento();
    bool desconectado = await _sharedPreferences.getModoConexion();
    if (desconectado) {
      if (!Hive.isBoxOpen('resumenPagos')) {
        await Hive.openBox<dynamic>('resumenPagos');
      }
      final boxResumenPagos = Hive.box<dynamic>('resumenPagos');
      final resumenPago = boxResumenPagos.values
          .where((r) => r['id_evento'] == idEvento)
          .toList()[0];
      final mapResumenPago = Map<String, dynamic>.from(resumenPago);
      return mapResumenPago;
    } else {
      const endpoint = '/wedding/PAGOS/obtenerResumenPagosPorEvento';
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        HttpHeaders.authorizationHeader: token ?? ''
      };
      final data = {
        'idEvento': idEvento,
      };
      final resp = await http.post(
        Uri.parse(confiC.url! + confiC.puerto! + endpoint),
        body: json.encode(data),
        headers: headers,
      );
      if (resp.statusCode == 200) {
        return jsonDecode(resp.body);
      } else {
        return null;
      }
    }
  }
}

// clases para manejar errores
class AutorizacionException implements Exception {}

class TokenException implements Exception {}

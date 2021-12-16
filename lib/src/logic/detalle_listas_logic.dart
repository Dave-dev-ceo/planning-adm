import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:planning/src/logic/listas_logic.dart';
import 'package:planning/src/models/item_model_detalle_listas.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/resources/config_conection.dart';

abstract class DetallesListasLogic {
  Future<ItemModelDetalleListas> fetchDetalleListas(int idLista);
  Future<int> createDetalleLista(Map<String, dynamic> data);
  Future<int> deleteDetallaLista(int idDetalleLista);
  Future<int> editarDetalleLista(Map<String, dynamic> data);
  Future<int> createLista(Map<String, dynamic> data);
  Future<int> editarLista(Map<String, dynamic> data);
  Future<String> downloadPDFDetalleLista(int idLista);
}

class DetalleListasException implements Exception {}

class TokenException implements Exception {}

class CreateDetalleListasException implements Exception {}

class FetchDetalleListaLogic extends DetallesListasLogic {
  SharedPreferencesT _sharedPreferences = new SharedPreferencesT();
  ConfigConection configC = new ConfigConection();
  Client client = Client();

  @override
  // ignore: missing_return
  Future<ItemModelDetalleListas> fetchDetalleListas(int idLista) async {
    try {
      int id_planner = await _sharedPreferences.getIdPlanner();
      int id_lista = await idLista;
      String token = await _sharedPreferences.getToken();
      final response = await client.get(
          Uri.parse(configC.url +
              configC.puerto +
              '/wedding/LISTAS/obtenerDetallesListaPorPlanner/$id_planner/$id_lista'),
          headers: {HttpHeaders.authorizationHeader: token});

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        await _sharedPreferences.setToken(data['token']);
        return ItemModelDetalleListas.fromJson(data["data"]);
      } else if (response.statusCode == 401) {
        throw TokenException();
      } else {
        throw DetalleListasException();
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  // ignore: missing_return
  Future<int> createDetalleLista(Map<String, dynamic> data) async {
    if (data['cantidad'] != 0 &&
        data['nombre'] != '' &&
        data['descripcion'] != '' &&
        data['id_lista'] != 0) {
      int idPlanner = await _sharedPreferences.getIdPlanner();
      int idEvento = await _sharedPreferences.getIdEvento();
      int idUsuario = await _sharedPreferences.getIdUsuario();
      data['cantidad'] = data['cantidad'].toString();
      data['id_lista'] = data['id_lista'].toString();
      data['id_evento'] = idEvento.toString();
      data['id_planner'] = idPlanner.toString();
      data['creado_por'] = idUsuario.toString();
      data['modificado_por'] = idUsuario.toString();
      String token = await _sharedPreferences.getToken();
      final response = await client.post(
          Uri.parse(configC.url +
              configC.puerto +
              '/wedding/LISTAS/insertDetalleLista'),
          body: data,
          headers: {HttpHeaders.authorizationHeader: token});
      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        await _sharedPreferences.setToken(res['token']);
        return 0;
      } else if (response.statusCode == 401) {
        throw TokenException();
      } else {
        throw CreateDetalleListasException();
      }
    }
  }

  @override
  Future<int> deleteDetallaLista(int idDetalleLista) async {
    int id_planner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();
    final response = await client.delete(
        Uri.parse(configC.url +
            configC.puerto +
            '/wedding/LISTAS/deleteDetalleLista'),
        body: {
          "id_detalle_lista": idDetalleLista.toString(),
          'id_planner': id_planner.toString()
        },
        headers: {
          HttpHeaders.authorizationHeader: token
        });
    if (response.statusCode == 200) {
      Map<String, dynamic> responseEvento = json.decode(response.body);
      await _sharedPreferences.setToken(responseEvento['token']);
      return 0;
    } else if (response.statusCode == 401) {
      throw TokenException();
    } else {
      throw CreateDetalleListasException();
    }
  }

  @override
  // ignore: missing_return
  Future<int> editarDetalleLista(Map<String, dynamic> data) async {
    if (data['cantidad'] != 0 &&
        data['nombre'] != '' &&
        data['descripcion'] != '' &&
        data['id_detalle_lista'] != 0) {
      int idPlanner = await _sharedPreferences.getIdPlanner();
      int idUsuario = await _sharedPreferences.getIdUsuario();
      data['cantidad'] = data['cantidad'].toString();
      data['id_lista'] = data['id_lista'].toString();
      data['id_detalle_lista'] = data['id_detalle_lista'].toString();
      data['id_planner'] = idPlanner.toString();
      data['modificado_por'] = idUsuario.toString();
      String token = await _sharedPreferences.getToken();
      final response = await client.put(
          Uri.parse(configC.url +
              configC.puerto +
              '/wedding/LISTAS/editarDetalleLista'),
          body: data,
          headers: {HttpHeaders.authorizationHeader: token});
      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        await _sharedPreferences.setToken(res['token']);
        return 0;
      } else if (response.statusCode == 401) {
        throw TokenException();
      } else {
        throw CreateDetalleListasException();
      }
    }
  }

  @override
  // ignore: missing_return
  Future<int> createLista(Map<String, dynamic> data) async {
    if (data['nombre'] != '' && data['descripcion'] != '') {
      int idPlanner = await _sharedPreferences.getIdPlanner();
      int idEvento = await _sharedPreferences.getIdEvento();
      int idUsuario = await _sharedPreferences.getIdUsuario();
      data['id_evento'] = idEvento.toString();
      data['id_planner'] = idPlanner.toString();
      data['creado_por'] = idUsuario.toString();
      data['modificado_por'] = idUsuario.toString();
      String token = await _sharedPreferences.getToken();
      final response = await client.post(
          Uri.parse(
              configC.url + configC.puerto + '/wedding/LISTAS/insertLista'),
          body: data,
          headers: {HttpHeaders.authorizationHeader: token});
      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        await _sharedPreferences.setToken(res['token']);
        return res['data'][0]['id_lista'];
      } else if (response.statusCode == 401) {
        throw TokenException();
      } else {
        throw CreateListasException();
      }
    }
  }

  @override
  // ignore: missing_return
  Future<int> editarLista(Map<String, dynamic> data) async {
    if (data['nombre'] != '' &&
        data['descripcion'] != '' &&
        data['id_lista'] != 0) {
      int idPlanner = await _sharedPreferences.getIdPlanner();
      int idUsuario = await _sharedPreferences.getIdUsuario();
      data['id_lista'] = data['id_lista'].toString();
      data['id_planner'] = idPlanner.toString();
      data['modificado_por'] = idUsuario.toString();
      String token = await _sharedPreferences.getToken();
      final response = await client.put(
          Uri.parse(
              configC.url + configC.puerto + '/wedding/LISTAS/updateLista'),
          body: data,
          headers: {HttpHeaders.authorizationHeader: token});
      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        await _sharedPreferences.setToken(res['token']);
        return 0;
      } else if (response.statusCode == 401) {
        throw TokenException();
      } else {
        throw CreateDetalleListasException();
      }
    }
  }

  @override
  Future<String> downloadPDFDetalleLista(int idLista) async {
    String token = await _sharedPreferences.getToken();
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idEvento = await _sharedPreferences.getIdEvento();

    const endpoint = '/wedding/LISTAS/downloadPDFDetalleLista';

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token
    };

    final data = {
      'idPlanner': idPlanner,
      'idEvento': idEvento,
      'idLista': idLista,
    };

    final resp = await client.post(
      Uri.parse(configC.url + configC.puerto + endpoint),
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

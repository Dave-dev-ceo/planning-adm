// ignore_for_file: missing_return

import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/models/item_model_servicios.dart';
import 'package:planning/src/resources/config_conection.dart';

abstract class ServiciosLogic {
  Future<ItemModuleServicios> fetchServicios();
  Future<int> createServicio(Map<String, dynamic> data);
  Future<int> editarServicio(Map<String, dynamic> data);
  Future<int> deleteDetallaLista(int? idServicio);
  Future<ItemModuleServicios> fetchServiciosByProoveedor(int? idProveedor);
}

class ServiciosException implements Exception {}

class TokenException implements Exception {}

class CreateServiciosException implements Exception {}

class FetchServiciosLogic extends ServiciosLogic {
  final SharedPreferencesT _sharedPreferences = SharedPreferencesT();
  ConfigConection configC = ConfigConection();
  Client client = Client();

  @override
  Future<ItemModuleServicios> fetchServicios() async {
    try {
      int idPlanner = await _sharedPreferences.getIdPlanner();
      String token = await _sharedPreferences.getToken();
      final response = await client.get(
          Uri.parse(
              '${configC.url}${configC.puerto}/wedding/SERVICIOS/obtenerServicios/$idPlanner'),
          headers: {HttpHeaders.authorizationHeader: token});
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        await _sharedPreferences.setToken(data['token']);
        return ItemModuleServicios.fromJson(data["data"]);
      } else if (response.statusCode == 401) {
        throw TokenException();
      } else {
        throw ServiciosException();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw ServiciosException();
    }
  }

  @override
  Future<int> createServicio(Map<String, dynamic> data) async {
    if (data['nombre'] != '') {
      int idPlanner = await _sharedPreferences.getIdPlanner();
      int idUsuario = await _sharedPreferences.getIdUsuario();
      data['id_planner'] = idPlanner.toString();
      data['creado_por'] = idUsuario.toString();
      data['modificado_por'] = idUsuario.toString();
      String token = await _sharedPreferences.getToken();
      final response = await client.post(
          Uri.parse(
              '${configC.url}${configC.puerto}/wedding/SERVICIOS/insertServicios'),
          body: data,
          headers: {HttpHeaders.authorizationHeader: token});
      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        await _sharedPreferences.setToken(res['token']);
        return 0;
      } else if (response.statusCode == 401) {
        throw TokenException();
      } else {
        throw CreateServiciosException();
      }
    }
    throw CreateServiciosException();
  }

  @override
  Future<int> editarServicio(Map<String, dynamic> data) async {
    if (data['nombre'] != '' && data['id_servicio'] != 0) {
      int idPlanner = await _sharedPreferences.getIdPlanner();
      int idUsuario = await _sharedPreferences.getIdUsuario();
      data['id_servicio'] = data['id_servicio'].toString();
      data['id_planner'] = idPlanner.toString();
      data['modificado_por'] = idUsuario.toString();
      String token = await _sharedPreferences.getToken();
      final response = await client.put(
          Uri.parse(
              '${configC.url}${configC.puerto}/wedding/SERVICIOS/editarServicio'),
          body: data,
          headers: {HttpHeaders.authorizationHeader: token});
      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        await _sharedPreferences.setToken(res['token']);
        return 0;
      } else if (response.statusCode == 401) {
        throw TokenException();
      } else {
        throw CreateServiciosException();
      }
    }

    throw CreateServiciosException();
  }

  @override
  Future<int> deleteDetallaLista(int? idServicio) async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();
    final response = await client.delete(
        Uri.parse(
            '${configC.url}${configC.puerto}/wedding/SERVICIOS/deleteServicio'),
        body: {
          "id_servicio": idServicio.toString(),
          'id_planner': idPlanner.toString()
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
      throw CreateServiciosException();
    }
  }

  @override
  Future<ItemModuleServicios> fetchServiciosByProoveedor(
      int? idProveedor) async {
    try {
      int idPlanner = await _sharedPreferences.getIdPlanner();
      String token = await _sharedPreferences.getToken();
      final response = await client.get(
          Uri.parse(
              '${configC.url}${configC.puerto}/wedding/SERVICIOS/obtenerServiciosByProveedor/$idPlanner/$idProveedor'),
          headers: {HttpHeaders.authorizationHeader: token});
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        await _sharedPreferences.setToken(data['token']);
        return ItemModuleServicios.fromJson(data["data"]);
      } else if (response.statusCode == 401) {
        throw TokenException();
      } else {
        throw ServiciosException();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      throw ServiciosException();
    }
  }
}

import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:planning/src/models/item_model_archivo_serv_prod.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/resources/config_conection.dart';

abstract class LogicArchivoProveedores {
  Future<ItemModelArchivoProvServ> fetchArchivosProvServ(int prov, int serv);
  Future<int> createArchivos(Map<String, dynamic> data);
  Future<int> deleteArchivo(int idArchivo);
  Future<ItemModelArchivoProvServ> fetchArchivosById(int idArchivo);

  Future<ItemModelArchivoEspecial> fetchArchivosProvEvent(int prov, int event);
  Future<int> deleteArchivoEspecial(int idArchivoEspecial);
  Future<int> createArchivosEspecial(Map<String, dynamic> data);
  Future<ItemModelArchivoEspecial> fetchArchivosEspecialById(int idArchivo);
}

class ArchivoProveedoresException implements Exception {}

class TokenException implements Exception {}

class CreateArchivoProveedorException implements Exception {}

class FetchArchivoProveedoresLogic extends LogicArchivoProveedores {
  final SharedPreferencesT _sharedPreferences = SharedPreferencesT();
  ConfigConection configC = ConfigConection();
  Client client = Client();

  @override
  Future<ItemModelArchivoProvServ> fetchArchivosProvServ(
      int prov, int serv) async {
    try {
      int idPlanner = await _sharedPreferences.getIdPlanner();

      String token = await _sharedPreferences.getToken();
      final response = await client.get(
          Uri.parse(configC.url +
              configC.puerto +
              '/wedding/PROVEEDORES/obtenerArchivos/$idPlanner/$prov/$serv'),
          headers: {
            HttpHeaders.authorizationHeader: token,
            'Content-type': 'application/json',
            'Accept': 'application/json',
          });
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        await _sharedPreferences.setToken(data['token']);
        return ItemModelArchivoProvServ.fromJson(data['data']);
      } else if (response.statusCode == 401) {
        throw TokenException();
      } else {
        throw ArchivoProveedoresException();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw ArchivoProveedoresException();
    }
  }

  @override
  Future<int> createArchivos(Map<String, dynamic> data) async {
    if (data['id_proveedor'] != '' || data['id_servicio'] != '') {
      int idPlanner = await _sharedPreferences.getIdPlanner();
      int idUsuario = await _sharedPreferences.getIdUsuario();
      data['id_proveedor'] = data['id_proveedor'].toString();
      data['id_servicio'] = data['id_servicio'].toString();
      data['id_planner'] = idPlanner.toString();
      data['creado_por'] = idUsuario.toString();
      data['modificado_por'] = idUsuario.toString();
      String token = await _sharedPreferences.getToken();
      final response = await client.post(
          Uri.parse(configC.url +
              configC.puerto +
              '/wedding/PROVEEDORES/insertArchivoProvServ'),
          body: data,
          headers: {HttpHeaders.authorizationHeader: token});
      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        await _sharedPreferences.setToken(res['token']);
        return 0;
      } else if (response.statusCode == 401) {
        throw TokenException();
      } else {
        throw CreateArchivoProveedorException();
      }
    } else {
      return -1;
    }
  }

  @override
  Future<int> deleteArchivo(int idArchivo) async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();
    final response = await client.delete(
        Uri.parse(configC.url +
            configC.puerto +
            '/wedding/PROVEEDORES/deleteArchivos'),
        body: {
          "id_archivo": idArchivo.toString(),
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
      throw ArchivoProveedoresException();
    }
  }

  @override
  Future<ItemModelArchivoProvServ> fetchArchivosById(int idArchivo) async {
    try {
      int idPlanner = await _sharedPreferences.getIdPlanner();
      String token = await _sharedPreferences.getToken();
      final response = await client.get(
          Uri.parse(configC.url +
              configC.puerto +
              '/wedding/PROVEEDORES/obtenerArchivosById/$idPlanner/$idArchivo'),
          headers: {HttpHeaders.authorizationHeader: token});

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        await _sharedPreferences.setToken(data['token']);
        return ItemModelArchivoProvServ.fromJson(data['data']);
      } else if (response.statusCode == 401) {
        throw TokenException();
      } else {
        throw ArchivoProveedoresException();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw ArchivoProveedoresException();
    }
  }

  @override
  Future<ItemModelArchivoEspecial> fetchArchivosProvEvent(
      int prov, int event) async {
    try {
      int idPlanner = await _sharedPreferences.getIdPlanner();
      String token = await _sharedPreferences.getToken();
      final response = await client.get(
          Uri.parse(configC.url +
              configC.puerto +
              '/wedding/PROVEEDORES/obtenerArchivosEspeciales/$idPlanner/$prov/$event'),
          headers: {
            HttpHeaders.authorizationHeader: token,
            'Content-type': 'application/json',
            'Accept': 'application/json',
          });
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        await _sharedPreferences.setToken(data['token']);
        return ItemModelArchivoEspecial.fromJson(data['data']);
      } else if (response.statusCode == 401) {
        throw TokenException();
      } else {
        throw ArchivoProveedoresException();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw ArchivoProveedoresException();
    }
  }

  @override
  Future<int> deleteArchivoEspecial(int idArchivoEspecial) async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();
    final response = await client.delete(
        Uri.parse(configC.url +
            configC.puerto +
            '/wedding/PROVEEDORES/deleteArchivosEspecial'),
        body: {
          "id_archivo": idArchivoEspecial.toString(),
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
      throw ArchivoProveedoresException();
    }
  }

  @override
  Future<int> createArchivosEspecial(Map<String, dynamic> data) async {
    if (data['id_proveedor'] != '') {
      int idPlanner = await _sharedPreferences.getIdPlanner();
      int idUsuario = await _sharedPreferences.getIdUsuario();
      data['id_proveedor'] = data['id_proveedor'].toString();
      data['id_evento'] = data['id_evento'].toString();
      data['id_servicio'] = data['id_servicio'].toString();
      data['id_planner'] = idPlanner.toString();
      data['creado_por'] = idUsuario.toString();
      data['modificado_por'] = idUsuario.toString();

      String token = await _sharedPreferences.getToken();
      final response = await client.post(
          Uri.parse(configC.url +
              configC.puerto +
              '/wedding/PROVEEDORES/insertArchivoEspecial'),
          body: data,
          headers: {HttpHeaders.authorizationHeader: token});
      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        await _sharedPreferences.setToken(res['token']);
        return 0;
      } else if (response.statusCode == 401) {
        throw TokenException();
      } else {
        throw CreateArchivoProveedorException();
      }
    } else {
      return -1;
    }
  }

  @override
  Future<ItemModelArchivoEspecial> fetchArchivosEspecialById(
      int idArchivo) async {
    try {
      int idPlanner = await _sharedPreferences.getIdPlanner();
      String token = await _sharedPreferences.getToken();
      final response = await client.get(
          Uri.parse(configC.url +
              configC.puerto +
              '/wedding/PROVEEDORES/obtenerArchivosEspecialById/$idPlanner/$idArchivo'),
          headers: {HttpHeaders.authorizationHeader: token});

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        await _sharedPreferences.setToken(data['token']);
        return ItemModelArchivoEspecial.fromJson(data['data']);
      } else if (response.statusCode == 401) {
        throw TokenException();
      } else {
        throw ArchivoProveedoresException();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw ArchivoProveedoresException();
    }
  }
}

// ignore_for_file: missing_return

import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/models/item_model_proveedores.dart';
import 'package:planning/src/resources/config_conection.dart';

abstract class LogicProveedores {
  Future<ItemModelProveedores> fetchProveedor();
  Future<ItemModelServicioByProv> fetchServicioByProv();
  Future<int> createProveedor(Map<String, dynamic> data);
  Future<int> deleteServicioProv(int idServcio, int idProveedor);
  Future<int> insertServicioProv(int idServcio, int idProveedor);
  Future<String> updateProveedor(ItemProveedor proveedor);
  Future<String> deleteProveedor(int idProveedor);
  Future<String> downloadPDFProveedor();
}

class ProveedoresException implements Exception {}

class TokenException implements Exception {}

class CreateProveedorException implements Exception {}

class FetchProveedoresLogic extends LogicProveedores {
  final SharedPreferencesT _sharedPreferences = SharedPreferencesT();
  ConfigConection configC = ConfigConection();
  Client client = Client();

  @override
  Future<int> createProveedor(Map<void, dynamic> data) async {
    if (data['nombre'] != '' && data['descripcion'] != '') {
      int idPlanner = await _sharedPreferences.getIdPlanner();
      int idUsuario = await _sharedPreferences.getIdUsuario();
      String token = await _sharedPreferences.getToken();
      List listaTest = data['servicios'];
      final _data = {
        'nombre': data['nombre'],
        'descripcion': data['descripcion'],
        'idCiudad': data['idCiudad'],
        'id_planner': idPlanner.toString(),
        'creado_por': idUsuario.toString(),
        'modificado_por': idUsuario.toString(),
        'servicios': listaTest,
      };
      final response = await client.post(
          Uri.parse(configC.url +
              configC.puerto +
              '/wedding/PROVEEDORES/insertProveedores'),
          body: jsonEncode(_data),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            HttpHeaders.authorizationHeader: token
          });
      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        await _sharedPreferences.setToken(res['token']);
        return 0;
      } else if (response.statusCode == 401) {
        throw TokenException();
      } else {
        throw CreateProveedorException();
      }
    }
  }

  @override
  Future<ItemModelProveedores> fetchProveedor() async {
    try {
      int idPlanner = await _sharedPreferences.getIdPlanner();
      String token = await _sharedPreferences.getToken();
      final response = await client.get(
          Uri.parse(configC.url +
              configC.puerto +
              '/wedding/PROVEEDORES/obtenerProveedores/$idPlanner'),
          headers: {HttpHeaders.authorizationHeader: token});

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        await _sharedPreferences.setToken(data['token']);
        return ItemModelProveedores.fromJson(data['data']);
      } else if (response.statusCode == 401) {
        throw TokenException();
      } else {
        throw ProveedoresException();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Future<ItemModelServicioByProv> fetchServicioByProv() async {
    try {
      int idPlanner = await _sharedPreferences.getIdPlanner();
      String token = await _sharedPreferences.getToken();
      final response = await client.get(
          Uri.parse(configC.url +
              configC.puerto +
              '/wedding/PROVEEDORES/obtenerServicioByProv/$idPlanner'),
          headers: {HttpHeaders.authorizationHeader: token});

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        await _sharedPreferences.setToken(data['token']);
        return ItemModelServicioByProv.fromJson(data['data']);
      } else if (response.statusCode == 401) {
        throw TokenException();
      } else {
        throw ProveedoresException();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Future<int> deleteServicioProv(int idServcio, int idProveedor) async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();
    final response = await client.delete(
        Uri.parse(configC.url +
            configC.puerto +
            '/wedding/PROVEEDORES/deleteServicioProv'),
        body: {
          "id_servicio": idServcio.toString(),
          'id_planner': idPlanner.toString(),
          'id_proveedor': idProveedor.toString(),
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
      throw ProveedoresException();
    }
  }

  @override
  Future<String> updateProveedor(ItemProveedor proveedor) async {
    String token = await _sharedPreferences.getToken();
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idUsuario = await _sharedPreferences.getIdUsuario();

    if (proveedor.estatus == 'Activo') {
      proveedor.estatus = 'A';
    } else {
      proveedor.estatus = 'I';
    }

    const endpoint = '/wedding/PROVEEDORES/updateProveedorAdmin';

    final body = {
      'idPlanner': idPlanner,
      'idUsuario': idUsuario,
      'idProveedor': proveedor.idProveedor,
      'nombre': proveedor.nombre,
      'descripcion': proveedor.descripcion,
      'estatus': proveedor.estatus,
      'telefono': proveedor.telefono,
      'correo': proveedor.correo,
      'direccion': proveedor.direccion,
      'idCiudad': proveedor.idCiudad,
    };

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token
    };

    final response = await client.post(
      Uri.parse(configC.url + configC.puerto + endpoint),
      body: json.encode(body),
      headers: headers,
    );

    if (response.statusCode == 200) {
      await _sharedPreferences.setToken(json.decode(response.body)['token']);
      return 'Ok';
    } else {
      return response.body;
    }
  }

  @override
  Future<String> deleteProveedor(int idProveedor) async {
    String token = await _sharedPreferences.getToken();
    String idPlanner = await _sharedPreferences.getIdPlanner();

    const endpoint = '';

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token
    };

    final data = {'idPlanner': idPlanner, 'idProveedor': idProveedor};

    final resp = await client.post(
      Uri.parse(configC.url + configC.puerto + endpoint),
      body: json.encode(data),
      headers: headers,
    );

    if (resp.statusCode == 200) {
      return 'Ok';
    } else {
      return resp.body;
    }
  }

  @override
  Future<String> downloadPDFProveedor() async {
    String token = await _sharedPreferences.getToken();
    int idPlanner = await _sharedPreferences.getIdPlanner();

    const endpoint = '/wedding/PROVEEDORES/downloadPDFProveedor';

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token
    };

    final data = {
      'idPlanner': idPlanner,
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

  @override
  Future<int> insertServicioProv(int idServcio, int idProveedor) async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();
    final response = await client.delete(
        Uri.parse(configC.url +
            configC.puerto +
            '/wedding/PROVEEDORES/insertServicioProv'),
        body: {
          "id_servicio": idServcio.toString(),
          'id_planner': idPlanner.toString(),
          'id_proveedor': idProveedor.toString(),
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
      throw ProveedoresException();
    }
  }
}

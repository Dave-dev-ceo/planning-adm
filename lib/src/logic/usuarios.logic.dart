import 'dart:convert';
import 'dart:io';

import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/models/item_model_usuarios.dart';
import 'package:http/http.dart' show Client;
import 'package:planning/src/resources/config_conection.dart';

abstract class UsuariosLogic {
  Future<ItemModelUsuarios?> fetchUsuariosPorPlanner();
}

abstract class UsuarioLogic {
  Future<ItemModelUsuario?> crearUsuario(Map<String, dynamic> dataUsuario);
  Future<ItemModelUsuario?> editarUsuario(Map<String, dynamic> dataUsuario);
  Future<bool?> eliminarUsuario(String idUsuario);
  Future<String?> downloadPdfUsuarios();
}

class ListaUsuariosException implements Exception {}

class CrearUsuarioException implements Exception {}

class EliminarUsuarioException implements Exception {}

class EditarUsuarioException implements Exception {}

class MostrarUsuarioException implements Exception {}

class TokenException implements Exception {}

class FetchListaUsuariosLogic extends UsuariosLogic {
  final SharedPreferencesT _sharedPreferences = SharedPreferencesT();

  ConfigConection confiC = ConfigConection();
  Client client = Client();

  @override
  Future<ItemModelUsuarios?> fetchUsuariosPorPlanner() async {
    int? idPlanner = await _sharedPreferences.getIdPlanner();
    String? token = await _sharedPreferences.getToken();

    final response = await client.post(
        Uri.parse(
            '${confiC.url}${confiC.puerto}/wedding/USUARIOS/obtenerUsuariosPorPlanner'),
        body: {'id_planner': idPlanner.toString()},
        headers: {HttpHeaders.authorizationHeader: token ?? ''});

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return ItemModelUsuarios.fromJson(data['data']);
    } else if (response.statusCode == 401) {
      return null;
    } else {
      throw ListaUsuariosException;
    }
  }
}

class UsuarioCrud extends UsuarioLogic {
  final SharedPreferencesT _sharedPreferences = SharedPreferencesT();

  ConfigConection confiC = ConfigConection();

  Client client = Client();
  @override
  Future<ItemModelUsuario?> crearUsuario(
      Map<String, dynamic> dataUsuario) async {
    int? idPlanner = await _sharedPreferences.getIdPlanner();
    int? idUsuario = await _sharedPreferences.getIdUsuario();
    String? token = await _sharedPreferences.getToken();

    final response = await client.post(
        Uri.parse(
            '${confiC.url}${confiC.puerto}/wedding/USUARIOS/crearUsuarioParaPlanner'),
        body: {
          'id_planner': idPlanner.toString(),
          'id_usuario': idUsuario.toString(),
          'usuario': jsonEncode(dataUsuario)
        },
        headers: {
          HttpHeaders.authorizationHeader: token ?? ''
        });

    if (response.statusCode == 201) {
      // If the call to the server was successful, parse the JSON
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return ItemModelUsuario.fromJson(data['data']);
    } else if (response.statusCode == 401) {
      return null;
    } else {
      throw CrearUsuarioException();
    }
  }

  @override
  Future<ItemModelUsuario?> editarUsuario(
      Map<String, dynamic> dataUsuario) async {
    int? idUsuario = await _sharedPreferences.getIdUsuario();
    int? idPlanner = await _sharedPreferences.getIdPlanner();
    String? token = await _sharedPreferences.getToken();

    final response = await client.post(
        Uri.parse(
            '${confiC.url}${confiC.puerto}/wedding/USUARIOS/editarUsuarioParaPlanner'),
        body: {
          'id_planner': idPlanner.toString(),
          'id_usuario': idUsuario.toString(),
          'usuario': jsonEncode(dataUsuario)
        },
        headers: {
          HttpHeaders.authorizationHeader: token ?? ''
        });

    if (response.statusCode == 201) {
      // If the call to the server was successful, parse the JSON
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return ItemModelUsuario.fromJson(data['data']);
    } else if (response.statusCode == 401) {
      return null;
    } else {
      throw CrearUsuarioException();
    }
  }

  @override
  Future<bool?> eliminarUsuario(String idUsuario) async {
    String? token = await _sharedPreferences.getToken();

    final response = await client.post(
        Uri.parse(
            '${confiC.url}${confiC.puerto}/wedding/USUARIOS/eliminarUsuario'),
        body: {'id_usuario': idUsuario.toString()},
        headers: {HttpHeaders.authorizationHeader: token ?? ''});

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return !data['codigo'];
    } else if (response.statusCode == 401) {
      return null;
    } else {
      throw EliminarUsuarioException();
    }
  }

  @override
  Future<String?> downloadPdfUsuarios() async {
    String? token = await _sharedPreferences.getToken();
    int? idPlanner = await _sharedPreferences.getIdPlanner();

    const endpoint = '/wedding/USUARIOS/downloadPdfUsuarios';

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token ?? ''
    };

    final data = {
      'idPlanner': idPlanner,
    };

    final resp = await client.post(
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
}

import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:planning/src/models/item_model_archivo_serv_prod.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/resources/config_conection.dart';

abstract class LogicArchivoProveedores {
  Future<int> createArchivos(Map<String, dynamic> data);
  Future<ItemModelArchivoProvServ> fetchArchivosProvServ(int prov, int serv);
  Future<int> deleteArchivo(int idArchivo);
  Future<ItemModelArchivoProvServ> fetchArchivosById(int idArchivo);
}

class ArchivoProveedoresException implements Exception {}

class TokenException implements Exception {}

class CreateArchivoProveedorException implements Exception {}

class FetchArchivoProveedoresLogic extends LogicArchivoProveedores {
  SharedPreferencesT _sharedPreferences = new SharedPreferencesT();
  ConfigConection configC = new ConfigConection();
  Client client = Client();

  @override
  // ignore: missing_return
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
    }
  }

  @override
  // ignore: missing_return
  Future<ItemModelArchivoProvServ> fetchArchivosProvServ(
      int prov, int serv) async {
    try {
      int id_planner = await _sharedPreferences.getIdPlanner();
      String token = await _sharedPreferences.getToken();
      final response = await client.get(
          Uri.parse(configC.url +
              configC.puerto +
<<<<<<< HEAD
              '/wedding/PROVEEDORES/archivosByProvedorEvento'),
          headers: {
            HttpHeaders.authorizationHeader: token,
            'Content-type': 'application/json',
            'Accept': 'application/json',
          },
          body: json.encode(data));
=======
              '/wedding/PROVEEDORES/obtenerArchivos/$id_planner/$prov/$serv'),
          headers: {HttpHeaders.authorizationHeader: token});
>>>>>>> 1e10bb58f2ac74258ee595b4d6d6c989e0d82592

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
      print(e);
    }
  }

  @override
  Future<int> deleteArchivo(int idArchivo) async {
    int id_planner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();
    final response = await client.delete(
        Uri.parse(configC.url +
            configC.puerto +
            '/wedding/PROVEEDORES/deleteArchivos'),
        body: {
          "id_archivo": idArchivo.toString(),
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
      throw ArchivoProveedoresException();
    }
  }

  @override
  // ignore: missing_return
  Future<ItemModelArchivoProvServ> fetchArchivosById(int idArchivo) async {
    try {
      int id_planner = await _sharedPreferences.getIdPlanner();
      String token = await _sharedPreferences.getToken();
      final response = await client.get(
          Uri.parse(configC.url +
              configC.puerto +
              '/wedding/PROVEEDORES/obtenerArchivosById/$id_planner/$idArchivo'),
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
      print(e);
    }
  }
}

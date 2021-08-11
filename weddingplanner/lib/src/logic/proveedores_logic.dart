import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:weddingplanner/src/models/item_model_archivo_serv_prod.dart';
import 'package:weddingplanner/src/models/item_model_preferences.dart';
import 'package:weddingplanner/src/models/item_model_proveedores.dart';
import 'package:weddingplanner/src/resources/config_conection.dart';

abstract class LogicProveedores {
  Future<ItemModelProveedores> fetchProveedor();
  Future<ItemModelServicioByProv> fetchServicioByProv();
  Future<int> createProveedor(Map<String, dynamic> data);
  Future<int> deleteServicioProv(int idServcio);
}

class ProveedoresException implements Exception {}

class TokenException implements Exception {}

class CreateProveedorException implements Exception {}

class FetchProveedoresLogic extends LogicProveedores {
  SharedPreferencesT _sharedPreferences = new SharedPreferencesT();
  ConfigConection configC = new ConfigConection();
  Client client = Client();

  @override
  Future<int> createProveedor(Map<void, dynamic> data) async {
    print('consulta');
    print(data);
    if (data['nombre'] != '' && data['descripcion'] != '') {
      int idPlanner = await _sharedPreferences.getIdPlanner();
      int idUsuario = await _sharedPreferences.getIdUsuario();
      String token = await _sharedPreferences.getToken();
      List listaTest = data['servicios'];
      print(data['servicios']);
      final _data = {
        'nombre': data['nombre'],
        'descripcion': data['descripcion'],
        'id_planner': idPlanner.toString(),
        'creado_por': idUsuario.toString(),
        'modificado_por': idUsuario.toString(),
        'servicios': listaTest
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
      int id_planner = await _sharedPreferences.getIdPlanner();
      String token = await _sharedPreferences.getToken();
      final response = await client.get(
          Uri.parse(configC.url +
              configC.puerto +
              '/wedding/PROVEEDORES/obtenerProveedores/$id_planner'),
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
      print(e);
    }
  }

  @override
  Future<ItemModelServicioByProv> fetchServicioByProv() async {
    try {
      int id_planner = await _sharedPreferences.getIdPlanner();
      String token = await _sharedPreferences.getToken();
      final response = await client.get(
          Uri.parse(configC.url +
              configC.puerto +
              '/wedding/PROVEEDORES/obtenerServicioByProv/$id_planner'),
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
      print(e);
    }
  }

  @override
  Future<int> deleteServicioProv(int idServcio) async {
    int id_planner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();
    final response = await client.delete(
        Uri.parse(configC.url +
            configC.puerto +
            '/wedding/PROVEEDORES/deleteServicioProv'),
        body: {
          "id_servicio": idServcio.toString(),
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
      throw ProveedoresException();
    }
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:weddingplanner/src/models/item_model_listas.dart';
import 'package:weddingplanner/src/models/item_model_preferences.dart';
import 'package:weddingplanner/src/resources/config_conection.dart';

abstract class ListasLogic {
  Future<ItemModelListas> fetchListas();
  Future<int> createLista(Map<String, dynamic> data);
  Future<int> deleteActividadesRecibir(int idActividad);
  // Future<ItemModelArticulosRecibir> fetchArticulosRecibirIdPlanner();
}

class ListasException implements Exception {}

class TokenException implements Exception {}

class CreateListasException implements Exception {}

class DeleteArticulosRecibirException implements Exception {}

class FetchListaLogic extends ListasLogic {
  SharedPreferencesT _sharedPreferences = new SharedPreferencesT();
  ConfigConection configC = new ConfigConection();
  Client client = Client();

  @override
  Future<ItemModelListas> fetchListas() async {
    print('Entro a la peticion');
    try {
      int id_planner = await _sharedPreferences.getIdPlanner();
      String token = await _sharedPreferences.getToken();
      final response = await client.get(
          Uri.parse(configC.url +
              configC.puerto +
              '/wedding/LISTAS/obtenerListaPorPlanner/$id_planner'),
          headers: {HttpHeaders.authorizationHeader: token});

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        await _sharedPreferences.setToken(data['token']);
        print('data["data"]');
        print(data["data"]);
        return ItemModelListas.fromJson(data["data"]);
      } else if (response.statusCode == 401) {
        throw TokenException();
      } else {
        throw ListasException();
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<bool> updateArticulosRecibir(Map<String, dynamic> data) async {
    if (data['descripcion'] != null && data['descripcion'] != '') {
      return true;
    } else {
      throw CreateListasException();
    }
  }

  @override
  Future<int> createLista(Map<String, dynamic> data) async {
    print('datos para la peticion');
    print(data);
    if (data['clave'] != '' &&
        data['nombre'] != '' &&
        data['descripcion'] != '') {
      print('Ento a la validacion');
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
        return 0;
      } else if (response.statusCode == 401) {
        throw TokenException();
      } else {
        throw CreateListasException();
      }
    }
  }

  Future<int> deleteActividadesRecibir(int idActividad) async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();
    int idUsuario = await _sharedPreferences.getIdUsuario();

    final response = await client.post(
        Uri.parse(configC.url + configC.puerto + ''),
        body: {"id": idPlanner.toString()},
        headers: {HttpHeaders.authorizationHeader: token});

    if (response.statusCode == 201) {
      Map<String, dynamic> responseEvento = json.decode(response.body);
      await _sharedPreferences.setToken(responseEvento['token']);
      return 0;
    } else if (response.statusCode == 401) {
      throw TokenException();
    } else {
      throw CreateListasException();
    }
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' show Client;
import 'package:weddingplanner/src/models/item_model_machotes.dart';
import 'package:weddingplanner/src/models/item_model_preferences.dart';
import 'package:weddingplanner/src/resources/config_conection.dart';

abstract class ListaMachotesLogic {
  Future<ItemModelMachotes> fetchMachotes();
  Future<bool> updateMachotes(Map<String, dynamic> data);
  Future<int> createMachotes(Map<String, dynamic> data);
}

class ListaMachotesException implements Exception {}

class TokenException implements Exception {}

class CreateMachotesException implements Exception {}

class UpdateMachotesException implements Exception {}

class FetchListaMachotesLogic extends ListaMachotesLogic {
  SharedPreferencesT _sharedPreferences = new SharedPreferencesT();
  ConfigConection confiC = new ConfigConection();
  Client client = Client();

  @override
  Future<ItemModelMachotes> fetchMachotes() async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();
    final response = await client.get(
        Uri.parse(confiC.url+confiC.puerto+'/wedding/MACHOTES/obtenerMachotes/$idPlanner'),
        headers: {HttpHeaders.authorizationHeader: token});

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return ItemModelMachotes.fromJson(data['data']);
    } else if (response.statusCode == 401) {
      throw TokenException();
    } else {
      throw ListaMachotesException();
    }
  }

  @override
  Future<bool> updateMachotes(Map<String, dynamic> data) async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idUsuario = await _sharedPreferences.getIdUsuario();
    String token = await _sharedPreferences.getToken();
    data['id_planner'] = idPlanner.toString();
    data['id_usuario'] = idUsuario.toString();
    final response = await client.post(
       Uri.parse(confiC.url+confiC.puerto+'/wedding/MACHOTES/updateMachotes'),
        body: data,
        headers: {HttpHeaders.authorizationHeader: token});

    if (response.statusCode == 201) {
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return true;
    } else if (response.statusCode == 401) {
      throw TokenException();
    } else {
      throw UpdateMachotesException();
    }
  }

  @override
  Future<int> createMachotes(Map<String, dynamic> data) async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idUsuario = await _sharedPreferences.getIdUsuario();
    String token = await _sharedPreferences.getToken();
    data['id_planner'] = idPlanner.toString();
    data['id_usuario'] = idUsuario.toString();
    final response = await client.post(
       Uri.parse(confiC.url+confiC.puerto+'/wedding/MACHOTES/createMachotes'),
        body: data,
        headers: {HttpHeaders.authorizationHeader: token});

    if (response.statusCode == 201) {
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return 0;
    } else if (response.statusCode == 401) {
      throw TokenException();
    } else {
      throw CreateMachotesException();
    }
  }
}
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' show Client;
import 'package:planning/src/models/item_model_inventario_alcohol.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/resources/config_conection.dart';

abstract class ListaInventarioAlcoholLogic {
  Future<ItemModelInventarioAlcohol> fetchInventarioAlcohol();
  Future<bool> updateInventarioAlcohol(Map<String, dynamic> data);
  Future<int> createInventarioAlcohol(Map<String, dynamic> data);
}

class ListaInventarioAlcoholException implements Exception {}

class TokenException implements Exception {}

class CreateInventarioAlcoholException implements Exception {}

class UpdateInventarioAlcoholException implements Exception {}

class FetchListaInventarioAlcoholLogic extends ListaInventarioAlcoholLogic {
  final SharedPreferencesT _sharedPreferences = SharedPreferencesT();
  ConfigConection confiC = ConfigConection();
  Client client = Client();

  @override
  Future<ItemModelInventarioAlcohol> fetchInventarioAlcohol() async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();
    final response = await client.get(
        Uri.parse(confiC.url +
            confiC.puerto +
            '/wedding/InventarioAlcohol/obtenerInventarioAlcohol/$idPlanner'),
        headers: {HttpHeaders.authorizationHeader: token});

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return ItemModelInventarioAlcohol.fromJson(data['data']);
    } else if (response.statusCode == 401) {
      throw TokenException();
    } else {
      throw ListaInventarioAlcoholException();
    }
  }

  @override
  Future<bool> updateInventarioAlcohol(Map<String, dynamic> data) async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idUsuario = await _sharedPreferences.getIdUsuario();
    String token = await _sharedPreferences.getToken();
    data['id_planner'] = idPlanner.toString();
    data['id_usuario'] = idUsuario.toString();
    final response = await client.post(
        Uri.parse(confiC.url +
            confiC.puerto +
            '/wedding/InventarioAlcohol/updateInventarioAlcohol'),
        body: data,
        headers: {HttpHeaders.authorizationHeader: token});

    if (response.statusCode == 201) {
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return true;
    } else if (response.statusCode == 401) {
      throw TokenException();
    } else {
      throw UpdateInventarioAlcoholException();
    }
  }

  @override
  Future<int> createInventarioAlcohol(Map<String, dynamic> data) async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idUsuario = await _sharedPreferences.getIdUsuario();
    data['id_usuario'] = idUsuario.toString();
    data['id_planner'] = idPlanner.toString();
    String token = await _sharedPreferences.getToken();
    final response = await client.post(
        Uri.parse(confiC.url +
            confiC.puerto +
            '/wedding/InventarioAlcohol/createInventarioAlcohol'),
        body: data,
        headers: {HttpHeaders.authorizationHeader: token});

    if (response.statusCode == 201) {
      Map<String, dynamic> res = json.decode(response.body);
      await _sharedPreferences.setToken(res['token']);
      return 0;
    } else if (response.statusCode == 401) {
      throw TokenException();
    } else {
      throw CreateInventarioAlcoholException();
    }
  }
}

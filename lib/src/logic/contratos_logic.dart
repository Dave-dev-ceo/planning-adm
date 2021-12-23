import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' show Client;
import 'package:planning/src/models/item_model_contratos.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/resources/config_conection.dart';

abstract class ListaContratosLogic {
  Future<ItemModelContratos> fetchContratos();
  Future<bool> updateContratos(Map<String, dynamic> data);
  Future<int> createContratos(Map<String, dynamic> data);
  Future<String> fetchContratosPdf(Map<String, dynamic> data);
  Future<bool> updateFile(Map<String, dynamic> data);
  Future<String> seeUploadFile(Map<String, dynamic> data);
}

class ListaContratosException implements Exception {}

class ListaContratosPdfException implements Exception {}

class TokenException implements Exception {}

class CreateContratosException implements Exception {}

class FetchListaContratosLogic extends ListaContratosLogic {
  SharedPreferencesT _sharedPreferences = new SharedPreferencesT();
  ConfigConection confiC = new ConfigConection();
  Client client = Client();

  @override
  Future<ItemModelContratos> fetchContratos() async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idEvento = await _sharedPreferences.getIdEvento();
    String token = await _sharedPreferences.getToken();
    final response = await client.get(
        Uri.parse(confiC.url +
            confiC.puerto +
            '/wedding/Contratos/obtenerContratos/$idPlanner/$idEvento'),
        headers: {HttpHeaders.authorizationHeader: token});

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return ItemModelContratos.fromJson(data['data']);
    } else if (response.statusCode == 401) {
      throw TokenException();
    } else {
      throw ListaContratosException();
    }
  }

  @override
  Future<bool> updateContratos(Map<String, dynamic> data) async {
    if (data['descripcion'] != null && data['descripcion'] != "") {
      return true; //int.parse(data['id_estatus_invitado']);
    } else {
      throw CreateContratosException();
    }
  }

  @override
  Future<int> createContratos(Map<String, dynamic> data) async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idEvento = await _sharedPreferences.getIdEvento();
    String token = await _sharedPreferences.getToken();
    data['id_planner'] = idPlanner.toString();
    data['id_evento'] = idEvento.toString();
    final response = await client.post(
        Uri.parse(
            confiC.url + confiC.puerto + '/wedding/MACHOTES/createContratos'),
        body: data,
        headers: {HttpHeaders.authorizationHeader: token});

    if (response.statusCode == 201) {
      return 0;
    } else if (response.statusCode == 401) {
      throw TokenException();
    } else {
      throw CreateContratosException();
    }
  }

  @override
  Future<String> fetchContratosPdf(Map<String, dynamic> data) async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idEvento = await _sharedPreferences.getIdEvento();
    String token = await _sharedPreferences.getToken();
    data['id_planner'] = idPlanner.toString();
    data['id_evento'] = idEvento.toString();
    final response = await client.post(
        Uri.parse(confiC.url + confiC.puerto + '/wedding/PDF/createPDF'),
        body: data,
        headers: {HttpHeaders.authorizationHeader: token});

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return data['data'];
    } else if (response.statusCode == 401) {
      throw TokenException();
    } else {
      throw ListaContratosPdfException();
    }
  }

  @override
  Future<bool> updateFile(Map<String, dynamic> data) async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idEvento = await _sharedPreferences.getIdEvento();
    String token = await _sharedPreferences.getToken();

    data['id_planner'] = idPlanner.toString();
    data['id_evento'] = idEvento.toString();

    final response = await client.post(
        Uri.parse(confiC.url + confiC.puerto + '/wedding/Contratos/uploadPDF'),
        body: jsonEncode(data),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          HttpHeaders.authorizationHeader: token
        });

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return true;
    } else if (response.statusCode == 401) {
      throw TokenException();
    } else {
      throw ListaContratosPdfException();
    }
  }

  @override
  Future<String> seeUploadFile(Map<String, dynamic> data) async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idEvento = await _sharedPreferences.getIdEvento();
    String token = await _sharedPreferences.getToken();
    data['id_planner'] = idPlanner.toString();
    data['id_evento'] = idEvento.toString();
    final response = await client.post(
        Uri.parse(confiC.url + confiC.puerto + '/wedding/PDF/seeUploadFile'),
        body: data,
        headers: {HttpHeaders.authorizationHeader: token});

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return data['data'];
    } else if (response.statusCode == 401) {
      throw TokenException();
    } else {
      throw ListaContratosPdfException();
    }
  }
}

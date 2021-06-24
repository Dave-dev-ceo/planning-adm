import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' show Client;
import 'package:weddingplanner/src/models/item_model_evento.dart';
import 'package:weddingplanner/src/models/item_model_eventos.dart';
import 'package:weddingplanner/src/models/item_model_preferences.dart';
import 'package:weddingplanner/src/resources/config_conection.dart';

abstract class ListaEventosLogic {
  Future<ItemModelEventos> fetchEventos();
  Future<Map<String, dynamic>> createEventos(Map<String, dynamic> dataEvento);
  Future<ItemModelEvento> fetchEventoPorId(String id_evento);
}

class ListaEventosException implements Exception {}

class CreateEventoException implements Exception {}

class EventoPorIdException implements Exception {}

class TokenException implements Exception {}

class FetchListaEventosLogic extends ListaEventosLogic {
  SharedPreferencesT _sharedPreferences = new SharedPreferencesT();
  ConfigConection confiC = new ConfigConection();
  Client client = Client();

  @override
  Future<ItemModelEventos> fetchEventos() async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();
    final response = await client.get(
        Uri.parse(confiC.url +
            confiC.puerto +
            '/wedding/EVENTOS/obtenerEventos/$idPlanner'),
        headers: {HttpHeaders.authorizationHeader: token});

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return ItemModelEventos.fromJson(data['data']);
    } else if (response.statusCode == 401) {
      await _sharedPreferences.clear();
      throw TokenException();
    } else {
      throw ListaEventosException();
    }
  }

  @override
  Future<ItemModelEvento> fetchEventoPorId(String id_evento) async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idEvento = await _sharedPreferences.getIdEvento();
    String token = await _sharedPreferences.getToken();
    print('idPlanner -> ' + idPlanner.toString());
    final response = await client.post(
        Uri.parse(confiC.url +
            confiC.puerto +
            '/wedding/EVENTOS/obtenerEventoPorId/'),
        headers: {
          HttpHeaders.authorizationHeader: token
        },
        body: {
          'id_planner': idPlanner.toString(),
          'id_evento': id_evento.toString()
        });
    // var uri = Uri.parse(
    //     confiC.url + confiC.puerto + '/wedding/EVENTOS/obtenerEventoPorId/');
    // var header = {HttpHeaders.authorizationHeader: token};
    // final response = await client.post(uri, headers: header, body: data);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return ItemModelEvento.fromJson(data['data']);
    } else if (response.statusCode == 401) {
      await _sharedPreferences.clear();
      throw TokenException();
    } else {
      throw EventoPorIdException();
    }
  }

  @override
  Future<Map<String, dynamic>> createEventos(
      Map<String, dynamic> dataEvento) async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();
    int idUsuario = await _sharedPreferences.getIdUsuario();
    dataEvento['id_planner'] = idPlanner.toString();
    dataEvento['id_usuario'] = idUsuario.toString();
    final response = await client.post(
        Uri.parse(
            confiC.url + confiC.puerto + '/wedding/EVENTOS/createEventos'),
        body: dataEvento,
        headers: {HttpHeaders.authorizationHeader: token});

    if (response.statusCode == 201) {
      Map<String, dynamic> responseEvento = json.decode(response.body);
      return responseEvento;
    } else if (response.statusCode == 401) {
      throw TokenException();
    } else {
      throw CreateEventoException();
    }
  }
}

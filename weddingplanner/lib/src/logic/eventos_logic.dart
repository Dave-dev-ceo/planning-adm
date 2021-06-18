import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' show Client;
import 'package:weddingplanner/src/models/item_model_eventos.dart';
import 'package:weddingplanner/src/models/item_model_preferences.dart';
import 'package:weddingplanner/src/resources/config_conection.dart';

abstract class ListaEventosLogic {
  Future<ItemModelEventos> fetchEventos();
  Future<Map<String,dynamic>> createEventos(Map<String,dynamic> dataEvento);
}

class ListaEventosException implements Exception {}
class CreateEventoException implements Exception {}

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
       Uri.parse(confiC.url+confiC.puerto+'/wedding/EVENTOS/obtenerEventos/$idPlanner'),
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
  Future<Map<String, dynamic>> createEventos(Map<String,dynamic> dataEvento) async{
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();
    int idUsuario = await _sharedPreferences.getIdUsuario();
    dataEvento['id_planner'] = idPlanner.toString();
    dataEvento['id_usuario'] = idUsuario.toString();
    final response = await client.post(
        Uri.parse(confiC.url+confiC.puerto+'/wedding/EVENTOS/createEventos'),
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

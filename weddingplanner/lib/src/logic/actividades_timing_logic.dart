import 'dart:convert';
import 'dart:io';

import 'package:weddingplanner/src/models/item_model_actividades_timings.dart';
import 'package:weddingplanner/src/models/item_model_preferences.dart';
import 'package:http/http.dart' show Client;
import 'package:weddingplanner/src/models/item_model_timings.dart';

import 'package:weddingplanner/src/resources/config_conection.dart';

abstract class ActividadesTimingsLogic {
  Future<ItemModelActividadesTimings> fetchActividadesTimingsPorPlanner(int idTiming);
  Future<int> createActividadesTiming(Map<String, dynamic> dataTiming, int idTiming);
  Future<int> deleteActividadesTiming(int idActividadTiming, int idTiming);
  
  Future<ItemModelActividadesTimings> fetchActividadesTimingsIdPorPlanner();
  Future<ItemModelTimings> fetchTimingsPorPlanner();
  Future<int> createTiming(Map<String, dynamic> dataTiming);
  Future<ItemModelTimings> fetchTimingsEvento();
  Future<ItemModelActividadesTimings> fetchActividadesTimings();
  Future<int> createActividadesEvento(Map<String, dynamic> dataTiming);
  Future<ItemModelActividadesTimings> fetchActividadesEvento();
  Future<ItemModelTimings> fetchNoInEvento();
  Future<ItemModelActividadesTimings> fetchNoInEventoActividades();
}

class ListaActividadesTimingsException implements Exception {}
class TokenException implements Exception {}
class CreateActividadesTimingException implements Exception {}
class DeleteActividadesTimingException implements Exception {}
class FetchListaActividadesTimingsLogic extends ActividadesTimingsLogic {
  SharedPreferencesT _sharedPreferences = new SharedPreferencesT();

  ConfigConection confiC = new ConfigConection();
  Client client = Client();

  @override
  Future<ItemModelActividadesTimings> fetchActividadesTimingsPorPlanner(int idTiming) async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();

    final response = await client.post(
        Uri.parse(confiC.url +
            confiC.puerto +
            '/wedding/ACTIVIDADESTIMINGS/obtenerActividadesTimingsPorPlanner'),
        body: {'id_planner': idPlanner.toString(),'id_tipo_timing':idTiming.toString()},
        headers: {HttpHeaders.authorizationHeader: token});

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return ItemModelActividadesTimings.fromJson(data['data']);
    } else if (response.statusCode == 401) {
      return null;
    } else {
      throw ListaActividadesTimingsException;
    }
  }

  @override
  Future<int> createActividadesTiming(Map<String, dynamic> dataTiming, int idTiming) async{

    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();
    int idUsuario = await _sharedPreferences.getIdUsuario();
    dataTiming['id_tipo_timing'] = idTiming.toString();
    dataTiming['id_planner'] = idPlanner.toString();
    dataTiming['id_usuario'] = idUsuario.toString();
    final response = await client.post(
        Uri.parse(
            confiC.url + confiC.puerto + '/wedding/ACTIVIDADESTIMINGS/createActividadesTimings'),
        body: dataTiming,
        headers: {HttpHeaders.authorizationHeader: token});

    if (response.statusCode == 201) {
      Map<String, dynamic> responseEvento = json.decode(response.body);
      await _sharedPreferences.setToken(responseEvento['token']);
      return 0;
    } else if (response.statusCode == 401) {
      throw TokenException();
    } else {
      throw CreateActividadesTimingException();
    }
  }

  @override
  Future<int> deleteActividadesTiming(int idActividadTiming, int idTiming) async{
    
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();
    int idUsuario = await _sharedPreferences.getIdUsuario();
    
    final response = await client.post(
        Uri.parse(
            confiC.url + confiC.puerto + '/wedding/ACTIVIDADESTIMINGS/deleteActividadesTimings'),
        body: {"id_planner":idPlanner.toString(),"id_usuario":idUsuario.toString(),"id_actividad_timing":idActividadTiming.toString(),"id_tipo_timing":idTiming.toString()},
        headers: {HttpHeaders.authorizationHeader: token});

    if (response.statusCode == 201) {
      Map<String, dynamic> responseEvento = json.decode(response.body);
      await _sharedPreferences.setToken(responseEvento['token']);
      return 0;
    } else if (response.statusCode == 401) {
      throw TokenException();
    } else {
      throw CreateActividadesTimingException();
    }
  }

  @override
  Future<ItemModelActividadesTimings> fetchActividadesTimingsIdPorPlanner() async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idEvento = await _sharedPreferences.getIdEvento();
    String token = await _sharedPreferences.getToken();

    final response = await client.post(
        Uri.parse(confiC.url +
            confiC.puerto +
            '/wedding/ACTIVIDADESTIMINGS/obtenerActividadesTimingsIdPorPlanner'),
        body: {'id_planner': idPlanner.toString(), 'id_evento':idEvento.toString()},
        headers: {HttpHeaders.authorizationHeader: token});

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return ItemModelActividadesTimings.fromJsonEvento(data['data']);
    } else if (response.statusCode == 401) {
      return null;
    } else {
      throw ListaActividadesTimingsException;
    }
  }

  @override
  Future<ItemModelTimings> fetchTimingsPorPlanner() async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();

    final response = await client.post(
        Uri.parse(confiC.url +
            confiC.puerto +
            '/wedding/TIMINGS/obtenerTimingsPorPlanner'),
        body: {'id_planner': idPlanner.toString()},
        headers: {HttpHeaders.authorizationHeader: token});

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return ItemModelTimings.fromJson(data['data']);
    } else if (response.statusCode == 401) {
      return null;
    } else {
      throw ListaActividadesTimingsException;
    }
  }

  @override
  Future<int> createTiming(Map<String, dynamic> dataTiming) async{

    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idEvento = await _sharedPreferences.getIdEvento();
    String token = await _sharedPreferences.getToken();
    int idUsuario = await _sharedPreferences.getIdUsuario();
    dataTiming['id_planner'] = idPlanner.toString();
    dataTiming['id_usuario'] = idUsuario.toString();
    dataTiming['id_evento'] = idEvento.toString();
    final response = await client.post(
        Uri.parse(
            confiC.url + confiC.puerto + '/wedding/ACTIVIDADESTIMINGS/createTimings'),
        body: dataTiming,
        headers: {HttpHeaders.authorizationHeader: token});

    if (response.statusCode == 201) {
      Map<String, dynamic> responseEvento = json.decode(response.body);
      await _sharedPreferences.setToken(responseEvento['token']);
      return 0;
    } else if (response.statusCode == 401) {
      throw TokenException();
    } else {
      throw CreateActividadesTimingException();
    }
  }

  @override
  Future<ItemModelTimings> fetchTimingsEvento() async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idEvento = await _sharedPreferences.getIdEvento();
    String token = await _sharedPreferences.getToken();

    final response = await client.post(
        Uri.parse(confiC.url +
            confiC.puerto +
            '/wedding/TIMINGS/obtenerTimingsEvento'),
        body: {'id_planner': idPlanner.toString(), 'id_evento':idEvento.toString()},
        headers: {HttpHeaders.authorizationHeader: token});

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return ItemModelTimings.fromJson(data['data']);
    } else if (response.statusCode == 401) {
      return null;
    } else {
      throw ListaActividadesTimingsException;
    }
  }

  @override
  Future<ItemModelActividadesTimings> fetchActividadesTimings() async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();

    final response = await client.post(
        Uri.parse(confiC.url +
            confiC.puerto +
            '/wedding/ACTIVIDADESTIMINGS/obtenerActividadesTimings'),
        body: {'id_planner': idPlanner.toString()},
        headers: {HttpHeaders.authorizationHeader: token});

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return ItemModelActividadesTimings.fromJsonEvento(data['data']);
    } else if (response.statusCode == 401) {
      return null;
    } else {
      throw ListaActividadesTimingsException;
    }
  }

  @override
  Future<int> createActividadesEvento(Map<String, dynamic> dataTiming) async{

    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idEvento = await _sharedPreferences.getIdEvento();
    String token = await _sharedPreferences.getToken();
    int idUsuario = await _sharedPreferences.getIdUsuario();
    dataTiming['id_planner'] = idPlanner.toString();
    dataTiming['id_usuario'] = idUsuario.toString();
    dataTiming['id_evento'] = idEvento.toString();
    final response = await client.post(
        Uri.parse(
            confiC.url + confiC.puerto + '/wedding/ACTIVIDADESTIMINGS/createActividadesEvento'),
        body: dataTiming,
        headers: {HttpHeaders.authorizationHeader: token});

    if (response.statusCode == 201) {
      Map<String, dynamic> responseEvento = json.decode(response.body);
      await _sharedPreferences.setToken(responseEvento['token']);
      return 0;
    } else if (response.statusCode == 401) {
      throw TokenException();
    } else {
      throw CreateActividadesTimingException();
    }
  }

  @override
  Future<ItemModelActividadesTimings> fetchActividadesEvento() async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idEvento = await _sharedPreferences.getIdEvento();
    String token = await _sharedPreferences.getToken();

    final response = await client.post(
        Uri.parse(confiC.url +
            confiC.puerto +
            '/wedding/ACTIVIDADESTIMINGS/obtenerActividadesEventoPorEvento'),
        body: {'id_planner': idPlanner.toString(),'id_evento':idEvento.toString()},
        headers: {HttpHeaders.authorizationHeader: token});

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return ItemModelActividadesTimings.fromJson(data['data']);
    } else if (response.statusCode == 401) {
      return null;
    } else {
      throw ListaActividadesTimingsException;
    }
  }

  @override
  Future<ItemModelTimings> fetchNoInEvento() async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idEvento = await _sharedPreferences.getIdEvento();
    String token = await _sharedPreferences.getToken();

    final response = await client.post(
        Uri.parse(confiC.url +
            confiC.puerto +
            '/wedding/ACTIVIDADESTIMINGS/obtenerNoInEvento'),
        body: {'id_planner': idPlanner.toString(),'id_evento':idEvento.toString()},
        headers: {HttpHeaders.authorizationHeader: token});

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return ItemModelTimings.fromJson(data['data']);
    } else if (response.statusCode == 401) {
      return null;
    } else {
      throw ListaActividadesTimingsException;
    }
  }

  @override
  Future<ItemModelActividadesTimings> fetchNoInEventoActividades() async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idEvento = await _sharedPreferences.getIdEvento();
    String token = await _sharedPreferences.getToken();

    final response = await client.post(
        Uri.parse(confiC.url +
            confiC.puerto +
            '/wedding/ACTIVIDADESTIMINGS/obtenerNoInEventoActividades'),
        body: {'id_planner': idPlanner.toString(),'id_evento':idEvento.toString()},
        headers: {HttpHeaders.authorizationHeader: token});

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return ItemModelActividadesTimings.fromJson(data['data']);
    } else if (response.statusCode == 401) {
      return null;
    } else {
      throw ListaActividadesTimingsException;
    }
  }

}
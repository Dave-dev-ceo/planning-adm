import 'dart:convert';
import 'dart:io';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:planning/src/models/item_model_evento.dart';
import 'package:planning/src/models/item_model_eventos.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/resources/config_conection.dart';

abstract class ListaEventosLogic {
  Future<ItemModelEventos> fetchEventos(String? estatus);
  Future<int> createEventos(Map<String, dynamic> dataEvento);
  Future<int?> editarEvento(Map<String, dynamic> dataEvento);
  Future<ItemModelEvento> fetchEventoPorId(String idEvento);
  Future<String?> donwloadPDFEvento();
  Future<String?> getFechaEvento();
}

class ListaEventosException implements Exception {}

class CreateEventoException implements Exception {}

class EditarEventoException implements Exception {}

class EventoPorIdException implements Exception {}

class TokenException implements Exception {}

class FetchListaEventosLogic extends ListaEventosLogic {
  final SharedPreferencesT _sharedPreferences = SharedPreferencesT();
  ConfigConection confiC = ConfigConection();

  @override
  Future<ItemModelEventos> fetchEventos(String? estatus) async {
    bool desconectado = await _sharedPreferences.getModoConexion();
    int? idUsuario = await _sharedPreferences.getIdUsuario();
    int? idPlanner = await _sharedPreferences.getIdPlanner();
    if (desconectado) {
      if (!Hive.isBoxOpen('infoEventos')) {
        await Hive.openBox<dynamic>('infoEventos');
      }
      final boxInfoEventos = Hive.box<dynamic>('infoEventos');
      final listaEventos = boxInfoEventos.values
          .where((e) => e['id_planner'] == idPlanner)
          .toList();
      final mapEventos = {'evento': listaEventos};
      await boxInfoEventos.close();
      return ItemModelEventos.fromJson(mapEventos);
    } else {
      String? token = await _sharedPreferences.getToken();
      final response = await http.post(
          Uri.parse(
              '${confiC.url}${confiC.puerto}/wedding/EVENTOS/obtenerEventos/'),
          body: {
            'id_usuario': idUsuario.toString(),
            'id_planner': idPlanner.toString(),
            'estatus': estatus
          },
          headers: {
            HttpHeaders.authorizationHeader: token ?? ''
          });

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
  }

  @override
  Future<ItemModelEvento> fetchEventoPorId(String idEvento) async {
    bool desconectado = await _sharedPreferences.getModoConexion();
    int? idPlanner = await _sharedPreferences.getIdPlanner();
    String? token = await _sharedPreferences.getToken();

    if (desconectado) {
      if (!Hive.isBoxOpen('infoEventos')) {
        await Hive.openBox<dynamic>('infoEventos');
      }
      final boxInfoEventos = Hive.box<dynamic>('infoEventos');
      final infoEvento = boxInfoEventos.values
          .where((c) => c['id_evento'] == int.parse(idEvento))
          .toList()[0];
      await boxInfoEventos.close();
      final mapInfoEvento = Map<String, dynamic>.from(infoEvento);
      return ItemModelEvento.fromJsonUnit(mapInfoEvento);
    } else {
      final response = await http.post(
          Uri.parse(
              '${confiC.url}${confiC.puerto}/wedding/EVENTOS/obtenerEventoPorId/'),
          headers: {HttpHeaders.authorizationHeader: token ?? ''},
          body: {'id_planner': idPlanner.toString(), 'id_evento': idEvento});
      // var uri = Uri.parse(
      //     confiC.url + confiC.puerto + '/wedding/EVENTOS/obtenerEventoPorId/');
      // var header = {HttpHeaders.authorizationHeader: token ?? ''};
      // final response = await http.post(uri, headers: header, body: data);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        await _sharedPreferences.setToken(data['token']);
        return ItemModelEvento.fromJsonUnit(data['data']['evento']);
      } else if (response.statusCode == 401) {
        await _sharedPreferences.clear();
        throw TokenException();
      } else {
        throw EventoPorIdException();
      }
    }
  }

  @override
  Future<int> createEventos(Map<String, dynamic> dataEvento) async {
    int? idPlanner = await _sharedPreferences.getIdPlanner();
    String? token = await _sharedPreferences.getToken();
    int? idUsuario = await _sharedPreferences.getIdUsuario();
    dataEvento['id_planner'] = idPlanner.toString();
    dataEvento['id_usuario'] = idUsuario.toString();
    final response = await http.post(
        Uri.parse(
            '${confiC.url}${confiC.puerto}/wedding/EVENTOS/createEventos'),
        body: dataEvento,
        headers: {HttpHeaders.authorizationHeader: token ?? ''});

    if (response.statusCode == 201) {
      Map<String, dynamic> responseEvento = json.decode(response.body);
      await _sharedPreferences.setToken(responseEvento['token']);
      return 0;
    } else if (response.statusCode == 401) {
      throw TokenException();
    } else {
      throw CreateEventoException();
    }
  }

  @override
  Future<int?> editarEvento(Map<String, dynamic> dataEvento) async {
    int? idPlanner = await _sharedPreferences.getIdPlanner();
    String? token = await _sharedPreferences.getToken();
    int? idUsuario = await _sharedPreferences.getIdUsuario();
    dataEvento['id_planner'] = idPlanner.toString();
    dataEvento['id_usuario'] = idUsuario.toString();
    final response = await http.post(
        Uri.parse('${confiC.url}${confiC.puerto}/wedding/EVENTOS/editarEvento'),
        body: dataEvento,
        headers: {HttpHeaders.authorizationHeader: token ?? ''});
    if (response.statusCode == 201) {
      Map<String, dynamic> responseEvento = json.decode(response.body);
      await _sharedPreferences.setToken(responseEvento['token']);
      return responseEvento['data']['id_evento'];
    } else if (response.statusCode == 401) {
      throw TokenException();
    } else {
      throw EditarEventoException();
    }
  }

  @override
  Future<String?> donwloadPDFEvento() async {
    String? token = await _sharedPreferences.getToken();
    int? idPlanner = await _sharedPreferences.getIdPlanner();
    int? idEvento = await _sharedPreferences.getIdEvento();

    const endpoint = '/wedding/EVENTOS/donwloadPDFEvento';

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token ?? ''
    };

    final data = {
      'idPlanner': idPlanner,
      'idEvento': idEvento,
    };

    final resp = await http.post(
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

  @override
  Future<String?> getFechaEvento() async {
    String? token = await _sharedPreferences.getToken();
    int? idPlanner = await _sharedPreferences.getIdPlanner();
    int? idEvento = await _sharedPreferences.getIdEvento();

    const endpoint = '/wedding/EVENTOS/getFechaEvento';

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token ?? ''
    };

    final data = {
      'idPlanner': idPlanner,
      'idEvento': idEvento,
    };

    final resp = await http.post(
      Uri.parse(confiC.url! + confiC.puerto! + endpoint),
      body: json.encode(data),
      headers: headers,
    );

    if (resp.statusCode == 200) {
      return json.decode(resp.body)['fecha'];
    } else {
      return null;
    }
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' show Client;

import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/resources/config_conection.dart';

import 'package:planning/src/models/item_model_asistencia.dart';

abstract class AsistenciaLogic {
  Future<ItemModelAsistencia> fetchAsistenciaPorPlanner();
  Future<int> saveAsistencia(int idInvitado, bool asistencia,
      {int idAcompanante});
  Future<String> downloadPDFAsistencia();
}

class ListaAsistenciaException implements Exception {}

class TokenException implements Exception {}

class FetchListaAsistenciaLogic extends AsistenciaLogic {
  final SharedPreferencesT _sharedPreferences = SharedPreferencesT();
  ConfigConection confiC = ConfigConection();
  Client client = Client();

  @override
  Future<ItemModelAsistencia> fetchAsistenciaPorPlanner() async {
    // implement fetchAsistenciaPorPlanner
    bool desconectado = await _sharedPreferences.getModoConexion();
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idEvento = await _sharedPreferences.getIdEvento();
    String token = await _sharedPreferences.getToken();

    if (desconectado) {
      if (!Hive.isBoxOpen('asistencias')) {
        await Hive.openBox<dynamic>('asistencias');
      }
      final boxAsistencias = Hive.box<dynamic>('asistencias');
      final listaAsistencias = boxAsistencias.values
          .where((a) =>
              a['id_evento'] == idEvento && a['id_estatus_invitado'] == 1)
          .toList();
      await boxAsistencias.close();
      return ItemModelAsistencia.fromJson(listaAsistencias);
    } else {
      final response = await client.post(
          Uri.parse(
              '${confiC.url}${confiC.puerto}/wedding/ASISTENCIA/obtenerAsistenciasPorPlanner'),
          body: {
            'id_planner': idPlanner.toString(),
            'id_evento': idEvento.toString()
          },
          headers: {
            HttpHeaders.authorizationHeader: token
          });

      if (response.statusCode == 200) {
        // If the call to the server was successful, parse the JSON
        Map<String, dynamic> data = json.decode(response.body);
        await _sharedPreferences.setToken(data['token']);
        return ItemModelAsistencia.fromJson(data['data']);
      } else if (response.statusCode == 401) {
        return null;
      } else {
        throw ListaAsistenciaException;
      }
    }
  }

  @override
  Future<int> saveAsistencia(int idInvitado, bool asistencia,
      {int idAcompanante}) async {
    bool desconectado = await _sharedPreferences.getModoConexion();
    int idPlanner = await _sharedPreferences.getIdPlanner();
    if (desconectado) {
      if (!Hive.isBoxOpen('asistencias')) {
        await Hive.openBox<dynamic>('asistencias');
      }
      final boxAsistencias = Hive.box<dynamic>('asistencias');
      final listaAsistencias = [...boxAsistencias.values];
      final asistencias =
          listaAsistencias.where((a) => a['id_invitado'] == idInvitado);
      if (!Hive.isBoxOpen('cambiosAsistencias')) {
        await Hive.openBox<dynamic>('cambiosAsistencias');
      }
      final boxCambiosAsistencias = Hive.box<dynamic>('cambiosAsistencias');
      final listaCambiosAsistencias = [...boxCambiosAsistencias.values];
      for (var as in asistencias) {
        final indexAsistencia = listaAsistencias.indexWhere((a) =>
            as['id_invitado'] == a['id_invitado'] &&
            as['id_acompanante'] == a['id_acompanante']);
        as['asistencia'] = asistencia;
        await boxAsistencias.putAt(indexAsistencia, as);
        final indexCambio = listaCambiosAsistencias.indexWhere(
            (a) => as['id_invitado'].toString() == a['id_invitado'].toString());
        final cambio = {
          'id_invitado': idInvitado.toString(),
          'asistencia': asistencia.toString(),
          'id_planner': idPlanner.toString(),
        };
        if (indexCambio != -1) {
          await boxCambiosAsistencias.putAt(indexCambio, cambio);
        } else {
          await boxCambiosAsistencias.add(cambio);
        }
      }
    } else {
      String token = await _sharedPreferences.getToken();

      await client.post(
          Uri.parse(
              '${confiC.url}${confiC.puerto}/wedding/ASISTENCIA/saveAsistenciasPorPlanner'),
          body: {
            'id_invitado': idInvitado.toString(),
            'id_acompanante': idAcompanante.toString(),
            'asistencia': asistencia.toString(),
            'id_planner': idPlanner.toString()
          },
          headers: {
            HttpHeaders.authorizationHeader: token
          });
    }
    return 0;
  }

  @override
  Future<String> downloadPDFAsistencia() async {
    String token = await _sharedPreferences.getToken();
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idEvento = await _sharedPreferences.getIdEvento();

    const endpoint = '/wedding/ASISTENCIA/downloadPDFAsistencia';

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token
    };

    final data = {
      'idPlanner': idPlanner,
      'idEvento': idEvento,
    };

    final resp = await client.post(
      Uri.parse(confiC.url + confiC.puerto + endpoint),
      body: json.encode(data),
      headers: headers,
    );

    if (resp.statusCode == 200) {
      return json.decode(resp.body)['pdf'];
    } else {
      return null;
    }
  }
}

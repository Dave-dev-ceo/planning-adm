// imports flutter/dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' show Client;

// imports weeding
import 'package:weddingplanner/src/models/item_model_preferences.dart';
import 'package:weddingplanner/src/resources/config_conection.dart';

// import model
import 'package:weddingplanner/src/models/item_model_add_contratos.dart';

// clase abstracta
abstract class AddContratosLogic {
  Future<ItemModelAddContratos> selectContratosFromPlanner();
  Future<ItemModelAddContratos> selectContratosArchivoPlaner(int idMachote);
  Future<bool> inserContrato(Map contrato);
}

class ConsultasAddContratosLogic extends AddContratosLogic {
  // variables configuracion
  SharedPreferencesT _sharedPreferences = new SharedPreferencesT();
  ConfigConection confiC = new ConfigConection();
  Client client = Client();

  @override
  Future<ItemModelAddContratos> selectContratosFromPlanner() async {
    // variables
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idEvento = await _sharedPreferences.getIdEvento();
    String token = await _sharedPreferences.getToken();

    // pedido al servidor
    final response = await client.post(
        Uri.parse(confiC.url +
            confiC.puerto +
            '/wedding/ADDCONTRATOS/selectContratosPlaner'),
        body: {
          'id_planner': idPlanner.toString(),
          "id_evento": idEvento.toString()
        },
        headers: {
          HttpHeaders.authorizationHeader: token
        });

    // filtro
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return ItemModelAddContratos.fromJson(data['data']);
    } else if (response.statusCode == 401) {
      throw TokenException();
    } else {
      throw AutorizacionException();
    }
  }

  @override
  Future<ItemModelAddContratos> selectContratosArchivoPlaner(
      int idMachote) async {
    // variables
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();

    // pedido al servidor
    final response = await client.post(
        Uri.parse(confiC.url +
            confiC.puerto +
            '/wedding/ADDCONTRATOS/selectContratosArchivoPlaner'),
        body: {
          'id_planner': idPlanner.toString(),
          'id_machote': idMachote.toString()
        },
        headers: {
          HttpHeaders.authorizationHeader: token
        });

    // filtro
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return ItemModelAddContratos.fromJson(data['data']);
    } else if (response.statusCode == 401) {
      throw TokenException();
    } else {
      throw AutorizacionException();
    }
  }

  @override
  Future<bool> inserContrato(Map contrato) async {
    // variables
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idEvento = await _sharedPreferences.getIdEvento();
    String token = await _sharedPreferences.getToken();

    contrato['id_planner'] = idPlanner.toString();
    contrato['id_evento'] = idEvento.toString();

    // pedido al servidor
    final response = await client.post(
        Uri.parse(
            confiC.url + confiC.puerto + '/wedding/ADDCONTRATOS/inserContrato'),
        body: contrato,
        headers: {HttpHeaders.authorizationHeader: token});

    // filtro
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return true;
    } else if (response.statusCode == 401) {
      throw TokenException();
    } else {
      throw AutorizacionException();
    }
  }
}

// clases para manejar errores
class AutorizacionException implements Exception {}

class TokenException implements Exception {}

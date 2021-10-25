// imports flutter/dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' show Client;
import 'package:weddingplanner/src/resources/config_conection.dart';

// imports weeding
import 'package:weddingplanner/src/models/item_model_preferences.dart';

// import model
import 'package:weddingplanner/src/models/item_model_add_contratos.dart';

// clase abstracta
abstract class AddContratosLogic {
  Future<ItemModelAddContratos> selectContratosFromPlanner();
  Future<ItemModelAddContratos> selectContratosArchivoPlaner(int idMachote);
  Future<bool> inserContrato(Map contrato);
  Future<ItemModelAddContratos> selectContratosEvento();
  Future<bool> borrarContratoEvento(int id);
  Future<String> fetchContratosPdf(Map<String, dynamic> data);
  Future<bool> updateContratoEvento(int id, String archivo);
  Future<String> updateValContratos(Map<String, dynamic> data);
  Future<String> fetchValContratos(String _machote);
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

  @override
  Future<ItemModelAddContratos> selectContratosEvento() async {
    // variables
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idEvento = await _sharedPreferences.getIdEvento();
    String token = await _sharedPreferences.getToken();

    // pedido al servidor
    final response = await client.post(
        Uri.parse(confiC.url +
            confiC.puerto +
            '/wedding/ADDCONTRATOS/selectContratosEvento'),
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
  Future<bool> borrarContratoEvento(int id) async {
    // variables
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();

    // pedido al servidor
    final response = await client.post(
        Uri.parse(confiC.url +
            confiC.puerto +
            '/wedding/ADDCONTRATOS/borrarContratoEvento'),
        body: {
          'id_planner': idPlanner.toString(),
          "id_contrato": id.toString()
        },
        headers: {
          HttpHeaders.authorizationHeader: token
        });

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
      throw AutorizacionException();
    }
  }

  @override
  Future<bool> updateContratoEvento(int id, String archivo) async {
    // variables
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();

    // pedido al servidor
    final response = await client.post(
        Uri.parse(confiC.url +
            confiC.puerto +
            '/wedding/ADDCONTRATOS/updateContratoEvento'),
        body: {
          'id_planner': idPlanner.toString(),
          'id_contrato': id.toString(),
          'archivo': archivo
        },
        headers: {
          HttpHeaders.authorizationHeader: token
        });

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

  @override
  Future<String> updateValContratos(Map<String, dynamic> data) async {
    print('llego a login');
    print(data);
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();
    data['id_planner'] = idPlanner.toString();
    data['id_contrato'] = data['id_contrato'].toString();
    print(data);
    final response = await client.post(
        Uri.parse(
            confiC.url + confiC.puerto + '/wedding/PDF/updateValContratos'),
        body: data,
        headers: {HttpHeaders.authorizationHeader: token});
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return data['data'];
    } else if (response.statusCode == 401) {
      throw TokenException();
    }
  }

  @override
  Future<String> fetchValContratos(String _machote) async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idEvento = await _sharedPreferences.getIdEvento();
    String token = await _sharedPreferences.getToken();

    Map<String, dynamic> json = {
      'id_planner': idPlanner.toString(),
      'id_evento': idEvento.toString(),
      'machote': _machote
    };
    final response = await client.post(
        Uri.parse(confiC.url +
            confiC.puerto +
            '/wedding/PDF/generarValorEtiquetasContrato'),
        body: json,
        headers: {HttpHeaders.authorizationHeader: token});
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return data['data'].toString();
    } else if (response.statusCode == 401) {
      throw TokenException();
    }
  }
}

// clases para manejar errores
class AutorizacionException implements Exception {}

class TokenException implements Exception {}

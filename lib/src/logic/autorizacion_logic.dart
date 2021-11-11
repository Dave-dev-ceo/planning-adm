// imports from flutter/dart
import 'package:http/http.dart' show Client;
import 'dart:io';
import 'dart:convert';

// imports from wedding
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/resources/config_conection.dart';

// import model
import 'package:planning/src/models/item_model_autorizacion.dart';

// clase abstracta con los metodos
abstract class AutorizacionLogic {
  Future<ItemModelAutorizacion> selectAutorizacion();
  Future<bool> createAutorizacion(Map autorizacion);
  Future<ItemModelAutorizacion> selectEvidencia(int idAuditorizacion);
  Future<bool> updateAutorizacion(
      int idAuditorizacion, String descripcion, String comentario);
  Future<bool> deleteAutorizacion(int idAuditorizacion);
  Future<bool> deleteImage(int idEvidencia);
  Future<bool> addImage(Map evidencia);
  Future<bool> updateImage(int id, String descripcion);
}

// class exiende - van las consultas
class ConsultasAutorizacionLogic extends AutorizacionLogic {
  // variables de configuracion
  SharedPreferencesT _sharedPreferences = new SharedPreferencesT();
  ConfigConection confiC = new ConfigConection();
  Client client = Client();

  @override
  Future<ItemModelAutorizacion> selectAutorizacion() async {
    // variables
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idEvento = await _sharedPreferences.getIdEvento();
    String token = await _sharedPreferences.getToken();

    // pedido al servidor
    final response = await client.post(
        Uri.parse(confiC.url +
            confiC.puerto +
            '/wedding/AUTORIZACION/selectAutorizacion'),
        body: {
          'id_evento': idEvento.toString(),
          'id_planner': idPlanner.toString()
        },
        headers: {
          HttpHeaders.authorizationHeader: token
        });

    // filtro
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return ItemModelAutorizacion.fromJson(data['data']);
    } else if (response.statusCode == 401) {
      throw TokenException();
    } else {
      throw AutorizacionException();
    }
  }

  @override
  Future<bool> createAutorizacion(Map autorizacion) async {
    // variables
    autorizacion['id_planner'] = await _sharedPreferences.getIdPlanner();
    autorizacion['id_evento'] = await _sharedPreferences.getIdEvento();
    String token = await _sharedPreferences.getToken();

    // pedido al servidor
    final response = await client.post(
        Uri.parse(confiC.url +
            confiC.puerto +
            '/wedding/AUTORIZACION/createAutorizacion'),
        body: jsonEncode(autorizacion),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
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
  Future<ItemModelAutorizacion> selectEvidencia(int idAuditorizacion) async {
    // variables
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();

    // pedido al servidor
    final response = await client.post(
        Uri.parse(confiC.url +
            confiC.puerto +
            '/wedding/AUTORIZACION/selectEvidencia'),
        body: {
          'id_planner': idPlanner.toString(),
          'id_auditoria': idAuditorizacion.toString()
        },
        headers: {
          HttpHeaders.authorizationHeader: token
        });

    // filtro
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return ItemModelAutorizacion.fromJson(data['data']);
    } else if (response.statusCode == 401) {
      throw TokenException();
    } else {
      throw AutorizacionException();
    }
  }

  @override
  Future<bool> updateAutorizacion(
      int idAuditorizacion, String descripcion, String comentario) async {
    // variables
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();

    // pedido al servidor
    final response = await client.post(
        Uri.parse(confiC.url +
            confiC.puerto +
            '/wedding/AUTORIZACION/updateAutorizacion'),
        body: {
          'id_planner': idPlanner.toString(),
          'id_autorizacion': idAuditorizacion.toString(),
          'descripcion': descripcion,
          'comentario': comentario
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
  Future<bool> deleteAutorizacion(int idAuditorizacion) async {
    // variables
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();

    // pedido al servidor
    final response = await client.post(
        Uri.parse(confiC.url +
            confiC.puerto +
            '/wedding/AUTORIZACION/deleteAutorizacion'),
        body: {
          'id_planner': idPlanner.toString(),
          'id_autorizacion': idAuditorizacion.toString()
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
  Future<bool> deleteImage(int idEvidencia) async {
    // variables
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();

    // pedido al servidor
    final response = await client.post(
        Uri.parse(
            confiC.url + confiC.puerto + '/wedding/AUTORIZACION/deleteImage'),
        body: {
          'id_planner': idPlanner.toString(),
          'id_evidencia': idEvidencia.toString()
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
  Future<bool> addImage(Map evidencia) async {
    // variables
    evidencia['id_planner'] = await _sharedPreferences.getIdPlanner();
    evidencia['id_evento'] = await _sharedPreferences.getIdEvento();
    String token = await _sharedPreferences.getToken();

    // pedido al servidor
    final response = await client.post(
        Uri.parse(
            confiC.url + confiC.puerto + '/wedding/AUTORIZACION/addImage'),
        body: jsonEncode(evidencia),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
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
  Future<bool> updateImage(int id, String descripcion) async {
    // variables
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();

    // pedido al servidor
    final response = await client.post(
        Uri.parse(
            confiC.url + confiC.puerto + '/wedding/AUTORIZACION/updateImage'),
        body: {
          'id_planner': idPlanner.toString(),
          'id_evidencia': id.toString(),
          'descripcion': descripcion
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
}

// clases para manejar errores
class AutorizacionException implements Exception {}

class TokenException implements Exception {}

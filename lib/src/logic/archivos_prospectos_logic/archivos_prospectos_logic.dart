import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../models/item_model_preferences.dart';
import '../../resources/config_conection.dart';

class ArchivosProspectosLogic {
  final SharedPreferencesT _sharedPreferencesT = SharedPreferencesT();
  ConfigConection confiC = ConfigConection();

  Future<List<ArchivoProspecto>> obtenerArchivosProspectos(
      int idProspecto) async {
    String token = await _sharedPreferencesT.getToken();

    final data = {
      'idProspecto': idProspecto,
    };

    const endpoint = 'wedding/PROSPECTO/obtenerArchivosProspecto';

    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token
    };

    final resp = await http.post(
      Uri.parse(confiC.url + confiC.puerto + '/' + endpoint),
      body: json.encode(data),
      headers: headers,
    );
    if (resp.statusCode == 200) {
      return archivosProspectosFromJson(json.decode(resp.body));
    }
    return null;
  }

  Future<bool> crearArchivoProspecto(ArchivoProspecto nuevoProspecto) async {
    String token = await _sharedPreferencesT.getToken();

    final data = {
      ...nuevoProspecto.toJson(),
    };

    const endpoint = 'wedding/PROSPECTO/agregarArchivoProspecto';

    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token
    };

    final resp = await http.post(
      Uri.parse(confiC.url + confiC.puerto + '/' + endpoint),
      body: json.encode(data),
      headers: headers,
    );

    return resp.statusCode == 200;
  }

  Future<bool> eliminarArchivoProespecto(int idArchivo) async {
    String token = await _sharedPreferencesT.getToken();

    final data = {'idArchivo': idArchivo};

    const endpoint = 'wedding/PROSPECTO/eliminarArchivoProspecto';

    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token
    };

    final resp = await http.post(
      Uri.parse(confiC.url + confiC.puerto + '/' + endpoint),
      body: json.encode(data),
      headers: headers,
    );

    return resp.statusCode == 200;
  }

  Future<bool> editarNombredelArchivo(int idArchivo, String nuevoNombre) async {
    String token = await _sharedPreferencesT.getToken();

    final data = {
      'nuevoNombre': nuevoNombre,
      'idArchivo': idArchivo,
    };

    const endpoint = 'wedding/PROSPECTO/editarNombredelArchivo';

    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token
    };

    final resp = await http.post(
      Uri.parse(confiC.url + confiC.puerto + '/' + endpoint),
      body: json.encode(data),
      headers: headers,
    );

    return resp.statusCode == 200;
  }
}

List<ArchivoProspecto> archivosProspectosFromJson(List<dynamic> data) =>
    List<ArchivoProspecto>.from(data.map((e) => ArchivoProspecto.fromJson(e)));

class ArchivoProspecto {
  ArchivoProspecto({
    this.idArchivo,
    this.idPropescto,
    this.archivo,
    this.tipoMime,
    this.nombreArchivo,
  });

  int idArchivo;
  int idPropescto;
  String archivo;
  String tipoMime;
  String nombreArchivo;

  factory ArchivoProspecto.fromJson(Map<String, dynamic> json) =>
      ArchivoProspecto(
        idArchivo: json['id_archivo_prospecto'],
        idPropescto: json['id_propescto'],
        archivo: json['archivo'],
        tipoMime: json['tipo_mime'],
        nombreArchivo: json['nombre_archivo'],
      );

  Map<String, dynamic> toJson() => {
        'id_archivo': idArchivo,
        'id_propescto': idPropescto,
        'archivo': archivo,
        'tipoMime': tipoMime,
        'nombreArchivo': nombreArchivo,
      };
}

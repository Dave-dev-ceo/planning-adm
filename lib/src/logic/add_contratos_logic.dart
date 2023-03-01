// imports flutter/dart
import 'dart:convert';
import 'dart:io';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:planning/src/resources/config_conection.dart';

// imports weeding
import 'package:planning/src/models/item_model_preferences.dart';

// import model
import 'package:planning/src/models/item_model_add_contratos.dart';

// clase abstracta
abstract class AddContratosLogic {
  Future<ItemModelAddContratos> selectContratosFromPlanner();
  Future<ItemModelAddContratos> selectContratosArchivoPlaner(int idMachote);
  Future<bool> inserContrato(Map contrato);
  Future<ItemModelAddContratos> selectContratosEvento();
  Future<bool> borrarContratoEvento(int? id);
  Future<String?> fetchContratosPdf(Map<String, dynamic> data);
  Future<bool> updateContratoEvento(
      int? id, String archivo, String tipoDoc, String? tipoMime);
  Future<String?> updateValContratos(Map<String, dynamic> data);
  Future<String> fetchValContratos(String machote);
  Future<String?> obtenerContratoById(Map<String, dynamic> data);
  Future<String?> obtenerContratoSubidoById(Map<String, dynamic> data);
  Future<String> actualizarDescripcionDocumento(
      int idDocumento, String descripcion);
  Future<Map<String, dynamic>?> obtenerUltimoDocumento();
}

class ConsultasAddContratosLogic implements AddContratosLogic {
  // variables configuracion
  final SharedPreferencesT _sharedPreferences = SharedPreferencesT();
  ConfigConection confiC = ConfigConection();

  @override
  Future<ItemModelAddContratos> selectContratosFromPlanner() async {
    // variables
    int? idPlanner = await _sharedPreferences.getIdPlanner();
    int? idEvento = await _sharedPreferences.getIdEvento();
    String? token = await _sharedPreferences.getToken();

    // pedido al servidor
    final response = await http.post(
        Uri.parse(
            '${confiC.url}${confiC.puerto}/wedding/ADDCONTRATOS/selectContratosPlaner'),
        body: {
          'id_planner': idPlanner.toString(),
          "id_evento": idEvento.toString()
        },
        headers: {
          HttpHeaders.authorizationHeader: token ?? ''
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
    int? idPlanner = await _sharedPreferences.getIdPlanner();
    String? token = await _sharedPreferences.getToken();

    // pedido al servidor
    final response = await http.post(
        Uri.parse(
            '${confiC.url}${confiC.puerto}/wedding/ADDCONTRATOS/selectContratosArchivoPlaner'),
        body: {
          'id_planner': idPlanner.toString(),
          'id_machote': idMachote.toString()
        },
        headers: {
          HttpHeaders.authorizationHeader: token ?? ''
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
    int? idPlanner = await _sharedPreferences.getIdPlanner();
    int? idEvento = await _sharedPreferences.getIdEvento();
    String? token = await _sharedPreferences.getToken();

    contrato['id_planner'] = idPlanner.toString();
    contrato['id_evento'] = idEvento.toString();

    // pedido al servidor
    final response = await http.post(
        Uri.parse(
            '${confiC.url}${confiC.puerto}/wedding/ADDCONTRATOS/inserContrato'),
        body: contrato,
        headers: {HttpHeaders.authorizationHeader: token ?? ''});

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
    int? idPlanner = await _sharedPreferences.getIdPlanner();
    int? idEvento = await _sharedPreferences.getIdEvento();
    String? token = await _sharedPreferences.getToken();
    bool? desconectado = await _sharedPreferences.getModoConexion();

    if (desconectado) {
      if (!Hive.isBoxOpen('contratos')) {
        await Hive.openBox<dynamic>('contratos');
      }
      final boxContratos = Hive.box<dynamic>('contratos');
      final listaContratos =
          boxContratos.values.where((c) => c['id_evento'] == idEvento).toList();
      await boxContratos.close();
      return ItemModelAddContratos.fromJson(listaContratos);
    } else {
      final response = await http.post(
          Uri.parse(
              '${confiC.url}${confiC.puerto}/wedding/ADDCONTRATOS/selectContratosEvento'),
          body: {
            'id_planner': idPlanner.toString(),
            "id_evento": idEvento.toString()
          },
          headers: {
            HttpHeaders.authorizationHeader: token ?? ''
          });

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
  }

  @override
  Future<bool> borrarContratoEvento(int? id) async {
    // variables
    int? idPlanner = await _sharedPreferences.getIdPlanner();
    String? token = await _sharedPreferences.getToken();

    // pedido al servidor
    final response = await http.post(
        Uri.parse(
            '${confiC.url}${confiC.puerto}/wedding/ADDCONTRATOS/borrarContratoEvento'),
        body: {
          'id_planner': idPlanner.toString(),
          "id_contrato": id.toString()
        },
        headers: {
          HttpHeaders.authorizationHeader: token ?? ''
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
  Future<String?> fetchContratosPdf(Map<String, dynamic> data) async {
    bool desconectado = await _sharedPreferences.getModoConexion();
    int? idPlanner = await _sharedPreferences.getIdPlanner();
    int? idEvento = await _sharedPreferences.getIdEvento();
    String? token = await _sharedPreferences.getToken();
    data['id_planner'] = idPlanner.toString();
    data['id_evento'] = idEvento.toString();
    if (desconectado) {
      if (!Hive.isBoxOpen('pdf')) {
        await Hive.openBox<dynamic>('pdf');
      }
      final boxPDF = Hive.box<dynamic>('pdf');
      final pdf = boxPDF.values.firstWhere(
          (c) => c['id_contrato'].toString() == data['id_contrato'].toString());
      await boxPDF.close();
      String? pdfB64 = pdf['pdf_generado'];
      return pdfB64;
    } else {
      final response = await http.post(
          Uri.parse('${confiC.url}${confiC.puerto}/wedding/PDF/createPDF'),
          body: data,
          headers: {HttpHeaders.authorizationHeader: token ?? ''});
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
  }

  @override
  Future<bool> updateContratoEvento(
      int? id, String archivo, String tipoDoc, String? tipoMime) async {
    // variables
    int? idPlanner = await _sharedPreferences.getIdPlanner();
    String? token = await _sharedPreferences.getToken();

    // pedido al servidor
    final response = await http.post(
        Uri.parse(
            '${confiC.url}${confiC.puerto}/wedding/ADDCONTRATOS/updateContratoEvento'),
        body: {
          'id_planner': idPlanner.toString(),
          'id_contrato': id.toString(),
          'archivo': archivo,
          'tipo_doc': tipoDoc,
          'tipo_mime': tipoMime
        },
        headers: {
          HttpHeaders.authorizationHeader: token ?? ''
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
  // ignore: missing_return
  Future<String?> updateValContratos(Map<String, dynamic> data) async {
    int? idPlanner = await _sharedPreferences.getIdPlanner();
    String? token = await _sharedPreferences.getToken();
    data['id_planner'] = idPlanner.toString();
    data['id_contrato'] = data['id_contrato'].toString();
    final response = await http.post(
        Uri.parse(
            '${confiC.url}${confiC.puerto}/wedding/PDF/updateValContratos'),
        body: data,
        headers: {HttpHeaders.authorizationHeader: token ?? ''});
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return data['data'];
    } else if (response.statusCode == 401) {
      throw TokenException();
    }
    return null;
  }

  @override
  // ignore: missing_return
  Future<String> fetchValContratos(String machote) async {
    int? idPlanner = await _sharedPreferences.getIdPlanner();
    int? idEvento = await _sharedPreferences.getIdEvento();
    String? token = await _sharedPreferences.getToken();

    Map<String, dynamic> json = {
      'id_planner': idPlanner.toString(),
      'id_evento': idEvento.toString(),
      'machote': machote
    };
    final response = await http.post(
        Uri.parse(
            '${confiC.url}${confiC.puerto}/wedding/PDF/generarValorEtiquetasContrato'),
        body: json,
        headers: {HttpHeaders.authorizationHeader: token ?? ''});
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return data['data'].toString();
    }
    throw TokenException();
  }

  @override
  Future<String?> obtenerContratoById(Map<String, dynamic> data) async {
    bool desconectado = await _sharedPreferences.getModoConexion();
    int? idPlanner = await _sharedPreferences.getIdPlanner();
    int? idEvento = await _sharedPreferences.getIdEvento();
    data['id_planner'] = idPlanner.toString();
    data['id_evento'] = idEvento.toString();
    if (desconectado) {
      if (!Hive.isBoxOpen('contratos')) {
        await Hive.openBox<dynamic>('contratos');
      }
      final boxContratos = Hive.box<dynamic>('contratos');
      final contrato = boxContratos.values.firstWhere((c) =>
          c['id_contrato'].toString() == data['id_contrato'].toString() &&
          c['id_planner'].toString() == data['id_planner'].toString() &&
          c['id_evento'].toString() == data['id_evento'].toString());
      await boxContratos.close();
      return contrato['original'];
    } else {
      String? token = await _sharedPreferences.getToken();

      final response = await http.post(
          Uri.parse(
              '${confiC.url}${confiC.puerto}/wedding/ADDCONTRATOS/obtenerContratoById'),
          body: {
            'id_contrato': data['id_contrato'].toString(),
            'id_planner': data['id_planner'].toString(),
            'id_evento': data['id_evento'].toString()
          },
          headers: {
            HttpHeaders.authorizationHeader: token ?? ''
          });
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        await _sharedPreferences.setToken(data['token']);
        return data['data'][0]['original'];
      } else if (response.statusCode == 401) {
        throw TokenException();
      } else {
        throw Exception();
      }
    }
  }

  @override
  Future<String?> obtenerContratoSubidoById(Map<String, dynamic> data) async {
    bool desconectado = await _sharedPreferences.getModoConexion();
    int? idPlanner = await _sharedPreferences.getIdPlanner();
    int? idEvento = await _sharedPreferences.getIdEvento();
    data['id_planner'] = idPlanner.toString();
    data['id_evento'] = idEvento.toString();
    String? token = await _sharedPreferences.getToken();
    if (desconectado) {
      if (!Hive.isBoxOpen('contratos')) {
        await Hive.openBox<dynamic>('contratos');
      }
      final boxContratos = Hive.box<dynamic>('contratos');
      final contrato = boxContratos.values.firstWhere((c) =>
          c['id_contrato'].toString() == data['id_contrato'].toString() &&
          c['id_planner'].toString() == data['id_planner'].toString() &&
          c['id_evento'].toString() == data['id_evento'].toString());
      await boxContratos.close();
      return contrato['archivo'];
    } else {
      final response = await http.post(
          Uri.parse(
              '${confiC.url}${confiC.puerto}/wedding/ADDCONTRATOS/obtenerContratoById'),
          body: {
            'id_contrato': data['id_contrato'].toString(),
            'id_planner': data['id_planner'].toString(),
            'id_evento': data['id_evento'].toString()
          },
          headers: {
            HttpHeaders.authorizationHeader: token ?? ''
          });
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        await _sharedPreferences.setToken(data['token']);
        return data['data'][0]['archivo'];
      } else if (response.statusCode == 401) {
        throw TokenException();
      } else {
        throw Exception();
      }
    }
  }

  @override
  Future<String> actualizarDescripcionDocumento(
      int? idDocumento, String? descripcion) async {
    String? token = await _sharedPreferences.getToken();

    const endpoint = '/wedding/ADDCONTRATOS/actualizarDescripcionDocumento';

    final data = {
      'idDocumento': idDocumento,
      'descripcion': descripcion,
    };

    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token ?? ''
    };

    final response = await http.post(
      Uri.parse(confiC.url! + confiC.puerto! + endpoint),
      body: json.encode(data),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return 'Ok';
    } else {
      return response.body;
    }
  }

  @override
  Future<Map<String, dynamic>?> obtenerUltimoDocumento() async {
    bool desconectado = await _sharedPreferences.getModoConexion();
    String? token = await _sharedPreferences.getToken();
    int? idEvento = await _sharedPreferences.getIdEvento();
    if (desconectado) {
      if (!Hive.isBoxOpen('contratos')) {
        await Hive.openBox<dynamic>('contratos');
      }
      final boxContratos = Hive.box<dynamic>('contratos');
      final listaContratos =
          boxContratos.values.where((c) => c['id_evento'] == idEvento).toList();
      if (listaContratos.isEmpty) {
        return null;
      }
      listaContratos.sort((a, b) {
        if (a['id_contrato'] > b['id_contrato']) {
          return -1;
        }
        return 1;
      });
      final body = Map<String, dynamic>.from(listaContratos[0]);
      return body;
    } else {
      const endpoint = '/wedding/ADDCONTRATOS/obtenerUltimoDocumento';
      final data = {
        'idEvento': idEvento,
      };
      final headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        HttpHeaders.authorizationHeader: token ?? ''
      };
      final response = await http.post(
        Uri.parse(confiC.url! + confiC.puerto! + endpoint),
        body: json.encode(data),
        headers: headers,
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    }
  }
}

// clases para manejar errores
class AutorizacionException implements Exception {}

class TokenException implements Exception {}

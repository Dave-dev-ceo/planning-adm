import 'dart:io';

//import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'package:http/http.dart' show Client;
import 'package:planning/src/models/item_model-acompanante.dart';
import 'package:planning/src/models/item_model_estatus_invitado.dart';
import 'package:planning/src/models/item_model_eventos.dart';
import 'package:planning/src/models/item_model_grupos.dart';
import 'package:planning/src/models/item_model_invitado.dart';
import 'package:planning/src/models/item_model_mesas.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/models/item_model_prueba.dart';
import 'package:planning/src/models/item_model_reporte_evento.dart';
import 'package:planning/src/models/item_model_reporte_genero.dart';
import 'package:planning/src/models/item_model_reporte_grupos.dart';
import 'package:planning/src/models/item_model_reporte_invitados.dart';
import 'package:planning/src/resources/config_conection.dart';
import 'dart:convert';
import '../models/item_model_invitados.dart';
//import '../models/item_model_response.dart';

class ApiProvider {
  SharedPreferencesT _sharedPreferences = new SharedPreferencesT();
  ConfigConection confiC = new ConfigConection();
  Client client = Client();
  _loadLogin(BuildContext context) async {
    await _sharedPreferences.clear();
    _showDialogMsg(context);
  }

  _showDialogMsg(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        //barrierDismissible: false,
        builder: (BuildContext context) {
          //_ingresando = context;
          return AlertDialog(
            title: Text(
              "Sesión 2",
              textAlign: TextAlign.center,
            ),
            content: Text(
                'Lo sentimos la sesión a caducado, por favor inicie sesión de nuevo.'),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            actions: <Widget>[
              TextButton(
                child: Text('Cerrar'),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/', (route) => false);
                },
              ),
            ],
          );
        });
  }

  Future<ItemModelPrueba> fetchPrueba() async {
    final response = await client.get(Uri.parse(
        confiC.url + confiC.puerto + '/wedding/PRUEBA/obtenerDatos/'));

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return ItemModelPrueba.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      return null;
    } else {
      throw Exception('Failed to load get');
    }
  }

  Future<ItemModelReporteGrupos> fetchReporteGrupos(
      BuildContext context) async {
    int res = await renovarToken();

    if (res == 0) {
      int idEvento = await _sharedPreferences.getIdEvento();
      String token = await _sharedPreferences.getToken();
      final response = await client.get(
          Uri.parse(confiC.url +
              confiC.puerto +
              '/wedding/INVITADOS/obtenerReporteInvitadosGrupo/$idEvento'),
          headers: {HttpHeaders.authorizationHeader: token});

      if (response.statusCode == 200) {
        // If the call to the server was successful, parse the JSON
        return ItemModelReporteGrupos.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        _loadLogin(context);
        return null;
      } else {
        throw Exception('Failed to load get');
      }
    } else if (res == 1) {
      _loadLogin(context);
      return null;
    } else {
      _loadLogin(context);
      return null;
    }
  }

  Future<ItemModelReporteInvitadosGenero> fetchReporteInvitadosGenero(
      BuildContext context) async {
    int res = await renovarToken();

    if (res == 0) {
      int idEvento = await _sharedPreferences.getIdEvento();
      String token = await _sharedPreferences.getToken();
      final response = await client.get(
          Uri.parse(confiC.url +
              confiC.puerto +
              '/wedding/INVITADOS/obtenerReporteInvitadosGenero/$idEvento'),
          headers: {HttpHeaders.authorizationHeader: token});

      if (response.statusCode == 200) {
        // If the call to the server was successful, parse the JSON
        return ItemModelReporteInvitadosGenero.fromJson(
            json.decode(response.body));
      } else if (response.statusCode == 401) {
        _loadLogin(context);
        return null;
      } else {
        throw Exception('Failed to load get');
      }
    } else if (res == 1) {
      _loadLogin(context);
      return null;
    } else {
      _loadLogin(context);
      return null;
    }
  }

  Future<ItemModelReporteInvitados> fetchReporteInvitados(
      BuildContext context) async {
    int res = await renovarToken();
    if (res == 0) {
      int idEvento = await _sharedPreferences.getIdEvento();
      String token = await _sharedPreferences.getToken();
      final response = await client.get(
          Uri.parse(confiC.url +
              confiC.puerto +
              '/wedding/INVITADOS/obtenerReporteInvitados/$idEvento'),
          headers: {HttpHeaders.authorizationHeader: token});

      if (response.statusCode == 200) {
        // If the call to the server was successful, parse the JSON
        return ItemModelReporteInvitados.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        _loadLogin(context);
        return null;
      } else {
        throw Exception('Failed to load get');
      }
    } else if (res == 1) {
      _loadLogin(context);
      return null;
    } else {
      _loadLogin(context);
      return null;
    }
  }

  Future<ItemModelReporte> fetchReportesList(
      BuildContext context, Map<String, String> reporte) async {
    int res = await renovarToken();
    if (res == 0) {
      //reporte['reporte'] = "asistencia";
      //reporte['id'] = "4";
      int idEvento = await _sharedPreferences.getIdEvento();
      reporte['id_evento'] = idEvento.toString();
      String token = await _sharedPreferences.getToken();
      final response = await client.post(
          Uri.parse(
              confiC.url + confiC.puerto + '/wedding/INVITADOS/obtenerReporte'),
          body: reporte,
          headers: {HttpHeaders.authorizationHeader: token});

      if (response.statusCode == 200) {
        // If the call to the server was successful, parse the JSON
        return ItemModelReporte.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        _loadLogin(context);
        return null;
      } else {
        throw Exception('Failed to load get');
      }
    } else if (res == 1) {
      _loadLogin(context);
      return null;
    } else {
      _loadLogin(context);
      return null;
    }
  }

  Future<ItemModelInvitados> fetchInvitadosList(BuildContext context) async {
    int res = await renovarToken();
    if (res == 0) {
      int idEvento = await _sharedPreferences.getIdEvento();
      String token = await _sharedPreferences.getToken();
      final response = await client.get(
          Uri.parse(confiC.url +
              confiC.puerto +
              '/wedding/INVITADOS/obtenerInvitados/$idEvento'),
          headers: {HttpHeaders.authorizationHeader: token});

      if (response.statusCode == 200) {
        // If the call to the server was successful, parse the JSON
        return ItemModelInvitados.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        _loadLogin(context);
        return null;
      } else {
        throw Exception('Failed to load get');
      }
    } else if (res == 1) {
      _loadLogin(context);
      return null;
    } else {
      _loadLogin(context);
      return null;
    }
  }

  Future<ItemModelEventos> fetchEventosList(BuildContext context) async {
    int res = await renovarToken();
    if (res == 0) {
      int idPlanner = await _sharedPreferences.getIdPlanner();
      String token = await _sharedPreferences.getToken();
      final response = await client.get(
          Uri.parse(confiC.url +
              confiC.puerto +
              '/wedding/EVENTOS/obtenerEventos/$idPlanner'),
          headers: {HttpHeaders.authorizationHeader: token});

      if (response.statusCode == 200) {
        // If the call to the server was successful, parse the JSON
        return ItemModelEventos.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        _loadLogin(context);
        return null;
      } else {
        throw Exception('Failed to load get');
      }
    } else if (res == 1) {
      _loadLogin(context);
      return null;
    } else {
      _loadLogin(context);
      return null;
    }
  }

  Future<ItemModelInvitado> fetchInvitadoList(
      int idInvitado, BuildContext context) async {
    int res = await renovarToken();

    if (res == 0) {
      String token = await _sharedPreferences.getToken();
      final response = await client.get(
          Uri.parse(confiC.url +
              confiC.puerto +
              '/wedding/INVITADOS/obtenerInvitado/$idInvitado'),
          headers: {HttpHeaders.authorizationHeader: token});

      if (response.statusCode == 200) {
        // If the call to the server was successful, parse the JSON
        return ItemModelInvitado.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        _loadLogin(context);
        return null;
      } else {
        throw Exception('Failed to load get');
      }
    } else if (res == 1) {
      _loadLogin(context);
      return null;
    } else {
      _loadLogin(context);
      return null;
    }
  }

  Future<bool> createInvitados(
      Map<String, String> invitados, BuildContext context) async {
    int res = await renovarToken();

    if (res == 0) {
      String token = await _sharedPreferences.getToken();
      final response = await client.post(
          Uri.parse(confiC.url +
              confiC.puerto +
              '/wedding/INVITADOS/createInvitados'),
          body: invitados,
          headers: {HttpHeaders.authorizationHeader: token});

      if (response.statusCode == 201) {
        return true;
      } else if (response.statusCode == 401) {
        _loadLogin(context);
        return null;
      } else {
        return false;
      }
    } else if (res == 1) {
      _loadLogin(context);
      return null;
    } else {
      _loadLogin(context);
      return false;
    }
  }

  Future<bool> updateEstatus(
      Map<String, String> data, BuildContext context) async {
    int res = await renovarToken();

    if (res == 0) {
      int idPlanner = await _sharedPreferences.getIdPlanner();
      String token = await _sharedPreferences.getToken();
      data['id_planner'] = idPlanner.toString();
      final response = await client.post(
          Uri.parse(
              confiC.url + confiC.puerto + '/wedding/ESTATUS/updateEstatus'),
          body: data,
          headers: {HttpHeaders.authorizationHeader: token});

      if (response.statusCode == 201) {
        return true;
      } else if (response.statusCode == 401) {
        _loadLogin(context);
        return null;
      } else {
        return false;
      }
    } else if (res == 1) {
      _loadLogin(context);
      return null;
    } else {
      _loadLogin(context);
      return false;
    }
  }

  Future<bool> updateEstatusInvitado(
      Map<String, String> data, BuildContext context) async {
    int res = await renovarToken();

    if (res == 0) {
      String token = await _sharedPreferences.getToken();
      final response = await client.post(
          Uri.parse(confiC.url +
              confiC.puerto +
              '/wedding/INVITADOS/updateEstatusInvitados'),
          body: data,
          headers: {HttpHeaders.authorizationHeader: token});

      if (response.statusCode == 201) {
        return true;
      } else if (response.statusCode == 401) {
        _loadLogin(context);
        return null;
      } else {
        return false;
      }
    } else if (res == 1) {
      _loadLogin(context);
      return null;
    } else {
      _loadLogin(context);
      return false;
    }
  }

  Future<bool> updateGrupoInvitado(
      Map<String, String> data, BuildContext context) async {
    int res = await renovarToken();

    if (res == 0) {
      String token = await _sharedPreferences.getToken();
      final response = await client.post(
          Uri.parse(confiC.url +
              confiC.puerto +
              '/wedding/INVITADOS/updateGrupoInvitados'),
          body: data,
          headers: {HttpHeaders.authorizationHeader: token});

      if (response.statusCode == 201) {
        return true;
      } else if (response.statusCode == 401) {
        _loadLogin(context);
        return null;
      } else {
        return false;
      }
    } else if (res == 1) {
      _loadLogin(context);
      return null;
    } else {
      _loadLogin(context);
      return false;
    }
  }

  Future<bool> updateInvitado(
      Map<String, String> data, BuildContext context) async {
    int res = await renovarToken();

    if (res == 0) {
      String token = await _sharedPreferences.getToken();
      final response = await client.post(
          Uri.parse(
              confiC.url + confiC.puerto + '/wedding/INVITADOS/updateInvitado'),
          body: data,
          headers: {HttpHeaders.authorizationHeader: token});

      if (response.statusCode == 201) {
        return true;
      } else if (response.statusCode == 401) {
        _loadLogin(context);
        return null;
      } else {
        return false;
      }
    } else if (res == 1) {
      _loadLogin(context);
      return null;
    } else {
      _loadLogin(context);
      return false;
    }
  }

  Future<ItemModelMesas> fetchMesasList(BuildContext context) async {
    int res = await renovarToken();

    if (res == 0) {
      String token = await _sharedPreferences.getToken();
      final response = await client.get(
          Uri.parse(confiC.url + confiC.puerto + '/wedding/MESAS/obtenerMesas'),
          headers: {HttpHeaders.authorizationHeader: token});

      if (response.statusCode == 200) {
        // If the call to the server was successful, parse the JSON
        return ItemModelMesas.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        _loadLogin(context);
        return null;
      } else {
        throw Exception('Failed to load get');
      }
    } else if (res == 1) {
      _loadLogin(context);
      return null;
    } else {
      _loadLogin(context);
      return null;
    }
  }

  Future<ItemModelGrupos> fetchGruposList(BuildContext context) async {
    int res = await renovarToken();

    if (res == 0) {
      int idEvento = await _sharedPreferences.getIdEvento();
      String token = await _sharedPreferences.getToken();
      final response = await client.get(
          Uri.parse(confiC.url +
              confiC.puerto +
              '/wedding/GRUPOS/obtenerGrupos/$idEvento'),
          headers: {HttpHeaders.authorizationHeader: token});

      if (response.statusCode == 200) {
        // If the call to the server was successful, parse the JSON
        return ItemModelGrupos.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        _loadLogin(context);
        return null;
      } else {
        throw Exception('Failed to load get');
      }
    } else if (res == 1) {
      _loadLogin(context);
      return null;
    } else {
      _loadLogin(context);
      return null;
    }
  }

  Future<ItemModelEstatusInvitado> fetchEstatusList(
      BuildContext context) async {
    int res = await renovarToken();

    if (res == 0) {
      int idPlanner = await _sharedPreferences.getIdPlanner();
      String token = await _sharedPreferences.getToken();
      final response = await client.get(
          Uri.parse(confiC.url +
              confiC.puerto +
              '/wedding/ESTATUS/obtenerEstatus/$idPlanner'),
          headers: {HttpHeaders.authorizationHeader: token});

      if (response.statusCode == 200) {
        // If the call to the server was successful, parse the JSON
        Map<String, dynamic> datas = json.decode(response.body);
        return ItemModelEstatusInvitado.fromJson(datas['data']);
      } else if (response.statusCode == 401) {
        _loadLogin(context);
        return null;
      } else {
        throw Exception('Failed to load get');
      }
    } else if (res == 1) {
      _loadLogin(context);
      return null;
    } else {
      _loadLogin(context);
      return null;
    }
  }

  Future<bool> createGrupo(
      Map<String, String> grupo, BuildContext context) async {
    int res = await renovarToken();

    if (res == 0) {
      int idEvento = await _sharedPreferences.getIdEvento();
      grupo['id_evento'] = idEvento.toString();
      String token = await _sharedPreferences.getToken();
      final response = await client.post(
          Uri.parse(confiC.url + confiC.puerto + '/wedding/GRUPOS/createGrupo'),
          body: grupo,
          headers: {HttpHeaders.authorizationHeader: token});

      if (response.statusCode == 201) {
        return true;
      } else if (response.statusCode == 401) {
        _loadLogin(context);
        return null;
      } else {
        return false;
      }
    } else if (res == 1) {
      _loadLogin(context);
      return null;
    } else {
      _loadLogin(context);
      return false;
    }
  }

  Future<bool> createEstatus(
      Map<String, String> estatus, BuildContext context) async {
    int res = await renovarToken();

    if (res == 0) {
      int idPlanner = await _sharedPreferences.getIdPlanner();
      estatus['id_planner'] = idPlanner.toString();
      String token = await _sharedPreferences.getToken();
      final response = await client.post(
          Uri.parse(
              confiC.url + confiC.puerto + '/wedding/ESTATUS/createEstatus'),
          body: estatus,
          headers: {HttpHeaders.authorizationHeader: token});

      if (response.statusCode == 201) {
        return true;
      } else if (response.statusCode == 401) {
        _loadLogin(context);
        return null;
      } else {
        return false;
      }
    } else if (res == 1) {
      _loadLogin(context);
      return null;
    } else {
      _loadLogin(context);
      return false;
    }
  }

  Future<int> registroPlanner(Map<String, String> auth) async {
    final response = await client.post(
        Uri.parse(
            confiC.url + confiC.puerto + '/wedding/PLANNER/registroPlanner'),
        body: auth);
    if (response.statusCode == 201) {
      return 0;
    } else if (response.statusCode == 403) {
      return 1;
    } else {
      return 2;
    }
  }

  Future<int> loginPlanner(Map<String, String> auth) async {
    final response = await client.post(
        Uri.parse(confiC.url + confiC.puerto + '/wedding/ACCESO/loginPlanner'),
        body: auth);
    if (response.statusCode == 200) {
      Map<dynamic, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setIdPlanner(data['usuario']['id_planner']);
      await _sharedPreferences.setToken(data['token']);
      await _sharedPreferences.setSesion(true);
      return 0;
    } else if (response.statusCode == 403) {
      return 1;
    } else {
      return 2;
    }
  }

  Future<Map<String, dynamic>> enviarInvitacionesPorEvento() async {
    int idPlanner = await _sharedPreferences.getIdEvento();
    int idEvento = await _sharedPreferences.getIdEvento();
    String token = await _sharedPreferences.getToken();
    final response = await client.post(
        Uri.parse(confiC.url +
            confiC.puerto +
            '/wedding/INVITADOS/enviarInvitacionesPorEvento'),
        body: {
          'id_planner': idPlanner.toString(),
          'id_evento': idEvento.toString()
        },
        headers: {
          HttpHeaders.authorizationHeader: token
        });

    int enviados = 0;
    // int total = 0;
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      data.forEach((dato) {
        if (dato['enviado']) {
          enviados += 1;
        }
      });
    } else {
      return {'msg': 'Error al enviar invitaciones', 'enviado': false};
    }
    return {
      'msg': 'Se han enviado $enviados invitaciones por correo electrónico',
      'enviado': true
    };
  }

  Future<int> renovarToken() async {
    final response = await client.post(
        Uri.parse(confiC.url + confiC.puerto + '/wedding/ACCESO/renovarToken'),
        body: {"token": await _sharedPreferences.getToken()});
    if (response.statusCode == 200) {
      Map<dynamic, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return 0;
    } else if (response.statusCode == 403) {
      return 1;
    } else {
      return 2;
    }
  }

  Future<ItemModelAcompanante> fetchAcompananteList(
      int idInvitado, BuildContext context) async {
    int res = await renovarToken();

    if (res == 0) {
      String token = await _sharedPreferences.getToken();
      int planner = await _sharedPreferences.getIdPlanner();
      int evento = await _sharedPreferences.getIdEvento();
      final response = await client.get(
          Uri.parse(confiC.url +
              confiC.puerto +
              '/wedding/INVITADOS/obtenerAcompanante/$idInvitado/$planner/$evento'),
          headers: {HttpHeaders.authorizationHeader: token});

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        // If the call to the server was successful, parse the JSON
        return ItemModelAcompanante.fromJson(data["data"]);
      } else if (response.statusCode == 401) {
        _loadLogin(context);
        return null;
      } else {
        throw Exception('Failed to load get');
      }
    } else if (res == 1) {
      _loadLogin(context);
      return null;
    } else {
      _loadLogin(context);
      return null;
    }
  }

  Future<void> updateAcompanante(Map<String, String> acompananteEditado) async {
    int res = await renovarToken();
    if (res == 0) {
      String token = await _sharedPreferences.getToken();
      int idUsuario = await _sharedPreferences.getIdUsuario();
      final endPoint = 'wedding/INVITADOS/updateAcompanante';

      acompananteEditado['idUsuario'] = idUsuario.toString();

      final response = await client.post(
          Uri.parse(confiC.url + confiC.puerto + '/' + endPoint),
          body: acompananteEditado,
          headers: {HttpHeaders.authorizationHeader: token});

      if (response == 200) {
      } else {
        print(response.body);
      }
    }
  }

  Future<String> deleteAcompanante(String idAcompanante) async {
    int res = await renovarToken();
    String _isOk;
    if (res == 0) {
      String token = await _sharedPreferences.getToken();

      final enpoint = 'wedding/INVITADOS/deleteAcompanante';

      final data = {'idAcompanante': idAcompanante};

      final response = await client.post(
          Uri.parse(confiC.url + confiC.puerto + '/' + enpoint),
          body: data,
          headers: {HttpHeaders.authorizationHeader: token});
      if (response.statusCode == 200) {
        return _isOk = 'Ok';
      } else {
        return _isOk = response.body;
      }
    }
    return _isOk;
  }

  Future<bool> agregarAcompanante(
      Map<String, String> data, BuildContext context) async {
    int res = await renovarToken();

    if (res == 0) {
      String token = await _sharedPreferences.getToken();
      int id_planner = await _sharedPreferences.getIdUsuario();
      int id_evento = await _sharedPreferences.getIdEvento();
      int creado_por = await _sharedPreferences.getIdUsuario();
      int modificado_por = await _sharedPreferences.getIdUsuario();
      data['id_planner'] = id_planner.toString();
      data['id_evento'] = id_evento.toString();
      data['creado_por'] = creado_por.toString();
      data['modificado_por'] = modificado_por.toString();
      final response = await client.post(
          Uri.parse(confiC.url +
              confiC.puerto +
              '/wedding/INVITADOS/agregarAcompanante'),
          body: data,
          headers: {HttpHeaders.authorizationHeader: token});
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        _loadLogin(context);
        return null;
      } else {
        return false;
      }
    } else if (res == 1) {
      _loadLogin(context);
      return null;
    } else {
      _loadLogin(context);
      return false;
    }
  }

  Future<String> downloadPDFInvitados() async {
    String token = await _sharedPreferences.getToken();
    int idEvento = await _sharedPreferences.getIdEvento();
    int idPlanner = await _sharedPreferences.getIdPlanner();

    final endpoint = '/wedding/INVITADOS/downloadPDFInvitados';

    final data = {
      'idPlanner': idPlanner,
      'idEvento': idEvento,
    };

    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token,
    };
    final response = await client.post(
      Uri.parse(confiC.url + confiC.puerto + endpoint),
      body: json.encode(data),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return json.decode(response.body)['pdf'];
    } else {
      return null;
    }
  }

  Future<int> updatePortadaEvento(String newPortada) async {
    String token = await _sharedPreferences.getToken();
    int idEvento = await _sharedPreferences.getIdEvento();

    final endpoint = '/wedding/EVENTOS/updatePortadaImage';

    final data = {
      'idEvento': idEvento,
      'portada': newPortada,
    };

    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token,
    };
    final response = await client.post(
      Uri.parse(confiC.url + confiC.puerto + endpoint),
      body: json.encode(data),
      headers: headers,
    );

    return response.statusCode;
  }

  Future<int> deleteInvitados(Map<String, dynamic> data) async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idEvento = await _sharedPreferences.getIdEvento();
    data['id_planner'] = idPlanner.toString();
    data['id_evento'] = idEvento.toString();
    String token = await _sharedPreferences.getToken();
    print(data);
    final response = await client.post(
        Uri.parse(
            confiC.url + confiC.puerto + '/wedding/INVITADOS/deleteInvitados'),
        body: {
          'id_invitado': data['id_invitado'].toString(),
          'id_planner': data['id_planner'].toString(),
          'id_evento': data['id_evento'].toString()
        },
        headers: {
          HttpHeaders.authorizationHeader: token
        });

    if (response.statusCode == 200) {
      Map<String, dynamic> res = json.decode(response.body);
      await _sharedPreferences.setToken(res['token']);
      return 0;
    } else {
      return null;
    }
  }
}

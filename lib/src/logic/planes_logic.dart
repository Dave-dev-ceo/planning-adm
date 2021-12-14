// imports from flutter/dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' show Client;
import 'package:planning/src/models/Planes/planes_model.dart';

// imports from wedding
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/resources/config_conection.dart';

// import model
import 'package:planning/src/models/item_model_planes.dart';

abstract class PlanesLogic {
  Future<ItemModelPlanes> selectPlanesPlanner();
  Future<ItemModelPlanes> selectPlanesEvento(String myQuery);
  Future<bool> crearTareasEventoLista(List<dynamic> listaPlanner);
  Future<int> createTareaEvento(Map<String, dynamic> tareaEvento);
  Future<int> createActividadEvento(
      Map<String, dynamic> actividadEvento, int idTarea);
  Future<bool> updateTareaEvento(Map<String, dynamic> tareaEvento);
  Future<bool> updateActividadEvento(List<dynamic> listaPlanner);
  Future<bool> deleteActividadEvento(int idActividad);
  Future<String> donwloadPDFPlanesEvento();
  Future<List<PlannesModel>> getAllPlannes();
  Future<List<TimingModel>> getTimingsAndActivities();
  Future<bool> updateEventoActividades(List<EventoActividadModel> actividades);
  Future<bool> addNewActividadEvento(
      EventoActividadModel actividadModel, int idEventoTiming);
}

class ConsultasPlanesLogic extends PlanesLogic {
  // variables de configuracion
  SharedPreferencesT _sharedPreferences = new SharedPreferencesT();
  ConfigConection confiC = new ConfigConection();
  Client client = Client();

  @override
  Future<ItemModelPlanes> selectPlanesPlanner() async {
    // variables
    int idEvento = await _sharedPreferences.getIdEvento();
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();

    // pedido al servidor
    final response = await client.post(
        Uri.parse(
            confiC.url + confiC.puerto + '/wedding/PLANES/selectPlanesPlanner'),
        body: {
          'id_evento': idEvento.toString(),
          'id_planner': idPlanner.toString()
        },
        headers: {
          HttpHeaders.authorizationHeader: token
        });

    // filtro
    if (response.statusCode == 200) {
      // creamos un mapa
      Map<String, dynamic> data = json.decode(response.body);
      // actualizamos shared
      await _sharedPreferences.setToken(data['token']);
      // enviamos data
      return ItemModelPlanes.fromJson(data['data']);
    } else if (response.statusCode == 401) {
      // enviamos un null
      return null;
    } else {
      // error
      throw ListaPlanesException();
    }
  }

  @override
  Future<bool> crearTareasEventoLista(List<dynamic> listaPlanner) async {
    // variables
    int idEvento = await _sharedPreferences.getIdEvento();
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();
    bool done;

    // creamos tareas
    listaPlanner.forEach((tarea) async {
      // validamos que no se repita
      if (!tarea.isEvento) {
        final response = await client.post(
            Uri.parse(confiC.url +
                confiC.puerto +
                '/wedding/PLANES/crearTareasEventoLista'),
            body: {
              'id_evento': idEvento.toString(),
              'id_planner': idPlanner.toString(),
              'id_timing': tarea.idTareaPlanner.toString(),
              'nombre': tarea.nombreTareaPlanner.toString(),
            },
            headers: {
              HttpHeaders.authorizationHeader: token
            });

        Map<String, dynamic> data = json.decode(response.body);

        tarea.actividadTareaPlanner.forEach((actividad) async {
          await client.post(
              Uri.parse(confiC.url +
                  confiC.puerto +
                  '/wedding/PLANES/crearActividadesEventoLista'),
              body: {
                'id_evento': idEvento.toString(),
                'id_planner': idPlanner.toString(),
                'id_evento_timing':
                    data['data'][0]['id_evento_timing'].toString(),
                'nombre': actividad.nombreActividadPlanner.toString(),
                'descripcion': actividad.descripcionActividadPlanner.toString(),
                'visible_involucrados':
                    actividad.visibleInvolucradosActividadPlanner.toString(),
                'dias': actividad.diasActividadPlanner.toString(),
                'predecesor': actividad.predecesorActividadPlanner.toString(),
                'id_actividad_timing': actividad.idActividadPlanner.toString(),
              },
              headers: {
                HttpHeaders.authorizationHeader: token
              });
        });
      } else {
        tarea.actividadTareaPlanner.forEach((actividad) async {
          if (!actividad.isEvento) {
            await client.post(
                Uri.parse(confiC.url +
                    confiC.puerto +
                    '/wedding/PLANES/crearActividadesEventoLista'),
                body: {
                  'id_evento': idEvento.toString(),
                  'id_planner': idPlanner.toString(),
                  'id_evento_timing': tarea.idTareaPlanner.toString(),
                  'nombre': actividad.nombreActividadPlanner.toString(),
                  'descripcion':
                      actividad.descripcionActividadPlanner.toString(),
                  'visible_involucrados':
                      actividad.visibleInvolucradosActividadPlanner.toString(),
                  'dias': actividad.diasActividadPlanner.toString(),
                  'predecesor': actividad.predecesorActividadPlanner.toString(),
                  'id_actividad_timing':
                      actividad.idActividadPlanner.toString(),
                },
                headers: {
                  HttpHeaders.authorizationHeader: token
                });
          }
        });
      }

      // si todo salio bien
      done = true;
    });

    return done;
  }

  @override
  Future<ItemModelPlanes> selectPlanesEvento(String myQuery) async {
    // variables
    int idEvento = await _sharedPreferences.getIdEvento();
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();

    // pedido al servidor
    final response = await client.post(
        Uri.parse(
            confiC.url + confiC.puerto + '/wedding/PLANES/selectPlanesEvento'),
        body: {
          'condicion': myQuery,
          'id_evento': idEvento.toString(),
          'id_planner': idPlanner.toString()
        },
        headers: {
          HttpHeaders.authorizationHeader: token
        });

    // filtro
    if (response.statusCode == 200) {
      // creamos un mapa
      Map<String, dynamic> data = json.decode(response.body);
      // actualizamos shared
      await _sharedPreferences.setToken(data['token']);
      // enviamos data
      return ItemModelPlanes.fromJson(data['data']);
    } else if (response.statusCode == 401) {
      // enviamos un null
      return null;
    } else {
      // error
      throw ListaPlanesException();
    }
  }

  @override
  Future<int> createTareaEvento(Map<String, dynamic> tareaEvento) {
    // TODO: implement createTareaEvento
    throw UnimplementedError();
  }

  @override
  Future<int> createActividadEvento(
      Map<String, dynamic> actividadEvento, int idTarea) async {
    // variables
    int idEvento = await _sharedPreferences.getIdEvento();
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();
    actividadEvento['id_planner'] = idPlanner.toString();
    actividadEvento['id_evento'] = idEvento.toString();
    actividadEvento['id_evento_timing'] = idTarea.toString();

    // enviamos
    final response = await client.post(
        Uri.parse(confiC.url +
            confiC.puerto +
            '/wedding/PLANES/crearActividadesEventoLista'),
        body: actividadEvento,
        headers: {HttpHeaders.authorizationHeader: token});

    // filtro
    if (response.statusCode == 200) {
      // creamos un mapa
      Map<String, dynamic> data = json.decode(response.body);
      // actualizamos shared
      await _sharedPreferences.setToken(data['token']);
      // enviamos data
      return 1;
    } else if (response.statusCode == 401) {
      // enviamos un null
      return null;
    } else {
      // error
      throw ListaPlanesException();
    }
  }

  @override
  Future<bool> updateTareaEvento(Map<String, dynamic> tareaEvento) {
    // TODO: implement updateTareaEvento
    throw UnimplementedError();
  }

  @override
  Future<bool> updateActividadEvento(List<dynamic> listaPlanner) async {
    // variables
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idUsuario = await _sharedPreferences.getIdUsuario();
    String token = await _sharedPreferences.getToken();
    // pedido al servidor - hay que ciclar
    listaPlanner.forEach((actividad) async {
      await client.post(
          Uri.parse(confiC.url +
              confiC.puerto +
              '/wedding/PLANES/updateActividadEvento'),
          body: {
            'id_planner': idPlanner.toString(),
            'id_usuario': idUsuario.toString(),
            'id_actividad': actividad.idActividadPlanner.toString(),
            'fecha': actividad.fechaInicioActividad.toString(),
            'progreso': actividad.checkActividadPlanner.toString(),
            'status': actividad.calendarActividad.toString(),
            'responsable': actividad.nombreResponsable.toString(),
          },
          headers: {
            HttpHeaders.authorizationHeader: token
          });
    });

    return true; // no debe ser asi
  }

  @override
  Future<bool> deleteActividadEvento(int idActividad) async {
    // variables
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();

    // enviamos
    final response = await client.post(
        Uri.parse(confiC.url +
            confiC.puerto +
            '/wedding/PLANES/deleteActividadEvento'),
        body: {
          'id_planner': idPlanner.toString(),
          'id_actividad': idActividad.toString()
        },
        headers: {
          HttpHeaders.authorizationHeader: token
        });

    // filtro
    if (response.statusCode == 200) {
      // creamos un mapa
      Map<String, dynamic> data = json.decode(response.body);
      // actualizamos shared
      await _sharedPreferences.setToken(data['token']);
      // enviamos data
      return true;
    } else if (response.statusCode == 401) {
      // enviamos un null
      return null;
    } else {
      // error
      throw ListaPlanesException();
    }
  }

  @override
  Future<String> donwloadPDFPlanesEvento() async {
    String token = await _sharedPreferences.getToken();
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idEvento = await _sharedPreferences.getIdEvento();

    const endpoint = '/wedding/PLANES/donwloadPDFPlanesEvento';

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token
    };

    final data = {'idPlanner': idPlanner, 'idEvento': idEvento};

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

  @override
  Future<List<PlannesModel>> getAllPlannes() async {
    String token = await _sharedPreferences.getToken();
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idEvento = await _sharedPreferences.getIdEvento();

    const endpoint = '/wedding/PLANES/getAllPlanes';

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token
    };

    final data = {'idPlanner': idPlanner, 'idEvento': idEvento};

    final resp = await client.post(
      Uri.parse(confiC.url + confiC.puerto + endpoint),
      body: json.encode(data),
      headers: headers,
    );

    if (resp.statusCode == 200) {
      List<PlannesModel> listaPlannes = List<PlannesModel>.from(
                  json.decode(resp.body).map((e) => PlannesModel.fromJson(e)))
              .toList() ??
          [];

      return listaPlannes;
    } else {
      return null;
    }
  }

  @override
  Future<List<TimingModel>> getTimingsAndActivities() async {
    String token = await _sharedPreferences.getToken();
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idEvento = await _sharedPreferences.getIdEvento();

    const endpoint = '/wedding/PLANES/getPlannesAndActivities';

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token
    };

    final data = {'idPlanner': idPlanner, 'idEvento': idEvento};

    final resp = await client.post(
      Uri.parse(confiC.url + confiC.puerto + endpoint),
      body: json.encode(data),
      headers: headers,
    );

    if (resp.statusCode == 200) {
      List<TimingModel> listTimings = List<TimingModel>.from(
                  json.decode(resp.body).map((e) => TimingModel.fromJson(e)))
              .toList() ??
          [];

      return listTimings;
    } else {
      return null;
    }
  }

  @override
  Future<bool> updateEventoActividades(
      List<EventoActividadModel> actividades) async {
    String token = await _sharedPreferences.getToken();
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idEvento = await _sharedPreferences.getIdEvento();

    const endpoint = '/wedding/PLANES/updateActividadesEvento';

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token
    };

    final data = {
      'idPlanner': idPlanner,
      'idEvento': idEvento,
      'actividades': actividades
    };

    final resp = await client.post(
      Uri.parse(confiC.url + confiC.puerto + endpoint),
      body: json.encode(data),
      headers: headers,
    );

    if (resp.statusCode == 200) {
      return true;
    } else {
      return null;
    }
  }

  @override
  Future<bool> addNewActividadEvento(
      EventoActividadModel actividadModel, int idEventoTiming) async {
    String token = await _sharedPreferences.getToken();
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idEvento = await _sharedPreferences.getIdEvento();
    int idUsuario = await _sharedPreferences.getIdUsuario();

    const endpoint = '/wedding/PLANES/addActividadEvento';

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token
    };

    final data = {
      'idPlanner': idPlanner,
      'idUsuario': idUsuario,
      'idEvento': idEvento,
      'idEventoTiming': idEventoTiming,
      'nombreActiviad': actividadModel.nombreActividad,
      'descripcion': actividadModel.descripcionActividad,
      'fecha': actividadModel.fechaInicioActividad.toString(),
      'visibleInvolucrado': actividadModel.visibleInvolucrado,
      'predecesor': actividadModel.predecesorActividad,
      'dias': actividadModel.diasActividad,
      'idActividadTiming': actividadModel.idActividadOld,
      'responsable': actividadModel.responsable,
      'fechafin': actividadModel.fechaFinActividad.toString()
    };

    final resp = await client.post(
      Uri.parse(confiC.url + confiC.puerto + endpoint),
      body: json.encode(data),
      headers: headers,
    );

    if (resp.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}

class ActividadesEvento {
  final _actividadesStreamController =
      StreamController<List<PlannesModel>>.broadcast();
  Function(List<PlannesModel>) get actividadeSink =>
      _actividadesStreamController.sink.add;

  Stream<List<PlannesModel>> get actividadesStream =>
      _actividadesStreamController.stream;

  void dispose() {
    _actividadesStreamController?.close();
  }

  Future<List<PlannesModel>> getAllPlannes() async {
    SharedPreferencesT _sharedPreferences = new SharedPreferencesT();
    ConfigConection confiC = new ConfigConection();
    Client client = Client();

    String token = await _sharedPreferences.getToken();
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idEvento = await _sharedPreferences.getIdEvento();

    const endpoint = '/wedding/PLANES/getAllPlanes';

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token
    };

    final data = {'idPlanner': idPlanner, 'idEvento': idEvento};

    final resp = await client.post(
      Uri.parse(confiC.url + confiC.puerto + endpoint),
      body: json.encode(data),
      headers: headers,
    );

    if (resp.statusCode == 200) {
      List<PlannesModel> listaPlannes = List<PlannesModel>.from(
                  json.decode(resp.body).map((e) => PlannesModel.fromJson(e)))
              .toList() ??
          [];

      actividadeSink(listaPlannes);

      return listaPlannes;
    } else {
      return null;
    }
  }
}

// exceptiones
class ListaPlanesException implements Exception {}

class CrearPlannerPlanesException implements Exception {}

class TokenException implements Exception {}

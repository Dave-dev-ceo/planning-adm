// imports from flutter/dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' show Client;

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
            'status': actividad.calendarActividad.toString()
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
}

// exceptiones
class ListaPlanesException implements Exception {}

class CrearPlannerPlanesException implements Exception {}

class TokenException implements Exception {}

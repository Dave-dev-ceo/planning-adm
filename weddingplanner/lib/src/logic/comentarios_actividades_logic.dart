// imports from flutter/dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' show Client;
// imports from wedding
import 'package:weddingplanner/src/models/item_model_preferences.dart';
import 'package:weddingplanner/src/resources/config_conection.dart';

// import model
import 'package:weddingplanner/src/models/item_model_comentarios_actividades.dart';

// clase abstracta
abstract class ComentariosActividadesLogic {
  Future<ItemModelComentarios> selectComentarioPorId();
  Future<int> createComentarioPorId(String comentarioTxt, int idActividad, bool estadoComentario);
  Future<int> updateComentarioPorId(int idComentario, String comentarioTxt, bool estadoComentario);
}

// clases que extienden
class ConsultasComentarioLogic extends ComentariosActividadesLogic {
  // variables de configuracion
  SharedPreferencesT _sharedPreferences = new SharedPreferencesT();
  ConfigConection confiC = new ConfigConection();
  Client client = Client();

  @override
  Future<int> createComentarioPorId(String comentarioTxt, int idActividad, bool estadoComentario) async {
    // implement createComentarioPorId
    // variables
    int idEvento = await _sharedPreferences.getIdEvento();
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();

    // pedido al servidor
    final response = await client.post(
      Uri.parse(
        confiC.url + 
        confiC.puerto +
        '/wedding/COMENTARIOSACTIVIDADES/crearComentarios'
      ),
      body: {
        'id_planner':idPlanner.toString(), 
        'id_evento':idEvento.toString(), 
        'id_actividad':idActividad.toString(),
        'comentario_txt':comentarioTxt.toString(),
        'estado_comentario':estadoComentario.toString()
      },
      headers: {HttpHeaders.authorizationHeader:token}
    );

    if(response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      ItemModelComentarios id = ItemModelComentarios.fromJson(data['data']);
      return id.comentarios[0].idComentario;
    } else if (response.statusCode == 401) {
      return null;
    }   else if (response.statusCode == 400) {
      return null;
    }  else {
      throw ListaComentarioException();
    }
  }

  @override
  Future<ItemModelComentarios> selectComentarioPorId() async {
    // implement selectComentarioPorId

    // variables
    int idEvento = await _sharedPreferences.getIdEvento();
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();

    // pedido al servidor
    final response = await client.post(
      Uri.parse(
        confiC.url + 
        confiC.puerto +
        '/wedding/COMENTARIOSACTIVIDADES/obtenerComentariosPorActividades'
      ),
      body: {'id_evento':idEvento.toString(), 'id_planner':idPlanner.toString()},
      headers: {HttpHeaders.authorizationHeader:token}
    );

    // filtro
    if(response.statusCode == 200) {
      // creamos un mapa
      Map<String, dynamic> data = json.decode(response.body);
      // actualizamos shared
      await _sharedPreferences.setToken(data['token']);
      // enviamos data
      return ItemModelComentarios.fromJson(data['data']);
    } else if(response.statusCode == 401) {
      // enviamos un null
      return null;
    } else {
      // error
      throw ListaComentarioException();
    }
  }

  @override
  Future<int> updateComentarioPorId(int idComentario, String comentarioTxt, bool estadoComentario) async {
    // implement updateComentarioPorId
    // variables
    int idEvento = await _sharedPreferences.getIdEvento();
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();

    // pedido al servidor
    final response = await client.post(
      Uri.parse(
        confiC.url + 
        confiC.puerto +
        '/wedding/COMENTARIOSACTIVIDADES/actualizarComentarios'
      ),
      body: {
        'id_planner':idPlanner.toString(), 
        'id_evento':idEvento.toString(), 
        'id_comentario':idComentario.toString(),
        'comentario_txt':comentarioTxt.toString(),
        'estado_comentario':estadoComentario.toString()
      },
      headers: {HttpHeaders.authorizationHeader:token}
    );

    if(response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return 1;
    } else if (response.statusCode == 401) {
      return null;
    }   else if (response.statusCode == 400) {
      return null;
    }  else {
      throw ListaComentarioException();
    }
  }
}

// exceptiones
class ListaComentarioException implements Exception {}
class TokenException implements Exception {}
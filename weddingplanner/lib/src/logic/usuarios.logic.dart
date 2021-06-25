import 'dart:convert';
import 'dart:io';

import 'package:weddingplanner/src/models/item_model_preferences.dart';
import 'package:weddingplanner/src/models/item_model_usuarios.dart';
import 'package:http/http.dart' show Client;
import 'package:weddingplanner/src/resources/config_conection.dart';

abstract class UsuariosLogic {
  Future<ItemModelUsuarios> fetchUsuariosPorPlanner();
}

class ListaUsuariosException implements Exception {}

class FetchListaUsuariosLogic extends UsuariosLogic {
  SharedPreferencesT _sharedPreferences = new SharedPreferencesT();

  ConfigConection confiC = new ConfigConection();
  Client client = Client();

  @override
  Future<ItemModelUsuarios> fetchUsuariosPorPlanner() async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();

    final response = await client.post(
        Uri.parse(confiC.url +
            confiC.puerto +
            '/wedding/USUARIOS/obtenerUsuariosPorPlanner'),
        body: {'id_planner': idPlanner.toString()},
        headers: {HttpHeaders.authorizationHeader: token});

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return ItemModelUsuarios.fromJson(data['data']);
    } else if (response.statusCode == 401) {
      return null;
    } else {
      throw ListaUsuariosException;
    }
  }
}

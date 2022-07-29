import 'dart:convert';
import 'dart:io';

import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/models/model_perfilado.dart';
import 'package:planning/src/resources/config_conection.dart';

abstract class PermisosLogic {
  Future<ItemModelPerfil> obtenerPermisosUsuario();
}

class PermisosException implements Exception {}

class TokenPermisosException implements Exception {}

class PaypalSubscriptionException implements Exception {}

class PerfiladoLogic implements PermisosLogic {
  final SharedPreferencesT _sharedPreferences = SharedPreferencesT();
  ConfigConection confiC = ConfigConection();

  PerfiladoLogic();

  @override
  Future<ItemModelPerfil> obtenerPermisosUsuario() async {
    bool desconectado = await _sharedPreferences.getModoConexion();
    if (desconectado) {
      if (!Hive.isBoxOpen('permisos')) {
        await Hive.openBox<dynamic>('permisos');
      }
      final boxPermisos = Hive.box<dynamic>('permisos');
      final permisos = boxPermisos.values.first;
      ItemModelSecciones secciones =
          ItemModelSecciones.fromJson(permisos['secciones']);
      ItemModelPantallas pantallas =
          ItemModelPantallas.fromJson(permisos['pantallas']);
      await boxPermisos.close();
      for (var s in secciones.secciones) {
        if (!(s.claveSeccion == 'WP-EVT')) {
          s.acceso = false;
        }
      }
      return ItemModelPerfil(secciones, pantallas);
    }
    String idUsuario = (await _sharedPreferences.getIdUsuario()).toString();
    String token = await _sharedPreferences.getToken();
    final response = await http.post(
        Uri.parse(confiC.url +
            confiC.puerto +
            '/wedding/USUARIOS/obtenerPermisosUsuario'),
        body: {'id_usuario': idUsuario.toString()},
        headers: {HttpHeaders.authorizationHeader: token});

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      ItemModelSecciones secciones =
          ItemModelSecciones.fromJson(data['secciones']);
      ItemModelPantallas pantallas =
          ItemModelPantallas.fromJson(data['pantallas']);
      //Guardar permisos en la box correspondiente
      if (!Hive.isBoxOpen('permisos')) {
        await Hive.openBox<dynamic>('permisos');
      }
      final boxPermisos = Hive.box<dynamic>('permisos');
      await boxPermisos.clear();
      await boxPermisos.add({
        'secciones': data['secciones'],
        'pantallas': data['pantallas'],
      });
      await boxPermisos.close();
      return ItemModelPerfil(secciones, pantallas);
    } else if (response.statusCode == 430) {
      throw PaypalSubscriptionException();
    } else if (response.statusCode == 401) {
      throw TokenPermisosException();
    } else {
      throw PermisosException();
    }
  }
}

import 'dart:convert';

import 'package:planning/src/models/item_model_prueba.dart';
import 'package:http/http.dart' show Client;
import 'package:planning/src/resources/config_conection.dart';

abstract class ListaInvitadosLogic {
  Future<ItemModelPrueba> fetchPrueba();
}

class ListaInvitadosException implements Exception {}

class FetchListaInvitadosLogic extends ListaInvitadosLogic {
  ConfigConection confiC = new ConfigConection();
  Client client = Client();

  @override
  Future<ItemModelPrueba> fetchPrueba() async {
    final response = await client.get(Uri.parse(
        confiC.url + confiC.puerto + '/wedding/PRUEBA/obtenerDatos/'));

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return ItemModelPrueba.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      return null;
    } else {
      throw ListaInvitadosException;
    }
  }
}

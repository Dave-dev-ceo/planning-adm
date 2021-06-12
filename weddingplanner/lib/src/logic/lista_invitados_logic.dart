import 'dart:convert';

import 'package:weddingplanner/src/models/item_model_prueba.dart';
import 'package:http/http.dart' show Client;

abstract class ListaInvitadosLogic {
  Future<ItemModelPrueba> fetchPrueba();
}

class ListaInvitadosException implements Exception {}

class FetchListaInvitadosLogic extends ListaInvitadosLogic {
  Client client = Client();

  @override
  Future<ItemModelPrueba> fetchPrueba() async {
    final response = await client
        .get(Uri.http('localhost:3005', 'wedding/PRUEBA/obtenerDatos/'));

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

import 'dart:convert';

import 'package:http/http.dart' show Client;
import 'package:planning/src/models/item_model_paises.dart';
import 'package:planning/src/resources/config_conection.dart';

abstract class ListaPaisesLogic {
  Future<ItemModelPaises?> fetchPaises();
}

class ListaPaisesException implements Exception {}

class FetchListaPaisesLogic extends ListaPaisesLogic {
  ConfigConection confiC = ConfigConection();
  Client client = Client();

  @override
  Future<ItemModelPaises?> fetchPaises() async {
    final response = await client.get(Uri.parse(
        '${confiC.url}${confiC.puerto}/wedding/PAISES/obtenerPaises/'));

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return ItemModelPaises.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      return null;
    } else {
      throw ListaPaisesException;
    }
  }
}

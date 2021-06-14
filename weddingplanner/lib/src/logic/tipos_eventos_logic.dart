import 'dart:convert';

import 'package:http/http.dart' show Client;
import 'package:weddingplanner/src/models/item_model_tipo_evento.dart';

abstract class ListaTiposEventosLogic {
  Future<ItemModelTipoEvento> fetchTiposEventos();
}

class ListaTiposEventosException implements Exception {}

class FetchListaTiposEventosLogic extends ListaTiposEventosLogic {
  Client client = Client();

  @override
  Future<ItemModelTipoEvento> fetchTiposEventos() async {
    final response = await client
        .get(Uri.http('localhost:3005', 'wedding/TIPOSEVENTOS/obtenerTiposEventos'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return ItemModelTipoEvento.fromJson(data['data']);
    } else if (response.statusCode == 401) {
      return null;
    } else {
      throw ListaTiposEventosException;
    }
  }
}

import 'dart:convert';

import 'package:http/http.dart' show Client;
import 'package:planning/src/models/item_model_tipo_evento.dart';
import 'package:planning/src/resources/config_conection.dart';

abstract class ListaTiposEventosLogic {
  Future<ItemModelTipoEvento> fetchTiposEventos();
}

class ListaTiposEventosException implements Exception {}

class FetchListaTiposEventosLogic extends ListaTiposEventosLogic {
  ConfigConection confiC = new ConfigConection();
  Client client = Client();

  @override
  Future<ItemModelTipoEvento> fetchTiposEventos() async {
    final response = await client.get(Uri.parse(confiC.url +
        confiC.puerto +
        '/wedding/TIPOSEVENTOS/obtenerTiposEventos'));

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

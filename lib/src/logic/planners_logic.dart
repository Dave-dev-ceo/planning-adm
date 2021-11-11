import 'dart:convert';
import 'package:http/http.dart' show Client;
import 'package:planning/src/models/item_model_planners.dart';
import 'package:planning/src/resources/config_conection.dart';

abstract class ListaPlannersLogic {
  Future<ItemModelPlanners> fetchPrueba();
  Future<int> createPlanners(Map<String, dynamic> json);
}

class ListaPlannersException implements Exception {}

class CreatePlannersException implements Exception {}

class FetchListaPlannersLogic extends ListaPlannersLogic {
  ConfigConection confiC = new ConfigConection();
  Client client = Client();

  @override
  Future<ItemModelPlanners> fetchPrueba() async {
    final response = await client.get(Uri.parse(
        confiC.url + confiC.puerto + '/wedding/PLANNER/obtenerPlanners/'));

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return ItemModelPlanners.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      return null;
    } else {
      throw ListaPlannersException;
    }
  }

  @override
  Future<int> createPlanners(Map<String, dynamic> json) {
    throw UnimplementedError();
  }
}

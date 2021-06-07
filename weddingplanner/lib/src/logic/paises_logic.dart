import 'dart:convert';

import 'package:http/http.dart' show Client;
import 'package:weddingplanner/src/models/item_model_paises.dart';
abstract class ListaPaisesLogic {
  Future<ItemModelPaises> fetchPaises();
}
class ListaPaisesException implements Exception{}

class FetchListaPaisesLogic extends ListaPaisesLogic{
  
  Client client = Client();
  
  @override
  Future<ItemModelPaises> fetchPaises() async {
    final response = await client.get(Uri.http('localhost:3005', 'wedding/PAISES/obtenerPaises/'));
      
      if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
        return ItemModelPaises.fromJson(json.decode(response.body));
      }else if(response.statusCode == 401){
        return null;
      }else{
        throw ListaPaisesException;
      }
  }

}
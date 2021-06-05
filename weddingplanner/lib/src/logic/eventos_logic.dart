import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' show Client;
import 'package:weddingplanner/src/models/item_model_eventos.dart';
import 'package:weddingplanner/src/models/item_model_preferences.dart';
abstract class ListaEventosLogic {
  Future<ItemModelEventos> fetchEventos();
}
class ListaEventosException implements Exception{}

class TokenException implements Exception{}

class FetchListaEventosLogic extends ListaEventosLogic{
  SharedPreferencesT _sharedPreferences = new SharedPreferencesT();
  Client client = Client();
  
  @override
  Future<ItemModelEventos> fetchEventos() async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
      String token = await _sharedPreferences.getToken();
      final response = await client.get(Uri.http('localhost:3005', '/wedding/EVENTOS/obtenerEventos/$idPlanner'),
      headers: {HttpHeaders.authorizationHeader: token});
      
      if (response.statusCode == 200) {
        Map<String,dynamic> data = json.decode(response.body);
        await _sharedPreferences.setToken(data['token']);
        return ItemModelEventos.fromJson(data['data']);
      } else if(response.statusCode == 401){
        await _sharedPreferences.clear();
        throw TokenException();
      }else{
        throw ListaEventosException();
      }
  }

}
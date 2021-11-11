import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' show Client;
import 'package:weddingplanner/src/models/item_model_etiquetas.dart';
import 'package:weddingplanner/src/models/item_model_preferences.dart';
import 'package:weddingplanner/src/resources/config_conection.dart';

abstract class ListaEtiquetasLogic {
  Future<ItemModelEtiquetas> fetchEtiquetas();
  Future<bool> updateEtiquetas(Map<String, dynamic> data);
  Future<int> createEtiquetas(Map<String, dynamic> data);
}

class ListaEtiquetasException implements Exception {}

class TokenException implements Exception {}

class CreateEtiquetasException implements Exception {}

class FetchListaEtiquetasLogic extends ListaEtiquetasLogic {
  SharedPreferencesT _sharedPreferences = new SharedPreferencesT();
  ConfigConection confiC = new ConfigConection();
  Client client = Client();

  @override
  Future<ItemModelEtiquetas> fetchEtiquetas() async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();
    final response = await client.get(
       Uri.parse(confiC.url+confiC.puerto+'/wedding/ETIQUETAS/obtenerEtiquetas/$idPlanner'),
        headers: {HttpHeaders.authorizationHeader: token});

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return ItemModelEtiquetas.fromJson(data['data']);
    } else if (response.statusCode == 401) {
      throw TokenException();
    } else {
      throw ListaEtiquetasException();
    }
  }

  @override
  Future<bool> updateEtiquetas(Map<String, dynamic> data) async {
    if (data['descripcion'] != null && data['descripcion'] != "") {
      return true; //int.parse(data['id_estatus_invitado']);
    } else {
      throw CreateEtiquetasException();
    }
    /*int idPlanner = await _sharedPreferences.getIdPlanner();
      String token = await _sharedPreferences.getToken();
      data['id_planner'] = idPlanner.toString();
       final response = await client.post(Uri.http('localhost:3005', 'wedding/ESTATUS/updateEtiquetas'),
        
        body: data,
      headers: {HttpHeaders.authorizationHeader: token});
      
      if (response.statusCode == 201) {
        return true;  
      } else if(response.statusCode == 401){
        
        return null;
      }else{
        return false;
      }*/
  }

  @override
  Future<int> createEtiquetas(Map<String, dynamic> data) async {
    if (data['descripcion'] != null && data['descripcion'] != "") {
      return 58; //int.parse(data['id_estatus_invitado']);
    } else {
      throw CreateEtiquetasException();
    }
  }
}

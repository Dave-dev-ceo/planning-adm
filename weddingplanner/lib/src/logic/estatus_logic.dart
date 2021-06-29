import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' show Client;
import 'package:weddingplanner/src/models/item_model_estatus_invitado.dart';
import 'package:weddingplanner/src/models/item_model_preferences.dart';
import 'package:weddingplanner/src/resources/config_conection.dart';

abstract class ListaEstatusLogic {
  Future<ItemModelEstatusInvitado> fetchEstatus();
  Future<bool> updateEstatus(Map<String, dynamic> data);
  Future<int> createEstatus(Map<String, dynamic> data);
}

class ListaEstatusException implements Exception {}

class TokenException implements Exception {}

class CreateEstatusException implements Exception {}

class FetchListaEstatusLogic extends ListaEstatusLogic {
  SharedPreferencesT _sharedPreferences = new SharedPreferencesT();
  ConfigConection confiC = new ConfigConection();
  Client client = Client();

  @override
  Future<ItemModelEstatusInvitado> fetchEstatus() async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();
    final response = await client.get(
        Uri.parse(confiC.url+confiC.puerto+'/wedding/ESTATUS/obtenerEstatus/$idPlanner'),
        headers: {HttpHeaders.authorizationHeader: token});

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return ItemModelEstatusInvitado.fromJson(data['data']);
    } else if (response.statusCode == 401) {
      throw TokenException();
    } else {
      throw ListaEstatusException();
    }
  }

  @override
  Future<bool> updateEstatus(Map<String, dynamic> data) async {
    if (data['descripcion'] != null && data['descripcion'] != "") {
      return true; //int.parse(data['id_estatus_invitado']);
    } else {
      throw CreateEstatusException();
    }
    /*int idPlanner = await _sharedPreferences.getIdPlanner();
      String token = await _sharedPreferences.getToken();
      data['id_planner'] = idPlanner.toString();
       final response = await client.post(Uri.http('localhost:3005', 'wedding/ESTATUS/updateEstatus'),
        
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
  Future<int> createEstatus(Map<String, dynamic> data) async {
    if (data['descripcion'] != null && data['descripcion'] != "") {
      int idPlanner = await _sharedPreferences.getIdPlanner();
      int idUsuario = await _sharedPreferences.getIdUsuario();
      data['id_usuario'] = idUsuario.toString();
      data['id_planner'] = idPlanner.toString();
      String token = await _sharedPreferences.getToken();
      final response = await client.post(
          Uri.parse(confiC.url+confiC.puerto+'/wedding/ESTATUS/createEstatus'),
          body: data,
          headers: {HttpHeaders.authorizationHeader: token});

      if (response.statusCode == 201) {
        Map<String, dynamic> res = json.decode(response.body);
        await _sharedPreferences.setToken(res['token']);
        return 0;
      } else if (response.statusCode == 401) {
        
        throw TokenException();
      } else {
        throw CreateEstatusException();
      }
    } else {
      throw CreateEstatusException();
    }
  }
}

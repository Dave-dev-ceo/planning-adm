import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' show Client;
import 'package:weddingplanner/src/models/item_model_machotes.dart';
import 'package:weddingplanner/src/models/item_model_preferences.dart';
abstract class ListaMachotesLogic {
  Future<ItemModelMachotes> fetchMachotes();
  Future<bool> updateMachotes(Map<String,dynamic> data);
  Future<int> createMachotes(Map<String,dynamic> data);
}
class ListaMachotesException implements Exception{}

class TokenException implements Exception{}

class CreateMachotesException implements Exception{}

class FetchListaMachotesLogic extends ListaMachotesLogic{
  SharedPreferencesT _sharedPreferences = new SharedPreferencesT();
  Client client = Client();
  
  @override
  Future<ItemModelMachotes> fetchMachotes() async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
      String token = await _sharedPreferences.getToken();
      final response = await client.get(Uri.http('localhost:3005', 'wedding/MACHOTES/obtenerMachotes/$idPlanner'),
      headers: {HttpHeaders.authorizationHeader: token});
      
      if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      await  _sharedPreferences.setToken(data['token']);
      return ItemModelMachotes.fromJson(data['data']);
    }else if(response.statusCode == 401){
      throw TokenException();
    }else{
      throw ListaMachotesException();
    }
  }

  @override
  Future<bool> updateMachotes(Map<String,dynamic> data) async {
    if(data['descripcion'] != null && data['descripcion'] != ""){
      return true;//int.parse(data['id_estatus_invitado']);
    }else{
      throw CreateMachotesException();
    }
    /*int idPlanner = await _sharedPreferences.getIdPlanner();
      String token = await _sharedPreferences.getToken();
      data['id_planner'] = idPlanner.toString();
       final response = await client.post(Uri.http('localhost:3005', 'wedding/ESTATUS/updateMachotes'),
        
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
  Future<int> createMachotes(Map<String, dynamic> data) async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();
    data['id_planner'] = idPlanner.toString();
    final response = await client.post(Uri.http('localhost:3005', 'wedding/MACHOTES/createMachotes'),  
    body: data,
    headers: {HttpHeaders.authorizationHeader: token});
      
    if (response.statusCode == 201) {
      return 0;  
    } else if(response.statusCode == 401){
      
      throw TokenException();
    }else{
      throw CreateMachotesException();
    }
    
    
  }

}
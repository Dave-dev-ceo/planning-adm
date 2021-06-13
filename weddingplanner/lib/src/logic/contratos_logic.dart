import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' show Client;
import 'package:weddingplanner/src/models/item_model_contratos.dart';
import 'package:weddingplanner/src/models/item_model_preferences.dart';

abstract class ListaContratosLogic {
  Future<ItemModelContratos> fetchContratos();
  Future<bool> updateContratos(Map<String, dynamic> data);
  Future<int> createContratos(Map<String, dynamic> data);
  Future<String> fetchContratosPdf(Map<String, dynamic> data);
}

class ListaContratosException implements Exception {}

class ListaContratosPdfException implements Exception {}

class TokenException implements Exception {}

class CreateContratosException implements Exception {}

class FetchListaContratosLogic extends ListaContratosLogic {
  SharedPreferencesT _sharedPreferences = new SharedPreferencesT();
  Client client = Client();

  @override
  Future<ItemModelContratos> fetchContratos() async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idEvento = await _sharedPreferences.getIdEvento();
    String token = await _sharedPreferences.getToken();
    final response = await client.get(
        Uri.http('localhost:3005',
            'wedding/Contratos/obtenerContratos/$idPlanner/$idEvento'),
        headers: {HttpHeaders.authorizationHeader: token});

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return ItemModelContratos.fromJson(data['data']);
    } else if (response.statusCode == 401) {
      throw TokenException();
    } else {
      throw ListaContratosException();
    }
  }

  @override
  Future<bool> updateContratos(Map<String, dynamic> data) async {
    if (data['descripcion'] != null && data['descripcion'] != "") {
      return true; //int.parse(data['id_estatus_invitado']);
    } else {
      throw CreateContratosException();
    }
    /*int idPlanner = await _sharedPreferences.getIdPlanner();
      String token = await _sharedPreferences.getToken();
      data['id_planner'] = idPlanner.toString();
       final response = await client.post(Uri.http('localhost:3005', 'wedding/ESTATUS/updateContratos'),
        
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
  Future<int> createContratos(Map<String, dynamic> data) async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idEvento = await _sharedPreferences.getIdEvento();
    String token = await _sharedPreferences.getToken();
    data['id_planner'] = idPlanner.toString();
    data['id_evento'] = idEvento.toString();
    final response = await client.post(
        Uri.http('localhost:3005', 'wedding/MACHOTES/createContratos'),
        body: data,
        headers: {HttpHeaders.authorizationHeader: token});

    if (response.statusCode == 201) {
      return 0;
    } else if (response.statusCode == 401) {
      throw TokenException();
    } else {
      throw CreateContratosException();
    }
  }

  @override
  Future<String> fetchContratosPdf(Map<String, dynamic> data) async {
    int idPlanner = await _sharedPreferences.getIdPlanner();
    int idEvento = await _sharedPreferences.getIdEvento();
    String token = await _sharedPreferences.getToken();
    data['id_planner'] = idPlanner.toString();
    data['id_evento'] = idEvento.toString();
    final response = await client.post(
        Uri.http('localhost:3005', 'wedding/PDF/createPDF'),
        body: data,
        headers: {HttpHeaders.authorizationHeader: token});

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      return data['data'];
    } else if (response.statusCode == 401) {
      throw TokenException();
    } else {
      throw ListaContratosPdfException();
    }
  }
}

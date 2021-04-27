import 'package:http/http.dart';
import 'dart:async';
import 'package:http/http.dart' show Client;
import 'package:weddingplanner/src/models/item_model_eventos.dart';
import 'package:weddingplanner/src/models/item_model_grupos.dart';
import 'dart:convert';
import '../models/item_model_invitados.dart';
//import '../models/item_model_response.dart';

class ApiProvider {
  Client client = Client();
  String baseUrl = 'server01.grupotum.com:3004';
  String baseUrlPruebas = 'localhost:3010';
  
  Future<ItemModelInvitados> fetchInvitadosList(int id) async {
    final response = await client.get(Uri.http(baseUrlPruebas, 'wedding/INVITADOS/obtenerInvitados/$id'));
    
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return ItemModelInvitados.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load get');
    }
  }

  Future<ItemModelEventos> fetchEventosList() async {
    final response = await client.get(Uri.http(baseUrlPruebas, '/wedding/EVENTOS/obtenerEventos/1'));
    
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return ItemModelEventos.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load get');
    }
  }

  Future<bool> createInvitados(Map<String,String> invitados) async{
    print(json.encode(invitados));
    final response = await client.post(Uri.http(baseUrlPruebas, 'wedding/INVITADOS/createInvitados'),
        
        body: invitados
    );
    if (response.statusCode == 201) {
      return true;  
    } else {
      //throw Exception('Failed post');
      return false;
    }
  }

  Future<bool> updateEstatusInvitado(Map<String,String> data) async{
    print(json.encode(data));
    final response = await client.post(Uri.http(baseUrlPruebas, 'wedding/INVITADOS/updateEstatusInvitados'),
        
        body: data
    );
    if (response.statusCode == 201) {
      return true;  
    } else {
      //throw Exception('Failed post');
      return false;
    }
  }

  Future<ItemModelGrupos> fetchGruposList() async {
    final response = await client.get(Uri.http(baseUrlPruebas, 'wedding/GRUPOS/obtenerGrupos'));
    
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return ItemModelGrupos.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load get');
    }
  }

    Future<bool> createGrupo(Map<String,String> grupo) async{
    print(json.encode(grupo));
    final response = await client.post(Uri.http(baseUrlPruebas, 'wedding/GRUPOS/createGrupo'),
        
        body: grupo
    );
    if (response.statusCode == 201) {
      return true;  
    } else {
      //throw Exception('Failed post');
      return false;
    }
  }
}
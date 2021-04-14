import 'package:http/http.dart';
import 'dart:async';
import 'package:http/http.dart' show Client;
import 'dart:convert';
import '../models/item_model_invitados.dart';
//import '../models/item_model_response.dart';

class InvitadosApiProvider {
  Client client = Client();
  String baseUrl = 'localhost:3010';
  
  Future<ItemModelInvitados> fetchInvitadosList() async {
    final response = await client.get(Uri.http(baseUrl, 'INVITADOS/obtenerInvitados'));
    
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return ItemModelInvitados.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load get');
    }
  }
  Future<bool> createInvitados(Map<String,String> invitados) async{
    print(json.encode(invitados));
    final response = await client.post(Uri.http(baseUrl, 'INVITADOS/createInvitados'),
        
        body: invitados
    );
    if (response.statusCode == 201) {
      return true;  
    } else {
      //throw Exception('Failed post');
      return false;
    }
  }
}
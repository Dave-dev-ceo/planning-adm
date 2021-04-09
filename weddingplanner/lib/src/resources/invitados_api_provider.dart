
import 'package:http/http.dart';
import 'dart:async';
import 'package:http/http.dart' show Client;
import 'dart:convert';
import '../models/item_model_invitados.dart';

class InvitadosApiProvider {
  Client client = Client();
  
  Future<ItemModelInvitados> fetchInvitadosList() async {
    final response = await client.get(Uri.http('localhost:3010', 'INVITADOS/obtenerInvitados'));
    
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return ItemModelInvitados.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
}
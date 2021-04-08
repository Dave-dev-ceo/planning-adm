import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weddingplanner/src/objects/invitados/invitadosList.dart';

Future<InvitadosList> obtenerListaInvolucrados() async {
  final response =
      await http.get(Uri.http('localhost:3010', 'INVITADOS/obtenerInvitados'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    //dynamic value = jsonDecode(response.body);
    //print(value[0]['id_involucrado']);
    return InvitadosList.fromJson(jsonDecode(response.body));
  }else{
    // If the server did not return a 200 OK response,
    // then throw an exception.
    print('error');
    throw Exception('Failed to load invitados');
  }
}
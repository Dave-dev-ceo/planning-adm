//import 'dart:convert';

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weddingplanner/src/objects/involucradosList.dart';

Future<InvolucradosList> obtenerListaInvolucrados() async {
  final response =
      await http.get(Uri.http('localhost:3010', 'INVOLUCRADOS/obtenerInvolucrados'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    //dynamic value = jsonDecode(response.body);
    //print(value[0]['id_involucrado']);
    return InvolucradosList.fromJson(jsonDecode(response.body));
  }else{
    // If the server did not return a 200 OK response,
    // then throw an exception.
    print('error');
    throw Exception('Failed to load album');
  }
}
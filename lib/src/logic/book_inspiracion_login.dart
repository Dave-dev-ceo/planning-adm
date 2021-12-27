import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/models/mesa/layout_mesa_model.dart';
import 'package:planning/src/resources/config_conection.dart';

class ServiceBookInspiracionLogic {
  SharedPreferencesT _sharedPreferences = SharedPreferencesT();
  ConfigConection confiC = ConfigConection();
  Client client = Client();
  LayoutBookModel _layoutMesa;

  final _layoutMesaStreamController =
      StreamController<LayoutBookModel>.broadcast();

  Function(LayoutBookModel) get layoutMesaSink =>
      _layoutMesaStreamController.sink.add;

  Future<LayoutBookModel> getBookInspiracion() async {
    String token = await _sharedPreferences.getToken();
    int idEvento = await _sharedPreferences.getIdEvento();

    final data = {
      'idEvento': idEvento,
    };

    final endpoint = '/wedding/';

    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token
    };

    final response = await http.post(
        Uri.parse(
            confiC.url + confiC.puerto + endpoint + 'BOOK/getBookInspiracion'),
        body: json.encode(data),
        headers: headers);

    if (response.statusCode == 200) {
      final layoutMesa = LayoutBookModel.fromJson(json.decode(response.body));

      _layoutMesa = layoutMesa;
      layoutMesaSink(_layoutMesa);
      return _layoutMesa;
    } else {
      return null;
    }
  }

  Future<String> createBookInspiracion(
      String fileBase64, String extension) async {
    String token = await _sharedPreferences.getToken();
    int idEvento = await _sharedPreferences.getIdEvento();

    final data = {
      'idEvento': idEvento,
      'file': fileBase64,
      'mime': extension,
    };

    final endpoint = 'wedding/BOOK/uploadBookInspiracion';

    final headers = {
      HttpHeaders.authorizationHeader: token,
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };

    final response = await client.post(
      Uri.parse(confiC.url + confiC.puerto + '/' + endpoint),
      body: json.encode(data),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return 'Ok';
    } else {
      return 'Ocurrio un error';
    }
  }
}

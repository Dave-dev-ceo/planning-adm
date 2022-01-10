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
  List<LayoutBookModel> _layoutBookImages = [];

  final _layoutBookInspiracionStreamController =
      StreamController<List<LayoutBookModel>>.broadcast();

  Function(List<LayoutBookModel>) get layoutBookImagesSink =>
      _layoutBookInspiracionStreamController.sink.add;

  Stream<List<LayoutBookModel>> get layoutBookImagesStream =>
      _layoutBookInspiracionStreamController.stream;

  void dispose() {
    _layoutBookInspiracionStreamController?.close();
  }

  Future<List<LayoutBookModel>> getBookInspiracion() async {
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
      headers: headers,
    );

    if (response.statusCode == 200) {
      final layoutMesa = List<LayoutBookModel>.from(json
          .decode(response.body)
          .map((b) => LayoutBookModel.fromJson(b))).toList();

      layoutBookImagesSink(layoutMesa);
      return layoutMesa;
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

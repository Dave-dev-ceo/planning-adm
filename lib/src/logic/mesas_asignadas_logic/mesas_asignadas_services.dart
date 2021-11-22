import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:planning/src/models/MesasAsignadas/mesas_asignadas_model.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/models/mesa/layout_mesa_model.dart';
import 'package:planning/src/resources/config_conection.dart';
import 'package:http/http.dart' as http;

class MesasAsignadasService {
  SharedPreferencesT _sharedPreferencesT = SharedPreferencesT();
  ConfigConection confiC = ConfigConection();

  List<MesasAsignadasModel> _mesasAsignadas = [];
  LayoutMesaModel _layoutMesa;

  final _mesasAsignadasStreamController =
      StreamController<List<MesasAsignadasModel>>.broadcast();

  Function(List<MesasAsignadasModel>) get mesasAsignadasSink =>
      _mesasAsignadasStreamController.sink.add;

  Stream<List<MesasAsignadasModel>> get mesasAsignadasStream =>
      _mesasAsignadasStreamController.stream;

  final _layoutMesaStreamController =
      StreamController<LayoutMesaModel>.broadcast();

  Function(LayoutMesaModel) get layoutMesaSink =>
      _layoutMesaStreamController.sink.add;

  Stream<LayoutMesaModel> get layoutMesaStream =>
      _layoutMesaStreamController.stream;

  void dispose() {
    _mesasAsignadasStreamController?.close();
    _layoutMesaStreamController?.close();
  }

  Future<LayoutMesaModel> getLayoutMesa() async {
    String token = await _sharedPreferencesT.getToken();
    int idEvento = await _sharedPreferencesT.getIdEvento();

    final data = {
      'idEvento': idEvento,
    };

    final endpoint = 'wedding/MESAS/getLayoutMesa';

    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token
    };

    final response = await http.post(
        Uri.parse(confiC.url + confiC.puerto + '/' + endpoint),
        body: json.encode(data),
        headers: headers);

    if (response.statusCode == 200) {
      final layoutMesa = LayoutMesaModel.fromJson(json.decode(response.body));

      _layoutMesa = layoutMesa;
      layoutMesaSink(_layoutMesa);
      return _layoutMesa;
    } else {
      return null;
    }
  }

  Future<List<MesasAsignadasModel>> getMesasAsignadas() async {
    int idEvento = await _sharedPreferencesT.getIdEvento();
    String token = await _sharedPreferencesT.getToken();
    final url = confiC.url + confiC.puerto;

    final data = {'idEvento': idEvento};

    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token
    };

    final endpoint = 'wedding/EVENTOS/getMesasAsignadas';

    final response = await http.post(Uri.parse(url + '/' + endpoint),
        body: jsonEncode(data), headers: headers);

    if (json.decode(response.body) == null) return [];

    _mesasAsignadas = List<MesasAsignadasModel>.from(json
        .decode(response.body)
        .map((data) => MesasAsignadasModel.fromJson(data)));

    mesasAsignadasSink(_mesasAsignadas);

    return _mesasAsignadas;
  }

  Future<String> deleteAsignadoFromMesa(
      List<MesasAsignadasModel> asignadosToDelete) async {
    String token = await _sharedPreferencesT.getToken();
    int id_planner = await _sharedPreferencesT.getIdPlanner();
    final url = confiC.url + confiC.puerto;

    final data = {
      'id_planner': id_planner,
      'asignadosToDelete':
          asignadosToDelete.map((e) => e.idMesaAsignada).toList(),
    };

    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token
    };

    final endpoint = 'wedding/EVENTOS/deleteAsignadosOnMesas';

    final response = await http.post(Uri.parse(url + '/' + endpoint),
        body: json.encode(data), headers: headers);

    if (response.statusCode == 200) {
      return 'Ok';
    } else {
      return 'Ocurrio un error';
    }
  }

  Future<String> asignarPersonasMesas(
      List<MesasAsignadasModel> listAsignarMesaModel) async {
    String token = await _sharedPreferencesT.getToken();
    int id_planner = await _sharedPreferencesT.getIdPlanner();
    final url = confiC.url + confiC.puerto;

    final data = {
      'id_planner': id_planner,
      'mesasAsignadas': listAsignarMesaModel.map((e) => e.toJson()).toList()
    };

    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token
    };

    final endpoint = 'wedding/EVENTOS/createMesasAsignadas';

    final response = await http.post(Uri.parse(url + '/' + endpoint),
        body: json.encode(data), headers: headers);

    if (response.statusCode == 200) {
      await _sharedPreferencesT.setToken(json.decode(response.body)['token']);
      mesasAsignadasSink(_mesasAsignadas);

      return 'Ok';
    } else {
      return 'Ocurrio un error';
    }
  }

  Future<String> getLogoPlanner() async {
    String token = await _sharedPreferencesT.getToken();
    int id_planner = await _sharedPreferencesT.getIdPlanner();
    final url = confiC.url + confiC.puerto;

    final data = {
      'idPlanner': id_planner,
    };

    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token
    };

    final endpoint = 'wedding/PLANNER/getLogoPlanner';

    final response = await http.post(Uri.parse(url + '/' + endpoint),
        body: json.encode(data), headers: headers);

    if (response.statusCode == 200) {
      return json.decode(response.body)['logo'];
    } else {
      return null;
    }
  }
}

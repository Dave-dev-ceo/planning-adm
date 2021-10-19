import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:weddingplanner/src/models/MesasAsignadas/mesas_asignadas_model.dart';
import 'package:weddingplanner/src/models/item_model_preferences.dart';
import 'package:weddingplanner/src/resources/config_conection.dart';
import 'package:http/http.dart' as http;

class MesasAsignadasService {
  SharedPreferencesT _sharedPreferencesT = SharedPreferencesT();
  ConfigConection confiC = ConfigConection();

  List<MesasAsignadasModel> _mesasAsignadas = [];

  final _mesasAsignadasStreamController =
      StreamController<List<MesasAsignadasModel>>.broadcast();

  Function(List<MesasAsignadasModel>) get mesasAsignadasSink =>
      _mesasAsignadasStreamController.sink.add;

  Stream<List<MesasAsignadasModel>> get mesasAsignadasStream =>
      _mesasAsignadasStreamController.stream;

  void dispose() {
    _mesasAsignadasStreamController?.close();
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
    print('Entra Aqui');
    print(response.statusCode);

    if (response.statusCode == 200) {
      print('Entra aqui');
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
}

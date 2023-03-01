import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/models/plannerModel/planner_model.dart';
import 'package:planning/src/resources/config_conection.dart';

class ListaPlannersException implements Exception {}

class CreatePlannersException implements Exception {}

class PlannersLogic {
  static final config = ConfigConection();
  final _sharedPreferencesT = SharedPreferencesT();

  Future<List<PlannerModel>?> obtenerPlanners() async {
    const endpoint = '/wedding/PLANNER/obtenerPlanners';

    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    final response = await http.post(
        Uri.parse(config.url! + config.puerto! + endpoint),
        headers: headers);

    if (response.statusCode == 200) {
      List<PlannerModel> planners = List<PlannerModel>.from(json
          .decode(response.body)['data']
          .map((p) => PlannerModel.fromJson(p)));

      return planners;
    } else {
      return null;
    }
  }

  Future<PlannerModel?> obtenerPlannerbyID(int? idPlanner) async {
    String? token = await _sharedPreferencesT.getToken();
    const endpoint = '/wedding/PLANNER/obtenerPlanerPorId';

    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token ?? '',
    };

    final body = {
      'idPlanner': idPlanner,
    };

    final response = await http.post(
        Uri.parse(config.url! + config.puerto! + endpoint),
        body: json.encode(body),
        headers: headers);

    if (response.statusCode == 200) {
      return PlannerModel.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

  Future<bool> editarPlanner(PlannerModel plannerEdit) async {
    String? token = await _sharedPreferencesT.getToken();
    const endpoint = '/wedding/PLANNER/editPlanner';

    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token ?? '',
    };

    final body = {
      'idPlanner': plannerEdit.idPlanner,
      'idUsuario': plannerEdit.idUsuario,
      'nombre': plannerEdit.nombreCompleto,
      'nombreEmpresa': plannerEdit.nombreEmpresa,
      'telefono': plannerEdit.telefono,
      'correo': plannerEdit.correo,
      'direccion': plannerEdit.direccion,
      'estatus': plannerEdit.estatus,
    };

    final response = await http.post(
        Uri.parse(config.url! + config.puerto! + endpoint),
        body: json.encode(body),
        headers: headers);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> agregarPlanner(PlannerModel plannerEdit) async {
    String? token = await _sharedPreferencesT.getToken();
    const endpoint = '/wedding/PLANNER/agregarPlanner';

    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token ?? '',
    };

    final body = {
      'nombre': plannerEdit.nombreCompleto,
      'nombreEmpresa': plannerEdit.nombreEmpresa,
      'telefono': plannerEdit.telefono,
      'correo': plannerEdit.correo,
      'direccion': plannerEdit.direccion,
    };

    final response = await http.post(
        Uri.parse(config.url! + config.puerto! + endpoint),
        body: json.encode(body),
        headers: headers);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}

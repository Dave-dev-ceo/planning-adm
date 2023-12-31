import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:hive_flutter/adapters.dart';
import 'package:planning/src/models/MesasAsignadas/mesas_asignadas_model.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/models/mesa/layout_mesa_model.dart';
import 'package:planning/src/resources/config_conection.dart';
import 'package:http/http.dart' as http;

class MesasAsignadasService {
  final SharedPreferencesT _sharedPreferencesT = SharedPreferencesT();
  ConfigConection confiC = ConfigConection();

  List<MesasAsignadasModel> mesasAsignadas = [];
  LayoutMesaModel? _layoutMesa;

  final _mesasAsignadasStreamController =
      StreamController<List<MesasAsignadasModel>>.broadcast();

  Function(List<MesasAsignadasModel>) get mesasAsignadasSink =>
      _mesasAsignadasStreamController.sink.add;

  Stream<List<MesasAsignadasModel>> get mesasAsignadasStream =>
      _mesasAsignadasStreamController.stream;

  final _layoutMesaStreamController =
      StreamController<LayoutMesaModel?>.broadcast();

  Function(LayoutMesaModel?) get layoutMesaSink =>
      _layoutMesaStreamController.sink.add;

  Stream<LayoutMesaModel?> get layoutMesaStream =>
      _layoutMesaStreamController.stream;

  void dispose() {
    _mesasAsignadasStreamController.close();
    _layoutMesaStreamController.close();
  }

  Future<LayoutMesaModel?> getLayoutMesa() async {
    bool desconectado = await _sharedPreferencesT.getModoConexion();
    String? token = await _sharedPreferencesT.getToken();
    int? idEvento = await _sharedPreferencesT.getIdEvento();

    if (desconectado) {
      if (!Hive.isBoxOpen('layouts')) {
        await Hive.openBox<dynamic>('layouts');
      }
      final boxLayouts = Hive.box<dynamic>('layouts');
      final listaLayouts = [...boxLayouts.values];
      final indexLayout =
          listaLayouts.indexWhere((l) => l['id_evento'] == idEvento);
      if (indexLayout != -1) {
        final layoutMesa = Map<String, dynamic>.from(listaLayouts[indexLayout]);
        return LayoutMesaModel.fromJson(layoutMesa);
      } else {
        return null;
      }
    } else {
      final data = {
        'idEvento': idEvento,
      };

      const endpoint = 'wedding/MESAS/getLayoutMesa';

      final headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        HttpHeaders.authorizationHeader: token ?? ''
      };

      final response = await http.post(
          Uri.parse('${confiC.url}${confiC.puerto}/$endpoint'),
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
  }

  Future<bool> eliminarLayoutMesa() async {
    String? token = await _sharedPreferencesT.getToken();
    int? idEvento = await _sharedPreferencesT.getIdEvento();

    final data = {
      'idEvento': idEvento,
    };

    const endpoint = 'wedding/MESAS/eliminarLayoutMesa';

    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token ?? ''
    };

    final response = await http.post(
        Uri.parse('${confiC.url}${confiC.puerto}/$endpoint'),
        body: json.encode(data),
        headers: headers);

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<List<MesasAsignadasModel>> getMesasAsignadas() async {
    int? idEvento = await _sharedPreferencesT.getIdEvento();
    bool desconectado = await _sharedPreferencesT.getModoConexion();
    if (desconectado) {
      if (!Hive.isBoxOpen('mesasAsignadas')) {
        await Hive.openBox<dynamic>('mesasAsignadas');
      }
      final boxMesasAsignadas = Hive.box<dynamic>('mesasAsignadas');
      final listaMesasAsignadas =
          boxMesasAsignadas.values.where((ma) => ma['id_evento'] == idEvento);
      if (listaMesasAsignadas.isEmpty) {
        return [];
      }
      return List<MesasAsignadasModel>.from(listaMesasAsignadas.map((data) =>
          MesasAsignadasModel.fromJson(Map<String, dynamic>.from(data))));
    } else {
      String? token = await _sharedPreferencesT.getToken();
      final url = confiC.url! + confiC.puerto!;

      final data = {'idEvento': idEvento};

      final headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        HttpHeaders.authorizationHeader: token ?? ''
      };

      const endpoint = 'wedding/EVENTOS/getMesasAsignadas';

      final response = await http.post(Uri.parse('$url/$endpoint'),
          body: jsonEncode(data), headers: headers);

      if (json.decode(response.body) == null) return [];

      mesasAsignadas = List<MesasAsignadasModel>.from(json
          .decode(response.body)
          .map((data) => MesasAsignadasModel.fromJson(data)));

      mesasAsignadasSink(mesasAsignadas);

      return mesasAsignadas;
    }
  }

  Future<String> deleteAsignadoFromMesa(
      List<MesasAsignadasModel?> asignadosToDelete) async {
    String? token = await _sharedPreferencesT.getToken();
    int? idPlanner = await _sharedPreferencesT.getIdPlanner();
    final url = confiC.url! + confiC.puerto!;

    final data = {
      'id_planner': idPlanner,
      'asignadosToDelete':
          asignadosToDelete.map((e) => e!.idMesaAsignada).toList(),
    };

    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token ?? ''
    };

    const endpoint = 'wedding/EVENTOS/deleteAsignadosOnMesas';

    final response = await http.post(Uri.parse('$url/$endpoint'),
        body: json.encode(data), headers: headers);

    if (response.statusCode == 200) {
      return 'Ok';
    } else {
      return 'Ocurrio un error';
    }
  }

  Future<String> asignarPersonasMesas(
      List<MesasAsignadasModel> listAsignarMesaModel) async {
    String? token = await _sharedPreferencesT.getToken();
    int? idPlanner = await _sharedPreferencesT.getIdPlanner();
    final url = confiC.url! + confiC.puerto!;

    final data = {
      'id_planner': idPlanner,
      'mesasAsignadas': listAsignarMesaModel.map((e) => e.toJson()).toList()
    };

    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token ?? ''
    };

    const endpoint = 'wedding/EVENTOS/createMesasAsignadas';

    final response = await http.post(Uri.parse('$url/$endpoint'),
        body: json.encode(data), headers: headers);

    if (response.statusCode == 200) {
      await _sharedPreferencesT.setToken(json.decode(response.body)['token']);
      mesasAsignadasSink(mesasAsignadas);

      return 'Ok';
    } else {
      return 'Ocurrio un error';
    }
  }

  Future<String?> getLogoPlanner() async {
    String? token = await _sharedPreferencesT.getToken();
    int? idPlanner = await _sharedPreferencesT.getIdPlanner();
    final url = confiC.url! + confiC.puerto!;

    final data = {
      'idPlanner': idPlanner,
    };

    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token ?? ''
    };

    const endpoint = 'wedding/PLANNER/getLogoPlanner';

    final response = await http.post(Uri.parse('$url/$endpoint'),
        body: json.encode(data), headers: headers);

    if (response.statusCode == 200) {
      return json.decode(response.body)['logo'];
    } else {
      return null;
    }
  }

  Future<String?> getPDFMesasAsiganadas() async {
    String? token = await _sharedPreferencesT.getToken();
    int? idPlanner = await _sharedPreferencesT.getIdPlanner();
    int? idEvento = await _sharedPreferencesT.getIdEvento();
    final url = confiC.url! + confiC.puerto!;

    final data = {'idPlanner': idPlanner, 'idEvento': idEvento};

    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token ?? ''
    };

    const endpoint = 'wedding/INVITADOS/getPDFMesasAsiganadas';

    final response = await http.post(Uri.parse('$url/$endpoint'),
        body: json.encode(data), headers: headers);

    if (response.statusCode == 200) {
      return json.decode(response.body)['pdf'];
    } else {
      return null;
    }
  }
}

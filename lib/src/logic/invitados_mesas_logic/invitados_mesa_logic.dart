import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:planning/src/models/invitadosConfirmadosModel/invitado_mesa_model.dart';

import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/resources/config_conection.dart';

abstract class InvitadosConfirmadosLogic {
  Future<List<InvitadosConfirmadosModel>> getInvitadosConfirmados();
}

class InvitadosMesasException implements Exception {}

class ServiceInvitadosMesasLogic extends InvitadosConfirmadosLogic {
  final SharedPreferencesT _sharedPreferences = SharedPreferencesT();
  ConfigConection confiC = ConfigConection();

  @override
  Future<List<InvitadosConfirmadosModel>> getInvitadosConfirmados() async {
    bool desconectado = await _sharedPreferences.getModoConexion();
    if (desconectado) {
      return null;
    }
    int idEvento = await _sharedPreferences.getIdEvento();
    String token = await _sharedPreferences.getToken();

    final data = {'idEvento': idEvento};

    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      HttpHeaders.authorizationHeader: token
    };

    const endpoint = 'wedding/INVITADOS/obtenerInvitadosConfirmados';

    final response = await http.post(
        Uri.parse('${confiC.url}${confiC.puerto}/$endpoint'),
        body: json.encode(data),
        headers: headers);

    if (response.statusCode == 200) {
      return List<InvitadosConfirmadosModel>.from(json
          .decode(response.body)
          .map((data) => InvitadosConfirmadosModel.fromJson(data)));
    } else {
      throw InvitadosMesasException();
    }
  }
}

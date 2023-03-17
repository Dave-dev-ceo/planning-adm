import 'dart:convert';
import 'dart:io';

import 'package:hive_flutter/adapters.dart';
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/models/qr_model/qr_model.dart';
import 'package:planning/src/resources/config_conection.dart';
import 'package:http/http.dart' as http;

class QrLogic {
  final SharedPreferencesT _sharedPreferencesT = SharedPreferencesT();
  final ConfigConection _configC = ConfigConection();

  Future<QrInvitadoModel?> validarQr(String? qrData) async {
    bool desconectado = await _sharedPreferencesT.getModoConexion();
    int? idEvento = await _sharedPreferencesT.getIdEvento();
    int? idPlanner = await _sharedPreferencesT.getIdEvento();

    if (desconectado) {
      if (!Hive.isBoxOpen('QR')) {
        await Hive.openBox<dynamic>('QR');
      }
      final boxQR = Hive.box<dynamic>('QR');
      final qr = boxQR.values
          .firstWhere((qr) => qr['id_invitado'].toString() == qrData);
      return qrInvitadoModelFromJson(json.encode(qr));
    } else {
      String? token = await _sharedPreferencesT.getToken();
      const endpoint = '/wedding/INVITADOS/desencryptQrData';
      final data = {
        'idPlanner': idPlanner,
        'idEvento': idEvento,
        'qrData': qrData,
      };

      final headers = {
        HttpHeaders.authorizationHeader: token ?? '',
        'content-type': 'application/json',
        'accept': 'application/json'
      };

      final response = await http.post(
        Uri.parse(_configC.url! + _configC.puerto! + endpoint),
        body: json.encode(data),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return qrInvitadoModelFromJson(response.body);
      } else if (response.statusCode == 302) {
        return QrInvitadoModel();
      } else {
        return null;
      }
    }
  }
}

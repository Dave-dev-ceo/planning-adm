import 'dart:convert';
import 'dart:io';

import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/models/prospectosModel/prospecto_model.dart';
import 'package:planning/src/resources/config_conection.dart';
import 'package:http/http.dart' as http;

class ProspectoLogic {
  SharedPreferencesT _sharedPreferencesT = SharedPreferencesT();
  ConfigConection _configC = ConfigConection();

  Future<List<EtapasModel>> getEtapasAndProspectos() async {
    String token = await _sharedPreferencesT.getToken();
    int idPlanner = await _sharedPreferencesT.getIdPlanner();

    const endpoint = '/wedding/PROSPECTO/getProspectosAndEtapas';

    final data = {
      'idPlanner': idPlanner,
    };

    final headers = {
      HttpHeaders.authorizationHeader: token,
      'content-type': 'application/json',
      'accept': 'application/json'
    };

    final response = await http.post(
      Uri.parse(_configC.url + _configC.puerto + endpoint),
      body: json.encode(data),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List<EtapasModel> etapas = [];

      etapas = List<EtapasModel>.from(
          json.decode(response.body).map((e) => EtapasModel.fromJson(e)));
      return etapas;
    } else {
      return null;
    }
  }

  Future<bool> addEtapasUpdate(ProspectoModel newProspecto) async {
    String token = await _sharedPreferencesT.getToken();
    int idPlanner = await _sharedPreferencesT.getIdPlanner();

    const endpoint = '/wedding/PROSPECTO/addProspecto';

    final data = {
      'idPlanner': idPlanner,
      'idEtapa': newProspecto.idEtapa,
      'nombreProspecto': newProspecto.nombreProspecto,
    };

    final headers = {
      HttpHeaders.authorizationHeader: token,
      'content-type': 'application/json',
      'accept': 'application/json'
    };

    final response = await http.post(
      Uri.parse(_configC.url + _configC.puerto + endpoint),
      body: json.encode(data),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateEtapaProspecto(int idEtapa, int idProspecto) async {
    String token = await _sharedPreferencesT.getToken();
    int idPlanner = await _sharedPreferencesT.getIdPlanner();

    const endpoint = '/wedding/PROSPECTO/updateEtapaProspecto';

    final data = {
      'idPlanner': idPlanner,
      'idEtapa': idEtapa,
      'idProspecto': idProspecto,
    };

    final headers = {
      HttpHeaders.authorizationHeader: token,
      'content-type': 'application/json',
      'accept': 'application/json'
    };

    final response = await http.post(
      Uri.parse(_configC.url + _configC.puerto + endpoint),
      body: json.encode(data),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateEtapa(List<UpdateEtapaModel> etapasToUpdate) async {
    String token = await _sharedPreferencesT.getToken();
    int idPlanner = await _sharedPreferencesT.getIdPlanner();

    const endpoint = '/wedding/PROSPECTO/updateEtapa';

    final data = {
      'idPlanner': idPlanner,
      'etapas': etapasToUpdate.map((e) => e.toJson()).toList()
    };

    final headers = {
      HttpHeaders.authorizationHeader: token,
      'content-type': 'application/json',
      'accept': 'application/json'
    };

    final response = await http.post(
      Uri.parse(_configC.url + _configC.puerto + endpoint),
      body: json.encode(data),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> addEtapa(EtapasModel newEtapa) async {
    String token = await _sharedPreferencesT.getToken();
    int idPlanner = await _sharedPreferencesT.getIdPlanner();

    const endpoint = '/wedding/PROSPECTO/addEtapa';

    final data = {
      'idPlanner': idPlanner,
      'nombre': newEtapa.nombreEtapa,
      'orden': newEtapa.ordenEtapa,
      'descripcion': newEtapa.descripcionEtapa,
      'color': newEtapa.color
    };

    final headers = {
      HttpHeaders.authorizationHeader: token,
      'content-type': 'application/json',
      'accept': 'application/json'
    };

    final response = await http.post(
      Uri.parse(_configC.url + _configC.puerto + endpoint),
      body: json.encode(data),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateNameProspecto(ProspectoModel prospectoToEdit) async {
    String token = await _sharedPreferencesT.getToken();
    int idPlanner = await _sharedPreferencesT.getIdPlanner();

    const endpoint = '/wedding/PROSPECTO/editNameProspecto';

    final data = {
      'idPlanner': idPlanner,
      'nombreProspecto': prospectoToEdit.nombreProspecto,
      'idProspecto': prospectoToEdit.idProspecto,
    };

    final headers = {
      HttpHeaders.authorizationHeader: token,
      'content-type': 'application/json',
      'accept': 'application/json'
    };

    final response = await http.post(
      Uri.parse(_configC.url + _configC.puerto + endpoint),
      body: json.encode(data),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updatePhoneProspecto(ProspectoModel prospectoToEdit) async {
    String token = await _sharedPreferencesT.getToken();
    int idPlanner = await _sharedPreferencesT.getIdPlanner();

    const endpoint = '/wedding/PROSPECTO/updatePhoneProspecto';

    final data = {
      'idPlanner': idPlanner,
      'telefono': prospectoToEdit.telefono,
      'idProspecto': prospectoToEdit.idProspecto,
    };

    final headers = {
      HttpHeaders.authorizationHeader: token,
      'content-type': 'application/json',
      'accept': 'application/json'
    };

    final response = await http.post(
      Uri.parse(_configC.url + _configC.puerto + endpoint),
      body: json.encode(data),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateCorreoProspecto(ProspectoModel prospectoToEdit) async {
    String token = await _sharedPreferencesT.getToken();
    int idPlanner = await _sharedPreferencesT.getIdPlanner();

    const endpoint = '/wedding/PROSPECTO/updateCorreoProspecto';

    final data = {
      'idPlanner': idPlanner,
      'correo': prospectoToEdit.correo,
      'idProspecto': prospectoToEdit.idProspecto,
    };

    final headers = {
      HttpHeaders.authorizationHeader: token,
      'content-type': 'application/json',
      'accept': 'application/json'
    };

    final response = await http.post(
      Uri.parse(_configC.url + _configC.puerto + endpoint),
      body: json.encode(data),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateDescripcionProspecto(
      ProspectoModel prospectoToEdit) async {
    String token = await _sharedPreferencesT.getToken();
    int idPlanner = await _sharedPreferencesT.getIdPlanner();

    const endpoint = '/wedding/PROSPECTO/updateDescripcionProspecto';

    final data = {
      'idPlanner': idPlanner,
      'descripcion': prospectoToEdit.descripcion,
      'idProspecto': prospectoToEdit.idProspecto,
    };

    final headers = {
      HttpHeaders.authorizationHeader: token,
      'content-type': 'application/json',
      'accept': 'application/json'
    };

    final response = await http.post(
      Uri.parse(_configC.url + _configC.puerto + endpoint),
      body: json.encode(data),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> insertActividadProspecto(
      ActividadProspectoModel newActividadProspecto) async {
    String token = await _sharedPreferencesT.getToken();
    int idPlanner = await _sharedPreferencesT.getIdPlanner();

    const endpoint = '/wedding/PROSPECTO/insertActividadProspecto';

    final data = {
      'idPlanner': idPlanner,
      'descripcion': newActividadProspecto.descripcion,
      'idProspecto': newActividadProspecto.idProspecto,
    };

    final headers = {
      HttpHeaders.authorizationHeader: token,
      'content-type': 'application/json',
      'accept': 'application/json'
    };

    final response = await http.post(
      Uri.parse(_configC.url + _configC.puerto + endpoint),
      body: json.encode(data),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> editNameEtapa(EtapasModel etapaToEdit) async {
    String token = await _sharedPreferencesT.getToken();
    int idPlanner = await _sharedPreferencesT.getIdPlanner();

    const endpoint = '/wedding/PROSPECTO/editNameEtapa';

    final data = {
      'idPlanner': idPlanner,
      'nombre': etapaToEdit.nombreEtapa,
      'idEtapa': etapaToEdit.idEtapa,
    };

    final headers = {
      HttpHeaders.authorizationHeader: token,
      'content-type': 'application/json',
      'accept': 'application/json'
    };

    final response = await http.post(
      Uri.parse(_configC.url + _configC.puerto + endpoint),
      body: json.encode(data),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteEtapa(int idEtapa) async {
    String token = await _sharedPreferencesT.getToken();
    int idPlanner = await _sharedPreferencesT.getIdPlanner();

    const endpoint = '/wedding/PROSPECTO/deleteEtapa';

    final data = {
      'idPlanner': idPlanner,
      'idEtapa': idEtapa,
    };

    final headers = {
      HttpHeaders.authorizationHeader: token,
      'content-type': 'application/json',
      'accept': 'application/json'
    };

    final response = await http.post(
      Uri.parse(_configC.url + _configC.puerto + endpoint),
      body: json.encode(data),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteActividadProspecto(int idActividad) async {
    String token = await _sharedPreferencesT.getToken();
    int idPlanner = await _sharedPreferencesT.getIdPlanner();

    const endpoint = '/wedding/PROSPECTO/deleteActividadProspecto';

    final data = {
      'idPlanner': idPlanner,
      'idActividad': idActividad,
    };

    final headers = {
      HttpHeaders.authorizationHeader: token,
      'content-type': 'application/json',
      'accept': 'application/json'
    };

    final response = await http.post(
      Uri.parse(_configC.url + _configC.puerto + endpoint),
      body: json.encode(data),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> editActividad(ActividadProspectoModel actividadToEdit) async {
    String token = await _sharedPreferencesT.getToken();
    int idPlanner = await _sharedPreferencesT.getIdPlanner();

    const endpoint = '/wedding/PROSPECTO/editActividad';

    final data = {
      'idPlanner': idPlanner,
      'descripcion': actividadToEdit.descripcion,
      'idActividad': actividadToEdit.idActividad,
    };

    final headers = {
      HttpHeaders.authorizationHeader: token,
      'content-type': 'application/json',
      'accept': 'application/json'
    };

    final response = await http.post(
      Uri.parse(_configC.url + _configC.puerto + endpoint),
      body: json.encode(data),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> editDatosEtapas(EtapasModel etapaToEdit) async {
    String token = await _sharedPreferencesT.getToken();
    int idPlanner = await _sharedPreferencesT.getIdPlanner();

    const endpoint = '/wedding/PROSPECTO/editDatosEtapas';

    final data = {
      'idPlanner': idPlanner,
      'nombre': etapaToEdit.nombreEtapa,
      'descripcion': etapaToEdit.descripcionEtapa,
      'idActividad': etapaToEdit.idEtapa,
      'color': etapaToEdit.color,
    };

    final headers = {
      HttpHeaders.authorizationHeader: token,
      'content-type': 'application/json',
      'accept': 'application/json'
    };

    final response = await http.post(
      Uri.parse(_configC.url + _configC.puerto + endpoint),
      body: json.encode(data),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> editInvolucrado(ProspectoModel prospectoModel) async {
    String token = await _sharedPreferencesT.getToken();
    int idPlanner = await _sharedPreferencesT.getIdPlanner();

    const endpoint = '/wedding/PROSPECTO/editInvolucradoProspecto';

    final data = {
      'idPlanner': idPlanner,
      'involucrado': prospectoModel.involucradoProspecto,
      'idProspecto': prospectoModel.idProspecto,
    };

    final headers = {
      HttpHeaders.authorizationHeader: token,
      'content-type': 'application/json',
      'accept': 'application/json'
    };

    final response = await http.post(
      Uri.parse(_configC.url + _configC.puerto + endpoint),
      body: json.encode(data),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> eventoFromProspecto(int idProspecto) async {
    String token = await _sharedPreferencesT.getToken();
    int idPlanner = await _sharedPreferencesT.getIdPlanner();

    const endpoint = '/wedding/PROSPECTO/eventoFromProspecto';

    final data = {
      'idPlanner': idPlanner,
      'idProspecto': idProspecto,
    };

    final headers = {
      HttpHeaders.authorizationHeader: token,
      'content-type': 'application/json',
      'accept': 'application/json'
    };

    final response = await http.post(
      Uri.parse(_configC.url + _configC.puerto + endpoint),
      body: json.encode(data),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteProspecto(int idProspecto) async {
    String token = await _sharedPreferencesT.getToken();
    int idPlanner = await _sharedPreferencesT.getIdPlanner();

    const endpoint = '/wedding/PROSPECTO/deleteProspecto';

    final data = {
      'idPlanner': idPlanner,
      'idProspecto': idProspecto,
    };

    final headers = {
      HttpHeaders.authorizationHeader: token,
      'content-type': 'application/json',
      'accept': 'application/json'
    };

    final response = await http.post(
      Uri.parse(_configC.url + _configC.puerto + endpoint),
      body: json.encode(data),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}

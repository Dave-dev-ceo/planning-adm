import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:planning/src/models/item_model_preferences.dart';
import 'package:planning/src/resources/config_conection.dart';
import 'package:planning/src/ui/widgets/snackbar_widget/snackbar_widget.dart';

import '../animations/loading_animation.dart';

abstract class ListaEventosOfflineLogic {
  Future<void> fetchEventosOffline(int idEvento, BuildContext context);
  Future<void> subirCambiosEventos(BuildContext context);
  Future<void> registrarAsistenciaOffline(int idInvitado);
  Future<List<bool>> eventoDescargado(int idEvento);
}

class FetchListaEventosOfflineLogic extends ListaEventosOfflineLogic {
  final SharedPreferencesT _sharedPreferences = SharedPreferencesT();
  ConfigConection configC = ConfigConection();
  BuildContext _dialogContext;

  @override
  Future<void> fetchEventosOffline(int idEvento, BuildContext context) async {
    _dialogSpinner('Descargando evento', context);
    int idPlanner = await _sharedPreferences.getIdPlanner();
    String token = await _sharedPreferences.getToken();
    //Descarga de documentos
    final response = await http.post(
      Uri.parse(
          '${configC.url}${configC.puerto}/wedding/ADDCONTRATOS/descargarContratosEvento'),
      body: {
        'id_planner': idPlanner.toString(),
        'id_evento': idEvento.toString(),
      },
      headers: {HttpHeaders.authorizationHeader: token},
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      await _sharedPreferences.setToken(data['token']);
      if (!Hive.isBoxOpen('contratos')) {
        await Hive.openBox<dynamic>('contratos');
      }
      final boxContratos = Hive.box<dynamic>('contratos');
      final listaContratos = [...boxContratos.values];
      for (var d in data['data']) {
        if (boxContratos.values
            .any((b) => b['id_contrato'] == d['id_contrato'])) {
          final indexContrato = listaContratos
              .indexWhere((b) => b['id_contrato'] == d['id_contrato']);
          await boxContratos.putAt(indexContrato, d);
        } else {
          await boxContratos.add(d);
        }
      }
      await boxContratos.close();
      if (!Hive.isBoxOpen('eventosDescargados')) {
        await Hive.openBox<int>('eventosDescargados');
      }
      final boxEventosDescargados = Hive.box<int>('eventosDescargados');
      if (boxEventosDescargados.values.any((ed) => ed == idEvento)) {
      } else {
        await boxEventosDescargados.add(idEvento);
      }
      await boxEventosDescargados.close();
    }

    //Descarga de información de evento
    final responseEvento = await http.post(
      Uri.parse(
          '${configC.url}${configC.puerto}/wedding/EVENTOS/descargarEventoPorId'),
      body: {
        'id_planner': idPlanner.toString(),
        'idEvento': idEvento.toString(),
      },
      headers: {HttpHeaders.authorizationHeader: token},
    );
    if (responseEvento.statusCode == 200) {
      Map<String, dynamic> dataEvento = json.decode(responseEvento.body);
      if (!Hive.isBoxOpen('infoEventos')) {
        await Hive.openBox<dynamic>('infoEventos');
      }
      final boxInfoEventos = Hive.box<dynamic>('infoEventos');
      final listaInfoEventos = [...boxInfoEventos.values];
      if (boxInfoEventos.values
          .any((i) => i['id_evento'] == dataEvento['id_evento'])) {
        final indexInfo = listaInfoEventos
            .indexWhere((i) => i['id_evento'] == dataEvento['id_evento']);
        await boxInfoEventos.putAt(indexInfo, dataEvento);
      } else {
        await boxInfoEventos.add(dataEvento);
      }
      await boxInfoEventos.close();
    }
    Navigator.pop(_dialogContext);
    MostrarAlerta(
      mensaje: 'Se ha descargado el evento exitosamente',
      tipoMensaje: TipoMensaje.correcto,
    );
  }

  @override
  Future<List<bool>> eventoDescargado(int idEvento) async {
    if (!Hive.isBoxOpen('eventosDescargados')) {
      await Hive.openBox<int>('eventosDescargados');
    }
    final boxEventosDescargados = Hive.box<int>('eventosDescargados');
    final descargado = boxEventosDescargados.values.any((ed) => ed == idEvento);
    bool desconectado = await _sharedPreferences.getModoConexion();
    return [desconectado, descargado];
  }

  @override
  Future<void> subirCambiosEventos(BuildContext context) async {
    _dialogSpinner('Subiendo cambios', context);
    //Limpiar todos los documentos del dispositivo
    if (!Hive.isBoxOpen('contratos')) {
      await Hive.openBox<dynamic>('contratos');
    }
    final boxContratos = Hive.box<dynamic>('contratos');
    await boxContratos.clear();
    await boxContratos.close();
    //Remover los id's de los eventos descargados
    if (!Hive.isBoxOpen('eventosDescargados')) {
      await Hive.openBox<int>('eventosDescargados');
      ;
    }
    final boxEventosDescargados = Hive.box<int>('eventosDescargados');
    await boxEventosDescargados.clear();
    await boxEventosDescargados.close();
    //Terminar proceso
    Navigator.pop(_dialogContext);
    MostrarAlerta(
      mensaje: 'Se han subido sus cambios exitosamente',
      tipoMensaje: TipoMensaje.correcto,
    );
  }

  _dialogSpinner(String title, BuildContext context) {
    Widget child = const LoadingCustom();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        _dialogContext = context;
        return AlertDialog(
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
          content: child,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
        );
      },
    );
  }

  @override
  Future<void> registrarAsistenciaOffline(int idInvitado) async {
    if (!Hive.isBoxOpen('asistieron')) {
      await Hive.openBox<int>('asistieron');
    }
    final boxAsistieron = Hive.box<int>('asistieron');
    if (boxAsistieron.values.any((a) => a == idInvitado)) {
    } else {
      await boxAsistieron.add(idInvitado);
    }
    await boxAsistieron.close();
  }
}

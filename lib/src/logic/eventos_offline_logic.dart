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

    //Descarga de pdf's generados de evento
    final responsePDF = await http.post(
      Uri.parse(
          '${configC.url}${configC.puerto}/wedding/PDF/generarPdfsEvento'),
      body: {
        'id_planner': idPlanner.toString(),
        'id_evento': idEvento.toString(),
      },
      headers: {HttpHeaders.authorizationHeader: token},
    );
    if (responsePDF.statusCode == 200) {
      final List<dynamic> dataPDF = json.decode(responsePDF.body);
      if (!Hive.isBoxOpen('pdf')) {
        await Hive.openBox<dynamic>('pdf');
      }
      final boxPDF = Hive.box<dynamic>('pdf');
      final listaPDF = [...boxPDF.values];
      for (var p in dataPDF) {
        if (boxPDF.values.any((c) => c['id_contrato'] == p['id_contrato'])) {
          final indexPDF =
              listaPDF.indexWhere((c) => c['id_contrato'] == p['id_contrato']);
          await boxPDF.putAt(indexPDF, p);
        } else {
          await boxPDF.add(p);
        }
      }
      await boxPDF.close();
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

    //Descarga del resumen de pagos
    final responseResumenPagos = await http.post(
      Uri.parse(
          '${configC.url}${configC.puerto}/wedding/PAGOS/obtenerResumenPagosPorEvento'),
      body: json.encode({'idEvento': idEvento}),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        HttpHeaders.authorizationHeader: token,
      },
    );
    if (responseResumenPagos.statusCode == 200) {
      final resumen = jsonDecode(responseResumenPagos.body);
      if (!Hive.isBoxOpen('resumenPagos')) {
        await Hive.openBox<dynamic>('resumenPagos');
      }
      final boxResumenPagos = Hive.box<dynamic>('resumenPagos');
      final listaResumenesPago = [...boxResumenPagos.values];
      if (listaResumenesPago.any((r) => r['id_evento'] == idEvento)) {
        final indexResumen =
            listaResumenesPago.indexWhere((r) => r['id_evento'] == idEvento);
        await boxResumenPagos.putAt(indexResumen, resumen);
      } else {
        await boxResumenPagos.add(resumen);
      }
      await boxResumenPagos.close();
    }

    //Descarga de conteo de estatus
    final isInvolucrado = await _checkIsInvolucrado();
    String endpoint;
    if (isInvolucrado) {
      endpoint = '/wedding/PLANES/conteoPorEstatusActividadInvolucrado';
    } else {
      endpoint = '/wedding/PLANES/conteoPorEstatusActividad';
    }
    final responseConteo = await http.post(
      Uri.parse('${configC.url}${configC.puerto}$endpoint'),
      body: json.encode({'idPlanner': idPlanner, 'idEvento': idEvento}),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        HttpHeaders.authorizationHeader: token
      },
    );
    if (responseConteo.statusCode == 200) {
      final conteo = json.decode(responseConteo.body);
      if (!Hive.isBoxOpen('conteos')) {
        await Hive.openBox<dynamic>('conteos');
      }
      final boxConteos = Hive.box<dynamic>('conteos');
      final listaConteos = [...boxConteos.values];
      if (listaConteos.any((c) => c['id_evento'] == idEvento)) {
        final indexConteo =
            listaConteos.indexWhere((c) => c['id_evento'] == idEvento);
        await boxConteos.putAt(indexConteo, conteo);
      } else {
        await boxConteos.add(conteo);
      }
      await boxConteos.close();
    }

    //Descarga de reporte de invitados
    final responseReporte = await http.get(
      Uri.parse(
          '${configC.url}${configC.puerto}/wedding/INVITADOS/obtenerReporteInvitados/$idEvento'),
      headers: {HttpHeaders.authorizationHeader: token},
    );
    if (responseReporte.statusCode == 200) {
      final reporte = {
        'id_evento': idEvento,
        'reporte': json.decode(responseReporte.body),
      };
      if (!Hive.isBoxOpen('reportesInvitados')) {
        await Hive.openBox<dynamic>('reportesInvitados');
      }
      final boxReportesInvitados = Hive.box<dynamic>('reportesInvitados');
      final listaReportesInvitados = [...boxReportesInvitados.values];
      if (listaReportesInvitados.any((r) => r['id_evento'] == idEvento)) {
        final indexReporte = listaReportesInvitados
            .indexWhere((r) => r['id_evento'] == idEvento);
        await boxReportesInvitados.putAt(indexReporte, reporte);
      } else {
        await boxReportesInvitados.add(reporte);
      }
      await boxReportesInvitados.close();
    }

    //Descarga de información de invitados y acompañanates
    final responseInvitadosAcompanantes = await http.post(
      Uri.parse(
          '${configC.url}${configC.puerto}/wedding/INVITADOS/obtenterDatosInvitados'),
      body: json.encode({'idEvento': idEvento}),
      headers: {
        HttpHeaders.authorizationHeader: token,
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
    );
    if (responseInvitadosAcompanantes.statusCode == 200) {
      List<dynamic> datosInvitadosAcompanantes =
          json.decode(responseInvitadosAcompanantes.body);
      if (!Hive.isBoxOpen('invitadosAcompanantes')) {
        await Hive.openBox<dynamic>('invitadosAcompanantes');
      }
      final boxInvitadosAcompanantes =
          Hive.box<dynamic>('invitadosAcompanantes');
      final listaInvitadosAcompanantes = [...boxInvitadosAcompanantes.values];
      for (var i in datosInvitadosAcompanantes) {
        if (listaInvitadosAcompanantes
            .any((ia) => ia['id_invitado'] == i['id_invitado'])) {
          final indexInvitadosAcompanantes = listaInvitadosAcompanantes
              .indexWhere((ia) => ia['id_invitado'] == i['id_invitado']);
          await boxInvitadosAcompanantes.putAt(indexInvitadosAcompanantes, i);
        } else {
          await boxInvitadosAcompanantes.add(i);
        }
      }
      await boxInvitadosAcompanantes.close();
    }

    //Descargar información de asistentes
    final responseAsistentes = await http.post(
      Uri.parse(
          '${configC.url}${configC.puerto}/wedding/ASISTENCIA/descargarAsistenciasPorPlanner'),
      body: {
        'id_planner': idPlanner.toString(),
        'id_evento': idEvento.toString()
      },
      headers: {HttpHeaders.authorizationHeader: token},
    );
    if (responseAsistentes.statusCode == 200) {
      final List<dynamic> asistentes = json.decode(responseAsistentes.body);
      if (!Hive.isBoxOpen('asistencias')) {
        await Hive.openBox<dynamic>('asistencias');
      }
      final boxAsistencias = Hive.box<dynamic>('asistencias');
      final listaAsistencias = [...boxAsistencias.values];
      for (var a in asistentes) {
        if (listaAsistencias.any((as) =>
            as['id_invitado'] == a['id_invitado'] &&
            as['id_evento'] == a['id_evento'])) {
          final indexAsistencia = listaAsistencias.indexWhere((as) =>
              as['id_invitado'] == a['id_invitado'] &&
              as['id_evento'] == a['id_evento']);
          await boxAsistencias.putAt(indexAsistencia, a);
        } else {
          await boxAsistencias.add(a);
        }
      }
      await boxAsistencias.close();
    }

    //Finalizar
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
    //Remover los documentos de los eventos
    if (!Hive.isBoxOpen('contratos')) {
      await Hive.openBox<dynamic>('contratos');
    }
    final boxContratos = Hive.box<dynamic>('contratos');
    await boxContratos.clear();
    await boxContratos.close();
    //Remover los PDF generados
    if (!Hive.isBoxOpen('pdf')) {
      await Hive.openBox<dynamic>('pdf');
    }
    final boxPDF = Hive.box<dynamic>('pdf');
    await boxPDF.clear();
    await boxPDF.close();
    //Remover los id's de los eventos descargados
    if (!Hive.isBoxOpen('eventosDescargados')) {
      await Hive.openBox<int>('eventosDescargados');
    }
    final boxEventosDescargados = Hive.box<int>('eventosDescargados');
    await boxEventosDescargados.clear();
    await boxEventosDescargados.close();
    //Remover la información de los eventos descargados
    if (!Hive.isBoxOpen('infoEventos')) {
      await Hive.openBox<dynamic>('infoEventos');
    }
    final boxInfoEventos = Hive.box<dynamic>('infoEventos');
    await boxInfoEventos.clear();
    await boxInfoEventos.close();
    //Remover lista de invitados que asistieron
    if (!Hive.isBoxOpen('asistieron')) {
      await Hive.openBox<int>('asistieron');
    }
    final boxAsistieron = Hive.box<int>('asistieron');
    /**
     * Lógica para subir las asistencias
     */
    await boxAsistieron.clear();
    await boxAsistieron.close();
    //Remover los resúmenes de pago
    if (!Hive.isBoxOpen('resumenPagos')) {
      await Hive.openBox<dynamic>('resumenPagos');
    }
    final boxResumenPagos = Hive.box<dynamic>('resumenPagos');
    await boxResumenPagos.clear();
    await boxResumenPagos.close();
    //Remover los datos de conteos
    if (!Hive.isBoxOpen('conteos')) {
      await Hive.openBox<dynamic>('conteos');
    }
    final boxConteos = Hive.box<dynamic>('conteos');
    await boxConteos.clear();
    await boxConteos.close();
    //Remover los datos de reportes
    if (!Hive.isBoxOpen('reportesInvitados')) {
      await Hive.openBox<dynamic>('reportesInvitados');
    }
    final boxReportesInvitados = Hive.box<dynamic>('reportesInvitados');
    await boxReportesInvitados.clear();
    await boxReportesInvitados.close();
    //Remover lista de invitados y asistentes
    if (!Hive.isBoxOpen('invitadosAcompanantes')) {
      await Hive.openBox<dynamic>('invitadosAcompanantes');
    }
    final boxInvitadosAcompanantes = Hive.box<dynamic>('invitadosAcompanantes');
    await boxInvitadosAcompanantes.clear();
    await boxInvitadosAcompanantes.close();
    //Remover lista de asistencias
    if (!Hive.isBoxOpen('asistencias')) {
      await Hive.openBox<dynamic>('asistencias');
    }
    final boxAsistencias = Hive.box<dynamic>('asistencias');
    await boxAsistencias.clear();
    await boxAsistencias.close();
    // Remover lista de cambios en asistencias
    if (!Hive.isBoxOpen('cambiosAsistencias')) {
      await Hive.openBox<dynamic>('cambiosAsistencias');
    }
    final boxCambiosAsistencias = Hive.box<dynamic>('cambiosAsistencias');
    if (boxCambiosAsistencias.values.isNotEmpty) {
      final listaCambios = [...boxCambiosAsistencias.values];
      String token = await _sharedPreferences.getToken();
      final respCambios = await http.post(
        Uri.parse(
            '${configC.url}${configC.puerto}/wedding/ASISTENCIA/subirCambiosAsistencias'),
        body: json.encode(listaCambios),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          HttpHeaders.authorizationHeader: token,
        },
      );
      if (respCambios.statusCode == 200) {
        print(respCambios.body);
      }
    }
    await boxCambiosAsistencias.clear();
    await boxCambiosAsistencias.close();

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

  Future<bool> _checkIsInvolucrado() async {
    int idInvolucrado = await SharedPreferencesT().getIdInvolucrado();
    if (idInvolucrado != null) {
      return true;
    }
    return false;
  }
}

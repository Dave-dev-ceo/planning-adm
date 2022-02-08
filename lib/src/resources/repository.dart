import 'dart:async';
import 'package:flutter/material.dart';
import 'package:planning/src/models/item_model_acompanante.dart';
import 'package:planning/src/models/item_model_estatus_invitado.dart';
import 'package:planning/src/models/item_model_eventos.dart';
import 'package:planning/src/models/item_model_grupos.dart';
import 'package:planning/src/models/item_model_invitado.dart';
import 'package:planning/src/models/item_model_mesas.dart';
import 'package:planning/src/models/item_model_prueba.dart';
import 'package:planning/src/models/item_model_reporte_evento.dart';
import 'package:planning/src/models/item_model_reporte_genero.dart';
import 'package:planning/src/models/item_model_reporte_grupos.dart';
import 'package:planning/src/models/item_model_reporte_invitados.dart';

import 'api_provider.dart';
import '../models/item_model_invitados.dart';

class Repository {
  final apiProvider = ApiProvider();

  Future<ItemModelInvitados> fetchAllInvitados(BuildContext context) =>
      apiProvider.fetchInvitadosList(context);

  Future<ItemModelReporteInvitados> fetchReporteInvitados(
          BuildContext context) =>
      apiProvider.fetchReporteInvitados(context);

  Future<ItemModelReporteGrupos> fetchReporteGrupos(BuildContext context) =>
      apiProvider.fetchReporteGrupos(context);

  Future<ItemModelReporteInvitadosGenero> fetchReporteInvitadosGenero(
          BuildContext context) =>
      apiProvider.fetchReporteInvitadosGenero(context);

  Future<ItemModelGrupos> fetchAllGrupos(BuildContext context) =>
      apiProvider.fetchGruposList(context);

  Future<ItemModelEstatusInvitado> fetchAllEstatus(BuildContext context) =>
      apiProvider.fetchEstatusList(context);

  Future<ItemModelEventos> fetchAllEventos(BuildContext context) =>
      apiProvider.fetchEventosList(context);

  Future<ItemModelInvitado> fetchAllInvitado(
          int idInvitado, BuildContext context) =>
      apiProvider.fetchInvitadoList(idInvitado, context);

  Future<ItemModelMesas> fetchAllMesas(BuildContext context) =>
      apiProvider.fetchMesasList(context);

  Future<ItemModelReporte> fetchReportes(
          BuildContext context, Map<String, String> data) =>
      apiProvider.fetchReportesList(context, data);

  Future<ItemModelPrueba> fetchPrueba() => apiProvider.fetchPrueba();

  Future<ItemModelAcompanante> fetchAllAcompanante(
          int idInvitado, BuildContext context) =>
      apiProvider.fetchAcompananteList(idInvitado, context);
}

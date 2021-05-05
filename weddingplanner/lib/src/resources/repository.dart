import 'dart:async';
import 'package:weddingplanner/src/models/item_model_estatus_invitado.dart';
import 'package:weddingplanner/src/models/item_model_eventos.dart';
import 'package:weddingplanner/src/models/item_model_grupos.dart';
import 'package:weddingplanner/src/models/item_model_invitado.dart';
import 'package:weddingplanner/src/models/item_model_mesas.dart';
import 'package:weddingplanner/src/models/item_model_reporte_genero.dart';
import 'package:weddingplanner/src/models/item_model_reporte_invitados.dart';

import 'api_provider.dart';
import '../models/item_model_invitados.dart';

class Repository {
  final apiProvider = ApiProvider();

  Future<ItemModelInvitados> fetchAllInvitados(int id) => apiProvider.fetchInvitadosList(id);

  Future<ItemModelReporteInvitados> fetchReporteInvitados(int id) => apiProvider.fetchReporteInvitados(id);

  Future<ItemModelReporteInvitadosGenero> fetchReporteInvitadosGenero(int id) => apiProvider.fetchReporteInvitadosGenero(id);

  Future<ItemModelGrupos> fetchAllGrupos() => apiProvider.fetchGruposList();

  Future<ItemModelEstatusInvitado> fetchAllEstatus() => apiProvider.fetchEstatusList();

  Future<ItemModelEventos> fetchAllEventos() => apiProvider.fetchEventosList();

  Future<ItemModelInvitado> fetchAllInvitado(int id) => apiProvider.fetchInvitadoList(id);

  Future<ItemModelMesas> fetchAllMesas() => apiProvider.fetchMesasList();

}
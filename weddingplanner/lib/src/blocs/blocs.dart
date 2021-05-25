import 'package:flutter/material.dart';
import 'package:weddingplanner/src/models/item_model_estatus_invitado.dart';
import 'package:weddingplanner/src/models/item_model_eventos.dart';
import 'package:weddingplanner/src/models/item_model_grupos.dart';
import 'package:weddingplanner/src/models/item_model_invitado.dart';
import 'package:weddingplanner/src/models/item_model_mesas.dart';
import 'package:weddingplanner/src/models/item_model_reporte_evento.dart';
import 'package:weddingplanner/src/models/item_model_reporte_genero.dart';
import 'package:weddingplanner/src/models/item_model_reporte_grupos.dart';
import 'package:weddingplanner/src/models/item_model_reporte_invitados.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import '../models/item_model_invitados.dart';

final blocInvitados = InvitadosBloc();
final blocGrupos = GruposBloc();
final blocEventos = EventosBloc();
final blocEstatus = EstatusBloc();
final blocInvitado = InvitadoBloc();
final blocMesas = MesasBloc();
final blocReporte = ReportesBloc();
class InvitadosBloc{
  final _repository = Repository();
  final _invitadosFetcher = PublishSubject<ItemModelInvitados>();
  final _reporteInvitadosFetcher = PublishSubject<ItemModelReporteInvitados>();
  final _reporteInvitadosGeneroFetcher = PublishSubject<ItemModelReporteInvitadosGenero>();
  final _reporteGruposFetcher = PublishSubject<ItemModelReporteGrupos>();

  Stream<ItemModelInvitados> get allInvitados=>_invitadosFetcher.stream;
  Stream<ItemModelReporteInvitados> get reporteInvitados=>_reporteInvitadosFetcher.stream;
  Stream<ItemModelReporteInvitadosGenero> get reporteInvitadosGenero=>_reporteInvitadosGeneroFetcher.stream;
  Stream<ItemModelReporteGrupos> get reporteGrupos=>_reporteGruposFetcher.stream;

  fetchAllInvitados(BuildContext context) async {
    ItemModelInvitados itemModel = await _repository.fetchAllInvitados(context);
    _invitadosFetcher.sink.add(itemModel);
  }
  fetchAllReporteInvitados(BuildContext context) async {
    ItemModelReporteInvitados itemModel = await _repository.fetchReporteInvitados(context);
    _reporteInvitadosFetcher.sink.add(itemModel);
  }
    fetchAllReporteInvitadosGenero(BuildContext context) async {
    ItemModelReporteInvitadosGenero itemModel = await _repository.fetchReporteInvitadosGenero(context);
    _reporteInvitadosGeneroFetcher.sink.add(itemModel);
  }
  fetchAllReporteGrupos(BuildContext context) async {
    ItemModelReporteGrupos itemModel = await _repository.fetchReporteGrupos(context);
    _reporteGruposFetcher.sink.add(itemModel);
  }
  dispose() {
    _invitadosFetcher.close();
    _reporteInvitadosFetcher.close();
    _reporteInvitadosGeneroFetcher.close();
    _reporteGruposFetcher.close();
  }
}
class GruposBloc{
  final _repository = Repository();
  final _gruposFetcher = PublishSubject<ItemModelGrupos>();

  Stream<ItemModelGrupos> get allGrupos=>_gruposFetcher.stream;

  fetchAllGrupos(BuildContext context) async {
    ItemModelGrupos itemModel = await _repository.fetchAllGrupos(context);
    _gruposFetcher.sink.add(itemModel);
  }

  dispose() {
    _gruposFetcher.close();
  }
}

class EventosBloc{
  final _repository = Repository();
  final _eventosFetcher = PublishSubject<ItemModelEventos>();

  Stream<ItemModelEventos> get allEventos=>_eventosFetcher.stream;

  fetchAllEventos(BuildContext context) async {
    ItemModelEventos itemModel = await _repository.fetchAllEventos(context);
    _eventosFetcher.sink.add(itemModel);
  }

  dispose() {
    _eventosFetcher.close();
  }
}

class EstatusBloc{
  final _repository = Repository();
  final _estatusFetcher = PublishSubject<ItemModelEstatusInvitado>();

  Stream<ItemModelEstatusInvitado> get allEstatus=>_estatusFetcher.stream;

  fetchAllEstatus(BuildContext context) async {
    ItemModelEstatusInvitado itemModel = await _repository.fetchAllEstatus(context);
    _estatusFetcher.sink.add(itemModel);
  }

  dispose() {
    _estatusFetcher.close();
  }
}

class InvitadoBloc{
  final _repository = Repository();
  final _invitadoFetcher = PublishSubject<ItemModelInvitado>();

  Stream<ItemModelInvitado> get allInvitado=>_invitadoFetcher.stream;

  fetchAllInvitado(int idInvitado, BuildContext context) async {
    ItemModelInvitado itemModel = await _repository.fetchAllInvitado(idInvitado, context);
    _invitadoFetcher.sink.add(itemModel);
  }

  dispose() {
    _invitadoFetcher.close();
  }
}
class MesasBloc{
  final _repository = Repository();
  final _mesasFetcher = PublishSubject<ItemModelMesas>();

  Stream<ItemModelMesas> get allMesas=>_mesasFetcher.stream;

  fetchAllMesas(BuildContext context) async {
    ItemModelMesas itemModel = await _repository.fetchAllMesas(context);
    _mesasFetcher.sink.add(itemModel);
  }

  dispose() {
    _mesasFetcher.close();
  }
}
class ReportesBloc{
  final _repository = Repository();
  final _reportesFetcher = PublishSubject<ItemModelReporte>();

  Stream<ItemModelReporte> get allReportes=>_reportesFetcher.stream;

  fetchAllReportes(BuildContext context, Map<String, String> data) async {
    ItemModelReporte itemModel = await _repository.fetchReportes(context, data);
    _reportesFetcher.sink.add(itemModel);
  }

  dispose() {
    _reportesFetcher.close();
  }
}
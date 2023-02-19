import 'package:flutter/material.dart';
import 'package:planning/src/models/item_model_reporte_genero.dart';
import 'package:planning/src/models/item_model_reporte_invitados.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import '../models/item_model_invitados.dart';

class InvitadosBloc {
  final _repository = Repository();
  final _invitadosFetcher = PublishSubject<ItemModelInvitados?>();
  final _reporteInvitadosFetcher = PublishSubject<ItemModelReporteInvitados?>();
  final _reporteInvitadosGeneroFetcher =
      PublishSubject<ItemModelReporteInvitadosGenero?>();

  Stream<ItemModelInvitados?> get allInvitados => _invitadosFetcher.stream;
  Stream<ItemModelReporteInvitados?> get reporteInvitados =>
      _reporteInvitadosFetcher.stream;
  Stream<ItemModelReporteInvitadosGenero?> get reporteInvitadosGenero =>
      _reporteInvitadosGeneroFetcher.stream;

  fetchAllInvitados(BuildContext context) async {
    ItemModelInvitados? itemModel = await _repository.fetchAllInvitados(context);
    _invitadosFetcher.sink.add(itemModel);
  }

  fetchAllReporteInvitados(BuildContext context) async {
    ItemModelReporteInvitados? itemModel =
        await _repository.fetchReporteInvitados(context);
    _reporteInvitadosFetcher.sink.add(itemModel);
  }

  fetchAllReporteInvitadosGenero(BuildContext context) async {
    ItemModelReporteInvitadosGenero? itemModel =
        await _repository.fetchReporteInvitadosGenero(context);
    _reporteInvitadosGeneroFetcher.sink.add(itemModel);
  }

  dispose() {
    _invitadosFetcher.close();
    _reporteInvitadosFetcher.close();
    _reporteInvitadosGeneroFetcher.close();
  }
}

final bloc = InvitadosBloc();

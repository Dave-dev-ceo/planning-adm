import 'package:weddingplanner/src/models/item_model_estatus_invitado.dart';
import 'package:weddingplanner/src/models/item_model_eventos.dart';
import 'package:weddingplanner/src/models/item_model_grupos.dart';
import 'package:weddingplanner/src/models/item_model_invitado.dart';
import 'package:weddingplanner/src/models/item_model_mesas.dart';
import 'package:weddingplanner/src/models/item_model_reporte_genero.dart';
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
class InvitadosBloc{
  final _repository = Repository();
  final _invitadosFetcher = PublishSubject<ItemModelInvitados>();
  final _reporteInvitadosFetcher = PublishSubject<ItemModelReporteInvitados>();
  final _reporteInvitadosGeneroFetcher = PublishSubject<ItemModelReporteInvitadosGenero>();

  Stream<ItemModelInvitados> get allInvitados=>_invitadosFetcher.stream;
  Stream<ItemModelReporteInvitados> get reporteInvitados=>_reporteInvitadosFetcher.stream;
  Stream<ItemModelReporteInvitadosGenero> get reporteInvitadosGenero=>_reporteInvitadosGeneroFetcher.stream;

  fetchAllInvitados(int id) async {
    ItemModelInvitados itemModel = await _repository.fetchAllInvitados(id);
    _invitadosFetcher.sink.add(itemModel);
  }
  fetchAllReporteInvitados(int id) async {
    ItemModelReporteInvitados itemModel = await _repository.fetchReporteInvitados(id);
    _reporteInvitadosFetcher.sink.add(itemModel);
  }
    fetchAllReporteInvitadosGenero(int id) async {
    ItemModelReporteInvitadosGenero itemModel = await _repository.fetchReporteInvitadosGenero(id);
    _reporteInvitadosGeneroFetcher.sink.add(itemModel);
  }
  dispose() {
    _invitadosFetcher.close();
    _reporteInvitadosFetcher.close();
    _reporteInvitadosGeneroFetcher.close();
  }
}
class GruposBloc{
  final _repository = Repository();
  final _gruposFetcher = PublishSubject<ItemModelGrupos>();

  Stream<ItemModelGrupos> get allGrupos=>_gruposFetcher.stream;

  fetchAllGrupos() async {
    ItemModelGrupos itemModel = await _repository.fetchAllGrupos();
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

  fetchAllEventos() async {
    ItemModelEventos itemModel = await _repository.fetchAllEventos();
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

  fetchAllEstatus() async {
    ItemModelEstatusInvitado itemModel = await _repository.fetchAllEstatus();
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

  fetchAllInvitado(int id) async {
    ItemModelInvitado itemModel = await _repository.fetchAllInvitado(id);
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

  fetchAllMesas() async {
    ItemModelMesas itemModel = await _repository.fetchAllMesas();
    _mesasFetcher.sink.add(itemModel);
  }

  dispose() {
    _mesasFetcher.close();
  }
}

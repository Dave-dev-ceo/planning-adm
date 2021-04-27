import 'package:weddingplanner/src/models/item_model_eventos.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';
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
final bloc = EventosBloc();
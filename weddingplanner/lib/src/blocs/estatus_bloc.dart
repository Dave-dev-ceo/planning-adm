import 'package:weddingplanner/src/models/item_model_estatus_invitado.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

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
final bloc = EstatusBloc();
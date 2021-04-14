import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import '../models/item_model_invitados.dart';

class InvitadosBloc{
  final _repository = Repository();
  final _invitadosFetcher = PublishSubject<ItemModelInvitados>();

  Stream<ItemModelInvitados> get allInvitados=>_invitadosFetcher.stream;

  fetchAllInvitados() async {
    ItemModelInvitados itemModel = await _repository.fetchAllInvitados();
    _invitadosFetcher.sink.add(itemModel);
  }

  dispose() {
    _invitadosFetcher.close();
  }
}
final bloc = InvitadosBloc();
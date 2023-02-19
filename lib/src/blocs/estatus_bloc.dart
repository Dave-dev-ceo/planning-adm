import 'package:flutter/material.dart';
import 'package:planning/src/models/item_model_estatus_invitado.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class EstatusBloc {
  final _repository = Repository();
  final _estatusFetcher = PublishSubject<ItemModelEstatusInvitado?>();

  Stream<ItemModelEstatusInvitado?> get allEstatus => _estatusFetcher.stream;

  fetchAllEstatus(BuildContext context) async {
    ItemModelEstatusInvitado? itemModel =
        await _repository.fetchAllEstatus(context);
    _estatusFetcher.sink.add(itemModel);
  }

  dispose() {
    _estatusFetcher.close();
  }
}

final bloc = EstatusBloc();

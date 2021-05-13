import 'package:flutter/material.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import '../models/item_model_grupos.dart';

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
final bloc = GruposBloc();
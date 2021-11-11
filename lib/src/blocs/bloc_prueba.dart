import 'package:flutter/material.dart';
//import 'package:planning/src/models/item_model_Prueba_invitado.dart';
import 'package:planning/src/models/item_model_prueba.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class PruebaBloc {
  final _repository = Repository();
  final _pruebaFetcher = PublishSubject<ItemModelPrueba>();

  Stream<ItemModelPrueba> get allPrueba => _pruebaFetcher.stream;

  fetchAllPrueba(BuildContext context) async {
    ItemModelPrueba itemModel = await _repository.fetchPrueba();
    _pruebaFetcher.sink.add(itemModel);
  }

  dispose() {
    _pruebaFetcher.close();
  }
}

final blocPrueba = PruebaBloc();

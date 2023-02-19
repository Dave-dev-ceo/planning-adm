import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:planning/src/logic/paises_logic.dart';
import 'package:planning/src/models/item_model_paises.dart';

part 'paises_event.dart';
part 'paises_state.dart';

class PaisesBloc extends Bloc<PaisesEvent, PaisesState> {
  final ListaPaisesLogic logic;
  PaisesBloc({required this.logic}) : super(PaisesInitialState());

  @override
  Stream<PaisesState> mapEventToState(
    PaisesEvent event,
  ) async* {
    if (event is FechtPaisesEvent) {
      yield LoadingPaisesState();

      try {
        ItemModelPaises? paises = await logic.fetchPaises();
        yield MostrarPaisesState(paises);
      } on ListaPaisesException {
        yield ErrorListaPaisesState("Sin paises");
      }
    }
  }
}

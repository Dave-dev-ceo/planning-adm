import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:planning/src/logic/tipos_eventos_logic.dart';
import 'package:planning/src/models/item_model_tipo_evento.dart';

part 'tiposeventos_event.dart';
part 'tiposeventos_state.dart';

class TiposEventosBloc extends Bloc<TiposEventosEvent, TiposEventosState> {
  final ListaTiposEventosLogic logic;
  TiposEventosBloc({required this.logic}) : super(TiposEventosInitial());

  @override
  Stream<TiposEventosState> mapEventToState(
    TiposEventosEvent event,
  ) async* {
    if (event is FetchTiposEventosEvent) {
      yield LoadingTiposEventosState();

      try {
        ItemModelTipoEvento? tiposEventos = await logic.fetchTiposEventos();
        yield MostrarTiposEventosState(tiposEventos);
      } on ListaTiposEventosException {
        yield ErrorListaTiposEventosState("Sin tiposEventos");
      }
    }
  }
}

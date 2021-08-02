import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingplanner/src/logic/listas_logic.dart';

import 'package:weddingplanner/src/models/item_model_listas.dart';

part 'listas_event.dart';
part 'listas_state.dart';

class ListasBloc extends Bloc<ListasEvent, ListasState> {
  final ListasLogic logic;
  ListasBloc({@required this.logic}) : super(ListasInitial());

  @override
  Stream<ListasState> mapEventToState(
    ListasEvent event,
  ) async* {
    if (event is FechtListasEvent) {
      yield LoadingListasState();
      try {
        ItemModelListas listas = await logic.fetchListas();
        yield MostrarListasState(listas);
      } on ListasException {
        yield ErrorMostrarListasState('Sin articulos');
      } on TokenException {
        yield ErrorCreateListasrState('Sesión caducada');
      }
    }
  }
}

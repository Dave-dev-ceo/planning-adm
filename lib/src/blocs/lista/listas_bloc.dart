import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planning/src/logic/listas_logic.dart';

import 'package:planning/src/models/item_model_listas.dart';

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
    if (event is DeleteListaEvent) {
      try {
        int idLista = await logic.deleteLista(event.data);
        if (idLista == 0) {
          add(FechtListasEvent());
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }
}

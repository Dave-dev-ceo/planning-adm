import 'package:flutter/cupertino.dart';
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
        print('Datos de la listas');
        print(listas);
        yield MostrarListasState(listas);
      } on ListasException {
        yield ErrorMostrarListasState('Sin articulos');
      } on TokenException {
        yield ErrorCreateListasrState('Sesión caducada');
      }
    } else if (event is CreateListasEvent) {
      try {
        int idArticulo = await logic.createLista(event.data);
        if (idArticulo == 0) {
          add(FechtListasEvent());
        }
      } catch (e) {
        print(e);
        yield ErrorCreateListasrState('No se pudo insertar');
      }
    }
  }
}

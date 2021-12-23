import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:planning/src/logic/lista_invitados_logic.dart';
import 'package:planning/src/models/item_model_prueba.dart';

part 'invitados_event.dart';
part 'invitados_state.dart';

class InvitadosBloc extends Bloc<InvitadosEvent, InvitadosState> {
  final ListaInvitadosLogic logic;
  InvitadosBloc({@required this.logic}) : super(InvitadosInitialState());

  @override
  Stream<InvitadosState> mapEventToState(
    InvitadosEvent event,
  ) async* {
    if (event is FechtInvitadosEvent) {
      yield LoadingInvitadosState();

      try {
        ItemModelPrueba invitados = await logic.fetchPrueba();
        yield MostrarInvitadosState(invitados);
      } on ListaInvitadosException {
        yield ErrorListaInvitadosState("Sin invitados");
      }
    }
  }
}

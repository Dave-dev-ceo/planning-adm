// ignore_for_file: must_call_super

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:planning/src/logic/invitados_mesas_logic/invitados_mesa_logic.dart';
import 'package:planning/src/models/invitadosConfirmadosModel/invitado_mesa_model.dart';

part 'invitadosmesas_event.dart';
part 'invitadosmesas_state.dart';

class InvitadosMesasBloc
    extends Bloc<InvitadosMesasEvent, InvitadosMesasState> {
  final InvitadosConfirmadosLogic logic;

  InvitadosMesasBloc({@required this.logic}) : super(InvitadosmesasInitial());

  @override
  Stream<InvitadosMesasState> mapEventToState(
      InvitadosMesasEvent event) async* {
    if (event is MostrarInvitadosMesasEvent) {
      yield LoadingInvitadoMesasState();
      try {
        final listaInvitados = await logic.getInvitadosConfirmados();
        yield MostraListaInvitadosMesaState(listaInvitados);
      } on InvitadosMesasException {
        yield ErrorInvitadoMesaState('Ocurrió un error');
      }
    }
  }
}

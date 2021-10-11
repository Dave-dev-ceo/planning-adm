import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weddingplanner/src/models/invitadosMesa/invitadosByMesaModel.dart';

part 'invitadomesa_event.dart';
part 'invitadomesa_state.dart';

class InvitadoMesaBloc extends Bloc<InvitadoMesaEvent, InvitadoMesaState> {
  InvitadoMesaBloc() : super(InvitadomesaInitial());

  @override
  Stream<InvitadoMesaState> mapEventToState(InvitadoMesaEvent event) async* {
    if (event is MostrarInvitadosMesaState) {
      yield LoadingInvitadosMesaStae();
    }
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
//import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:planning/src/logic/estatus_logic.dart';
import 'package:planning/src/models/item_model_estatus_invitado.dart';

part 'estatus_event.dart';
part 'estatus_state.dart';

class EstatusBloc extends Bloc<EstatusEvent, EstatusState> {
  final ListaEstatusLogic logic;
  EstatusBloc({@required this.logic}) : super(EstatusInitial());

  @override
  Stream<EstatusState> mapEventToState(
    EstatusEvent event,
  ) async* {
    if (event is FechtEstatusEvent) {
      yield LoadingEstatusState();

      try {
        ItemModelEstatusInvitado estatus = await logic.fetchEstatus();
        yield MostrarEstatusState(estatus);
      } on ListaEstatusException {
        yield ErrorListaEstatusState("Sin estatus");
      } on TokenException {
        yield ErrorTokenEstatusState("Sesión caducada");
      }
    } else if (event is CreateEstatusEvent) {
      try {
        int idEstatusInvitado = await logic.createEstatus(event.data);

        if (idEstatusInvitado == 0) {
          add(FechtEstatusEvent());
        }
      } on CreateEstatusException {
        yield ErrorCreateEstatusState("No se pudo insertar");
      }
    } else if (event is UpdateEstatusEvent) {
      int response = await logic.updateEstatus(event.data);
      // ItemModelEstatusInvitado model = event.estatus;
      if (response == 0) {
        add(FechtEstatusEvent());
      }
    } else if (event is DeleteEstatusEvent) {
      int response = await logic.deleteEstatus(event.idEstatus);
      if (response == 0) {
        add(FechtEstatusEvent());
      }
    }
  }
}

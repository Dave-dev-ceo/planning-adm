import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:planning/src/logic/asistencia_logic.dart';
import 'package:planning/src/models/item_model_asistencia.dart';

part 'asistencia_event.dart';
part 'asistencia_state.dart';

class AsistenciaBloc extends Bloc<AsistenciaEvent, AsistenciaState> {
  final AsistenciaLogic logic;
  AsistenciaBloc({@required this.logic}) : super(AsistenciaInitialState());

  @override
  Stream<AsistenciaState> mapEventToState(
    AsistenciaEvent event,
  ) async* {
    if (event is FetchAsistenciaPorPlannerEvent) {
      yield LodingAsistenciaState();
      try {
        ItemModelAsistencia usuarios = await logic.fetchAsistenciaPorPlanner();
        yield MostrarAsistenciaState(usuarios);
      } on ListaAsistenciaException {
        yield ErrorMostrarAsistenciaState("Sin Asistencias");
      } on TokenException {
        yield ErrorTokenAsistenciaState("Error de validación de token");
      }
    }
    // mejorar
    else if (event is SaveAsistenciaEvent) {
      await logic.saveAsistencia(event.idInvitado, event.asistencia);
      // yield SavedAsistenciaState(response);
      ItemModelAsistencia usuarios = await logic.fetchAsistenciaPorPlanner();
      yield MostrarAsistenciaState(usuarios);
    }
  }
}

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:planning/src/logic/timings_logic.dart';
import 'package:planning/src/models/item_model_timings.dart';

part 'timings_event.dart';
part 'timings_state.dart';

class TimingsBloc extends Bloc<TimingsEvent, TimingsState> {
  final TimingsLogic logic;
  TimingsBloc({required this.logic}) : super(TimingsInitial());

  @override
  Stream<TimingsState> mapEventToState(
    TimingsEvent event,
  ) async* {
    if (event is FetchTimingsPorPlannerEvent) {
      yield LoadingTimingsState();
      try {
        ItemModelTimings? usuarios =
            await logic.fetchTimingsPorPlanner(event.estatus);
        yield MostrarTimingsState(usuarios);
      } on ListaTimingsException {
        yield ErrorMostrarTimingsState("Sin timings");
      } on TokenException {
        yield ErrorTokenTimingsState("Error de validación de token");
      }
    } else if (event is CreateTimingsEvent) {
      try {
        yield CreateTimingsState();
        int data = await logic.createTiming(event.data);
        if (data == 0) {
          add(FetchTimingsPorPlannerEvent('A'));
        }

        yield CreateTimingsOkState();
      } on CreateTimingException {
        yield ErrorCreateTimingsState("No se pudo insertar");
      } on TokenException {
        yield ErrorTokenTimingsState("Error de validación de token");
      }
    } else if (event is UpdateTimingEvent) {
      try {
        final resp = await logic.updateTiming(
            event.idTiming, event.nombre, event.estatus);
        if (resp == 'Ok') {
          add(FetchTimingsPorPlannerEvent('A'));
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    } else if (event is DeleteTimingPlannerEvent) {
      try {
        final data = await logic.deleteTimingPlanner(event.idTipoTiming);

        yield TimingDeletedState(data);
        add(FetchTimingsPorPlannerEvent('A'));
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }
}

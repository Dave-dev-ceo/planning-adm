import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weddingplanner/src/logic/timings_logic.dart';
import 'package:weddingplanner/src/models/item_model_timings.dart';

part 'timings_event.dart';
part 'timings_state.dart';

class TimingsBloc extends Bloc<TimingsEvent, TimingsState> {
  final TimingsLogic logic;
  TimingsBloc({@required this.logic}) : super(TimingsInitial());

  @override
  Stream<TimingsState> mapEventToState(
    TimingsEvent event,
  ) async* {
    if (event is FetchTimingsPorPlannerEvent) {
      yield LoadingTimingsState();
      try {
        ItemModelTimings usuarios = await logic.fetchTimingsPorPlanner();
        yield MostrarTimingsState(usuarios);
      } on ListaTimingsException {
        yield ErrorMostrarTimingsState("Sin Timings");
      } on TokenException {
        yield ErrorTokenTimingsState("Error de validación de token");
      }
    } else if (event is CreateTimingsEvent) {
      try {
        yield CreateTimingsState();
        int data = await logic.createTiming(event.data);
        if (data == 0) {
          add(FetchTimingsPorPlannerEvent());
        }

        yield CreateTimingsOkState();
      } on CreateTimingException {
        yield ErrorCreateTimingsState("No se pudo insertar");
      } on TokenException {
        yield ErrorTokenTimingsState("Error de validación de token");
      }
    } else if (event is DeleteTimingEvent) {
      yield DeleteTimingState();
    }
  }
}

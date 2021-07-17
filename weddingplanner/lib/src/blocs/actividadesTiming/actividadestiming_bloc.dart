import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weddingplanner/src/logic/actividades_timing_logic.dart';
import 'package:weddingplanner/src/models/item_model_actividades_timings.dart';

part 'actividadestiming_event.dart';
part 'actividadestiming_state.dart';

class ActividadestimingBloc extends Bloc<ActividadestimingEvent, ActividadestimingState> {
  final ActividadesTimingsLogic logic;
  ActividadestimingBloc({@required this.logic}) : super(ActividadestimingInitial());

  @override
  Stream<ActividadestimingState> mapEventToState(
    ActividadestimingEvent event,
  ) async* {
    if (event is FetchActividadesTimingsPorPlannerEvent) {
      yield LoadingActividadesTimingsState();
      try {
        ItemModelActividadesTimings usuarios = await logic.fetchActividadesTimingsPorPlanner(event.idTiming);
        yield MostrarActividadesTimingsState(usuarios);
      } on ListaActividadesTimingsException {
        yield ErrorMostrarActividadesTimingsState("Sin Actividades");
      } on TokenException {
        yield ErrorTokenActividadesTimingsState("Error de validación de token");
      }
    } else if (event is CreateActividadesTimingsEvent) {
      try {
        yield CreateActividadesTimingsState();
        int data = await logic.createActividadesTiming(event.data,event.idTiming);
        if (data == 0) {
          add(FetchActividadesTimingsPorPlannerEvent(event.idTiming));
        }

        yield CreateActividadesTimingsOkState();
      } on CreateActividadesTimingException {
        yield ErrorCreateActividadesTimingsState("No se pudo insertar");
      } on TokenException {
        yield ErrorTokenActividadesTimingsState("Error de validación de token");
      }
    } else if (event is DeleteActividadesTimingsEvent) {
      try {
        yield DeleteActividadesTimingsState();
        int data = await logic.deleteActividadesTiming(event.idActividadTiming,event.idTiming);
        if (data == 0) {
          add(FetchActividadesTimingsPorPlannerEvent(event.idTiming));
        }

        yield DeleteActividadesTimingsOkState();
      } on CreateActividadesTimingException {
        yield ErrorCreateActividadesTimingsState("No se pudo insertar");
      } on TokenException {
        yield ErrorTokenActividadesTimingsState("Error de validación de token");
      }
    }
    else if(event is FetchActividadesTimingsPorIdPlannerEvent) {
      yield LoadingActividadesTimingsState();
      try {
        ItemModelActividadesTimings actividades = await logic.fetchActividadesTimingsIdPorPlanner();
        yield MostrarActividadesTimingsEventosState(actividades);
      } on ListaActividadesTimingsException {
        yield ErrorMostrarActividadesTimingsState("Sin Actividades");
      } on TokenException {
        yield ErrorTokenActividadesTimingsState("Error de validación de token");
      }
    }
  }
}

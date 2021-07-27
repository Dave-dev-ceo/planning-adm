import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weddingplanner/src/logic/actividades_timing_logic.dart';
import 'package:weddingplanner/src/models/item_model_actividades_timings.dart';
import 'package:weddingplanner/src/models/item_model_timings.dart';

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
        // consulta cargada - las tareas que no existen en tareasEvento
        ItemModelTimings plannerTareas = await logic.fetchNoInEvento();
        var itemTareasPlanner = MostrarTimingsState(plannerTareas);

        // insertamos - tareas en evento
        itemTareasPlanner.usuarios.results.forEach((planner) async {
          await logic.createTiming({'timing':planner.nombre_timing, 'id_tipo_timing':planner.id_timing.toString()});
        });

        // consulta cargada - las actividades que no existen en actividadesEvento
        ItemModelActividadesTimings plannerActividades = await logic.fetchNoInEventoActividades();
        var itemActividadesPlanner = MostrarActividadesTimingsState(plannerActividades);
        // consulta cargada - las tareas de evento
        ItemModelTimings eventoTareas = await logic.fetchTimingsEvento();
        var itemTareasEvento = MostrarTimingsState(eventoTareas);

        // insertamos - acividades en evento
        itemTareasEvento.usuarios.results.forEach((eventoTarea) async {
          itemActividadesPlanner.actividadesTimings.results.forEach((plannerActividad) async {
            if(eventoTarea.id_timing == plannerActividad.idTipoTimig) {
              Map<String,dynamic> eventoActividades = {
                'id_evento_timing':eventoTarea.idEventoTiming.toString(),
                'nombre':plannerActividad.nombreActividad, 
                'descripcion':plannerActividad.descripcion, 
                'visible_involucrados':plannerActividad.visibleInvolucrados.toString(), 
                'dias':plannerActividad.dias,
                'id_tipo_timing' : plannerActividad.idTipoTimig.toString(),
              };
              await logic.createActividadesEvento(eventoActividades);
            }
          });
        });

        // consulta cargada - la información a mostrar Tareas y sus Actividades
        ItemModelActividadesTimings mostrarTodo = await logic.fetchActividadesTimingsIdPorPlanner();

        yield MostrarActividadesTimingsEventosState(mostrarTodo);
      } on ListaActividadesTimingsException {
        yield ErrorMostrarActividadesTimingsState("Sin Actividades");
      } on TokenException {
        yield ErrorTokenActividadesTimingsState("Error de validación de token");
      }
    }
  }
}

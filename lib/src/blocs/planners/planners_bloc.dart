import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:planning/src/logic/planners_logic/planners_logic.dart';
import 'package:planning/src/models/plannerModel/planner_model.dart';

part 'planners_event.dart';
part 'planners_state.dart';

class PlannersBloc extends Bloc<PlannersEvent, PlannersState> {
  PlannersBloc() : super(PlannersInitialState()) {
    final logic = PlannersLogic();
    on<ObtenerPlannersEvent>((event, emit) async {
      try {
        emit(LoadingPlannersState());
        final data = (await logic.obtenerPlanners())!;

        emit(MostrarPlannersState(data, [...data]));
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        emit(ErrorListaPlannersState('Ocurrió un error'));
      }
    });

    on<ObtenerDetallePlannerEvent>(((event, emit) async {
      try {
        emit(LoadingPlannersState());

        final data = await logic.obtenerPlannerbyID(event.idPlanner);

        if (data != null) {
          emit(DetallesPlannerState(data));
        } else {
          emit(ErrorListaPlannersState('Ocurrió un error'));
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        emit(ErrorListaPlannersState('Ocurrió un error'));
      }
    }));

    on<EditPlannerEvent>(((event, emit) async {
      try {
        final data = await logic.editarPlanner(event.plannerEdit!);
        if (data) {
          emit(PlannerEditSuccessState());
        } else {
          emit(PlannerEditErrorState());
          add(ObtenerDetallePlannerEvent(event.plannerEdit!.idPlanner));
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        emit(ErrorListaPlannersState('Ocurrió un error'));
      }
    }));

    on<AddPlannerEvent>(((event, emit) async {
      try {
        final data = await logic.agregarPlanner(event.plannerEdit!);
        if (data) {
          emit(PlannerCreatedSuccessState());
        } else {
          emit(PlannerCreatedErrorState());
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        emit(PlannerCreatedErrorState());
      }
    }));
  }
}

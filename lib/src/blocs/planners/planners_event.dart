part of 'planners_bloc.dart';

@immutable
abstract class PlannersEvent {}

class ObtenerPlannersEvent extends PlannersEvent {}

class CreatePlannersEvent extends PlannersEvent {}

class ObtenerDetallePlannerEvent extends PlannersEvent {
  final int idPlanner;

  ObtenerDetallePlannerEvent(this.idPlanner);

  List<Object> get props => [idPlanner];
}

class EditPlannerEvent extends PlannersEvent {
  final PlannerModel plannerEdit;

  EditPlannerEvent(this.plannerEdit);
}

class AddPlannerEvent extends PlannersEvent {
  final PlannerModel plannerEdit;

  AddPlannerEvent(this.plannerEdit);
}

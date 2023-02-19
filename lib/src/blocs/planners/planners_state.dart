part of 'planners_bloc.dart';

@immutable
abstract class PlannersState {}

class PlannersInitialState extends PlannersState {}

class LoadingPlannersState extends PlannersState {}

class MostrarPlannersState extends PlannersState {
  final List<PlannerModel> planners;
  final List<PlannerModel> plannersFiltrados;

  MostrarPlannersState(this.planners, this.plannersFiltrados);
}

class ErrorCreatePlannersState extends PlannersState {
  final String message;

  ErrorCreatePlannersState(this.message);

  List<Object> get props => [message];
}

class ErrorListaPlannersState extends PlannersState {
  final String message;

  ErrorListaPlannersState(this.message);

  List<Object> get props => [message];
}

class ErrorTokenPlannersState extends PlannersState {
  final String message;

  ErrorTokenPlannersState(this.message);

  List<Object> get props => [message];
}

class DetallesPlannerState extends PlannersState {
  final PlannerModel planner;

  DetallesPlannerState(this.planner);

  List<Object> get props => [planner];
}

class PlannerEditSuccessState extends PlannersState {}

class PlannerCreatedSuccessState extends PlannersState {}

class PlannerEditErrorState extends PlannersState {}

class PlannerCreatedErrorState extends PlannersState {}

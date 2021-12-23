part of 'planners_bloc.dart';

@immutable
abstract class PlannersState {}

class PlannersInitialState extends PlannersState {}

class LoadingPlannersState extends PlannersState {}

class MostrarPlannersState extends PlannersState {
  final ItemModelPlanners planners;

  MostrarPlannersState(this.planners);

  ItemModelPlanners get props => planners;
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
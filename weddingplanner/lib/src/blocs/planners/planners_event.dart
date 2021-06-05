part of 'planners_bloc.dart';

@immutable
abstract class PlannersEvent {}

class FechtPlannersEvent extends PlannersEvent {}

class CreatePlannersEvent extends PlannersEvent {
  final Map<String,dynamic> data;
  final ItemModelPlanners planners;
  CreatePlannersEvent(this.data, this.planners);
  List <Object> get props => [data,planners];
}
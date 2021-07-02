part of 'actividadestiming_bloc.dart';

@immutable
abstract class ActividadestimingEvent {}

class FetchActividadesTimingsPorPlannerEvent extends ActividadestimingEvent {
  final int idTiming;
  FetchActividadesTimingsPorPlannerEvent(this.idTiming);
  List<Object> get props => [idTiming];
}

class CreateActividadesTimingsEvent extends ActividadestimingEvent {
  final Map<String, dynamic> data;
  final int idTiming;
  CreateActividadesTimingsEvent(this.data, this.idTiming);
  List<Object> get props => [data];
}

class DeleteActividadesTimingsEvent extends ActividadestimingEvent {
  final int idTiming;
  final int idActividadTiming;
  DeleteActividadesTimingsEvent(this.idTiming,this.idActividadTiming);
  List<Object> get props => [idTiming, idActividadTiming];
}

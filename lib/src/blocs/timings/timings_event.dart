part of 'timings_bloc.dart';

@immutable
abstract class TimingsEvent {}

class FetchTimingsPorPlannerEvent extends TimingsEvent {
  final String estatus;
  FetchTimingsPorPlannerEvent(this.estatus);
}

class CreateTimingsEvent extends TimingsEvent {
  final Map<String, dynamic> data;
  CreateTimingsEvent(this.data);
  List<Object> get props => [data];
}

class UpdateTimingEvent extends TimingsEvent {
  final int? idTiming;
  final String? nombre;
  final String? estatus;

  UpdateTimingEvent(this.idTiming, this.nombre, this.estatus);
  List<Object?> get props => [idTiming, nombre, estatus];
}

class DeleteTimingPlannerEvent extends TimingsEvent {
  final int? idTipoTiming;

  DeleteTimingPlannerEvent(this.idTipoTiming);
}

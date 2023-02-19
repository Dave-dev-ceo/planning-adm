part of 'actividadestiming_bloc.dart';

@immutable
abstract class ActividadestimingEvent {}

class FetchActividadesTimingsPorPlannerEvent extends ActividadestimingEvent {
  final int? idTiming;
  FetchActividadesTimingsPorPlannerEvent(this.idTiming);
  List<Object?> get props => [idTiming];
}

class FetchActividadesTimingsPorIdPlannerEvent extends ActividadestimingEvent {
  FetchActividadesTimingsPorIdPlannerEvent();
}

class CreateActividadesTimingsEvent extends ActividadestimingEvent {
  final Map<String, dynamic> data;
  final int? idTiming;
  CreateActividadesTimingsEvent(this.data, this.idTiming);
  List<Object> get props => [data];
}

class DeleteActividadesTimingsEvent extends ActividadestimingEvent {
  final int? idTiming;
  final int? idActividadTiming;
  DeleteActividadesTimingsEvent(this.idTiming, this.idActividadTiming);
  List<Object?> get props => [idTiming, idActividadTiming];
}

class ActulizarTimingsEvent extends ActividadestimingEvent {
  final int? idEventoActividad;
  final bool? addEventoActividad;
  final DateTime? fechaEventoActividad;

  ActulizarTimingsEvent(
    this.idEventoActividad,
    this.addEventoActividad,
    this.fechaEventoActividad,
  );

  List<Object?> get props => [
        idEventoActividad,
        addEventoActividad,
        fechaEventoActividad,
      ];
}

class AddActividadesEvent extends ActividadestimingEvent {
  final Map<String, dynamic> data;
  final int? idTarea;
  AddActividadesEvent(this.data, this.idTarea);
  List<Object> get props => [data];
}

class UpdateActividadEvent extends ActividadestimingEvent {
  final EventoActividadModel actividad;
  final int? idTiming;

  UpdateActividadEvent(this.actividad, this.idTiming);

  List<Object?> get props => [actividad, idTiming];
}

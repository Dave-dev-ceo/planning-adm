part of 'planes_bloc.dart';

@immutable
abstract class PlanesEvent {}

// evento - select - todo de planner
class SelectPlanesEvent extends PlanesEvent {
  SelectPlanesEvent();
}

// evento - crear de planner::evento
class CreatePlanesEvent extends PlanesEvent {
  final List<TareaPlanner> planesPlanner;

  CreatePlanesEvent(this.planesPlanner);

  List<dynamic> get props => [planesPlanner];
}

// evento - select - todo evento
class SelectPlanesEventoEvent extends PlanesEvent {
  final String myQuery;

  SelectPlanesEventoEvent(this.myQuery);

  String get props => myQuery;
}

// evento - update
class UpdatePlanesEventoEvent extends PlanesEvent {
  final List<dynamic> actividades;
  final String querySelect;

  UpdatePlanesEventoEvent(this.actividades, this.querySelect);

  String get prop => querySelect;
  List<dynamic> get props => [actividades];
}

// evento - crea 1
class CreateUnaPlanesEvent extends PlanesEvent {
  final Map<String, dynamic> actividad;
  final int idTarea;
  final String querySelect;

  CreateUnaPlanesEvent(this.actividad, this.idTarea, this.querySelect);

  List<dynamic> get props => [actividad];
  int get prop => idTarea;
  String get pro => querySelect;
}

// evento - borrar actividad
class DeleteAnActividadEvent extends PlanesEvent {
  final int idActividad;
  final String querySelect;

  DeleteAnActividadEvent(this.idActividad, this.querySelect);

  int get prop => idActividad;
  String get pro => querySelect;
}

class GetAllPlannesEvent extends PlanesEvent {}

class GetTimingsAndActivitiesEvent extends PlanesEvent {}

class BorrarActividadPlanEvent extends PlanesEvent {
  final int idActividad;

  BorrarActividadPlanEvent(this.idActividad);
}

class UpdateActividadesEventoEvent extends PlanesEvent {
  final List<EventoActividadModel> actividades;

  UpdateActividadesEventoEvent(this.actividades);

  List<Object> get props => [actividades];
}

class AddNewActividadEvent extends PlanesEvent {
  final EventoActividadModel actividad;
  final int idTiming;
  final String archivo;
  final String tipoMime;

  AddNewActividadEvent(
      this.actividad, this.idTiming, this.archivo, this.tipoMime);

  List<Object> get props => [actividad, idTiming, archivo, tipoMime];
}

class EditActividadEvent extends PlanesEvent {
  final String archivo;
  final String tipoMime;
  final EventoActividadModel actividad;

  EditActividadEvent(this.actividad, this.archivo, this.tipoMime);
  List<Object> get props => [
        actividad,
        archivo,
        tipoMime,
      ];
}

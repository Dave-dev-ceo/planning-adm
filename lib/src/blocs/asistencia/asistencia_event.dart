part of 'asistencia_bloc.dart';

@immutable
abstract class AsistenciaEvent {}

// evento - buscar
class FetchAsistenciaPorPlannerEvent extends AsistenciaEvent {
  FetchAsistenciaPorPlannerEvent();
}

// evento - guardar
class SaveAsistenciaEvent extends AsistenciaEvent {
  final int idInvitado;
  final bool asistencia;

  SaveAsistenciaEvent(this.idInvitado,this.asistencia);

  List<Object> get props => [idInvitado, asistencia];
}

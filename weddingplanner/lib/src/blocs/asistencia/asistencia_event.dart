part of 'asistencia_bloc.dart';

@immutable
abstract class AsistenciaEvent {}

// evento - buscar
class FetchAsistenciaPorPlannerEvent extends AsistenciaEvent {
  FetchAsistenciaPorPlannerEvent();
}

part of 'asistencia_bloc.dart';

@immutable
abstract class AsistenciaEvent {}

class FetchAsistenciaPorPlannerEvent extends AsistenciaEvent {
  FetchAsistenciaPorPlannerEvent();
}

part of 'asistencia_bloc.dart';

@immutable
abstract class AsistenciaState {}

class AsistenciaInitialState extends AsistenciaState {}

class LodingAsistenciaState extends AsistenciaState {}

class MostrarAsistenciaState extends AsistenciaState {
  final ItemModelAsistencia asistencia;

  MostrarAsistenciaState(this.asistencia);

  ItemModelAsistencia get props => asistencia;
}

class ErrorMostrarAsistenciaState extends AsistenciaState {
  final String message;

  ErrorMostrarAsistenciaState(this.message);

  List<Object> get props => [message];
}

// ERROR EN TOKEN:
class ErrorTokenAsistenciaState extends AsistenciaState {
  final String message;

  ErrorTokenAsistenciaState(this.message);

  List<Object> get props => [message];
}

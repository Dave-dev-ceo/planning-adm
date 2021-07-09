part of 'asistencia_bloc.dart';

@immutable
abstract class AsistenciaState {}

// estado inicial
class AsistenciaInitialState extends AsistenciaState {}

// estado cargando
class LodingAsistenciaState extends AsistenciaState {}

// estado con datos
class MostrarAsistenciaState extends AsistenciaState {
  final ItemModelAsistencia asistencia;

  MostrarAsistenciaState(this.asistencia);

  ItemModelAsistencia get props => asistencia;
}

// estado error data
class ErrorMostrarAsistenciaState extends AsistenciaState {
  final String message;

  ErrorMostrarAsistenciaState(this.message);

  List<Object> get props => [message];
}

// estado error token
class ErrorTokenAsistenciaState extends AsistenciaState {
  final String message;

  ErrorTokenAsistenciaState(this.message);

  List<Object> get props => [message];
}

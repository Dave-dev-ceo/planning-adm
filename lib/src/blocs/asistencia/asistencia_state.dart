part of 'asistencia_bloc.dart';

@immutable
abstract class AsistenciaState {}

// estado inicial
class AsistenciaInitialState extends AsistenciaState {}

// estado cargando
class LodingAsistenciaState extends AsistenciaState {}

// estado con datos - consulta todos
class MostrarAsistenciaState extends AsistenciaState {
  final ItemModelAsistencia asistencia;

  MostrarAsistenciaState(this.asistencia);

  ItemModelAsistencia get props => asistencia;
}

// estado con datos - guardando cambios
class SaveAsistenciaState extends AsistenciaState {
  List<Object> get props => [];
}

// estado con datos - guardado cambios
class SavedAsistenciaState extends AsistenciaState {
  final int response;

  SavedAsistenciaState(this.response);

  List<Object> get props => [response];
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

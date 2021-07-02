part of 'actividadestiming_bloc.dart';

@immutable
abstract class ActividadestimingState {}

class ActividadestimingInitial extends ActividadestimingState {}

class LoadingActividadesTimingsState extends ActividadestimingState {}

class CreateActividadesTimingsState extends ActividadestimingState {}

class CreateActividadesTimingsOkState extends ActividadestimingState {}

class DeleteActividadesTimingsState extends ActividadestimingState {}

class DeleteActividadesTimingsOkState extends ActividadestimingState {}

class ErrorDeleteActividadesTimingsState extends ActividadestimingState {
  final String message;

  ErrorDeleteActividadesTimingsState(this.message);

  List<Object> get props => [message];
}

class ErrorCreateActividadesTimingsState extends ActividadestimingState {
  final String message;

  ErrorCreateActividadesTimingsState(this.message);

  List<Object> get props => [message];
}

class MostrarActividadesTimingsState extends ActividadestimingState {
  final ItemModelActividadesTimings actividadesTimings;

  MostrarActividadesTimingsState(this.actividadesTimings);

  ItemModelActividadesTimings get props => actividadesTimings;
}

class ErrorMostrarActividadesTimingsState extends ActividadestimingState {
  final String message;

  ErrorMostrarActividadesTimingsState(this.message);

  List<Object> get props => [message];
}

// ERROR EN TOKEN:
class ErrorTokenActividadesTimingsState extends ActividadestimingState {
  final String message;

  ErrorTokenActividadesTimingsState(this.message);

  List<Object> get props => [message];
}

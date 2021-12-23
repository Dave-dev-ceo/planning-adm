part of 'actividadestiming_bloc.dart';

@immutable
abstract class ActividadestimingState {}

class ActividadestimingInitial extends ActividadestimingState {}

class LoadingActividadesTimingsState extends ActividadestimingState {}

class CreateActividadesTimingsState extends ActividadestimingState {}

class CreateActividadesTimingsOkState extends ActividadestimingState {}

class DeleteActividadesTimingsState extends ActividadestimingState {}

class DeleteActividadesTimingsOkState extends ActividadestimingState {}

class AddActividadesState extends ActividadestimingState {
  final int idActividad;
  final int idTarea;

  AddActividadesState(this.idActividad, this.idTarea);

  List<int> get props => [idActividad, idTarea];
}

class UpdateActividadesState extends ActividadestimingState {
  final String message;

  UpdateActividadesState(this.message);

  List<Object> get props => [message];
}

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

class MostrarActividadesTimingsEventosState extends ActividadestimingState {
  final ItemModelActividadesTimings actividadesTimings;

  MostrarActividadesTimingsEventosState(this.actividadesTimings);

  ItemModelActividadesTimings get props => actividadesTimings;
}

class MostrarTimingsState extends ActividadestimingState {
  final ItemModelTimings usuarios;

  MostrarTimingsState(this.usuarios);

  ItemModelTimings get props => usuarios;
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

class EditedActividadEvent extends ActividadestimingState {
  final bool isOk;

  EditedActividadEvent(this.isOk);
}

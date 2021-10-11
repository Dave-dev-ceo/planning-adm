part of 'mesas_bloc.dart';

@immutable
abstract class MesasAsignadasState {}

class MesasInitial extends MesasAsignadasState {}

class LoadingMesasAsignadasState extends MesasAsignadasState {}

class MostrarMesasAsignadasState extends MesasAsignadasState {
  final List<MesasModel> mesasAsignadas;

  MostrarMesasAsignadasState(this.mesasAsignadas);

  List<Object> get props => [mesasAsignadas];
}

class ErrorMesasAsignadasState extends MesasAsignadasState {
  final String message;

  ErrorMesasAsignadasState(this.message);
  List<Object> get props => [message];
}

class ErrorTokenMesasAsignadasState extends MesasAsignadasState {
  final String message;

  ErrorTokenMesasAsignadasState({this.message});

  List<Object> get props => [message];
}

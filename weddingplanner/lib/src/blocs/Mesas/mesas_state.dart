part of 'mesas_bloc.dart';

@immutable
abstract class MesasState {}

class MesasInitial extends MesasState {}

class LoadingMesasAsignadasState extends MesasState {}

class MostrarMesasAsignadasState extends MesasState {
  final List<MesasModel> mesasAsignadas;

  MostrarMesasAsignadasState({this.mesasAsignadas});
}

class ErrorMesasAsignadasState extends MesasEvent {
  final String message;

  ErrorMesasAsignadasState(this.message);
}

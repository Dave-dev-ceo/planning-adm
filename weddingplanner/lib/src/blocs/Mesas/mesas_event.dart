part of 'mesas_bloc.dart';

@immutable
abstract class MesasEvent {}

class MostrarMesasAsignadasEvent extends MesasEvent {
  final int idEvento;
  final int idPlanner;

  MostrarMesasAsignadasEvent(this.idEvento, this.idPlanner);
}

part of 'dashboard_bloc.dart';

@immutable
abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class MostrarEventosState extends DashboardState {
  final List<DashboardEventoModel> eventos;
  final List<EventoActividadModel> actividades;

  MostrarEventosState(this.eventos, this.actividades);

  List<Object> get props => [eventos, actividades];
}

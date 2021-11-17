part of 'perfil_bloc.dart';

@immutable
abstract class PerfilState {}

class PerfilInitial extends PerfilState {}

class PerfilLogging extends PerfilState {}

// estados - consultas
class PerfilSelect extends PerfilState {
  final ItemModelPerfil perfil;

  PerfilSelect(this.perfil);

  ItemModelPerfil get props => perfil;
}

class PerfilUpdate extends PerfilState {
  final ItemModelPerfil perfil;

  PerfilUpdate(this.perfil);

  ItemModelPerfil get props => perfil;
}

// estado - errores
class AutorizacionErrorState extends PerfilState {
  final String message;

  AutorizacionErrorState(this.message);

  List<Object> get props => [message];
}

class AutorizacionTokenErrorState extends PerfilState {
  final String message;

  AutorizacionTokenErrorState(this.message);

  List<Object> get props => [message];
}

class PerfilPlannerState extends PerfilState {
  final PerfilPlannerModel perfilPlanner;

  PerfilPlannerState(this.perfilPlanner);
}

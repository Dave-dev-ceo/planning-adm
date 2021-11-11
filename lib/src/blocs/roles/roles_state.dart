part of 'roles_bloc.dart';

@immutable
abstract class RolesState {}

class RolesInitial extends RolesState {}

class LoadingRoles extends RolesState {}

class MostrarRoles extends RolesState {
  final ItemModelRoles roles;
  MostrarRoles(this.roles);
  ItemModelRoles get props => roles;
}

class ErrorObtenerRoles extends RolesState {
  final String message;
  ErrorObtenerRoles(this.message);
  get props => message;
}

// ERROR EN TOKEN:
class ErrorTokenRoles extends RolesState {
  final String message;
  ErrorTokenRoles(this.message);
  List<Object> get props => [message];
}

class LoadingRolesPlanner extends RolesState {}

class MostrarRolesPlanner extends RolesState {
  final ItemModelRoles roles;
  MostrarRolesPlanner(this.roles);
  ItemModelRoles get props => roles;
}

class ErrorObtenerRolesPlanner extends RolesState {
  final String message;
  ErrorObtenerRolesPlanner(this.message);
  get props => message;
}

// ERROR EN TOKEN:
class ErrorTokenRolesPlanner extends RolesState {
  final String message;
  ErrorTokenRolesPlanner(this.message);
  List<Object> get props => [message];
}

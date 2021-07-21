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

class ErrorRoles extends RolesState {
  final String message;
  ErrorRoles(this.message);
  get props => message;
}

// ERROR EN TOKEN:
class ErrorTokenRoles extends RolesState {
  final String message;
  ErrorTokenRoles(this.message);
  List<Object> get props => [message];
}

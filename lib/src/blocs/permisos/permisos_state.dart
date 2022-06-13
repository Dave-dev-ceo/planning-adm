part of 'permisos_bloc.dart';

@immutable
abstract class PermisosState {}

class PermisosInitial extends PermisosState {}

class LoadingPermisos extends PermisosState {}

class PermisosOk extends PermisosState {
  final ItemModelPerfil permisos;
  PermisosOk(this.permisos);
  ItemModelPerfil get props => permisos;
}

class ErrorPermisos extends PermisosState {
  final String message;
  ErrorPermisos(this.message);
  get props => message;
}

// ERROR EN TOKEN:
class ErrorTokenPermisos extends PermisosState {
  final String message;

  ErrorTokenPermisos(this.message);

  List<Object> get props => [message];
}

//Suscripción en Paypal cancelada
class ErrorSuscripcionPaypal extends PermisosState {
  final String message;

  ErrorSuscripcionPaypal(this.message);

  get props => message;
}
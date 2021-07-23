part of 'inv_alcohol_bloc.dart';

@immutable
abstract class InvAlcoholState {}

class InvAlcoholInitial extends InvAlcoholState {}

class LoadingInvAlcoholState extends InvAlcoholState {}

class MostrarInvAlcoholState extends InvAlcoholState {
  final ItemModelInventarioAlcohol cantidad;

  MostrarInvAlcoholState(this.cantidad);

  ItemModelInventarioAlcohol get props => cantidad;
}

class CreateInvAlcoholState extends InvAlcoholState {
  final String cantidad;

  CreateInvAlcoholState(this.cantidad);

  List<Object> get props => [cantidad];
}

class UpdateInvAlcohol extends InvAlcoholState {
  final String cantidad;

  UpdateInvAlcohol(this.cantidad);

  List<Object> get props => [cantidad];
}

class ErrorCreateInvAlcoholState extends InvAlcoholState {
  final String message;

  ErrorCreateInvAlcoholState(this.message);

  List<Object> get props => [message];
}

class ErrorUpdateInvAlcoholState extends InvAlcoholState {
  final String message;

  ErrorUpdateInvAlcoholState(this.message);

  List<Object> get props => [message];
}

class ErrorListaInvAlcoholState extends InvAlcoholState {
  final String message;

  ErrorListaInvAlcoholState(this.message);

  List<Object> get props => [message];
}

class ErrorTokenInvAlcoholState extends InvAlcoholState {
  final String message;

  ErrorTokenInvAlcoholState(this.message);

  List<Object> get props => [message];
}

part of 'invitados_bloc.dart';

@immutable
abstract class InvitadosState {}

class InvitadosInitialState extends InvitadosState {}

class LoadingInvitadosState extends InvitadosState {}

class MostrarInvitadosState extends InvitadosState {
  final ItemModelPrueba? invitados;

  MostrarInvitadosState(this.invitados);

  ItemModelPrueba? get props => invitados;
}

class ErrorListaInvitadosState extends InvitadosState {
  final String message;

  ErrorListaInvitadosState(this.message);
  
  List<Object> get props => [message];

}
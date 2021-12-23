part of 'invitadosmesas_bloc.dart';

@immutable
abstract class InvitadosMesasState {}

class InvitadosmesasInitial extends InvitadosMesasState {}

class LoadingInvitadoMesasState extends InvitadosMesasState {}

class MostraListaInvitadosMesaState extends InvitadosMesasState {
  final List<InvitadosConfirmadosModel> listaInvitadoMesa;

  MostraListaInvitadosMesaState(this.listaInvitadoMesa);

  List<Object> get props => [listaInvitadoMesa];
}

class ErrorInvitadoMesaState extends InvitadosMesasState {
  final String message;

  ErrorInvitadoMesaState(this.message);
}

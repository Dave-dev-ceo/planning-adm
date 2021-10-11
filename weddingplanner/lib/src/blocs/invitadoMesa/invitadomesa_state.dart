part of 'invitadomesa_bloc.dart';

@immutable
abstract class InvitadoMesaState {}

class InvitadomesaInitial extends InvitadoMesaState {}

class LoadingInvitadosMesaStae extends InvitadoMesaState {}

class MostrarInvitadosMesaState extends InvitadoMesaState {
  final List<InvitadosMesaModel> invitadosMesa;

  MostrarInvitadosMesaState(this.invitadosMesa);

  List<Object> get props => [invitadosMesa];
}

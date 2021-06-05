part of 'estatus_bloc.dart';

@immutable
abstract class EstatusState {}

class EstatusInitial extends EstatusState {}

class LoadingEstatusState extends EstatusState {}

class MostrarEstatusState extends EstatusState {
  final ItemModelEstatusInvitado estatus;

  MostrarEstatusState(this.estatus);

  ItemModelEstatusInvitado get props => estatus;
}

class CreateEstatusState extends EstatusState {
  final String estatus;

  CreateEstatusState(this.estatus);


  List<Object> get props => [estatus];
}

class UpdateEstatus extends EstatusState {
  final String estatus;

  UpdateEstatus(this.estatus);


  List<Object> get props => [estatus];
}

class ErrorCreateEstatusState extends EstatusState {
  final String message;

  ErrorCreateEstatusState(this.message);
  
  List<Object> get props => [message];

}

class ErrorUpdateEstatusState extends EstatusState {
  final String message;

  ErrorUpdateEstatusState(this.message);
  
  List<Object> get props => [message];

}

class ErrorListaEstatusState extends EstatusState {
  final String message;

  ErrorListaEstatusState(this.message);
  
  List<Object> get props => [message];

}

class ErrorTokenEstatusState extends EstatusState {
  final String message;

  ErrorTokenEstatusState(this.message);
  
  List<Object> get props => [message];

}
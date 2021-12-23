part of 'contratos_bloc.dart';

@immutable
abstract class ContratosState {}

class ContratosInitial extends ContratosState {}

class ContratosLogging extends ContratosState {}

// estado - select
class SelectContratoState extends ContratosState {
  final ItemModelAddContratos contrato;

  SelectContratoState(this.contrato);

  ItemModelAddContratos get props => contrato;
}

// estado - errores
class AutorizacionErrorState extends ContratosState {
  final String message;

  AutorizacionErrorState(this.message);

  List<Object> get props => [message];
}

class AutorizacionTokenErrorState extends ContratosState {
  final String message;

  AutorizacionTokenErrorState(this.message);

  List<Object> get props => [message];
}

class UpdateValContratoState extends ContratosState {
  final String contratos;
  UpdateValContratoState(this.contratos);
  String get props => contratos;
}

class FectValContratoState extends ContratosState {
  final String valor;
  FectValContratoState(this.valor);
  String get props => valor;
}

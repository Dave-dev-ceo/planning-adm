part of 'add_contratos_bloc.dart';

@immutable
abstract class AddContratosState {}

// evento
class AddContratosInitialState extends AddContratosState {}
class AddContratosLoggingState extends AddContratosState {}

// estado - select id
class SelectAddContratosState extends AddContratosState {
  final ItemModelAddContratos contratos;

  SelectAddContratosState(this.contratos);

  ItemModelAddContratos get props => contratos;
}

class InsertAddContratosState extends AddContratosState {
  InsertAddContratosState();
}

// estado - errores
class AutorizacionErrorState extends AddContratosState {
  final String message;

  AutorizacionErrorState(this.message);

  List<Object> get props => [message];
}

class AutorizacionTokenErrorState extends AddContratosState {
  final String message;

  AutorizacionTokenErrorState(this.message);

  List<Object> get props => [message];
}

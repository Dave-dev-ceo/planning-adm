part of 'listas_bloc.dart';

@immutable
abstract class ListasState {}

class ListasInitial extends ListasState {}

class LoadingListasState extends ListasState {}

class CreateListasState extends ListasState {}

class CreateListasOkState extends ListasState {}

class DeleteListasState extends ListasState {}

class DeleteListasOkState extends ListasState {}

class ErrorDeleteListasState extends ListasState {
  final String message;
  ErrorDeleteListasState(this.message);
  List<Object> get props => [message];
}

class ErrorCreateListasrState extends ListasState {
  final String message;
  ErrorCreateListasrState(this.message);
  List<Object> get props => [message];
}

class MostrarListasState extends ListasState {
  final ItemModelListas listas;
  MostrarListasState(this.listas);
  ItemModelListas get props => listas;
}

class MostrarListasEventState extends ListasState {
  final ItemModelListas articulosRecibir;
  MostrarListasEventState(this.articulosRecibir);
  ItemModelListas get props => articulosRecibir;
}

class ErrorMostrarListasState extends ListasState {
  final String message;
  ErrorMostrarListasState(this.message);
  List<Object> get props => [message];
}

class ErrorTokenListaState extends ListasState {
  final String message;
  ErrorTokenListaState(this.message);
  List<Object> get props => [message];
}

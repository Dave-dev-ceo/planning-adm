part of 'contratos_bloc.dart';

@immutable
abstract class ContratosState {}

class ContratosInitial extends ContratosState {}

class LoadingContratosState extends ContratosState {}

class LoadingContratosPdfState extends ContratosState {}

class LoadingContratosPdfViewState extends ContratosState {}

class LoadingUploadFileState extends ContratosState {}

class LoadingSeeUploadFileState extends ContratosState {}

class MostrarContratosPdfState extends ContratosState {
  final String contratos;

  MostrarContratosPdfState(this.contratos);

  String get props => contratos;
}

class MostrarContratosPdfViewState extends ContratosState {
  final String contratos;

  MostrarContratosPdfViewState(this.contratos);

  String get props => contratos;
}

class MostrarUploadPdfViewState extends ContratosState {
  final String contratos;

  MostrarUploadPdfViewState(this.contratos);

  String get props => contratos;
}

class MostrarContratosState extends ContratosState {
  final ItemModelContratos contratos;

  MostrarContratosState(this.contratos);

  ItemModelContratos get props => contratos;
}

class CreateContratosState extends ContratosState {
  final String contratos;

  CreateContratosState(this.contratos);

  List<Object> get props => [contratos];
}

class UpdateContratos extends ContratosState {
  final String contratos;

  UpdateContratos(this.contratos);

  List<Object> get props => [contratos];
}

class ErrorCreateContratosState extends ContratosState {
  final String message;

  ErrorCreateContratosState(this.message);

  List<Object> get props => [message];
}

class ErrorUpdateContratosState extends ContratosState {
  final String message;

  ErrorUpdateContratosState(this.message);

  List<Object> get props => [message];
}

class ErrorListaContratosState extends ContratosState {
  final String message;

  ErrorListaContratosState(this.message);

  List<Object> get props => [message];
}

class ErrorListaContratosPdfState extends ContratosState {
  final String message;

  ErrorListaContratosPdfState(this.message);

  List<Object> get props => [message];
}

class ErrorTokenContratosState extends ContratosState {
  final String message;

  ErrorTokenContratosState(this.message);

  List<Object> get props => [message];
}

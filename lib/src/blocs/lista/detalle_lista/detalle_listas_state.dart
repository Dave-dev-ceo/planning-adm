part of 'detalle_listas_bloc.dart';

@immutable
abstract class DetalleListasState {}

class DetalleListasInitial extends DetalleListasState {}

class LoadingDetalleListasState extends DetalleListasState {}

class CreateDetalleListasState extends DetalleListasState {}

class CreateDetalleListasOkState extends DetalleListasState {}

class DeleteDetalleListasState extends DetalleListasState {}

class DeleteDetalleListasOkState extends DetalleListasState {}

class MostrarDetalleListasState extends DetalleListasState {
  final ItemModelDetalleListas detlistas;
  MostrarDetalleListasState(this.detlistas);
  ItemModelDetalleListas get props => detlistas;
}

class ErrorMostrarDetalleListasState extends DetalleListasState {
  final String message;
  ErrorMostrarDetalleListasState(this.message);
  List<Object> get props => [message];
}

class ErrorTokenDetalleListaState extends DetalleListasState {
  final String message;
  ErrorTokenDetalleListaState(this.message);
  List<Object> get props => [message];
}

class ErrorCreateDetalleListasrState extends DetalleListasState {
  final String message;
  ErrorCreateDetalleListasrState(this.message);
  List<Object> get props => [message];
}

class ErrorCreateListasState extends DetalleListasState {
  final String message;
  ErrorCreateListasState(this.message);
  List<Object> get props => [message];
}

class CreateListasState extends DetalleListasState {
  final int? idLista;
  CreateListasState(this.idLista);
  List<Object?> get props => [idLista];
}

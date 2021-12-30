part of 'archivo_proveedor_bloc.dart';

@immutable
abstract class ArchivoProveedorState {}

class LoadingArchivoProveedorState extends ArchivoProveedorState {}

class ArchivoProveedorInitial extends ArchivoProveedorState {}

class MostrarArchivoProvServState extends ArchivoProveedorState {
  final ItemModelArchivoProvServ detlistas;
  MostrarArchivoProvServState(this.detlistas);
  ItemModelArchivoProvServ get props => detlistas;
}

class ErrorMostrarArchivoProvServState extends ArchivoProveedorState {
  final String message;
  ErrorMostrarArchivoProvServState(this.message);
  List<Object> get props => [message];
}

class ErrorCreateArchivoProvServState extends ArchivoProveedorState {
  final String message;
  ErrorCreateArchivoProvServState(this.message);
  List<Object> get props => [message];
}

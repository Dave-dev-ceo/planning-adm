part of 'proveedoreventos_bloc.dart';

@immutable
abstract class ProveedoreventosState {}

class ProveedoreventosInitial extends ProveedoreventosState {}

class LoadingProveedorEvento extends ProveedoreventosState {}

class MostrarProveedorEventoState extends ProveedoreventosState {
  final ItemModelProveedoresEvento detlistas;
  MostrarProveedorEventoState(this.detlistas);
  ItemModelProveedoresEvento get props => detlistas;
}

class CreateProveedorEventoState extends ProveedoreventosState {
  final int id_lista;
  CreateProveedorEventoState(this.id_lista);
  List<Object> get props => [id_lista];
}

class ErrorMostrarProveedorEventoState extends ProveedoreventosState {
  final String message;
  ErrorMostrarProveedorEventoState(this.message);
  List<Object> get props => [message];
}

class ErrorCreateProveedorEventoState extends ProveedoreventosState {
  final String message;
  ErrorCreateProveedorEventoState(this.message);
  List<Object> get props => [message];
}

class ErrorDeleteProveedorEventoState extends ProveedoreventosState {
  final String message;
  ErrorDeleteProveedorEventoState(this.message);
  List<Object> get props => [message];
}

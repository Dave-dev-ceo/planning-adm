part of 'proveedor_bloc.dart';

@immutable
abstract class ProveedorState {}

class LoadingProveedorState extends ProveedorState {}

class ProveedorInitial extends ProveedorState {}

class ErrorCreateProveedorState extends ProveedorState {
  final String message;
  ErrorCreateProveedorState(this.message);
  List<Object> get props => [message];
}

class MostrarProveedorState extends ProveedorState {
  final ItemModelProveedores detlistas;
  MostrarProveedorState(this.detlistas);
  ItemModelProveedores get props => detlistas;
}

class ErrorMostrarProveedorState extends ProveedorState {
  final String message;
  ErrorMostrarProveedorState(this.message);
  List<Object> get props => [message];
}

class MostrarSevicioByProveedorState extends ProveedorState {
  final ItemModelServicioByProv detlistas;
  MostrarSevicioByProveedorState(this.detlistas);
  ItemModelServicioByProv get props => detlistas;
}

class ErrorMostrarSevicioByProveedorState extends ProveedorState {
  final String message;
  ErrorMostrarSevicioByProveedorState(this.message);
  List<Object> get props => [message];
}

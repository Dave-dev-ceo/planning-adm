part of 'pagos_bloc.dart';

@immutable
abstract class PagosState {}

class PagosInitial extends PagosState {}
class PagosLogging extends PagosState {}

class PagosSelect extends PagosState {
  final ItemModelPagos pagos;

  PagosSelect(this.pagos);

  ItemModelPagos get prop => pagos;
}

class PagosSelectId extends PagosState {
  final ItemModelPagos pagos;
  final ItemModelPagos proveedor;
  final ItemModelPagos servicio;

  PagosSelectId(this.pagos,this.proveedor,this.servicio);

  ItemModelPagos get prop => pagos;
  ItemModelPagos get pro => proveedor;
  ItemModelPagos get pr => servicio;
}

class PagosCreateState extends PagosState {
  PagosCreateState();
}

class PagosUpdateState extends PagosState {
  PagosUpdateState();
}

class PagosDeleteState extends PagosState {
  PagosDeleteState();
}

class PagosSelectFormState extends PagosState {
  final ItemModelPagos proveedor;
  final ItemModelPagos servicios;

  PagosSelectFormState(this.proveedor, this.servicios);

  ItemModelPagos get props => proveedor;
  ItemModelPagos get prop => servicios;

}

// estado - errores
class PagosErrorState extends PagosState {
  final String message;

  PagosErrorState(this.message);

  List<Object> get props => [message];
}

class PagosTokenErrorState extends PagosState {
  final String message;

  PagosTokenErrorState(this.message);

  List<Object> get props => [message];
}

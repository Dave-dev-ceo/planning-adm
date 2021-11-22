part of 'historialpagos_bloc.dart';

@immutable
abstract class HistorialPagosState {}

class HistorialPagosInitial extends HistorialPagosState {}

class LoadingHistorialPagosState extends HistorialPagosState {}

class MostrarHistorialPagosState extends HistorialPagosState {
  final List<HistorialPagosModel> listaPagos;

  MostrarHistorialPagosState(this.listaPagos);
}

class PagoAgregadostate extends HistorialPagosState {
  final String message;

  PagoAgregadostate(this.message);
}

class PagoEditadostate extends HistorialPagosState {
  final String message;

  PagoEditadostate(this.message);
}

class EliminarPagoState extends HistorialPagosState {
  final String message;

  EliminarPagoState(this.message);
}

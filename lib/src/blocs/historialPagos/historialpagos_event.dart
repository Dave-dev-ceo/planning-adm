part of 'historialpagos_bloc.dart';

@immutable
abstract class HistorialPagosEvent {}

class MostrarHistorialPagosEvent extends HistorialPagosEvent {}

class AgregarPagosEvent extends HistorialPagosEvent {
  final HistorialPagosModel pago;

  AgregarPagosEvent(this.pago);
}

class EditarPagosEvent extends HistorialPagosEvent {
  final HistorialPagosModel pago;

  EditarPagosEvent(this.pago);
}

class EliminarPagoEvent extends HistorialPagosEvent {
  final int idPago;

  EliminarPagoEvent(this.idPago);
}

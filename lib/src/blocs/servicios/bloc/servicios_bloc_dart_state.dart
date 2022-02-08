part of 'servicios_bloc_dart_bloc.dart';

@immutable
abstract class ServiciosState {}

class ServiciosInitial extends ServiciosState {}

class LoadingServiciosState extends ServiciosState {}

class ErrorMostrarServiciosState extends ServiciosState {
  final String message;
  ErrorMostrarServiciosState(this.message);
  List<Object> get props => [message];
}

class MostrarServiciosState extends ServiciosState {
  final ItemModuleServicios listServicios;
  MostrarServiciosState(this.listServicios);
  ItemModuleServicios get props => listServicios;
}

class MostrarServiciosByProveedorState extends ServiciosState {
  final ItemModuleServicios servicios;
  final ItemModuleServicios listServiciosEvent;
  MostrarServiciosByProveedorState(this.listServiciosEvent, this.servicios);
  ItemModuleServicios get props => listServiciosEvent;
}

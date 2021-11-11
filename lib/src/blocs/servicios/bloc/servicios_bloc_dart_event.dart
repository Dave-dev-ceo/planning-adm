part of 'servicios_bloc_dart_bloc.dart';

@immutable
abstract class ServiciosEvent {}

class FechtServiciosEvent implements ServiciosEvent {}

class CreateServiciosEvent extends ServiciosEvent {
  final Map<String, dynamic> data;
  final ItemModuleServicios servicios;
  CreateServiciosEvent(this.data, this.servicios);
  List<Object> get props => [data, servicios];
}

class UpdateServicioEvent extends ServiciosEvent {
  final Map<String, dynamic> datos;
  final ItemModuleServicios servicios;
  UpdateServicioEvent(this.datos, this.servicios);
  List<Object> get props => [datos, servicios];
}

class DeleteServicioEvent extends ServiciosEvent {
  final int idServicio;
  DeleteServicioEvent(this.idServicio);
  List<Object> get props => [idServicio];
}

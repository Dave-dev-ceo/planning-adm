part of 'proveedoreventos_bloc.dart';

@immutable
abstract class ProveedoreventosEvent {}

class FechtProveedorEventosEvent implements ProveedoreventosEvent {}

class CreateProveedorEventosEvent extends ProveedoreventosEvent {
  final Map<String, dynamic> data;
  CreateProveedorEventosEvent(this.data);
  List<Object> get props => [data];
}

class DeleteProveedorEventosEvent extends ProveedoreventosEvent {
  final Map<String, dynamic> data;
  DeleteProveedorEventosEvent(this.data);
  List<Object> get props => [data];
}

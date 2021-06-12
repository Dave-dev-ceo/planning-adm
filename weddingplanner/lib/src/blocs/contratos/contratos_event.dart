part of 'contratos_bloc.dart';

@immutable
abstract class ContratosEvent {}

class FechtContratosEvent extends ContratosEvent {}

class FechtContratosPdfEvent extends ContratosEvent {
  final Map<String, dynamic> data;

  FechtContratosPdfEvent(this.data);

  List<Object> get props => [data];
}

class CreateContratosEvent extends ContratosEvent {
  final Map<String, dynamic> data;
  final ItemModelContratos contratos;
  CreateContratosEvent(this.data, this.contratos);
  List<Object> get props => [data, contratos];
}

class UpdateContratosEvent extends ContratosEvent {
  final Map<String, dynamic> data;
  final ItemModelContratos contratos;
  final int id;

  UpdateContratosEvent(this.data, this.contratos, this.id);
  List<Object> get props => [data, contratos, id];
}

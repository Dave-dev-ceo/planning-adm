part of 'contratos_bloc.dart';

@immutable
abstract class ContratosEvent {}

class FechtContratosEvent extends ContratosEvent {}

class FechtContratosPdfViewEvent extends ContratosEvent {
  final Map<String, dynamic> data;

  FechtContratosPdfViewEvent(this.data);

  List<Object> get props => [data];
}

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

class UploadFileEvent extends ContratosEvent {
  final int id;
  final String file;
  final String name;

  UploadFileEvent(this.id, this.file,this.name);

  int get props => id;
  String get prop => file;
  String get pro => name;
}

class SeeUploadFileEvent extends ContratosEvent {
  final int id;

  SeeUploadFileEvent(this.id);

  int get props => id;
}

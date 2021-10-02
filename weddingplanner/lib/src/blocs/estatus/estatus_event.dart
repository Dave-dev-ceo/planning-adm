part of 'estatus_bloc.dart';

@immutable
abstract class EstatusEvent {}

class FechtEstatusEvent extends EstatusEvent {}

class CreateEstatusEvent extends EstatusEvent {
  final Map<String, dynamic> data;
  final ItemModelEstatusInvitado estatus;
  CreateEstatusEvent(this.data, this.estatus);
  List<Object> get props => [data, estatus];
}

class UpdateEstatusEvent extends EstatusEvent {
  final Map<String, dynamic> data;
  final ItemModelEstatusInvitado estatus;
  final int id;

  UpdateEstatusEvent(this.data, this.estatus, this.id);
  List<Object> get props => [data, estatus, id];
}

class DeleteEstatusEvent extends EstatusEvent {
  final int idEstatus;
  DeleteEstatusEvent(this.idEstatus);
  List<Object> get props => [idEstatus];
}

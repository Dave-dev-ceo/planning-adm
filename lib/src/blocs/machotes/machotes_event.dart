part of 'machotes_bloc.dart';

@immutable
abstract class MachotesEvent {}

class FechtMachotesEvent extends MachotesEvent {}

class CreateMachotesEvent extends MachotesEvent {
  final Map<String, dynamic> data;
  final ItemModelMachotes? machotes;
  CreateMachotesEvent(this.data, this.machotes);
  List<Object?> get props => [data, machotes];
}

class UpdateMachotesEvent extends MachotesEvent {
  final Map<String, dynamic> data;
  final ItemModelMachotes? machotes;

  UpdateMachotesEvent(this.data, this.machotes);
  List<Object?> get props => [data, machotes];
}

class UpdateNombreMachoteEvent extends MachotesEvent {
  final int? idMachote;
  final String? nuevoombre;

  UpdateNombreMachoteEvent(this.idMachote, this.nuevoombre);
}

class EliminarMachoteEvent extends MachotesEvent {
  final int? idMachote;

  EliminarMachoteEvent(this.idMachote);
}

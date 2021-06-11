part of 'machotes_bloc.dart';

@immutable
abstract class MachotesEvent {}

class FechtMachotesEvent extends MachotesEvent {}

class CreateMachotesEvent extends MachotesEvent {
  final Map<String,dynamic> data;
  final ItemModelMachotes machotes;
  CreateMachotesEvent(this.data, this.machotes);
  List <Object> get props => [data,machotes];
}

class UpdateMachotesEvent extends MachotesEvent {
  final Map<String, dynamic> data;
  final ItemModelMachotes machotes;
  final int id;

  UpdateMachotesEvent(this.data, this.machotes, this.id);
  List <Object> get props => [data,machotes,id];
}
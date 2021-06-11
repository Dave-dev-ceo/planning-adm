part of 'machotes_bloc.dart';

@immutable
abstract class MachotesState {}

class MachotesInitial extends MachotesState {}

class LoadingMachotesState extends MachotesState {}

class MostrarMachotesState extends MachotesState {
  final ItemModelMachotes machotes;

  MostrarMachotesState(this.machotes);

  ItemModelMachotes get props => machotes;
}

class CreateMachotesState extends MachotesState {
  final String machotes;

  CreateMachotesState(this.machotes);


  List<Object> get props => [machotes];
}

class UpdateMachotes extends MachotesState {
  final String machotes;

  UpdateMachotes(this.machotes);


  List<Object> get props => [machotes];
}

class ErrorCreateMachotesState extends MachotesState {
  final String message;

  ErrorCreateMachotesState(this.message);
  
  List<Object> get props => [message];

}

class ErrorUpdateMachotesState extends MachotesState {
  final String message;

  ErrorUpdateMachotesState(this.message);
  
  List<Object> get props => [message];

}

class ErrorListaMachotesState extends MachotesState {
  final String message;

  ErrorListaMachotesState(this.message);
  
  List<Object> get props => [message];

}

class ErrorTokenMachotesState extends MachotesState {
  final String message;

  ErrorTokenMachotesState(this.message);
  
  List<Object> get props => [message];

}
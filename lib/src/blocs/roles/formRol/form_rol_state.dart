part of 'form_rol_bloc.dart';

@immutable
abstract class FormRolState {}

class FormRolInitial extends FormRolState {}

// ESTADOS DE ALTA DE USUARIO

class LoadingMostrarFormRol extends FormRolState {}

class MostrarFormRol extends FormRolState {
  final ItemModelFormRol form;
  MostrarFormRol(this.form);
  ItemModelFormRol get data => form;
}

class ErrorMostrarFormRol extends FormRolState {
  final String message;
  ErrorMostrarFormRol(this.message);
  List<Object> get props => [message];
}

// ERROR DE TOKEN

class ErrorTokenFormRolState extends FormRolState {
  final String message;
  ErrorTokenFormRolState(this.message);
  List<Object> get props => [message];
}

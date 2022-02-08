part of 'form_rol_bloc.dart';

@immutable
abstract class FormRolEvent {}

class GetFormRolEvent extends FormRolEvent {
  final int idRol0;
  GetFormRolEvent({this.idRol0 = -1});
  int get idRol => idRol0;
}

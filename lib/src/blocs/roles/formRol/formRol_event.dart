part of 'formRol_bloc.dart';

@immutable
abstract class FormRolEvent {}

class GetFormRolEvent extends FormRolEvent {
  final String idRol0;
  GetFormRolEvent({this.idRol0 = '-1'});
  String get idRol => this.idRol0;
}

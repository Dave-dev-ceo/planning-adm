part of 'involucrados_bloc.dart';

@immutable
abstract class InvolucradosEvent {}

class InsertInvolucrado extends InvolucradosEvent {
  final Object involucrado;

  InsertInvolucrado(this.involucrado);

  Object get props => involucrado;
}

class SelectInvolucrado extends InvolucradosEvent {}

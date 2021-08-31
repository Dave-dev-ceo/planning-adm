part of 'involucrados_bloc.dart';

@immutable
abstract class InvolucradosState {}

class InvolucradosInitial extends InvolucradosState {}
class InvolucradosLogging extends InvolucradosState {}

class InvolucradosInsert extends InvolucradosState {
  final ItemModelInvolucrados autorizacion;

  InvolucradosInsert(this.autorizacion);

  ItemModelInvolucrados get props => autorizacion;

}

class InvolucradosSelect extends InvolucradosState {
  final ItemModelInvolucrados autorizacion;

  InvolucradosSelect(this.autorizacion);

  ItemModelInvolucrados get props => autorizacion;
}

class AutorizacionErrorState extends InvolucradosState {
  final String message;

  AutorizacionErrorState(this.message);

  List<Object> get props => [message];
}

class AutorizacionTokenErrorState extends InvolucradosState {
  final String message;

  AutorizacionTokenErrorState(this.message);

  List<Object> get props => [message];
}



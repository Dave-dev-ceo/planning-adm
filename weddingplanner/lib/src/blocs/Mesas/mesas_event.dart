part of 'mesas_bloc.dart';

@immutable
abstract class MesasEvent {}

class MostrarMesasEvent extends MesasEvent {}

class CreateMesasEvent extends MesasEvent {
  final List<MesaModel> mesas;

  CreateMesasEvent(this.mesas);

  List<Object> get props => [mesas];
}

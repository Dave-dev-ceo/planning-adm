part of 'prospecto_bloc.dart';

@immutable
abstract class ProspectoState {}

class ProspectoInitial extends ProspectoState {}

class LoadingProspectoState extends ProspectoState {}

class MostrarEtapasState extends ProspectoState {
  final List<EtapasModel> etapas;

  MostrarEtapasState(this.etapas);

  List<Object> get props => [etapas];
}

class AddedEtapaState extends ProspectoState {
  final bool wasAdded;

  AddedEtapaState(this.wasAdded);
}

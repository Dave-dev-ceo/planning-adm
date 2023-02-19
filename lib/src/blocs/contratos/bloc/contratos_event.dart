part of 'contratos_bloc.dart';

@immutable
abstract class ContratosEvent {}

// evento
class ContratosSelect extends ContratosEvent {
  ContratosSelect();
}

class UpdateValContratoEvent extends ContratosEvent {
  final Map<String, dynamic> data;
  UpdateValContratoEvent(this.data);
  Map<String, dynamic> get props => data;
}

class FectValContratoEvent extends ContratosEvent {
  final String machote;
  FectValContratoEvent(this.machote);
  String get props => machote;
}

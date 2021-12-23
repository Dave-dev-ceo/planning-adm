part of 'add_contratos_bloc.dart';

@immutable
abstract class AddContratosEvent {}

// eventos
class AddContratosSelect extends AddContratosEvent {
  AddContratosSelect();
}

class AddContratosSelectArchivo extends AddContratosEvent {
  final int idMachote;

  AddContratosSelectArchivo(this.idMachote);

  int get props => idMachote;
}

class AddContratosInsert extends AddContratosEvent {
  final Map contrato;

  AddContratosInsert(this.contrato);

  Map get props => contrato;
}

part of 'ver_contratos_bloc.dart';

@immutable
abstract class VerContratosState {}

class VerContratosInitial extends VerContratosState {}
class VerContratosLoggin extends VerContratosState {}

class VerContratosBorrar extends VerContratosState {}

class VerContratosSubir extends VerContratosState {}

class CrearContratoState extends VerContratosState {}

class VerContratosVer extends VerContratosState {
  final String archivo;

  VerContratosVer(this.archivo);

  String get prop => archivo;
}

class DescargarContratoState extends VerContratosState {
  final String nombre;
  final String archivo;

  DescargarContratoState(this.nombre,this.archivo);

  String get props => nombre;
  String get prop => archivo;
}

class AutorizacionErrorState extends VerContratosState {
  final String message;

  AutorizacionErrorState(this.message);

  List<Object> get props => [message];
}

class AutorizacionTokenErrorState extends VerContratosState {
  final String message;

  AutorizacionTokenErrorState(this.message);

  List<Object> get props => [message];
}
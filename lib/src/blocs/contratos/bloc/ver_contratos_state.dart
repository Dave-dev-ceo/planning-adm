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
  final String tipoMime;
  final String tipoDoc;
  VerContratosVer(this.archivo, this.tipoMime, this.tipoDoc);

  String get prop => archivo;
}

class DescargarArchivoSubidoState extends VerContratosState {
  final String subido;
  final String tipoMime;
  final String nombre;
  DescargarArchivoSubidoState(this.subido, this.tipoMime, this.nombre);

  String get prop => subido;
  String get propd => tipoMime;
  String get propdd => nombre;
}

class DescargarContratoSubidoState extends VerContratosState {
  final String subido;
  final String tipoMime;
  final String nombre;
  DescargarContratoSubidoState(this.subido, this.tipoMime, this.nombre);

  String get prop => subido;
  String get propd => tipoMime;
  String get propdd => nombre;
}

class VerContratoSubidoState extends VerContratosState {
  final String subido;
  final String tipoMime;
  final String nombre;
  VerContratoSubidoState(this.subido, this.tipoMime, this.nombre);
  String get prop => subido;
  String get propd => tipoMime;
  String get propdd => nombre;
}

class DescargarContratoState extends VerContratosState {
  final String nombre;
  final String archivo;
  final String extencion;

  DescargarContratoState(this.nombre, this.archivo, this.extencion);

  String get props => nombre;
  String get prop => archivo;
  String get prod => extencion;
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

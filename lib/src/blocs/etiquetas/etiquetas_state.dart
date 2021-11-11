part of 'etiquetas_bloc.dart';

@immutable
abstract class EtiquetasState {}

class EtiquetasInitial extends EtiquetasState {}

class LoadingEtiquetasState extends EtiquetasState {}

class MostrarEtiquetasState extends EtiquetasState {
  final ItemModelEtiquetas etiquetas;

  MostrarEtiquetasState(this.etiquetas);

  ItemModelEtiquetas get props => etiquetas;
}

class CreateEtiquetasState extends EtiquetasState {
  final String etiquetas;

  CreateEtiquetasState(this.etiquetas);


  List<Object> get props => [etiquetas];
}

class UpdateEtiquetas extends EtiquetasState {
  final String etiquetas;

  UpdateEtiquetas(this.etiquetas);


  List<Object> get props => [etiquetas];
}

class ErrorCreateEtiquetasState extends EtiquetasState {
  final String message;

  ErrorCreateEtiquetasState(this.message);
  
  List<Object> get props => [message];

}

class ErrorUpdateEtiquetasState extends EtiquetasState {
  final String message;

  ErrorUpdateEtiquetasState(this.message);
  
  List<Object> get props => [message];

}

class ErrorListaEtiquetasState extends EtiquetasState {
  final String message;

  ErrorListaEtiquetasState(this.message);
  
  List<Object> get props => [message];

}

class ErrorTokenEtiquetasState extends EtiquetasState {
  final String message;

  ErrorTokenEtiquetasState(this.message);
  
  List<Object> get props => [message];

}
part of 'etiquetas_bloc.dart';

@immutable
abstract class EtiquetasEvent {}

class FechtEtiquetasEvent extends EtiquetasEvent {}

class CreateEtiquetasEvent extends EtiquetasEvent {
  final Map<String,dynamic> data;
  final ItemModelEtiquetas etiquetas;
  CreateEtiquetasEvent(this.data, this.etiquetas);
  List <Object> get props => [data,etiquetas];
}

class UpdateEtiquetasEvent extends EtiquetasEvent {
  final Map<String, dynamic> data;
  final ItemModelEtiquetas etiquetas;
  final int id;

  UpdateEtiquetasEvent(this.data, this.etiquetas, this.id);
  List <Object> get props => [data,etiquetas,id];
}
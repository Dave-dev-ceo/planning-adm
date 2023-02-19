part of 'plantiilas_sistema_bloc.dart';

@immutable
abstract class PlantillasSistemaState {}

class PlantiilasSistemaInitial extends PlantillasSistemaState {}

class MostrarPlantillasSistemaState extends PlantillasSistemaState {
  final List<PlantillaSistemaModel> plantillas;

  MostrarPlantillasSistemaState(this.plantillas);
}

class ErrorObtenerListState extends PlantillasSistemaState {}

class ErrorInsertPlantillaState extends PlantillasSistemaState {}

class SuccessInsertPlantillaState extends PlantillasSistemaState {}

class SuccessEditDesPlantillaState extends PlantillasSistemaState {}

class ErrorEditDesPlantillaState extends PlantillasSistemaState {}

class ErrorDeletePlantillaState extends PlantillasSistemaState {}

class SuccessDeletePlantillaState extends PlantillasSistemaState {}

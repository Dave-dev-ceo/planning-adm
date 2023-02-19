part of 'paises_bloc.dart';

@immutable
abstract class PaisesState {}

class PaisesInitialState extends PaisesState {}

class LoadingPaisesState extends PaisesState {}

class MostrarPaisesState extends PaisesState {
  final ItemModelPaises? paises;

  MostrarPaisesState(this.paises);

  ItemModelPaises? get props => paises;
}

class ErrorListaPaisesState extends PaisesState {
  final String message;

  ErrorListaPaisesState(this.message);
  
  List<Object> get props => [message];

}
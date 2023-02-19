part of 'comentariosactividades_bloc.dart';

@immutable
abstract class ComentariosactividadesState {}

class ComentariosactividadesInitial extends ComentariosactividadesState {}

// estado - inicial
class ComentarioInitialState extends ComentariosactividadesState {}

// estado - cargando
class LodingComentarioState extends ComentariosactividadesState {}

// estado - select
class SelectComentarioState extends ComentariosactividadesState {
  final ItemModelComentarios? comentario;

  SelectComentarioState(this.comentario);

  ItemModelComentarios? get props => comentario;
}

// estado - create
class CreateComentariosState extends ComentariosactividadesState {
  final int? idComentario;

  CreateComentariosState(this.idComentario);
  
  int? get props => idComentario;
}

// estado - update
class UpdateComentariosState extends ComentariosactividadesState {
  bool get props => true;
}

// estado - errores
class ErrorMostrarComentarioState extends ComentariosactividadesState {
  final String message;

  ErrorMostrarComentarioState(this.message);

  List<Object> get props => [message];
}

class ErrorTokenComentarioState extends ComentariosactividadesState {
  final String message;

  ErrorTokenComentarioState(this.message);

  List<Object> get props => [message];
}

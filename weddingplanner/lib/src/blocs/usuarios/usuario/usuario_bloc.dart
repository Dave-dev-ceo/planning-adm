import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weddingplanner/src/logic/usuarios.logic.dart';
import 'package:weddingplanner/src/models/item_model_usuarios.dart';

part 'usuario_event.dart';
part 'usuario_state.dart';

class UsuarioBloc extends Bloc<UsuarioEvent, UsuarioState> {
  final UsuarioLogic logic;
  UsuarioBloc({@required this.logic}) : super(UsuarioInitial());

  @override
  Stream<UsuarioState> mapEventToState(
    UsuarioEvent event,
  ) async* {
    // Crear usuario
    if (event is CrearUsuarioEvent) {
      yield LoadingCrearUsuarioState();
      try {
        ItemModelUsuario usuario = await logic.crearUsuario(event.data);
        yield UsuarioCreadoState(new ItemModelUsuario(usuario.result));
      } on CrearUsuarioException {
        yield ErrorCrearUsuarioState("Error al crear Usuario");
      } on TokenException {
        yield ErrorTokenUsuarioState("Error de validación de token");
      }
    } // Editar usuario
    if (event is EditarUsuarioEvent) {
      yield LoadingEditarUsuarioState();
      try {
        ItemModelUsuario usuario = await logic.editarUsuario(event.data);
        yield UsuarioCreadoState(new ItemModelUsuario(usuario.result));
      } on CrearUsuarioException {
        yield ErrorCrearUsuarioState("Error al crear Usuario");
      } on TokenException {
        yield ErrorTokenUsuarioState("Error de validación de token");
      }
    }
  }
}

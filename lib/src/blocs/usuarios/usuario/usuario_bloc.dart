import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:planning/src/logic/usuarios.logic.dart';
import 'package:planning/src/models/item_model_usuarios.dart';

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
        yield UsuarioCreadoState(ItemModelUsuario(usuario.result));
      } on CrearUsuarioException {
        yield ErrorCrearUsuarioState("Error al crear usuario");
      } on TokenException {
        yield ErrorTokenUsuarioState("Error de validación de token");
      }
    } // Editar usuario
    if (event is EditarUsuarioEvent) {
      yield LoadingEditarUsuarioState();
      try {
        ItemModelUsuario usuario = await logic.editarUsuario(event.data);
        yield UsuarioCreadoState(ItemModelUsuario(usuario.result));
      } on CrearUsuarioException {
        yield ErrorCrearUsuarioState("Error al editar usuario");
      } on TokenException {
        yield ErrorTokenUsuarioState("Error de validación de token");
      }
    }
  }
}

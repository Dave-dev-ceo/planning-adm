import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:planning/src/logic/usuarios.logic.dart';
import 'package:planning/src/models/item_model_usuarios.dart';

part 'usuarios_event.dart';
part 'usuarios_state.dart';

class UsuariosBloc extends Bloc<UsuariosEvent, UsuariosState> {
  final UsuariosLogic logic;
  UsuariosBloc({@required this.logic}) : super(UsuariosInitialState());

  @override
  Stream<UsuariosState> mapEventToState(
    UsuariosEvent event,
  ) async* {
    if (event is FetchUsuariosPorPlannerEvent) {
      yield LoadingUsuariosState();
      try {
        ItemModelUsuarios usuarios = await logic.fetchUsuariosPorPlanner();
        yield MostrarUsuariosState(usuarios);
      } on ListaUsuariosException {
        yield ErrorMostrarUsuariosState("Sin Usuarios");
      } on TokenException {
        yield ErrorTokenUsuariosState("Error de validación de token");
      }
    }
  }
}

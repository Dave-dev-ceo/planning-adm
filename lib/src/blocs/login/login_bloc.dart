import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:planning/src/logic/login_logic.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginLogic logic;
  LoginBloc({@required this.logic}) : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LogginEvent) {
      try {
        yield LogginState();
        Map<dynamic, dynamic> response =
            await logic.login(event.correo, event.password);

        yield LoggedState(response);
      } on LoginException {
        yield ErrorLogginState("Correo o contraseña incorrectos");
      } catch (e) {
        yield ErrorLogginState('No se pudo iniciar sesión, intente más tarde');
      }
    } else if (event is RecoverPasswordEvent) {
      try {
        final data = await logic.recoverPassword(event.correo);
        if (data == 'Ok') {
          yield CorreoSentState();
        } else if (data == 'NotFound') {
          yield CorreoNotFoundState();
        } else {
          yield ErrorLogginState('Ocurrió un error');
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    } else if (event is ValidateTokenEvent) {
      try {
        final data = await logic.validarTokenPassword(event.token);

        if (data) {
          yield TokenValidadoState();
        } else {
          yield TokenExpiradoState();
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    } else if (event is ChangeAndRecoverPassword) {
      try {
        final statusCode =
            await logic.changePasswordAnRecover(event.newPassword, event.token);

        if (statusCode == 200) {
          yield PasswordChangedState();
        } else if (statusCode == 302) {
          yield TokenExpiradoState();
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }
}

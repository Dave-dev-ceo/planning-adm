import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
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
        if (event.correo == "" ||
            event.password == "" ||
            event.correo == null ||
            event.password == null) {
          yield MsgLogginState("Favor de ingresar correo y contraseña");
        } else {
          yield LogginState();
          Map<dynamic, dynamic> response =
              await logic.login(event.correo, event.password);
          yield LoggedState(response);
        }
      } on LoginException {
        yield ErrorLogginState("Correo o contraseña incorrectos");
      }
    } else if (event is RecoverPasswordEvent) {
      try {
        final data = await logic.recoverPassword(event.correo);
        print(data);
        if (data == 'Ok') {
          yield CorreoSentState();
        } else if (data == 'NotFound') {
          yield CorreoNotFoundState();
        } else {
          yield ErrorLogginState('Ocurrio un error');
        }
      } catch (e) {
        print(e);
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
        print(e);
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
        print(e);
      }
    }
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weddingplanner/src/logic/login_logic.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginLogic logic;
  LoginBloc({@required this.logic}) : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if(event is LogginEvent) {
      try {
        if(event.correo == "" || event.password == "" || event.correo == null || event.password == null){
          yield MsgLogginState("Favor de ingresar correo y contraseña");
        }else{
          yield LogginState();
          String response = await logic.login(event.correo, event.password);
          yield LoggedState(response);
        }
      }on LoginException{
        yield ErrorLogginState("Correo o contraseña incorrectos");
      }
    }
  }
}

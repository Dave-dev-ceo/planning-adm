part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LogginState extends LoginState {
  List<Object> get props => [];
}

class LoggedState extends LoginState {
  final Map<dynamic, dynamic> response;

  LoggedState(this.response);

  Map<dynamic, dynamic> get props => response;
}

class MsgLogginState extends LoginState {
  final String message;

  MsgLogginState(this.message);

  List<Object> get props => [message];
}

class ErrorLogginState extends LoginState {
  final String message;

  ErrorLogginState(this.message);

  List<Object> get props => [message];
}

class CorreoNotFoundState extends LoginState {}

class CorreoSentState extends LoginState {}

class TokenValidadoState extends LoginState {}

class TokenExpiradoState extends LoginState {}

class PasswordChangedState extends LoginState {}

class ErrorChengedPasswordState extends LoginState {}

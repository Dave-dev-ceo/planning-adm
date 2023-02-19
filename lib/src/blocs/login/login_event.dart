part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LogginEvent extends LoginEvent {
  final String correo;
  final String password;
  LogginEvent(this.correo, this.password);

  List<Object> get props => [correo, password];
}

class RecoverPasswordEvent extends LoginEvent {
  final String correo;

  RecoverPasswordEvent(this.correo);
}

class ValidateTokenEvent extends LoginEvent {
  final String? token;

  ValidateTokenEvent(this.token);
}

class ChangeAndRecoverPassword extends LoginEvent {
  final String newPassword;
  final String? token;

  ChangeAndRecoverPassword(this.newPassword, this.token);
}

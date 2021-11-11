part of 'login_bloc.dart';

@immutable
abstract class LoginEvent{}

class LogginEvent extends LoginEvent {
  final String correo;
  final String password;
  LogginEvent(this.correo,this.password);

  List<Object> get props => [correo, password];
  
}

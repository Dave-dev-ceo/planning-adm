part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LogginState extends LoginState {
  List<Object> get props => [];
}

class LoggedState extends LoginState {
  final int response;

  LoggedState(this.response);

  List<Object> get props => [response];
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
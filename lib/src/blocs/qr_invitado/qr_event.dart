part of 'qr_bloc.dart';

abstract class QrEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class QrValidation extends QrEvent {
  final String token;

  QrValidation(this.token);
}

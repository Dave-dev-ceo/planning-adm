part of 'qr_bloc.dart';

abstract class QrState extends Equatable {
  const QrState();

  @override
  List<Object> get props => [];
}

class QrInitial extends QrState {}

class QrLoading extends QrState {}

class QrValidState extends QrState {
  final QrInvitadoModel qrData;

  const QrValidState(this.qrData);
}

class QrValidAnotherState extends QrState {}

class QrInvitadoUpdateState extends QrState {}

class QrErrorState extends QrState {}

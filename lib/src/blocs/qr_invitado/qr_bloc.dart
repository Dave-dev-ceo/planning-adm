import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:planning/src/models/qr_model/qr_model.dart';
import 'package:planning/src/logic/qr_logic/qr_logic.dart';

part 'qr_event.dart';
part 'qr_state.dart';

class QrBloc extends Bloc<QrEvent, QrState> {
  QrBloc() : super(QrInitial()) {
    on<QrValidation>((event, emit) async {
      try {
        emit(QrLoading());
        final resp = await QrLogic().validarQr(event.token);
        if (resp != null) {
          if (resp.idInvitado != null) {
            emit(QrValidState(resp));
          } else {
            emit(QrValidAnotherState());
          }
        } else {
          emit(QrErrorState());
        }
      } catch (e) {
        emit(QrErrorState());

        print(e);
      }
    });
  }
}

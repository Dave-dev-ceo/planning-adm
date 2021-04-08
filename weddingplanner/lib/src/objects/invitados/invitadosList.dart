
import 'package:flutter/foundation.dart';

class InvitadosList {
final List<dynamic> invitadosList;

InvitadosList(
  {
    @required this.invitadosList
  }
);

factory InvitadosList.fromJson(List<dynamic> json) {
  return InvitadosList(
    invitadosList: json
    );
}
}

import 'dart:async';
import 'invitados_api_provider.dart';
import '../models/item_model_invitados.dart';

class Repository {
  final invitadosApiProvider = InvitadosApiProvider();

  Future<ItemModelInvitados> fetchAllInvitados() => invitadosApiProvider.fetchInvitadosList();
}
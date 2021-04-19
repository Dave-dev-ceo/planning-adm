import 'dart:async';
import 'package:weddingplanner/src/models/item_model_grupos.dart';

import 'api_provider.dart';
import '../models/item_model_invitados.dart';

class Repository {
  final apiProvider = ApiProvider();

  Future<ItemModelInvitados> fetchAllInvitados() => apiProvider.fetchInvitadosList();

  Future<ItemModelGrupos> fetchAllGrupos() => apiProvider.fetchGruposList();

}
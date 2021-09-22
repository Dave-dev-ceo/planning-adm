class ItemModelAcompanante {
  List<_ItemModelAcompanante> _results = [];

  ItemModelAcompanante.fromJson(List<dynamic> parsedJson) {
    List<_ItemModelAcompanante> temp = [];
    //print(parsedJson.length);
    //print(parsedJson[0]['nombre']);
    for (int i = 0; i < parsedJson.length; i++) {
      //print(parsedJson[0][i]);
      _ItemModelAcompanante result = _ItemModelAcompanante(parsedJson[i]);
      temp.add(result);
    }
    _results = temp;
  }
  List<_ItemModelAcompanante> get results => _results;
}

class _ItemModelAcompanante {
  int _id_acompanante;
  String _nombre;
  String _edad;
  int _id_evento;
  int _id_invitado;
  int _id_planner;

  _ItemModelAcompanante(result) {
    _id_acompanante = result['id_acompanante'];
    _nombre = result['nombre'];
    _edad = result['edad'];
    _id_evento = result['id_evento'];
    _id_invitado = result['id_invitado'];
    _id_planner = result['id_planner'];
  }
  int get idAcompanne => _id_acompanante;
  String get nombre => _nombre;
  String get edad => _edad;
  int get idEvento => _id_evento;
  int get idInvitado => _id_invitado;
  int get idPlanner => _id_planner;
}

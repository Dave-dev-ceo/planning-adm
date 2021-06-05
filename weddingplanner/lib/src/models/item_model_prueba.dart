class ItemModelPrueba {
  
  List<_Result> _results = [];

  ItemModelPrueba.fromJson(Map<dynamic,dynamic> parsedJson){
    List<_Result> temp = [];
    //print(parsedJson.length);
    //print(parsedJson[0]['nombre']);
    for (int i = 0; i < parsedJson['data'].length; i++) {
      //print(parsedJson[0][i]);
      _Result result = _Result(parsedJson['data'][i]);
      temp.add(result);
    }
    _results = temp;
  }
  List<_Result> get results => _results;
}

class _Result {
  String _nombre;
  String _apellido;
  String _pais;
  String _direccion;

  _Result(result){
    //_idInvitado = result['id_invitado'];
    _nombre = result['nombre'];
    _apellido = result['apellido'];
    _pais = result['pais'];
    _direccion = result['direccion'];
  }
  //int get idInvitado=>_idInvitado;
  String get nombre=>_nombre;
  String get apellido=>_apellido;
  String get pais=>_pais;
  String get direccion=>_direccion;

}
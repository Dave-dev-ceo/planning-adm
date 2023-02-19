class ItemModelReporte {
  
  List<_Result> _results = [];

  ItemModelReporte.fromJson(List<dynamic> parsedJson){
    List<_Result> temp = [];
    for (int i = 0; i < parsedJson.length; i++) {
      _Result result = _Result(parsedJson[i]);
      temp.add(result);
    }
    _results = temp;
  }
  List<_Result> get results => _results;
}

class _Result {
  int? _idInvitado;
  String? _nombre;
  String? _telefono;
  String? _email;

  _Result(result){
    _idInvitado = result['id_invitado'];
    _nombre = result['nombre'];
    _telefono = result['telefono'];
    _email = result['email'];
  }
  int? get idInvitado=>_idInvitado;
  String? get nombre=>_nombre;
  String? get telefono=>_telefono;
  String? get email=>_email;

}
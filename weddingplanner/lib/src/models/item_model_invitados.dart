class ItemModelInvitados {
  
  List<_Result> _results = [];

  ItemModelInvitados.fromJson(List<dynamic> parsedJson){
    List<_Result> temp = [];
    //print(parsedJson.length);
    //print(parsedJson[0]['nombre']);
    for (int i = 0; i < parsedJson.length; i++) {
      //print(parsedJson[0][i]);
      _Result result = _Result(parsedJson[i]);
      temp.add(result);
    }
    _results = temp;
  }
  List<_Result> get results => _results;
}

class _Result {
  String _nombre;
  String _telefono;
  String _email;
  String _asistencia;

  _Result(result){
    _nombre = result['nombre'];
    _telefono = result['telefono'];
    _email = result['email'];
    _asistencia = result['descripcion'];
  }

  String get nombre=>_nombre;
  String get telefono=>_telefono;
  String get email=>_email;
  String get asistencia=>_asistencia;

}